-- 48b3ba5e96b04d55db172793e1f64b519c0ac4c6
ALTER TABLE reading_progress ADD COLUMN canonical_locator TEXT;
ALTER TABLE bookmarks ADD COLUMN canonical_locator TEXT;
ALTER TABLE reader_notes ADD COLUMN canonical_locator TEXT;
ALTER TABLE highlight_notes ADD COLUMN canonical_locator TEXT;
ALTER TABLE highlights ADD COLUMN canonical_locator TEXT;
