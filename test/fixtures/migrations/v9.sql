-- 64e0d3a1a4c80701cac6d0ff59370a5c728261f5
ALTER TABLE reader_preferences ADD COLUMN plain_reading_mode INTEGER NOT NULL DEFAULT 0 CHECK (plain_reading_mode IN (0, 1));
