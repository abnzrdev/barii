import 'dart:io';
import 'dart:isolate';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as path;
import 'package:sqlite3/sqlite3.dart';

import '../../../core/database/app_database.dart';
import '../domain/dictionary_repository.dart';
import '../domain/word_normalizer.dart';

class DictionaryPackService {
  DictionaryPackService({
    required this.database,
    required this.storageDirectory,
  });

  final AppDatabase database;
  final Directory storageDirectory;

  Future<DictionarySource> import(File source, {bool bundled = false}) async {
    final digest = await sha256.bind(source.openRead()).first;
    final hash = digest.toString();
    final existing = await database.dictionarySourceByHash(hash);
    if (existing != null) return existing;

    final metadata = await Isolate.run(() => _validatePack(source.path));
    await storageDirectory.create(recursive: true);
    final destination = File(
      path.join(storageDirectory.path, '$hash.dict.sqlite'),
    );
    final temporary = File('${destination.path}.importing');
    await source.copy(temporary.path);
    try {
      await Isolate.run(() => _validatePack(temporary.path));
      if (await destination.exists()) await destination.delete();
      await temporary.rename(destination.path);
      await database.saveDictionarySource(
        id: hash,
        name: metadata.name,
        language: 'en',
        format: bundled ? 'barii-bundled-v1' : 'limmud-sqlite-v1',
        sizeBytes: await destination.length(),
        filePath: destination.path,
        contentHash: hash,
        source: metadata.homepage,
        licenseName: metadata.license,
        attribution: metadata.attribution,
        installedAt: DateTime.now().toUtc(),
      );
      return (await database.dictionarySourceByHash(hash))!;
    } catch (_) {
      if (await temporary.exists()) await temporary.delete();
      if (await destination.exists() &&
          await database.dictionarySourceByHash(hash) == null) {
        await destination.delete();
      }
      rethrow;
    }
  }

  Future<void> remove(DictionarySource source) async {
    await database.deleteDictionarySource(source.id);
    final file = File(source.filePath);
    if (await file.exists()) await file.delete();
  }
}

class SqliteDictionaryRepository implements DictionaryRepository {
  SqliteDictionaryRepository(this.database);

  final AppDatabase database;
  final _cache = <String, DictionaryEntry?>{};

  @override
  Future<DictionaryEntry?> lookupEntry(
    String word, {
    String context = '',
    int? contextOffset,
  }) async {
    if (normalizeWord(word).isEmpty || word.length > 160) return null;
    final sources = (await database.allDictionarySources())
        .where((s) => s.enabled)
        .toList();
    final key =
        '${sources.map((s) => s.id).join('|')}:$word:$contextOffset:$context';
    if (_cache.containsKey(key)) {
      final result = _cache.remove(key);
      _cache[key] = result;
      return result;
    }
    final candidates = contextualCandidates(word, context, contextOffset);
    final result = await Isolate.run(
      () => _lookupLocal(sources, candidates, context),
    );
    _cache[key] = result;
    if (_cache.length > 128) _cache.remove(_cache.keys.first);
    return result;
  }

  @override
  Future<List<String>> suggest(String word, {int limit = 8}) async {
    final normalized = normalizeWord(word);
    if (normalized.isEmpty || limit <= 0) return const [];
    final sources = (await database.allDictionarySources())
        .where((s) => s.enabled)
        .toList();
    return Isolate.run(
      () => _suggestLocal(sources, normalized, limit.clamp(1, 20)),
    );
  }
}

