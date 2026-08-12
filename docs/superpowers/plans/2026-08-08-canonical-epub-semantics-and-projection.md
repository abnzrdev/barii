# Canonical EPUB Semantics and Projection Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Preserve readable EPUB semantics canonically, then project every readable canonical node into Barii bites without changing the reader or Plain Reading Mode.

**Architecture:** Enrich the existing `CanonicalNode` tree with effective language/direction and safe semantic attributes. Keep M3b parser-only, then make M3c perform one ordered projection from that tree into the existing `SourceBlock` contract, reusing current asset and bite behavior.

**Tech Stack:** Dart, Flutter, existing `epubx`, `html`, `archive`, and Flutter tests.

## Global Constraints

- Exactly two implementation commits: M3b semantic preservation, then M3c projection.
- No Drift, stored-bite migration, canonical persistence, CFI, paginator, reader UI, dependency, or reference-repository changes.
- Fixed-layout metadata is detected, not rendered as a fixed-layout reader.
- Existing imported books are not regenerated.

---

### Task 1: M3b canonical preservation

**Files:**
- Modify: `lib/features/library/domain/canonical_publication.dart`
- Modify: `lib/features/library/data/epub_parser.dart`
- Modify: `test/support/epub_fixture.dart`
- Modify: `test/features/library/epub_parser_test.dart`

**Interfaces:**
- Consumes: XHTML/SVG publication resources already decoded by `EpubParser`.
- Produces: ordered `CanonicalNode` trees with safe semantic attributes and inherited language/direction.

- [ ] Add failing tests for containers, pre/code whitespace, tables, ruby, sup/sub, breaks, figures, SVG, IDs, roles, EPUB types, and inherited language/direction.
- [ ] Run the focused parser test and confirm semantic assertions fail.
- [ ] Add the minimum canonical fields and parser traversal needed by the tests; exclude script/style/event-handler content.
- [ ] Run format, diff check, analyzer, and focused parser/import tests.
- [ ] Commit `feat(epub): preserve canonical EPUB semantics`.

### Task 2: M3c complete Barii projection

**Files:**
- Modify: `lib/features/library/data/canonical_bite_projection.dart`
- Modify: `test/features/library/epub_parser_test.dart`

**Interfaces:**
- Consumes: `CanonicalSpineOccurrence.nodes` and existing archive bytes.
- Produces: ordered existing `SourceBlock` objects and assets for `BiteGenerator`.

- [ ] Add failing tests proving all readable semantic fixture text reaches blocks and bites once, in order, with deterministic table/ruby/break text and figures.
- [ ] Run focused tests and confirm projection assertions fail.
- [ ] Replace the narrow HTML selector projection with one ordered canonical-tree projection while retaining current block kinds, marks, anchors, and asset safety.
- [ ] Run format, diff check, analyzer, focused tests, full tests, Linux profile build, and authorized Samsung profile verification.
- [ ] Commit `feat(epub): project complete canonical content`.
