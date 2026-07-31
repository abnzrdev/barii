import 'dart:io';

import 'package:bookbites/core/database/app_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  test(
    'v2 migration preserves books, progress, notes, and vocabulary',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'bookbites-migration-',
      );
      final file = File('${directory.path}/bookbites.sqlite');
      final old = sqlite3.open(file.path);
      old.execute('''
      PRAGMA user_version = 2;
      CREATE TABLE books (
        id TEXT PRIMARY KEY, fingerprint TEXT NOT NULL UNIQUE,
        title TEXT NOT NULL, author TEXT NOT NULL, file_path TEXT NOT NULL,
        file_type TEXT NOT NULL, cover BLOB, created_at INTEGER NOT NULL
      );
      CREATE TABLE sections (
        id TEXT PRIMARY KEY, book_id TEXT NOT NULL, position INTEGER NOT NULL,
        heading TEXT, UNIQUE(book_id, position)
      );
      CREATE TABLE bites (
        id TEXT PRIMARY KEY, book_id TEXT NOT NULL, section_id TEXT NOT NULL,
        position INTEGER NOT NULL, content TEXT NOT NULL,
        source_start INTEGER NOT NULL, source_end INTEGER NOT NULL,
        UNIQUE(book_id, position)
      );
      CREATE TABLE reading_progress (
        book_id TEXT PRIMARY KEY, bite_id TEXT NOT NULL,
        bite_position INTEGER NOT NULL, updated_at INTEGER NOT NULL
      );
      CREATE TABLE reader_notes (
        id TEXT PRIMARY KEY, book_id TEXT NOT NULL, bite_id TEXT NOT NULL,
        note_text TEXT NOT NULL, created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      );
      CREATE TABLE vocabulary_entries (
        id TEXT PRIMARY KEY, word TEXT NOT NULL, normalized_word TEXT NOT NULL,
        definition TEXT NOT NULL, source_sentence TEXT NOT NULL,
        book_id TEXT NOT NULL, bite_id TEXT NOT NULL, created_at INTEGER NOT NULL
      );
      CREATE TABLE reader_preferences (
        id INTEGER PRIMARY KEY DEFAULT 1, theme TEXT NOT NULL DEFAULT 'system',
        font_size REAL NOT NULL DEFAULT 20,
        line_height REAL NOT NULL DEFAULT 1.6,
        alignment TEXT NOT NULL DEFAULT 'start',
        reading_width REAL NOT NULL DEFAULT 680,
        page_margin REAL NOT NULL DEFAULT 24,
        auto_hide_controls INTEGER NOT NULL DEFAULT 1,
        haptics_enabled INTEGER NOT NULL DEFAULT 1
      );
      INSERT INTO books VALUES
        ('book','hash','Title','Author','/book.epub','epub',NULL,1);
      INSERT INTO sections VALUES ('section','book',0,'Chapter');
      INSERT INTO bites VALUES
        ('bite','book','section',0,'Readable text.',0,14);
      INSERT INTO reading_progress VALUES ('book','bite',0,1);
      INSERT INTO reader_notes VALUES ('note','book','bite','Remember',1,1);
      INSERT INTO vocabulary_entries VALUES
        ('word','Book','book','A work.','Readable text.','book','bite',1);
      INSERT INTO reader_preferences (id) VALUES (1);
    ''');
      old.close();

      final database = AppDatabase.forTesting(NativeDatabase(file));
      expect((await database.allBooks()).single.title, 'Title');
      expect((await database.progressFor('book'))?.biteId, 'bite');
      expect((await database.progressFor('book'))?.sourceOffset, 0);
      expect((await database.notesForBook('book')).single.noteText, 'Remember');
      expect(
        (await database.vocabularyForBook('book')).single.definition,
        'A work.',
      );
      expect(await database.allDictionarySources(), isEmpty);
      await database.close();
      await directory.delete(recursive: true);
    },
  );
}
