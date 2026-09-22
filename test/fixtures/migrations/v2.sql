-- de82308488ff51a68e1e79228225dc58a01702a8
ALTER TABLE reader_preferences ADD COLUMN page_margin REAL NOT NULL DEFAULT 24;
ALTER TABLE reader_preferences ADD COLUMN auto_hide_controls INTEGER NOT NULL DEFAULT 1 CHECK (auto_hide_controls IN (0, 1));
ALTER TABLE reader_preferences ADD COLUMN haptics_enabled INTEGER NOT NULL DEFAULT 1 CHECK (haptics_enabled IN (0, 1));
