import 'dart:io';

import 'package:barii/core/database/app_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  for (final bothColumns in [false, true]) {
    test('resumes interrupted appearance migration (both=$bothColumns)', () async {
      final directory = await Directory.systemTemp.createTemp(
        'barii-interrupted-',
      );
      final file = File('${directory.path}/barii.sqlite');
      addTearDown(() => directory.delete(recursive: true));
      _createHistoricalDatabase(file, 12);
      final raw = sqlite3.open(file.path);
      raw.execute(
        "ALTER TABLE reader_preferences ADD COLUMN font_family TEXT NOT NULL DEFAULT 'serif'",
      );
      raw.execute("UPDATE reader_preferences SET font_family='mono'");
      if (bothColumns) {
        raw.execute(
          "ALTER TABLE reader_preferences ADD COLUMN reading_background TEXT NOT NULL DEFAULT 'theme'",
        );
        raw.execute("UPDATE reader_preferences SET reading_background='night'");
      }
      raw.close();
      final db = AppDatabase.forTesting(NativeDatabase(file));
      expect((await db.preferences()).fontFamily, 'mono');
      expect(
        (await db.preferences()).readingBackground,
        bothColumns ? 'night' : 'theme',
      );
      expect(
        (await db.vocabularyForBook('book')).single.definition,
        'Definition',
      );
      await db.close();
      final check = sqlite3.open(file.path);
      expect(check.userVersion, 14);
      expect(check.select('PRAGMA foreign_key_check'), isEmpty);
      check.close();
    });
  }
  for (var sourceVersion = 1; sourceVersion <= 13; sourceVersion++) {
    test(
      'authentic v$sourceVersion schema migrates to v14 and reopens',
      () async {
        final directory = await Directory.systemTemp.createTemp(
          'barii-migration-v$sourceVersion-',
        );
        final file = File('${directory.path}/barii.sqlite');
        try {
          _createHistoricalDatabase(file, sourceVersion);

          final database = AppDatabase.forTesting(NativeDatabase(file));
          expect((await database.allBooks()).single.title, 'Historical Title');
          expect((await database.progressFor('book'))?.biteId, 'bite');
          expect((await database.notesForBook('book')).single.noteText, 'Note');
          expect(
            (await database.vocabularyForBook('book')).single.definition,
            'Definition',
          );
          expect((await database.preferences()).theme, 'dark');
          expect((await database.preferences()).fontFamily, 'serif');
          expect((await database.preferences()).readingBackground, 'theme');
          if (sourceVersion >= 3) {
            expect(await database.highlightsForBook('book'), hasLength(1));
          }
          if (sourceVersion >= 6) {
            expect(await database.bookmarksForBook('book'), hasLength(1));
          }
          if (sourceVersion >= 10) {
            expect(await database.readerViewMode('book'), 'original');
          }
          if (sourceVersion >= 11) {
            expect(
              (await database.canonicalPublicationFor('book'))?.publicationJson,
              '{"title":"Historical"}',
            );
          }
          await database.close();

          final reopened = AppDatabase.forTesting(NativeDatabase(file));
          expect((await reopened.allBooks()).single.id, 'book');
          expect((await reopened.progressFor('book'))?.biteId, 'bite');
          await reopened.close();

          final verification = sqlite3.open(file.path);
          expect(verification.userVersion, 14);
          expect(verification.select('PRAGMA foreign_key_check'), isEmpty);
          expect(
            verification.select('PRAGMA integrity_check').single.values.single,
            'ok',
          );
          expect(
            verification
                .select("SELECT COUNT(*) AS count FROM books WHERE id = 'book'")
                .single['count'],
            1,
          );
          if (sourceVersion >= 12) {
            for (final table in [
              'reading_progress',
              'bookmarks',
              'reader_notes',
              'highlight_notes',
              'highlights',
            ]) {
              expect(
                verification
                    .select('SELECT canonical_locator FROM $table LIMIT 1')
                    .single['canonical_locator'],
                '{"href":"one.xhtml"}',
              );
            }
          }
          verification.close();
        } finally {
          await directory.delete(recursive: true);
        }
      },
    );
  }
}

void _createHistoricalDatabase(File file, int version) {
  final database = sqlite3.open(file.path);
  try {
    database.execute('PRAGMA foreign_keys = ON');
    for (var schemaVersion = 1; schemaVersion <= version; schemaVersion++) {
      final fixture = File(
        'test/fixtures/migrations/v$schemaVersion.sql',
      ).readAsStringSync();
      database.execute(fixture);
    }
    database.userVersion = version;
    _populateHistoricalData(database, version);
    expect(database.select('PRAGMA foreign_key_check'), isEmpty);
  } finally {
    database.close();
  }
}

