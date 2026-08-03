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

The repaired reader was profiled on the requested Samsung `SM_M145F`
(`R9ZX30B0CHB`, Android 15, 1080 × 2400) with Flutter's VM timeline and frame
performance capture. The test continuously dragged all four layout sliders for
20.48 seconds, changed themes repeatedly, rotated the settings layout to
landscape and back, then verified the stable bite/source offset and persisted
settings after reopening the reader.

The profile run completed in 1 minute 57 seconds with 2,867 measured frames.
Average/90th/99th-percentile UI build times were 0.808/0.933/6.460 ms; the worst
was 45.708 ms and 15 frames missed the build budget. Average/90th/99th-percentile
raster times were 11.227/15.382/19.163 ms; the worst was 24.613 ms and 216
frames missed the raster budget. The timeline contains `Reader.paginateBite`
events, confirming that the expensive method remained observable while the
debounce/cancellation path prevented it from running on every drag tick.

`adb logcat` recorded no ANR, input-dispatch timeout, crash, or BookBites
skipped-frame warning during the sustained interaction interval. Startup did
show skipped frames before the activity was displayed; that is outside this
settings repair and remains a candidate for the later comparison benchmark.

Capture command:

```sh
flutter drive --profile --no-start-paused --no-dds \
  --dart-define=BOOKBITES_SETTINGS_PROFILE_ONLY=true \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/reader_android_test.dart \
  -d R9ZX30B0CHB
```

The generated DevTools-compatible timeline and frame report is
`build/integration_response_data.json`; it is a local build artifact and is not
committed.
