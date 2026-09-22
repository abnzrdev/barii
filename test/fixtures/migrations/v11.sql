-- 73af6e8129fc7b1dd158cfaa1d21146549f0d0ae
CREATE TABLE canonical_publication_records (book_id TEXT PRIMARY KEY NOT NULL REFERENCES books(id) ON DELETE CASCADE, model_version INTEGER NOT NULL, parser_version INTEGER NOT NULL, projection_version INTEGER NOT NULL, publication_json TEXT NOT NULL, created_at INTEGER NOT NULL);
