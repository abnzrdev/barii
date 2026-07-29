import 'dart:io';
import 'dart:isolate';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as path;
import 'package:sqlite3/sqlite3.dart';

import '../../../core/database/app_database.dart';
import '../domain/dictionary_repository.dart';
import '../domain/word_normalizer.dart';
import 'bundled_dictionary.dart';

class DictionaryPackService {
  DictionaryPackService({
    required this.database,
    required this.storageDirectory,
  });

  final AppDatabase database;
  final Directory storageDirectory;

  Future<DictionarySource> import(File source) async {
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
        format: 'limmud-sqlite-v1',
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
  static const _fallback = BundledDictionary();

  @override
  Future<DictionaryEntry?> lookupEntry(String word) async {
    final candidates = lookupCandidates(word);
    if (candidates.isEmpty || candidates.first.runes.length > 80) return null;
    for (final source in await database.allDictionarySources()) {
      if (!source.enabled || !File(source.filePath).existsSync()) continue;
      for (final candidate in candidates) {
        final result = _lookup(source, candidate);
        if (result != null) return result;
      }
    }
    for (final candidate in candidates) {
      final result = await _fallback.lookupEntry(candidate);
      if (result != null) return result;
    }
    return null;
  }

  @override
  Future<List<String>> suggest(String word, {int limit = 8}) async {
    final normalized = normalizeWord(word);
    if (normalized.isEmpty) return const [];
    final suggestions = <String>{};
    for (final source in await database.allDictionarySources()) {
      if (!source.enabled || !File(source.filePath).existsSync()) continue;
      Database? pack;
      try {
        pack = sqlite3.open(source.filePath, mode: OpenMode.readOnly);
        for (final row in pack.select(
          'SELECT headword FROM entries WHERE normalized_headword LIKE ? '
          'ORDER BY length(headword), headword LIMIT ?',
          ['$normalized%', limit],
        )) {
          suggestions.add(row['headword'] as String);
          if (suggestions.length == limit) return suggestions.toList();
        }
      } on SqliteException {
        continue;
      } finally {
        pack?.close();
      }
    }
    suggestions.addAll(await _fallback.suggest(normalized, limit: limit));
    return suggestions.take(limit).toList();
  }

  DictionaryEntry? _lookup(DictionarySource source, String normalized) {
    Database? pack;
    try {
      pack = sqlite3.open(source.filePath, mode: OpenMode.readOnly);
      final rows = pack.select(
        'SELECT e.id, e.headword, e.part_of_speech, ds.source_name, '
        'ds.attribution, (SELECT definition FROM senses '
        'WHERE entry_id=e.id ORDER BY sense_order LIMIT 1) definition, '
        '(SELECT ipa FROM pronunciations WHERE entry_id=e.id LIMIT 1) ipa '
        'FROM entries e JOIN dictionary_sources ds ON ds.id=e.source_id '
        'LEFT JOIN forms f ON f.entry_id=e.id '
        'WHERE e.normalized_headword=? OR f.normalized_form=? '
        'ORDER BY CASE WHEN e.normalized_headword=? THEN 0 ELSE 1 END, e.id '
        'LIMIT 1',
        [normalized, normalized, normalized],
      );
      if (rows.isEmpty) return null;
      final row = rows.first;
      return DictionaryEntry(
        word: row['headword'] as String,
        definition: row['definition'] as String? ?? '',
        sourceName: row['source_name'] as String,
        partOfSpeech: row['part_of_speech'] as String?,
        pronunciation: row['ipa'] as String?,
        attribution: row['attribution'] as String?,
        sourceId: source.id,
      );
    } on SqliteException {
      return null;
    } finally {
      pack?.close();
    }
  }
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
      name: first['source_name'] as String,
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
