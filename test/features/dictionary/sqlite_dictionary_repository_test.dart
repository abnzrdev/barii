import 'dart:io';

import 'package:barii/core/database/app_database.dart';
import 'package:barii/features/dictionary/data/sqlite_dictionary_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  late AppDatabase database;
  late Directory temporary;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    temporary = await Directory.systemTemp.createTemp('barii-dictionary-');
  });

  tearDown(() async {
    await database.close();
    await temporary.delete(recursive: true);
  });

  test('imports once, persists metadata, and looks up forms', () async {
    final pack = File('${temporary.path}/fixture.sqlite');
    _writePack(pack, definition: 'To move swiftly on foot.');
    final service = DictionaryPackService(
      database: database,
      storageDirectory: Directory('${temporary.path}/installed'),
    );

    final first = await service.import(pack);
    final duplicate = await service.import(pack);
    final result = await SqliteDictionaryRepository(
      database,
    ).lookupEntry('Running!');

    expect(duplicate.id, first.id);
    expect(await database.allDictionarySources(), hasLength(1));
    expect(result?.definition, 'To move swiftly on foot.');
    expect(result?.sourceName, 'Test Wiktionary');
  });

  test('rejects damaged packs without registering a source', () async {
    final damaged = File('${temporary.path}/damaged.sqlite');
    await damaged.writeAsString('not sqlite');
    final service = DictionaryPackService(
      database: database,
      storageDirectory: Directory('${temporary.path}/installed'),
    );

    await expectLater(service.import(damaged), throwsA(isA<FormatException>()));
    expect(await database.allDictionarySources(), isEmpty);
  });

  test('enabled source priority controls lookup', () async {
    final service = DictionaryPackService(
      database: database,
      storageDirectory: Directory('${temporary.path}/installed'),
    );
    final first = File('${temporary.path}/first.sqlite');
    final second = File('${temporary.path}/second.sqlite');
    _writePack(first, definition: 'First definition.');
    _writePack(second, definition: 'Second definition.', version: '2');
    final firstSource = await service.import(first);
    final secondSource = await service.import(second);
    await database.setDictionaryPriorities([secondSource.id, firstSource.id]);

    final repository = SqliteDictionaryRepository(database);
    expect(
      (await repository.lookupEntry('run'))?.definition,
      'Second definition.',
    );
    await database.setDictionaryEnabled(secondSource.id, false);
    expect(
      (await repository.lookupEntry('run'))?.definition,
      'First definition.',
    );
  });

  test('removing a pack keeps saved vocabulary snapshots', () async {
    final pack = File('${temporary.path}/fixture.sqlite');
    _writePack(pack, definition: 'Snapshot definition.');
    final service = DictionaryPackService(
      database: database,
      storageDirectory: Directory('${temporary.path}/installed'),
    );
    final source = await service.import(pack);
    await database.addBook(
      id: 'book',
      fingerprint: 'hash',
      title: 'Book',
      author: 'Author',
      filePath: '/book.txt',
      fileType: 'txt',
    );
    await database.replaceContent(
      'book',
      sections: const [StoredSection(id: 'section', position: 0)],
      bites: const [
        StoredBite(
          id: 'bite',
          sectionId: 'section',
          position: 0,
          text: 'Run.',
          sourceStart: 0,
          sourceEnd: 4,
        ),
      ],
    );
    await database.saveVocabulary(
      id: 'saved',
      word: 'run',
      normalizedWord: 'run',
      definition: 'Snapshot definition.',
      sourceSentence: 'Run.',
      bookId: 'book',
      biteId: 'bite',
      now: DateTime.utc(2026),
      dictionarySourceId: source.id,
      dictionarySourceName: source.name,
    );

    await service.remove(source);

    final saved = (await database.vocabularyForBook('book')).single;
    expect(saved.definition, 'Snapshot definition.');
    expect(saved.dictionarySourceName, source.name);
    expect(saved.dictionarySourceId, isNull);
    expect(File(source.filePath).existsSync(), isFalse);
  });

  test('large generated pack lookup and suggestions stay bounded', () async {
    final pack = File('${temporary.path}/large.sqlite');
    _writePack(
      pack,
      definition: 'To move swiftly on foot.',
      extraEntries: 20000,
    );
    final service = DictionaryPackService(
      database: database,
      storageDirectory: Directory('${temporary.path}/installed'),
    );
    await service.import(pack);
    final repository = SqliteDictionaryRepository(database);
    final stopwatch = Stopwatch()..start();

    expect((await repository.lookupEntry('word19999'))?.word, 'word19999');
    expect(await repository.suggest('word1999', limit: 5), hasLength(5));

    expect(stopwatch.elapsed, lessThan(const Duration(seconds: 2)));
  });
}

