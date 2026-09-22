-- 836f160febef5b4b35a53eaa7dd266cadae5cec3
CREATE TABLE books (id TEXT PRIMARY KEY NOT NULL, fingerprint TEXT NOT NULL UNIQUE, title TEXT NOT NULL, author TEXT NOT NULL, file_path TEXT NOT NULL, file_type TEXT NOT NULL, cover BLOB, created_at INTEGER NOT NULL DEFAULT (strftime('%s', 'now')));
CREATE TABLE sections (id TEXT PRIMARY KEY NOT NULL, book_id TEXT NOT NULL REFERENCES books(id) ON DELETE CASCADE, position INTEGER NOT NULL, heading TEXT, UNIQUE(book_id, position));
CREATE TABLE bites (id TEXT PRIMARY KEY NOT NULL, book_id TEXT NOT NULL REFERENCES books(id) ON DELETE CASCADE, section_id TEXT NOT NULL REFERENCES sections(id) ON DELETE CASCADE, position INTEGER NOT NULL, content TEXT NOT NULL, source_start INTEGER NOT NULL, source_end INTEGER NOT NULL, UNIQUE(book_id, position));
CREATE TABLE reading_progress (book_id TEXT PRIMARY KEY NOT NULL REFERENCES books(id) ON DELETE CASCADE, bite_id TEXT NOT NULL REFERENCES bites(id) ON DELETE CASCADE, bite_position INTEGER NOT NULL, updated_at INTEGER NOT NULL);
CREATE TABLE reader_notes (id TEXT PRIMARY KEY NOT NULL, book_id TEXT NOT NULL REFERENCES books(id) ON DELETE CASCADE, bite_id TEXT NOT NULL REFERENCES bites(id) ON DELETE CASCADE, note_text TEXT NOT NULL, created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL);
CREATE TABLE vocabulary_entries (id TEXT PRIMARY KEY NOT NULL, word TEXT NOT NULL, normalized_word TEXT NOT NULL, definition TEXT NOT NULL, source_sentence TEXT NOT NULL, book_id TEXT NOT NULL REFERENCES books(id) ON DELETE CASCADE, bite_id TEXT NOT NULL REFERENCES bites(id) ON DELETE CASCADE, created_at INTEGER NOT NULL);
CREATE TABLE reader_preferences (id INTEGER PRIMARY KEY NOT NULL DEFAULT 1, theme TEXT NOT NULL DEFAULT 'system', font_size REAL NOT NULL DEFAULT 20, line_height REAL NOT NULL DEFAULT 1.6, alignment TEXT NOT NULL DEFAULT 'start', reading_width REAL NOT NULL DEFAULT 680);
CREATE INDEX bites_book_position ON bites (book_id, position);
CREATE INDEX notes_book_bite ON reader_notes (book_id, bite_id);
CREATE INDEX vocabulary_book_word ON vocabulary_entries (book_id, normalized_word);
