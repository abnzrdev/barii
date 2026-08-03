# BookBites and Readest comparison plan

## Controls

- Use the same physical phone, Android build type, EPUB file, orientation,
  battery/power state, and a stable thermal state.
- Clear each app from recents before a cold-start run. Do not clear app data
  between repeated runs unless both apps are reset.
- Run at least five measured repetitions after one unmeasured warm-up and keep
  raw traces. Report median and range; do not discard failed or ANR runs.
- Record app commits, Flutter/Readest build versions, Android version, device
  model, and measurement tooling with every trace.

## Identical action script

1. Cold-start the app and measure launch until the library is interactive.
2. Open the same local EPUB and measure until readable content is interactive.
3. Move forward through 20 pages or bites using the normal gesture once per
   screen.
4. Open reader settings.
5. Change font size continuously for 15 seconds across the available range.
6. Rotate portrait → landscape → portrait while settings remain open.
7. Close settings, reopen the book, and verify location and settings.

BookBites' bite and Readest's page are each one native navigation action; the
comparison must not claim they contain equivalent amounts of text.

## Measurements

- Startup milliseconds: Android launch timing plus first-interactive timeline
  marker.
- Frame jank: Flutter DevTools frame chart for BookBites and the equivalent
  browser/Tauri frame trace for Readest; retain missed-frame counts and worst
  frame duration.
- CPU: profiler samples over the complete scripted interval and the 15-second
  settings interval separately.
- Memory: baseline after open, peak during settings drag/rotation, and retained
  memory after returning to the book.
- ANRs: `logcat` ActivityManager/input-dispatch evidence and Android vitals if
  available.

No benchmark values belong in this document until both apps have completed the
same recorded run.