void _populateHistoricalData(Database database, int version) {
  database.execute('''
    INSERT INTO books
      (id, fingerprint, title, author, file_path, file_type, created_at)
    VALUES
      ('book', 'fingerprint', 'Historical Title', 'Author', '/book.epub',
       'epub', 1);
    INSERT INTO sections (id, book_id, position, heading)
    VALUES ('section', 'book', 0, 'Chapter');
    INSERT INTO bites
      (id, book_id, section_id, position, content, source_start, source_end)
    VALUES ('bite', 'book', 'section', 0, 'Readable text.', 0, 14);
    INSERT INTO reading_progress
      (book_id, bite_id, bite_position, updated_at)
    VALUES ('book', 'bite', 0, 1);
    INSERT INTO reader_notes
      (id, book_id, bite_id, note_text, created_at, updated_at)
    VALUES ('note', 'book', 'bite', 'Note', 1, 1);
    INSERT INTO vocabulary_entries
      (id, word, normalized_word, definition, source_sentence, book_id,
       bite_id, created_at)
    VALUES
      ('word', 'Term', 'term', 'Definition', 'Readable text.', 'book',
       'bite', 1);
    INSERT INTO reader_preferences
      (id, theme, font_size, line_height, alignment, reading_width)
    VALUES (1, 'dark', 21, 1.7, 'start', 640);
  ''');
  if (version >= 3) {
    database.execute('''
      INSERT INTO dictionary_sources
        (id, name, language, format, size_bytes, file_path, content_hash,
         source, license_name, attribution, enabled, priority, installed_at)
      VALUES
        ('dictionary', 'Dictionary', 'en', 'sqlite', 10, '/dictionary.sqlite',
         'dictionary-hash', 'local', 'Test', 'Test attribution', 1, 0, 1);
      UPDATE vocabulary_entries
      SET dictionary_source_id = 'dictionary',
          dictionary_source_name = 'Dictionary', part_of_speech = 'noun',
          pronunciation = 'term';
      INSERT INTO highlight_notes
        (id, book_id, bite_id, note_text, created_at, updated_at)
      VALUES ('highlight-note', 'book', 'bite', 'Highlight note', 1, 1);
      INSERT INTO highlights
        (id, book_id, bite_id, start_offset, end_offset, selected_text,
         prefix_context, suffix_context, content_checksum, style, color,
         note_id, resolved, created_at, updated_at)
      VALUES
        ('highlight', 'book', 'bite', 0, 8, 'Readable', '', ' text.',
         'checksum', 'background', 'yellow', 'highlight-note', 1, 1, 1);
    ''');
  }
  if (version >= 4) {
    database.execute(
      "UPDATE reading_progress SET source_offset = 4 WHERE book_id = 'book'",
    );
  }
  if (version >= 5) {
    database.execute(
      "UPDATE bites SET kind = 'text', alt_text = 'preserved' "
      "WHERE id = 'bite'",
    );
  }
  if (version >= 6) {
    database.execute('''
      INSERT INTO bookmarks (book_id, bite_id, source_offset, created_at)
      VALUES ('book', 'bite', 4, 1);
    ''');
  }
  if (version >= 7) {
    database.execute(
      'UPDATE reader_preferences SET show_progress = 1 WHERE id = 1',
    );
  }
  if (version >= 8) {
    database.execute(
      "UPDATE bites SET markup = '{\"marks\":[]}' WHERE id = 'bite'",
    );
  }
  if (version >= 9) {
    database.execute(
      'UPDATE reader_preferences SET plain_reading_mode = 1 WHERE id = 1',
    );
  }
  if (version >= 10) {
    database.execute('''
      INSERT INTO reader_view_modes (book_id, mode)
      VALUES ('book', 'original');
    ''');
  }
  if (version >= 11) {
    database.execute('''
      INSERT INTO canonical_publication_records
        (book_id, model_version, parser_version, projection_version,
         publication_json, created_at)
      VALUES ('book', 1, 1, 1, '{"title":"Historical"}', 1);
    ''');
  }
  if (version >= 12) {
    for (final table in [
      'reading_progress',
      'bookmarks',
      'reader_notes',
      'highlight_notes',
      'highlights',
    ]) {
      database.execute(
        "UPDATE $table SET canonical_locator = "
        "'{\"href\":\"one.xhtml\"}'",
      );
    }
  }
}
