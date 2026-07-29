# BookBites MVP Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans
> to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for
> tracking.

**Goal:** Deliver an offline-first Android/Linux Flutter reader that imports
EPUB/TXT books and supports stable bites, progress, notes, and vocabulary.

**Architecture:** A feature-first Flutter UI uses Riverpod-provided services.
Drift is the only persistence boundary; `epubx` and Dart file APIs feed a
deterministic bite generator rendered with Flutter widgets.

**Tech Stack:** Flutter 3.44, Dart 3.12, Material 3, Riverpod, Drift/SQLite,
file_picker, path_provider, crypto, html, epubx.

## Global Constraints

- Target Android and Linux only; keep Dart code portable.
- Work offline and never call an AI or dictionary network API.
- Do not embed a mobile EPUB viewer as the core reader.
- Preserve Unicode and never split a bite inside a sentence.
- Hide total pages and chapter size in the reader.
- Add no abstraction without a present second implementation or test boundary.
- Independently implement behavior; do not copy AGPL Readest source.
- Every behavioral task follows red, green, refactor, then a conventional commit.

---

### Task 1: Research, dependencies, and application shell

**Files:** `pubspec.yaml`, `lib/main.dart`, `lib/app/bookbites_app.dart`,
`docs/architecture/epub-options.md`, `docs/readest-reference.md`,
`assets/sample_book.txt`

**Produces:** Material 3 `BookBitesApp` and documented dependency choices.

- [ ] Record current EPUB package versions, licenses, and verified platform
      constraints from documentation and source.
- [ ] Document Readest ideas and confirm that no source was adapted.
- [ ] Add only packages required by this MVP and the original sample asset.
- [ ] Replace the scaffold screen with a Riverpod-enabled Material 3 shell.
- [ ] Run `flutter pub get`, analysis, and the shell widget test; commit.

### Task 2: Drift persistence

**Files:** `lib/core/database/app_database.dart`,
`lib/core/database/app_database.g.dart`, `test/core/database/app_database_test.dart`

**Produces:** `AppDatabase`, schema version 1, and CRUD/watch methods for books,
sections, bites, progress, notes, vocabulary, and preferences.

- [ ] Write in-memory database tests for progress restore, note timestamps and
      deletion, vocabulary persistence, unique fingerprints, and book cascades.
- [ ] Run tests and confirm they fail because the database API is absent.
- [ ] Define the smallest Drift tables, foreign keys, constraints, indexes, and
      query methods that satisfy those tests.
- [ ] Generate Drift code, rerun focused and full tests, then commit.

### Task 3: Deterministic bite engine

**Files:** `lib/features/reader/domain/bite_generator.dart`,
`test/features/reader/bite_generator_test.dart`

**Produces:** `BiteGenerator.generate(bookFingerprint, sections)` returning
ordered `GeneratedBite` values with stable IDs and source offsets.

- [ ] Write literal-expectation tests for sentence boundaries, short and long
      paragraphs, headings, Unicode, malformed/empty content, and stable IDs.
- [ ] Run focused tests and verify the expected missing-symbol failure.
- [ ] Implement paragraph-preferred 100–180-word grouping with sentence-only
      long-paragraph splits and SHA-256 IDs.
- [ ] Run focused/full tests, format, then commit.

### Task 4: TXT and EPUB import

**Files:** `lib/features/library/data/book_import_service.dart`,
`lib/features/library/data/epub_parser.dart`,
`test/features/library/book_import_service_test.dart`,
`test/features/library/epub_parser_test.dart`, `test/fixtures/*`

**Produces:** `BookImportService.importFile(path)` and
`EpubParser.parse(bytes)` returning normalized metadata and source sections.

- [ ] Create small TXT and generated EPUB fixtures; test metadata fallback,
      chapter order, sanitization, invalid archives, DRM rejection, empty books,
      copied files, and duplicate fingerprints.
- [ ] Run focused tests and verify they fail for missing APIs.
- [ ] Implement direct TXT parsing, `epubx` metadata/spine extraction, HTML
      sanitization, hashing, controlled file copy, bite generation, and one
      database transaction.
- [ ] Run focused/full tests, format, then commit.

### Task 5: Library and reader

**Files:** `lib/features/library/presentation/library_screen.dart`,
`lib/features/reader/presentation/reader_screen.dart`,
`lib/features/reader/presentation/reader_controller.dart`,
`lib/features/settings/presentation/reader_settings_sheet.dart`,
`test/features/reader/reader_screen_test.dart`

**Produces:** responsive library CRUD and a single-bite reader with persisted
navigation/preferences.

- [ ] Write widget tests for library empty/sample/import states, bite rendering,
      visible labeled controls, progress restore, keyboard mappings, gesture
      thresholds/conflict isolation, themes, and text preferences.
- [ ] Run widget tests and verify missing-widget failures.
- [ ] Implement direct Riverpod state, responsive Material widgets, gestures
      inside safe horizontal padding, shortcuts, tooltips, and semantics.
- [ ] Run focused/full tests, format, then commit.

### Task 6: Notes and dictionary

**Files:** `lib/features/notes/presentation/notes_panel.dart`,
`lib/features/notes/presentation/notebook_screen.dart`,
`lib/features/dictionary/domain/dictionary_repository.dart`,
`lib/features/dictionary/data/bundled_dictionary.dart`,
`lib/features/dictionary/presentation/dictionary_panel.dart`,
`lib/features/dictionary/presentation/vocabulary_screen.dart`,
`test/features/dictionary/word_normalizer_test.dart`,
`test/features/reader/reader_panels_test.dart`

**Produces:** bite-linked note CRUD, notebook navigation, offline lookup,
long-press word selection, and saved vocabulary.

- [ ] Write tests for Unicode/apostrophe normalization, missing definitions,
      note CRUD/navigation, vocabulary save/list, swipe panels, and Escape.
- [ ] Run focused tests and verify missing-API failures.
- [ ] Implement the single required `DictionaryRepository` boundary, bundled
      dictionary, responsive panels, and database-backed screens.
- [ ] Run focused/full tests, format, then commit.

### Task 7: Validation and audit

**Files:** existing files only, plus documentation corrections found by audit.

- [ ] Run `dart format .`, `flutter pub get`, `flutter analyze`, `flutter test`,
      and `flutter build linux`.
- [ ] Detect the Android SDK and run `flutter build apk --debug` when available.
- [ ] Launch the Linux binary under an available display, verify it remains
      alive and produces no startup error, then terminate it cleanly.
- [ ] Review `git diff` for redundant code, unsafe import/delete handling,
      accessibility gaps, accidental Readest copying, and license omissions.
- [ ] Fix each discovered defect with a reproducing test and rerun validation.
- [ ] Commit the verified final checkpoint and use the branch-finishing workflow.
