-- 41edaa03729f6f7015f9d18a9181ba590bfb9734
CREATE TABLE bookmarks (book_id TEXT NOT NULL REFERENCES books(id) ON DELETE CASCADE, bite_id TEXT NOT NULL REFERENCES bites(id) ON DELETE CASCADE, source_offset INTEGER NOT NULL, created_at INTEGER NOT NULL, PRIMARY KEY(book_id, bite_id, source_offset));
CREATE INDEX bookmarks_book_location ON bookmarks (book_id, bite_id, source_offset);
