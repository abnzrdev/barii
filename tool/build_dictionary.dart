// Release-time data conversion only. The application never downloads data.
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:sqlite3/sqlite3.dart';

import 'package:barii/features/dictionary/domain/word_normalizer.dart';

Future<void> main() async {
  final simple = File('build/dictionary-sources/simple-extract.jsonl.gz');
  final wordnet = File(
    'build/dictionary-sources/english-wordnet-2025-json.zip',
  );
  const expected = {
    'simple-extract.jsonl.gz':
        '813324e35a8cc2488692850626c54e457da03019ce33ee227e3c0cc82b69932d',
    'english-wordnet-2025-json.zip':
        '7d749f6e2c39e6970e4997839dcf6e42fd281f3c2fae0171d2192bae8cfa4b51',
  };
  for (final file in [simple, wordnet]) {
    final hash = (await sha256.bind(file.openRead()).first).toString();
    if (hash != expected[file.uri.pathSegments.last]) {
      throw StateError(
        'Source checksum changed: ${file.path}. Review the new release before rebuilding.',
      );
    }
  }
  final output = File('build/dictionary-sources/english.sqlite');
  if (await output.exists()) await output.delete();
  final db = sqlite3.open(output.path);
  db.execute('''
    PRAGMA journal_mode=OFF;
    PRAGMA synchronous=OFF;
    CREATE TABLE pack_metadata(key TEXT PRIMARY KEY, value TEXT NOT NULL);
    CREATE TABLE dictionary_sources(id INTEGER PRIMARY KEY, source_name TEXT NOT NULL,
      license_name TEXT NOT NULL, attribution TEXT NOT NULL, homepage TEXT NOT NULL);
    INSERT INTO dictionary_sources VALUES(1,'Simple English Wiktionary','CC BY-SA 4.0',
      'Simple English Wiktionary contributors, extracted by Wiktextract / Kaikki.org, October 2026. Adapted into a compact dictionary; quotations and media omitted.',
      'https://simple.wiktionary.org');
    INSERT INTO dictionary_sources VALUES(2,'Open English WordNet 2025','CC BY 4.0; Princeton WordNet License',
      'Princeton University WordNet and the Open English WordNet team. Open English WordNet 2025; adapted into indexed SQLite.',
      'https://en-word.net');
    CREATE TABLE entries(id INTEGER PRIMARY KEY, source_id INTEGER NOT NULL,
      headword TEXT NOT NULL, normalized_headword TEXT NOT NULL, part_of_speech TEXT,
      source_url TEXT NOT NULL);
    CREATE TABLE senses(id INTEGER PRIMARY KEY, entry_id INTEGER NOT NULL,
      sense_order INTEGER NOT NULL, definition TEXT NOT NULL, sense_key TEXT NOT NULL,
      examples_json TEXT NOT NULL, synonyms_json TEXT NOT NULL, tags_json TEXT NOT NULL);
    CREATE TABLE forms(entry_id INTEGER NOT NULL, normalized_form TEXT NOT NULL,
      PRIMARY KEY(entry_id,normalized_form)) WITHOUT ROWID;
    CREATE TABLE pronunciations(entry_id INTEGER NOT NULL, ipa TEXT NOT NULL);
    BEGIN;
  ''');
  final entry = db.prepare('INSERT INTO entries VALUES(?,?,?,?,?,?)');
  final sense = db.prepare('INSERT INTO senses VALUES(NULL,?,?,?,?,?,?,?)');
  final form = db.prepare('INSERT OR IGNORE INTO forms VALUES(?,?)');
  final pronunciation = db.prepare('INSERT INTO pronunciations VALUES(?,?)');
  var nextId = 0;
  var senseCount = 0;
  final aliases = <({String form, String lemma})>[];
  final sourceCounts = <String, int>{};

  int addEntry(int source, String word, String pos) {
    final id = ++nextId;
    entry.execute([
      id,
      source,
      word,
      normalizeWord(word),
      pos,
      source == 1
          ? 'https://simple.wiktionary.org/wiki/${Uri.encodeComponent(word)}'
          : 'https://en-word.net/?word=${Uri.encodeComponent(word)}',
    ]);
    return id;
  }

  void addSense(
    int id,
    int order,
    String definition,
    String key,
    List<String> examples,
    List<String> synonyms,
    List<String> tags,
  ) {
    if (definition.trim().isEmpty) return;
    sense.execute([
      id,
      order,
      definition.trim(),
      key,
      jsonEncode(examples.take(2).toList()),
      jsonEncode(synonyms.toSet().take(20).toList()),
      jsonEncode(tags),
    ]);
    senseCount++;
  }

  await for (final line
      in simple
          .openRead()
          .transform(gzip.decoder)
          .transform(utf8.decoder)
          .transform(const LineSplitter())) {
    final data = jsonDecode(line) as Map<String, dynamic>;
    if (data['lang_code'] != 'en') continue;
    final word = data['word'] as String;
    final pos = data['pos'] as String? ?? '';
    final rawSenses = (data['senses'] as List? ?? const [])
        .cast<Map<String, dynamic>>();
    final usable = <Map<String, dynamic>>[];
    for (final item in rawSenses) {
      if (item['form_of'] case final List forms) {
        for (final target in forms) {
          if (target is Map && target['word'] is String) {
            aliases.add((
              form: normalizeWord(word),
              lemma: normalizeWord(target['word'] as String),
            ));
          }
        }
      } else if ((item['glosses'] as List? ?? []).isNotEmpty) {
        usable.add(item);
      }
    }
    if (usable.isEmpty) continue;
    final canonical = (data['forms'] as List? ?? [])
        .whereType<Map>()
        .where((item) => (item['tags'] as List? ?? []).contains('canonical'))
        .map((item) => item['form'])
        .whereType<String>()
        .firstOrNull;
    if (canonical != null && normalizeWord(canonical) != normalizeWord(word)) {
      final grammatical = RegExp(
        r'^(the )?(simple )?(past tense|past participle|present participle|plural|comparative|superlative|third.person)',
        caseSensitive: false,
      );
      usable.removeWhere(
        (item) => (item['glosses'] as List).every(
          (g) => grammatical.hasMatch(g as String),
        ),
      );
      aliases.add((form: normalizeWord(word), lemma: normalizeWord(canonical)));
      if (usable.isEmpty) continue;
    }
    final id = addEntry(1, word, pos);
    sourceCounts.update('simple_entries', (n) => n + 1, ifAbsent: () => 1);
    for (var i = 0; i < usable.length; i++) {
      final item = usable[i];
      addSense(
        id,
        i,
        (item['glosses'] as List).join(' '),
        'simple:$word:$pos:$id:$i',
        const [],
        [..._words(item['synonyms']), ..._words(data['synonyms'])],
        (item['tags'] as List? ?? []).whereType<String>().toList(),
      );
    }
    for (final item in data['forms'] as List? ?? []) {
      if (item is Map && item['form'] is String) {
        form.execute([id, normalizeWord(item['form'] as String)]);
      }
    }
    for (final sound in data['sounds'] as List? ?? []) {
      if (sound is Map && sound['ipa'] is String) {
        pronunciation.execute([id, sound['ipa']]);
        break;
      }
    }
  }
  stdout.writeln(
    'Converted Simple English: ${sourceCounts['simple_entries']} entries',
  );
  final archive = ZipDecoder().decodeBytes(await wordnet.readAsBytes());
  final synsets = <String, Map<String, dynamic>>{};
  for (final file in archive.files.where(
    (f) => f.name.endsWith('.json') && !f.name.startsWith('entries-'),
  )) {
    final data =
        jsonDecode(utf8.decode(file.content as List<int>))
            as Map<String, dynamic>;
    for (final item in data.entries) {
      if (item.value is Map<String, dynamic> &&
          RegExp(r'^\d{8}-[nvars]$').hasMatch(item.key)) {
        synsets[item.key] = item.value as Map<String, dynamic>;
      }
    }
  }
  for (final file in archive.files.where(
    (f) => f.name.startsWith('entries-') && f.name.endsWith('.json'),
  )) {
    final data =
        jsonDecode(utf8.decode(file.content as List<int>))
            as Map<String, dynamic>;
    for (final word in data.entries) {
      for (final part in (word.value as Map<String, dynamic>).entries) {
        final lexical = part.value as Map<String, dynamic>;
        final senses = (lexical['sense'] as List? ?? [])
            .whereType<Map>()
            .toList();
        if (senses.isEmpty) continue;
        final id = addEntry(2, word.key, _pos(part.key));
        sourceCounts.update('wordnet_entries', (n) => n + 1, ifAbsent: () => 1);
        for (var i = 0; i < senses.length; i++) {
          final lexicalSense = senses[i];
          final synset = synsets[lexicalSense['synset']];
          if (synset == null) continue;
          addSense(
            id,
            i,
            (synset['definition'] as List? ?? []).join(' '),
            'oewn2025:${lexicalSense['id']}',
            (synset['example'] as List? ?? []).whereType<String>().toList(),
            (synset['members'] as List? ?? [])
                .whereType<String>()
                .where((s) => s != word.key)
                .toList(),
            const [],
          );
        }
        for (final value in lexical['form'] as List? ?? []) {
          if (value is String) form.execute([id, normalizeWord(value)]);
        }
        for (final sound in lexical['pronunciation'] as List? ?? []) {
          if (sound is Map && sound['value'] is String) {
            pronunciation.execute([id, sound['value']]);
            break;
          }
        }
      }
    }
  }
  db.execute(
    'CREATE INDEX headwords ON entries(normalized_headword,source_id);',
  );
  final targets = db.prepare(
    'SELECT id FROM entries WHERE normalized_headword=?',
  );
  for (final alias in aliases) {
    for (final target in targets.select([alias.lemma])) {
      form.execute([target['id'], alias.form]);
    }
  }
  targets.close();
  for (final statement in [entry, sense, form, pronunciation]) {
    statement.close();
  }
  db.execute('''
    CREATE INDEX normalized_forms ON forms(normalized_form,entry_id);
    CREATE INDEX entry_senses ON senses(entry_id,sense_order);
    CREATE INDEX entry_pronunciation ON pronunciations(entry_id);
    INSERT INTO pack_metadata VALUES('schema_version','1'),('build_complete','1'),
      ('pack_version','barii-english-2026-10-26-v1');
    COMMIT;
    VACUUM;
  ''');
  final report = <String, Object?>{
    'version': 'barii-english-2026-10-26-v1',
    ...sourceCounts,
    'entries': nextId,
    'senses': senseCount,
    'forms': db.select('SELECT count(*) n FROM forms').first['n'],
    'phrases': db
        .select("SELECT count(*) n FROM entries WHERE headword LIKE '% %'")
        .first['n'],
    'source_sha256': expected,
    'source_urls': [
      'https://kaikki.org/dictionary/downloads/simple/simple-extract.jsonl.gz',
      'https://en-word.net/downloads/english-wordnet-2025-json.zip',
    ],
    'simple_dump_date': '2026-10-02',
    'simple_examples': 'Omitted to avoid redistributing third-party quotations',
    'licenses': [
      'CC BY-SA 4.0 (Simple English content)',
      'CC BY 4.0 and Princeton WordNet License (OEWN content)',
    ],
    'changes':
        'English-only compact SQLite conversion; selected metadata and examples omitted; no definitions generated or rewritten.',
  };
  if (db.select('PRAGMA integrity_check').first.values.first != 'ok') {
    throw StateError('Integrity check failed');
  }
  db.close();
  final compressed = gzip.encode(await output.readAsBytes());
  final asset = File('assets/dictionary/english.sqlite.gz');
  await asset.writeAsBytes(compressed);
  report['installed_bytes'] = await output.length();
  report['compressed_bytes'] = compressed.length;
  report['database_sha256'] = (await sha256.bind(output.openRead()).first)
      .toString();
  report['asset_sha256'] = sha256.convert(compressed).toString();
  await File(
    'assets/dictionary/manifest.json',
  ).writeAsString(const JsonEncoder.withIndent('  ').convert(report));
  stdout.writeln(const JsonEncoder.withIndent('  ').convert(report));
}

List<String> _words(dynamic value) => (value is List ? value : const [])
    .whereType<Map>()
    .map((item) => item['word'])
    .whereType<String>()
    .toList();

String _pos(String value) => switch (value) {
  'n' => 'noun',
  'v' => 'verb',
  'a' || 's' => 'adjective',
  'r' => 'adverb',
  _ => value,
};
