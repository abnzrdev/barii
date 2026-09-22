# Production Hardening Batch Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make book processing bounded and responsive, make startup failures recoverable, verify historical Drift upgrades, and validate every change in minimal CI.

**Architecture:** Preserve Barii's current parsing and persistence outputs. Add one archive-limit policy and a pure-Dart worker boundary around expensive import work, wrap existing startup dependencies in a retryable bootstrap widget, use authentic Drift schema exports for migration tests, and add validation-only GitHub Actions.

**Tech Stack:** Flutter 3.44-compatible Dart, archive 3.6.1, epubx 4.0.0, Drift 2.34.x, flutter_test, GitHub Actions.

## Global Constraints

- Do not change fingerprints, bite IDs, canonical locators, progress, notes, highlights, bookmarks, Unicode/RTL behavior, WebView containment, or licensing.
- Do not add dependencies, native/Rust code, or schema behavior changes.
- Keep limits centralized, documented, adjustable, and tested with generated fixtures.
- Follow red-green-refactor for runtime behavior.
- Do not commit production signing secrets or use them in pull-request CI.

---

### Task 1: Bounded book processing

**Files:**
- Create: `lib/features/library/data/book_resource_limits.dart`
- Create: `lib/features/library/data/book_processing_worker.dart`
- Modify: `lib/features/library/data/epub_parser.dart`
- Modify: `lib/features/library/data/book_import_service.dart`
- Modify: `lib/features/reader/data/canonical_locator_backfill.dart`
- Modify: `lib/features/reader/data/original_epub_server.dart`
- Modify: `lib/features/reader/presentation/original_epub_view.dart`
- Test: `test/features/library/epub_parser_test.dart`
- Test: `test/features/library/book_import_service_test.dart`
- Test: `test/features/reader/original_epub_server_test.dart`

**Interfaces:**
- `BookResourceLimits` validates source and archive metadata through one policy.
- `BookProcessingWorker.process(path, extension)` returns fingerprint and existing `ParsedPublication`/generated bite values without performing database writes.
- Existing constructors retain defaults so current callers and persisted books remain compatible.

- [ ] Write failing tests for source-size, entry-count, expanded-size, per-entry, and compression-ratio rejection using generated small ZIP fixtures.
- [ ] Run focused tests and confirm failures are caused by missing limit behavior.
- [ ] Implement the centralized policy and EPUB preflight with stable user-facing exceptions.
- [ ] Run focused parser/original-server tests to green.
- [ ] Write a failing responsiveness/worker contract test that proves import yields to the event loop and preserves fixture output.
- [ ] Implement the minimal isolate worker and keep storage/Drift operations in `BookImportService`.
- [ ] Add cancellation/disposal where the UI owns a running task and ensure errors expose Retry/Return actions.
- [ ] Run all library and reader tests.

### Task 2: Bootstrap and async recovery

**Files:**
- Create: `lib/app/barii_bootstrap.dart`
- Modify: `lib/main.dart`
- Modify: `lib/app/barii_app.dart`
- Modify: `lib/features/library/presentation/library_screen.dart`
- Modify: `lib/features/reader/presentation/reader_screen.dart`
- Test: `test/app/barii_bootstrap_test.dart`
- Test: `test/features/library/library_screen_test.dart`
- Test: `test/features/reader/reader_screen_test.dart`

**Interfaces:**
- `BariiBootstrap` accepts an injectable async initializer for widget tests and defaults to the existing production initialization sequence.
- Bootstrap success owns one `AppDatabase`; failure exposes retry and sanitized details without modifying storage.

- [ ] Write failing widget tests for loading, success, failure diagnostics, and retry.
- [ ] Run focused tests and verify the expected missing-widget failures.
- [ ] Implement the smallest bootstrap state machine and wire `main()` to render it immediately.
- [ ] Write failing tests for library and reader async errors leaving spinner state.
- [ ] Add explicit error states with Retry/Return behavior.
- [ ] Run bootstrap, library, and reader widget tests.
- [ ] Capture golden-free deterministic screenshots for loading, success, and failure using the widget test harness.

### Task 3: Authentic migration verification

**Files:**
- Create: `drift_schemas/` focused historical schema JSON files
- Modify: `test/core/database/migration_test.dart`
- Modify: `pubspec.yaml` only if Drift schema-test wiring requires an existing dev dependency configuration; do not add dependencies.

**Interfaces:**
- Drift `SchemaVerifier` opens exported historical versions and migrates them with the current `AppDatabase` strategy.

- [ ] Extract schema definitions from meaningful schema-introducing commits and generate/export snapshots with the locked current tooling where compatible.
- [ ] Verify snapshots correspond to repository history and omit redundant generated Dart application output.
- [ ] Replace the handwritten v2-only test with fixture-backed populated migrations covering early, annotation, bookmark/view-mode, canonical, and current states.
- [ ] Assert preserved rows, foreign-key integrity, schema version 12, and successful close/reopen.
- [ ] Run migration tests independently and with the full suite.

### Task 4: Minimal validation CI

**Files:**
- Create: `.github/workflows/ci.yml`

**Interfaces:**
- Pull requests and pushes to `main` run repository validation without production signing secrets.

- [ ] Pin checkout/setup/upload actions to immutable commits and configure a Flutter version satisfying `sdk: ^3.12.2`.
- [ ] Run enforced-lockfile resolution, format verification, analysis, unit/widget/migration tests, Android release compilation, and Linux release build/linkage diagnostics.
- [ ] Upload test/build diagnostics with `if: failure()` or `if: always()` as appropriate.
- [ ] Validate YAML structure and review the workflow for absent secret references.

### Task 5: Verification and handoff

**Files:**
- Review all changed files only.

- [ ] Run `dart format .`.
- [ ] Run `flutter analyze`.
- [ ] Run `flutter test`.
- [ ] Run existing integration tests when a device is available.
- [ ] Run practical Android and Linux build checks when toolchains permit.
- [ ] Run `git diff --check`, inspect `git diff --stat`, and review the full diff for scope and persisted-identity changes.
- [ ] Report exact commands/results, screenshots/demo, remaining production gaps, and file-level rollback.
