# M1 incremental first-readable Samsung baseline

Recorded 2026-08-07 from M1 on top of Barii M0 commit
`01a93aae139722dd4e20c0adc3e6e1bd4e859625` using the same physical Samsung
`SM-M145F` (`R9ZX30B0CHB`, Android 15), profile mode, and M0 fixture.

## Fixture and procedure

- file: Readest test fixture `sample-alice.epub` (not committed to Barii)
- size: 414345 bytes
- SHA-256: `a6403b7951058243f91843bbe8a9e46ed205d5a7dcdb9758f70f11e360e17246`
- result: 16 sections, 208 bites, 246 display pages
- runs: one warm-up followed by five recorded opens

The M0 harness was reused. A compile-time setup delay lets the unchanged local
fixture be copied into the app sandbox after `flutter drive` installs the APK;
the delay is outside every traced open action.

```sh
flutter build apk --profile \
  --target=integration_test/reader_android_test.dart \
  --dart-define=BARII_BASELINE_PROFILE_ONLY=true \
  --dart-define=BARII_BENCHMARK_EPUB_PATH=/data/user/0/com.abnzr.barii/files/benchmark.epub \
  --dart-define=BARII_BENCHMARK_SETUP_DELAY_SECONDS=10

flutter drive --profile --no-start-paused --no-dds \
  --use-application-binary=build/app/outputs/flutter-apk/app-profile.apk \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/reader_android_test.dart \
  -d R9ZX30B0CHB
```

During the ten-second setup window:

```sh
adb -s R9ZX30B0CHB shell run-as com.abnzr.barii mkdir -p files
adb -s R9ZX30B0CHB shell run-as com.abnzr.barii cp \
  /data/local/tmp/barii-baseline.epub files/benchmark.epub
```

## Reader timings

The exported trace did not retain the nested foreground task or named
first-readable marker. The conservative first-readable bound below therefore
uses the start of the second `Reader.paginateBite`: M1 awaits publication and
two completed frames before it permits that second bite to start. Actual first
display cannot be later than this boundary. Complete pagination retains the M0
definition, first `Reader.paginateBite` start to `Reader.pagination` completion.

| Run | First-readable upper bound (ms) | Complete pagination (ms) |
| --- | ---: | ---: |
| warm-up | 116.425 | 8123.443 |
| 1 | 120.558 | 8724.980 |
| 2 | 125.964 | 8715.070 |
| 3 | 121.469 | 8650.034 |
| 4 | 119.043 | 8645.396 |
| 5 | 121.292 | 8586.163 |

| Recorded result | Minimum | Median | Maximum |
| --- | ---: | ---: | ---: |
| first-readable upper bound | 119.043 ms | 121.292 ms | 125.964 ms |
| complete pagination | 8586.163 ms | 8650.034 ms | 8724.980 ms |

M0 first-readable median was 8434.093 ms. M1's conservative median upper bound
is 121.292 ms: 8312.801 ms lower, a 98.56% reduction (about 69.5 times faster).
Complete pagination increased from 8305.322 ms to 8650.034 ms (344.712 ms,
4.15%) because incremental publication adds bounded intermediate Flutter
frames while the unchanged paginator completes in the background.

## Frame and memory observations

| Run | Frames | Build avg / p99 / worst (ms) | Build misses | Raster avg / p99 / worst (ms) | Raster misses |
| --- | ---: | --- | ---: | --- | ---: |
| 1 | 266 | 4.770 / 22.255 / 23.826 | 46 | 3.447 / 5.577 / 6.188 | 0 |
| 2 | 266 | 4.284 / 21.765 / 22.829 | 36 | 3.399 / 4.643 / 9.436 | 0 |
| 3 | 266 | 4.909 / 22.758 / 24.415 | 49 | 3.502 / 4.471 / 6.976 | 0 |
| 4 | 266 | 4.751 / 22.587 / 27.768 | 45 | 3.497 / 4.246 / 18.217 | 1 |
| 5 | 266 | 3.590 / 21.925 / 38.263 | 24 | 3.056 / 4.185 / 5.147 | 0 |

Raster performance remained bounded, but incremental list publication raised
build work relative to M0. This is the next measured optimization target; it
does not block first readable content.

On the normal profile app, total PSS was 326031 KB immediately after opening
and full pagination/image display, then 180040 KB after swipes, reopen,
rotation, Plain Reading Mode, settings reflow, and GC/resource settling. The
large transient and retained pagination/image footprint remains an M2/M3
investigation; M1 deliberately does not change cache policy.

## Device verification

The normal profile APK was inspected on the Samsung using the same Alice EPUB:

- the cover was readable approximately one second after tapping the book;
- three vertical swipes advanced from the cover to the About bite;
- returning to the library and reopening restored the About location;
- portrait-to-landscape-to-portrait retained the same canonical content;
- enabling Plain Reading Mode hid the About heading without removing its body;
- changing font size reflowed while retaining the same bite;
- the completed reader contained all 246 display pages in the benchmark and
  the widget regression materialized all 200 fixture pages;
- no Barii ANR, input timeout, fatal signal, fatal Android exception, or
  Flutter exception appeared in the captured logcat.

Android `dumpsys gfxinfo` from the short manual session contained only seven
frames and is not statistically useful (all included import/image/reflow
transitions); the 266-frame-per-run Flutter profile table above is the useful
frame baseline.

## Readest/Foliate comparison and provenance

The implementation is concept-only adaptation:

- Readest repository: `6469cbb5b5799912b6376765d57175f5552eedf7`, AGPL-3.0
- Foliate-js submodule: `f6bce4ce81d7cc6cd5df156a9867e3f0daa0427c`, MIT
- studied files: `packages/foliate-js/view.js` and
  `packages/foliate-js/paginator.js`
- principle used: resolve the canonical navigation target, render its section,
  then fill adjacent content without making disposable display indexes the
  authoritative location
- implementation: independently written Flutter/Dart using existing
  `BitePaginationCache`, `DisplayPage`, `PageView`, and bite/source offsets
- no Readest or Foliate source was copied or mechanically translated

## Excluded attempts

Several setup attempts were excluded rather than averaged: the Samsung first
disconnected; later `flutter drive` installs cleared the fixture before the
test could read it; two orphaned driver processes briefly overlapped; and two
diagnostic captures established that the exported trace omitted instant/nested
foreground events. The final table comes only from one clean driver process,
one verified fixture, one warm-up, and five consecutive recorded runs.
