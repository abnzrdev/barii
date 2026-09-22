-- 34f92aca0606de5094fc456cf558a4939fedf2c2
ALTER TABLE reader_preferences ADD COLUMN show_progress INTEGER NOT NULL DEFAULT 0 CHECK (show_progress IN (0, 1));
