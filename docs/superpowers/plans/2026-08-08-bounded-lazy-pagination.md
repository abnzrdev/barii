# Bounded Lazy Pagination Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Preserve sub-200 ms anchor-first display while eliminating complete-book background pagination and bounding retained layout results.

**Architecture:** Reuse the existing paginator, canonical anchor, PageView, and generation cancellation. Materialize a nine-bite window centered on the current target, refresh it near an edge, and retain at most 32 bite-layout entries in an LRU cache.

**Tech Stack:** Flutter, Dart `dart:developer`, existing widget/integration tests, Android profile tooling.

## Global Constraints

- Preserve EPUB canonical semantics, Drift schema, annotations, figures, Plain Reading Mode, and Linux behavior.
- Treat `biteId + sourceOffset` as authoritative; temporary display indexes and page counts are never canonical.
- Do not copy or translate Readest/Foliate source.
- Commit once after device verification with the user-specified message; do not push.

---

### Task 1: Bounded paginator cache and split work

**Files:**
- Modify: `test/features/reader/bite_paginator_test.dart`
- Modify: `lib/features/reader/presentation/bite_paginator.dart`

- [ ] Write tests proving a fixed cache limit, LRU reuse/eviction, and exact content continuity.
- [ ] Run the paginator test and confirm the new cache test fails because the cache is unbounded/unobservable.
- [ ] Implement a 32-entry access-ordered cache and cap balanced-split layout candidates at 24.
- [ ] Run paginator tests and confirm they pass.

### Task 2: Lazy reader window and direct targets

**Files:**
- Modify: `test/features/reader/reader_screen_test.dart`
- Modify: `lib/features/reader/presentation/reader_screen.dart`

- [ ] Replace the M1 complete-materialization expectation with failing tests for a bounded initial window, edge-triggered preparation, stable canonical progress, and unloaded search navigation.
- [ ] Run focused reader tests and confirm failures reflect complete-book pagination and ignored unloaded targets.
- [ ] Paginate the anchor first, then at most four neighboring bites each way; publish only the target and final window.
- [ ] Trigger recentering near window edges and route unloaded navigation through canonical target materialization.
- [ ] Preserve generation/signature checks and re-resolve canonical location on every publication.
- [ ] Run focused reader tests and confirm they pass.

### Task 3: Profile and finish

**Files:**
- Modify: `integration_test/reader_android_test.dart` only if the existing harness cannot expose bounded work.
- Create: `docs/performance/m2-samsung-baseline.md`

- [ ] Run formatting, focused tests, and analysis.
- [ ] Run one warm-up plus five Samsung profile opens with the M1 fixture.
- [ ] Record first-readable, bounded pagination, frames, PSS, cache diagnostics, repeated open/close stabilization, and logcat results.
- [ ] Visually verify open, swipes across a window edge, unloaded search jump, rotation, settings, close, and reopen.
- [ ] Run final focused tests, `flutter analyze`, and the required project test suite.
- [ ] Commit the clean scoped worktree with `perf(reader): bound and lazily materialize pagination`.
