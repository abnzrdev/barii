# Offline Dictionary and Highlights Plan

## Goal

Add validated Limmud-compatible offline dictionary packs and persistent,
selection-driven highlights without damaging existing Barii data.

## Milestones

1. Add Drift v3 tables/migration for dictionary sources/import state,
   highlights/highlight notes, and vocabulary source snapshots; test migration
   and cascades first.
2. Expand the existing dictionary contract and normalization tests, then add a
   read-only SQLite/FTS5 provider with validated atomic import, priority,
   enablement, suggestions, and removal.
3. Add dictionary settings and richer adaptive lookup UI using current
   Barii panels and navigation.
4. Add a deterministic highlight anchor resolver and persistence tests,
   including repeated identical text and unresolved ranges.
5. Replace word recognizers with `SelectableText.rich`, native adaptive context
   actions, highlighted spans, and selection/gesture coordination.
6. Extend notebook behavior for highlight notes, color filtering, exact
   navigation, and Markdown/plain-text export.
7. Run formatting, dependency resolution, code generation, analysis, tests,
   Android/Linux builds, and device/desktop smoke tests; review licences and
   remove unnecessary abstractions.

## Constraints

- No large or copyrighted dictionary/book fixture.
- No AGPL source adaptation.
- No MDict/StarDict provider without a legal cross-platform proof.
- No global sentence deduplication or regression to canonical EPUB traversal.
- Existing books, progress, notes, vocabulary, and reader preferences must
  migrate intact.
- Reader progress UI remains forbidden.