DictionaryEntry? _lookupLocal(
  List<DictionarySource> sources,
  List<String> candidates,
  String context,
) {
  for (final source in sources) {
    Database? pack;
    try {
      if (!File(source.filePath).existsSync()) continue;
      pack = sqlite3.open(source.filePath, mode: OpenMode.readOnly);
      final detailed = pack
          .select('PRAGMA table_info(senses)')
          .any((row) => row['name'] == 'sense_key');
      for (final candidate in candidates) {
        final ids = <int>{
          ...pack
              .select(
                'SELECT id FROM entries WHERE normalized_headword=? ORDER BY source_id,id LIMIT 12',
                [candidate],
              )
              .map((r) => r['id'] as int),
          ...pack
              .select(
                'SELECT entry_id FROM forms WHERE normalized_form=? LIMIT 12',
                [candidate],
              )
              .map((r) => r['entry_id'] as int),
        };
        if (ids.isEmpty) continue;
        final found =
            <
              ({
                DictionarySense sense,
                String word,
                String entryId,
                String? ipa,
                String attribution,
                double score,
              })
            >[];
        final contextTokens = meaningTokens(context)
          ..removeAll(meaningTokens(candidate));
        for (final id in ids) {
          final entry = pack.select(
            'SELECT e.*, ds.source_name, ds.attribution FROM entries e JOIN dictionary_sources ds ON ds.id=e.source_id WHERE e.id=?',
            [id],
          ).first;
          final ipaRows = pack.select(
            'SELECT ipa FROM pronunciations WHERE entry_id=? LIMIT 1',
            [id],
          );
          for (final row in pack.select(
            'SELECT * FROM senses WHERE entry_id=? ORDER BY sense_order LIMIT 64',
            [id],
          )) {
            final definition = row['definition'] as String;
            if (definition.trim().isEmpty) continue;
            final examples = detailed
                ? _strings(row['examples_json'])
                : <String>[];
            final synonyms = detailed
                ? _strings(row['synonyms_json'])
                : <String>[];
            final labels = detailed ? _strings(row['tags_json']) : <String>[];
            final tokens = meaningTokens(
              '$definition ${examples.join(' ')} ${synonyms.join(' ')}',
            );
            final overlap = contextTokens.intersection(tokens).length;
            final score =
                overlap * 2.0 +
                (entry['source_id'] == 1 ? 0.25 : 0) -
                ((labels.contains('obsolete') || labels.contains('archaic'))
                    ? 1
                    : 0);
            found.add((
              sense: DictionarySense(
                entryId: '${source.id}:$id',
                id: detailed
                    ? row['sense_key'] as String
                    : '${source.id}:$id:${row['sense_order']}',
                definition: definition,
                sourceName: entry['source_name'] as String,
                partOfSpeech: entry['part_of_speech'] as String?,
                examples: examples,
                synonyms: synonyms,
                labels: labels,
                sourceUrl: detailed
                    ? entry['source_url'] as String?
                    : source.source,
              ),
              word: entry['headword'] as String,
              entryId: '${source.id}:$id',
              ipa: ipaRows.isEmpty ? null : ipaRows.first['ipa'] as String?,
              attribution: entry['attribution'] as String,
              score: score,
            ));
          }
        }
        if (found.isEmpty) continue;
        // Stable ordering for ties; overlap is only a suggestion, never certainty.
        final ordered = found.indexed.toList()
          ..sort((a, b) {
            final score = b.$2.score.compareTo(a.$2.score);
            return score == 0 ? a.$1.compareTo(b.$1) : score;
          });
        final best = ordered.first.$2;
        final seen = <String>{};
        final senses = ordered
            .map((item) => item.$2.sense)
            .where(
              (sense) => seen.add('${sense.partOfSpeech}:${sense.definition}'),
            )
            .toList();
        return DictionaryEntry(
          word: best.word,
          definition: best.sense.definition,
          sourceName: best.sense.sourceName,
          partOfSpeech: best.sense.partOfSpeech,
          pronunciation: best.ipa,
          attribution: best.attribution,
          sourceId: source.id,
          entryId: best.entryId,
          senses: senses,
        );
      }
    } on SqliteException {
      continue;
    } finally {
      pack?.close();
    }
  }
  return null;
}

List<String> _strings(Object? value) => value is String
    ? (jsonDecode(value) as List).whereType<String>().toList()
    : [];

List<String> _suggestLocal(
  List<DictionarySource> sources,
  String prefix,
  int limit,
) {
  final results = <String>{};
  for (final source in sources) {
    Database? pack;
    try {
      if (!File(source.filePath).existsSync()) continue;
      pack = sqlite3.open(source.filePath, mode: OpenMode.readOnly);
      for (final row in pack.select(
        'SELECT headword FROM entries WHERE normalized_headword>=? AND normalized_headword<? ORDER BY normalized_headword LIMIT ?',
        [prefix, '$prefix\uffff', limit],
      )) {
        results.add(row['headword'] as String);
      }
    } on SqliteException {
      continue;
    } finally {
      pack?.close();
    }
    if (results.length >= limit) break;
  }
  return results.take(limit).toList();
}

class _PackMetadata {
  const _PackMetadata({
    required this.name,
    required this.license,
    required this.attribution,
    required this.homepage,
  });

  final String name;
  final String license;
  final String attribution;
  final String homepage;
}

_PackMetadata _validatePack(String filePath) {
  Database? pack;
  try {
    pack = sqlite3.open(filePath, mode: OpenMode.readOnly);
    if (pack.select('PRAGMA integrity_check').first.values.first != 'ok') {
      throw const FormatException('Dictionary database is corrupt');
    }
    final metadata = {
      for (final row in pack.select('SELECT key, value FROM pack_metadata'))
        row['key'] as String: row['value'] as String,
    };
    if (metadata['schema_version'] != '1' ||
        metadata['build_complete'] != '1') {
      throw const FormatException('Unsupported or incomplete dictionary pack');
    }
    const requiredTables = {
      'dictionary_sources',
      'entries',
      'senses',
      'forms',
      'pronunciations',
    };
    final tables = pack
        .select("SELECT name FROM sqlite_master WHERE type='table'")
        .map((row) => row['name'] as String)
        .toSet();
    if (!tables.containsAll(requiredTables)) {
      throw const FormatException('Dictionary pack is missing required tables');
    }
    final sources = pack.select(
      'SELECT source_name, license_name, attribution, homepage '
      'FROM dictionary_sources ORDER BY id',
    );
    if (sources.isEmpty ||
        sources.any(
          (row) =>
              (row['license_name'] as String).trim().isEmpty ||
              (row['attribution'] as String).trim().isEmpty,
        )) {
      throw const FormatException(
        'Dictionary source license metadata is missing',
      );
    }
    final first = sources.first;
    return _PackMetadata(
      name: sources.length > 1
          ? 'Barii English — Simple English + WordNet'
          : first['source_name'] as String,
      license: sources.map((row) => row['license_name']).join('; '),
      attribution: sources.map((row) => row['attribution']).join('\n'),
      homepage: first['homepage'] as String,
    );
  } on SqliteException {
    throw const FormatException('Invalid dictionary pack');
  } finally {
    pack?.close();
  }
}
