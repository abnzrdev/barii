# Incremental First-Readable Pagination Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Render the saved canonical location before complete-book pagination.

**Architecture:** ReaderScreen paginates and publishes the anchor bite first,
then incrementally publishes the remaining bites while re-resolving the current
canonical location. Existing cache and paginator behavior remain unchanged.

**Tech Stack:** Flutter, Dart `TimelineTask`, Drift-backed reader tests.

## Global Constraints

- Preserve bite navigation, visuals, EPUB semantics, Plain Reading Mode, schema,
  annotations, and Linux behavior.
- Preserve M0 timeline events and add only foreground pagination timing.
- Do not port browser/CSS-column source.

### Task 1: Anchored-first reader behavior

**Files:**
- Modify: `test/features/reader/reader_screen_test.dart`
- Modify: `lib/features/reader/presentation/reader_screen.dart`

**Interfaces:**
- Consumes: persisted `ReadingProgress.biteId` and `sourceOffset`.
- Produces: the existing `_pages`/`_index` state, published incrementally.

- [ ] Add a widget test that pumps only enough frames for the saved bite and
      verifies it appears before background pagination settles.
- [ ] Run that test and confirm it fails because `_pages` remains empty.
- [ ] Paginate the target bite first and publish its containing page.
- [ ] Add remaining bites incrementally with generation checks and canonical
      relocation on every publication.
- [ ] Run focused paginator and reader tests.

### Task 2: Profile verification and documentation

**Files:**
- Modify: `integration_test/reader_android_test.dart` only if a foreground marker
  requires harness reporting changes.
- Create: `docs/performance/m1-samsung-baseline.md`

**Interfaces:**
- Consumes: the M0 fixture and benchmark command.
- Produces: one warm-up plus five comparable Samsung profile runs.

- [ ] Run formatting, focused tests, and `flutter analyze`.
- [ ] Run the M0 profile harness on the detected Samsung.
- [ ] Verify open, swipes, reopen, rotation, Plain Reading Mode, and settings.
- [ ] Record raw and summarized before/after results and upstream provenance.
- [ ] Run repository-required verification and commit once with the requested
      milestone message.
