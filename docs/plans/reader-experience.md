# Reader Experience Plan

## Goal

Replace discrete bite switching with a calm, vertical, snapping `PageView`;
add focus mode, directional side-panel gestures, Android-only haptics, and
persisted appearance controls without exposing reading progress.

## Milestones

1. Add failing widget tests for vertical paging, completed/cancelled swipes,
   stable-ID restoration, controls, and forbidden progress UI.
2. Replace the reader body with a persistent vertical `PageController` and
   save progress only from completed `onPageChanged` events.
3. Add focus-mode timer/tap behavior and reduced-motion handling.
4. Reuse the existing notes and dictionary panels with direction-locked
   horizontal drags, edge protection, Back/Escape precedence, and visible
   buttons.
5. Add an injectable haptic callback and persisted focus, haptic, margin, and
   theme preferences using a Drift schema migration.
6. Verify deterministic chapter-opening bites, nested EPUB paragraph
   extraction, large-text layout, keyboard navigation, and many-bite lazy
   construction.
7. Run formatting, dependency resolution, analysis, tests, Android/Linux
   builds, and a Linux smoke test; then remove unnecessary code.

## Constraints

- Flutter SDK animations and input APIs only; no animation dependency.
- Never render progress, page/bite totals, percentages, remaining time, or
  chapter length.
- Keep stable bite IDs, progress fallback, bottom controls, long-press word
  lookup, notes, dictionary, and Android system gesture safety.
- Do not migrate existing book content destructively; corrected EPUB
  extraction applies when content is imported or regenerated.
