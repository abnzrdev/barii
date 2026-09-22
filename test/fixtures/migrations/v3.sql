-- f8b822301bee251857cb24a1dc62f62df0b8a3f9
CREATE TABLE dictionary_sources (id TEXT PRIMARY KEY NOT NULL, name TEXT NOT NULL, language TEXT NOT NULL, format TEXT NOT NULL, size_bytes INTEGER NOT NULL, file_path TEXT NOT NULL, content_hash TEXT NOT NULL UNIQUE, source TEXT NOT NULL, license_name TEXT NOT NULL, attribution TEXT NOT NULL, enabled INTEGER NOT NULL DEFAULT 1 CHECK (enabled IN (0, 1)), priority INTEGER NOT NULL, installed_at INTEGER NOT NULL);
CREATE TABLE dictionary_import_states (source_id TEXT PRIMARY KEY NOT NULL REFERENCES dictionary_sources(id) ON DELETE CASCADE, stage TEXT NOT NULL, completed INTEGER NOT NULL DEFAULT 0, total INTEGER NOT NULL DEFAULT 1, error TEXT, updated_at INTEGER NOT NULL);
CREATE TABLE highlight_notes (id TEXT PRIMARY KEY NOT NULL, book_id TEXT NOT NULL REFERENCES books(id) ON DELETE CASCADE, bite_id TEXT NOT NULL REFERENCES bites(id) ON DELETE CASCADE, note_text TEXT NOT NULL, created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL);
CREATE TABLE highlights (id TEXT PRIMARY KEY NOT NULL, book_id TEXT NOT NULL REFERENCES books(id) ON DELETE CASCADE, bite_id TEXT NOT NULL REFERENCES bites(id) ON DELETE CASCADE, start_offset INTEGER NOT NULL, end_offset INTEGER NOT NULL, selected_text TEXT NOT NULL, prefix_context TEXT NOT NULL, suffix_context TEXT NOT NULL, content_checksum TEXT NOT NULL, style TEXT NOT NULL, color TEXT NOT NULL, note_id TEXT REFERENCES highlight_notes(id) ON DELETE SET NULL, resolved INTEGER NOT NULL DEFAULT 1 CHECK (resolved IN (0, 1)), created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL, UNIQUE(bite_id, start_offset, end_offset));
ALTER TABLE vocabulary_entries ADD COLUMN dictionary_source_id TEXT REFERENCES dictionary_sources(id) ON DELETE SET NULL;
ALTER TABLE vocabulary_entries ADD COLUMN dictionary_source_name TEXT NOT NULL DEFAULT 'Bundled dictionary';
ALTER TABLE vocabulary_entries ADD COLUMN part_of_speech TEXT;
ALTER TABLE vocabulary_entries ADD COLUMN pronunciation TEXT;
CREATE INDEX dictionary_enabled_priority ON dictionary_sources (enabled, priority);
CREATE INDEX highlights_book_bite ON highlights (book_id, bite_id);
CREATE INDEX highlight_notes_book_bite ON highlight_notes (book_id, bite_id);
