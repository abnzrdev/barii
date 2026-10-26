-- Reader appearance migration, applied on top of the authentic v12 fixture.
ALTER TABLE reader_preferences ADD COLUMN font_family TEXT NOT NULL DEFAULT 'serif';
ALTER TABLE reader_preferences ADD COLUMN reading_background TEXT NOT NULL DEFAULT 'theme';
