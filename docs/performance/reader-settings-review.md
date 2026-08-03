# Reader settings performance review

## Scope

Reviewed BookBites' settings-to-render path and Readest commit
`6469cbb5b5799912b6376765d57175f5552eedf7`. Readest was inspected only; no
Readest files were changed and no AGPL source was copied.

## Confirmed root cause

Before this repair, every slider `onChanged` called `setState` on
`ReaderScreen`. Its nested `LayoutBuilder` then called `_paginate`
synchronously during layout. A new font size, line height, reading width, or
margin produced a new signature, so `_paginate` traversed the complete book.
For every text bite, `paginateBites` repeatedly created and laid out
`TextPainter` instances during binary fitting. A one-line tail additionally
ran `_balancedSplit`, which measured both halves at every whitespace candidate.
Rapid dragging therefore queued input behind repeated full-book text layout.

The slow path was:

`Slider.onChanged` → `ReaderScreen.setState` → `LayoutBuilder` → `_paginate` →
`BitePaginationCache.pagesFor`/`paginateBites` → `TextPainter.layout` and
`_balancedSplit`.

Theme selection also started unawaited Drift writes. That was not the primary
CPU cost, but rapid selection could overlap writes and add avoidable work.
There was no repeated image decode in the slider path and no Riverpod/provider
notification fan-out; the reader is a stateful widget.

## Instrumentation and repair

Repagination now emits a `Reader.paginateBite` timeline event with bite ID and
character count, suitable for DevTools Performance and CPU correlation. Style
dragging previews the currently built PageView content, commits layout values
after a 180 ms trailing debounce, cancels superseded generations, yields a
frame between canonical bites, caches each bite by content, viewport, style,
alignment, direction, and text scale, and restores the same bite ID/source
offset. Preference and theme writes share one serialized future chain.

## Physical-device evidence

Pending: the requested Samsung `SM_M145F` (`R9ZX30B0CHB`) did not appear in
`adb devices -l` or USB enumeration during this review. No physical-device
timing or no-ANR claim is recorded until the device is visible and the profile
scenario is rerun for at least 20 seconds.