void _writePack(
  File file, {
  required String definition,
  String version = '1',
  int extraEntries = 0,
}) {
  final pack = sqlite3.open(file.path);
  pack.execute('''
    CREATE TABLE pack_metadata (key TEXT PRIMARY KEY, value TEXT NOT NULL);
    CREATE TABLE dictionary_sources (
      id INTEGER PRIMARY KEY, source_key TEXT, source_name TEXT,
      source_version TEXT, source_date TEXT, license_name TEXT,
      attribution TEXT, homepage TEXT, schema_version INTEGER
    );
    CREATE TABLE entries (
      id INTEGER PRIMARY KEY, source_id INTEGER, headword TEXT,
      normalized_headword TEXT, language_code TEXT, part_of_speech TEXT,
      etymology_text TEXT, raw_source_id TEXT
    );
    CREATE TABLE senses (
      id INTEGER PRIMARY KEY, entry_id INTEGER, sense_order INTEGER,
      definition TEXT, learner_definition TEXT, tags_json TEXT,
      raw_source_id TEXT
    );
    CREATE TABLE pronunciations (
      id INTEGER PRIMARY KEY, entry_id INTEGER, ipa TEXT, region TEXT,
      audio_filename TEXT, audio_available INTEGER
    );
    CREATE TABLE forms (
      id INTEGER PRIMARY KEY, entry_id INTEGER, form TEXT,
      normalized_form TEXT, form_tags_json TEXT
    );
  ''');
  pack.execute(
    "INSERT INTO pack_metadata VALUES ('schema_version','1'),"
    "('build_complete','1'),('pack_version',?)",
    [version],
  );
  pack.execute(
    'INSERT INTO dictionary_sources VALUES '
    "(1,'test','Test Wiktionary',?,'2026-01-01','CC BY-SA 4.0',"
    "'Synthetic test data','https://example.test',1)",
    [version],
  );
  pack.execute(
    "INSERT INTO entries VALUES (1,1,'run','run','en','verb',NULL,NULL)",
  );
  pack.execute('INSERT INTO senses VALUES (1,1,1,?,NULL,\'[]\',NULL)', [
    definition,
  ]);
  pack.execute("INSERT INTO forms VALUES (1,1,'running','running','[]')");
  if (extraEntries > 0) {
    pack.execute(
      '''
      WITH RECURSIVE seq(x) AS (
        VALUES(2) UNION ALL SELECT x + 1 FROM seq WHERE x <= ?
      )
      INSERT INTO entries
      SELECT x, 1, 'word' || x, 'word' || x, 'en', 'noun', NULL, NULL
      FROM seq
    ''',
      [extraEntries],
    );
    pack.execute('''
      INSERT INTO senses
      SELECT id, id, 1, 'Generated definition ' || id, NULL, '[]', NULL
      FROM entries WHERE id > 1
    ''');
  }
  pack.execute(
    'CREATE INDEX entries_normalized_idx ON entries(normalized_headword)',
  );
  pack.execute('CREATE INDEX forms_normalized_idx ON forms(normalized_form)');
  pack.close();
}
