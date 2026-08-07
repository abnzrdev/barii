# M2 bounded lazy pagination design

## Decision

Use approach B: an anchor-centered, bounded pagination window with direct
materialization of unloaded navigation targets.

- A, optimizing complete background pagination, still spends CPU and retains
  pages for unread content.
- B removes whole-book work and fits BookBites' existing canonical
  `biteId + sourceOffset` location model with the smallest change.
- C, opportunistic idle completion, adds scheduling and ultimately recreates
  the CPU and memory cost M2 is intended to remove.

## BookBites data flow

On open or reflow, paginate and publish the authoritative anchor bite first.
Then paginate a small contiguous bite window around it. When the current page
approaches either edge, materialize a new window centered on that canonical
location. Search, contents, bookmarks, and internal links set the canonical
target before requesting the same window materialization path.

Each publication resolves the visible page again from `biteId + sourceOffset`.
Display indexes remain disposable, and progress continues to use canonical
bite position and source offset rather than the temporary window page count.
Generation and layout-signature checks prevent stale resize, settings, Plain
Reading Mode, or disposed-reader work from publishing.

## Bounds

The materialized reader window contains the anchor bite plus four bites on
each side where available. `BitePaginationCache` is an access-ordered LRU with
32 entries. This covers the visible window and common backtracking while
bounding pages retained across layout signatures. Cache size and eviction are
observable for tests and timeline diagnostics.

`_balancedSplit` keeps its lossless source offsets and widow/tail rule, but
limits expensive `TextPainter` measurements to at most 24 whitespace
candidates sampled across the combined final two pages. Scanning the string
for candidate boundaries is cheap; exhaustive layout measurement is not.

## Readest/Foliate influence

This is a concept adaptation only. Readest commit
`6469cbb5b5799912b6376765d57175f5552eedf7` is AGPL-3.0. Its pinned Foliate-js
commit `f6bce4ce81d7cc6cd5df156a9867e3f0daa0427c` is MIT. Studied sources are
`packages/foliate-js/view.js`, `paginator.js`, and `epub.js`: canonical target
resolution before rendering, bounded adjacent section fill (`minPages = 5`,
`maxSections = 8`), direct loading of unloaded targets, view trimming,
reference-counted resource unload, stale animation/load guards, and teardown.
No upstream source is copied or mechanically translated.

## Verification

Regression tests cover LRU eviction, bounded initial materialization, edge
growth without location jumps, direct unloaded search navigation, progress
independence from window size, and content continuity after bounded split.
Samsung profile verification reuses the Alice fixture and M1 method, with one
warm-up and five recorded opens plus open/swipe/jump/rotate/settings/reopen and
memory/logcat checks.
