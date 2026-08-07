# Canonical EPUB Seam Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add an in-memory canonical EPUB publication model and a compatibility projection that leaves stored bites and reader behavior unchanged.

**Architecture:** `EpubParser` will build immutable publication/resource/spine/node objects, then one `CanonicalBiteProjection` will reproduce the existing `SourceSection`/`SourceBlock` output. Duplicate spine occurrences remain separate in the canonical reading order while the compatibility projection retains the current href-deduplicated behavior.

**Tech Stack:** Dart, Flutter, existing `epubx`, `html`, `archive`, and Flutter tests.

## Global Constraints

- No Drift schema, stored-bite, reader, paginator, UI, or dependency changes.
- No EPUB CFI implementation; locator foundations use resource href and media type with optional fragment, logical offsets, and text context.
- Preserve Plain Reading Mode and M2 lazy pagination behavior.
- No direct Readest or Foliate source adaptation.

---

### Task 1: Define preservation and compatibility expectations

**Files:**
- Modify: `test/support/epub_fixture.dart`
- Modify: `test/features/library/epub_parser_test.dart`

**Interfaces:**
- Consumes: `EpubParser.parse(List<int>)`
- Produces: failing expectations for `ParsedPublication.canonical`, canonical resources, occurrences, nodes, rendition, and unchanged projected sections/bites.

- [ ] Add a fixture variant with duplicate spine references, manifest metadata, language/direction, IDs, nested inline text, and fixed-layout metadata.
- [ ] Assert duplicate occurrences have distinct occurrence IDs but share one resource href.
- [ ] Assert canonical nodes preserve IDs, inherited language/direction inputs, and nested logical text order.
- [ ] Snapshot the current projected blocks and generated bite fields for compatibility.
- [ ] Run `flutter test test/features/library/epub_parser_test.dart` and confirm failure because the canonical API does not exist.

### Task 2: Add the minimal canonical domain model

**Files:**
- Create: `lib/features/library/domain/canonical_publication.dart`

**Interfaces:**
- Produces: `CanonicalPublication`, `CanonicalMetadata`, `CanonicalRendition`, `CanonicalResource`, `CanonicalSpineOccurrence`, `CanonicalNode`, and `CanonicalLocator`.

- [ ] Implement immutable data-only types required by the failing tests.
- [ ] Keep occurrence identity separate from resource identity.
- [ ] Run the focused parser test and confirm remaining failures are parser population failures.

### Task 3: Populate canonical data and project compatibly

**Files:**
- Create: `lib/features/library/data/canonical_bite_projection.dart`
- Modify: `lib/features/library/data/epub_parser.dart`

**Interfaces:**
- Consumes: `CanonicalPublication` plus the existing archive bytes.
- Produces: the existing `List<SourceSection>` and parsed assets without changing `BiteGenerator` output.

- [ ] Build manifest resources keyed by normalized href and spine occurrences keyed by occurrence index plus itemref ID.
- [ ] Build semantic element/text nodes with logical offsets, IDs, language, direction, href, and EPUB semantic terms.
- [ ] Read publication language, page direction, and global rendition metadata exposed by `epubx`.
- [ ] Move the current flattening behavior behind `CanonicalBiteProjection` without changing its algorithms.
- [ ] Run parser, import, bite, paginator, and reader tests until green.

### Task 4: Verify and commit

**Files:**
- Modify only verification documentation if device evidence requires it.

**Interfaces:**
- Produces: one reversible M3a commit with no migration.

- [ ] Run `dart format .` and `git diff --check`.
- [ ] Run `flutter analyze` and the focused/full regression tests.
- [ ] Run `flutter build linux --profile`.
- [ ] If authorized, run a focused Samsung profile import/open/reopen and inspect logcat.
- [ ] Confirm `ReaderScreen`, paginator, Drift schema, `pubspec.yaml`, and lockfile are unchanged.
- [ ] Commit the scoped files with a clear M3a message and do not push.
