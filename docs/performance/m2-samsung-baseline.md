# M2 bounded lazy pagination Samsung baseline

Recorded 2026-08-08 from BookBites M2 on top of M1 commit
`b40b3d8fe95dde42a8379d504b8d78415ac9a412`, on the detected physical
Samsung `SM-M145F` (`R9ZX30B0CHB`, Android 15) in Flutter profile mode.

## Fixture and method

- file: Readest test fixture `sample-alice.epub` (not committed to BookBites)
- size: 414345 bytes
- SHA-256: `a6403b7951058243f91843bbe8a9e46ed205d5a7dcdb9758f70f11e360e17246`
- imported result: 16 sections and 208 bites
- runs: one warm-up followed by five recorded opens

The M1 APK build, fixture-copy delay, and `flutter drive` commands were reused
unchanged. The exported trace retained `Reader.firstReadablePage` in M2, so
first-readable duration is measured directly from the first
`Reader.paginateBite` start to that marker. Bounded pagination duration uses
the same start and the completed non-empty `Reader.pagination` event.

## Reader timings

| Run | First readable (ms) | Bounded pagination (ms) | Bites/pages | Cache entries/evictions |
| --- | ---: | ---: | ---: | ---: |
| warm-up | 118.580 | 808.677 | 5 / 5 | 5 / 0 |
| 1 | 119.769 | 887.100 | 5 / 5 | 5 / 0 |
| 2 | 120.175 | 899.011 | 5 / 5 | 5 / 0 |
| 3 | 120.140 | 858.095 | 5 / 5 | 5 / 0 |
| 4 | 121.938 | 869.499 | 5 / 5 | 5 / 0 |
| 5 | 121.294 | 856.470 | 5 / 5 | 5 / 0 |

| Recorded result | Minimum | Median | Maximum |
| --- | ---: | ---: | ---: |
| first readable | 119.769 ms | 120.175 ms | 121.938 ms |
| bounded pagination | 856.470 ms | 869.499 ms | 899.011 ms |

M1 first-readable median was 121.292 ms; M2 is 1.117 ms lower and remains
comfortably below the 200 ms acceptance threshold. M1 complete-book
pagination was 8650.034 ms. M2 prepares only the five-bite initial window in
869.499 ms median, eliminating 7780.535 ms (89.95%, about 9.95 times less
background duration) and never starting the other 203 bites.

## Frames

| Run | Frames | Build avg / p99 / worst (ms) | Build misses | Raster avg / p99 / worst (ms) | Raster misses | GC new/old |
| --- | ---: | --- | ---: | --- | ---: | ---: |
| warm-up | 8 | 4.305 / 14.485 / 14.485 | 0 | 4.250 / 7.479 / 7.479 | 0 | 4 / 2 |
| 1 | 9 | 6.523 / 20.608 / 20.608 | 1 | 4.116 / 4.960 / 4.960 | 0 | 4 / 2 |
| 2 | 8 | 6.988 / 17.783 / 17.783 | 1 | 3.878 / 5.868 / 5.868 | 0 | 4 / 0 |
| 3 | 9 | 7.992 / 20.406 / 20.406 | 1 | 3.707 / 5.465 / 5.465 | 0 | 4 / 2 |
| 4 | 8 | 6.302 / 13.360 / 13.360 | 0 | 3.372 / 4.011 / 4.011 | 0 | 3 / 0 |
| 5 | 8 | 7.000 / 20.730 / 20.730 | 1 | 3.437 / 4.078 / 4.078 | 0 | 5 / 2 |

M1 recorded 266 frames per open and 24-49 build misses. M2 records 8-9
frames, 0-1 build misses, and no raster misses. The short manual `gfxinfo`
sample covered only 14 import/image/rotation/reflow transition frames and is
not statistically useful; the Flutter profile table is the comparable frame
baseline.

## Memory and cache

- library before open: 156925 KB total PSS
- one second after opening reader: 167920 KB
- after multiple window crossings: 194744 KB
- after rotation: 191229 KB
- after Plain Reading Mode and font reflow: 199771 KB
- five successive close/reopen samples: 189984, 194132, 198624, 198070,
  and 198478 KB
- after five seconds settling: 182271 KB

M1's immediate post-open/full-pagination sample was 326031 KB and settled to
180040 KB. M2 removes the transient full-book peak while returning to a
similar settled application footprint. Repeated opens plateau rather than
growing continuously.

The cache policy is a 32-entry access-ordered LRU. The initial Samsung window
used 5 entries and 0 evictions. A focused unit regression with a two-entry
limit proves reuse, least-recently-used eviction, the hard size bound, and the
eviction counter. Reader widget tests prove the materialized PageView remains
at or below nine bites while moving across window boundaries.

## Device verification

On the normal profile app with the same Alice fixture:

- opening displayed the cover immediately and retained BookBites' vertical
  bite presentation;
- repeated vertical swipes crossed several lazy-window boundaries without a
  blank page, duplication, or visible location shift;
- whole-book search jumped directly from an early chapter location to the
  unloaded Cheshire-Cat result;
- portrait-to-landscape-to-portrait retained that canonical location;
- Plain Reading Mode and font-size reflow retained the Cheshire-Cat content;
- closing to the library and reopening restored the same saved location;
- five repeated close/open cycles stabilized in memory;
- captured logcat contained no BookBites ANR, input-dispatch timeout, fatal
  signal, fatal Android exception, Flutter exception, or unhandled exception.

Device rotation settings were restored to their detected original values:
`accelerometer_rotation=0`, `user_rotation=0`.

## Readest/Foliate comparison and provenance

This remains concept-only adaptation:

- Readest: `6469cbb5b5799912b6376765d57175f5552eedf7`, AGPL-3.0
- pinned Foliate-js: `f6bce4ce81d7cc6cd5df156a9867e3f0daa0427c`, MIT
- studied: `packages/foliate-js/view.js`, `paginator.js`, and `epub.js`
- relevant behavior: canonical target resolution; direct unloaded-section
  loading; bounded adjacent fill (`minPages = 5`, `maxSections = 8`); distant
  view trimming; resource reference counting/unload; stale-work guards; and
  full teardown
- BookBites translation: a nine-bite Flutter PageView window, direct canonical
  target materialization, generation guards, and a 32-entry pagination LRU
- no Readest or Foliate source was copied or mechanically translated

## Excluded setup failure

One pre-measurement driver attempt is excluded: the fixture was copied after
the ten-second setup window, so the test correctly failed before import. It
produced no reader timing data. The accepted table is from the subsequent
single clean process with the fixture verified in the sandbox before traced
work began.
