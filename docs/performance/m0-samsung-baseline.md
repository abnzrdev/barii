# M0 Samsung profile baseline

Recorded 2026-08-07 from BookBites `a71371191805ae482213f8ac618682afc4e0b72c`
plus the M0 instrumentation change, on the detected physical device:

- serial: `R9ZX30B0CHB`
- model: Samsung `SM-M145F`
- Android: 15
- mode: Flutter profile

## Fixture

The benchmark uses Readest's local test fixture
`apps/readest-app/src/__tests__/fixtures/data/sample-alice.epub`. It is not
copied into or committed to BookBites.

- size: 414345 bytes
- SHA-256: `a6403b7951058243f91843bbe8a9e46ed205d5a7dcdb9758f70f11e360e17246`
- imported result: 16 sections, 208 bites, 246 display pages

## Commands

```sh
adb devices -l
sha256sum ../_references/readest/apps/readest-app/src/__tests__/fixtures/data/sample-alice.epub
stat -c '%s' ../_references/readest/apps/readest-app/src/__tests__/fixtures/data/sample-alice.epub

flutter build apk --profile \
  --target=integration_test/reader_android_test.dart \
  --dart-define=BOOKBITES_BASELINE_PROFILE_ONLY=true \
  --dart-define=BOOKBITES_BENCHMARK_EPUB_PATH=/data/user/0/com.abnzr.bookbites/files/benchmark.epub
adb -s R9ZX30B0CHB install -r build/app/outputs/flutter-apk/app-profile.apk
adb -s R9ZX30B0CHB push \
  ../_references/readest/apps/readest-app/src/__tests__/fixtures/data/sample-alice.epub \
  /data/local/tmp/bookbites-baseline.epub
adb -s R9ZX30B0CHB shell run-as com.abnzr.bookbites mkdir -p files
adb -s R9ZX30B0CHB shell run-as com.abnzr.bookbites cp \
  /data/local/tmp/bookbites-baseline.epub files/benchmark.epub
flutter drive --profile --no-start-paused --no-dds \
  --use-application-binary=build/app/outputs/flutter-apk/app-profile.apk \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/reader_android_test.dart \
  -d R9ZX30B0CHB

adb -s R9ZX30B0CHB shell am force-stop com.abnzr.bookbites
adb -s R9ZX30B0CHB shell am start -W \
  -n com.abnzr.bookbites/.MainActivity
adb -s R9ZX30B0CHB shell dumpsys meminfo com.abnzr.bookbites
adb -s R9ZX30B0CHB shell dumpsys gfxinfo com.abnzr.bookbites
adb -s R9ZX30B0CHB shell top -b -n 1 -p "$(adb -s R9ZX30B0CHB shell pidof com.abnzr.bookbites)"
adb -s R9ZX30B0CHB logcat -d -v threadtime
```

The integration report is written to the ignored
`build/integration_response_data.json`. Run 0 is the warm-up; runs 1-5 are
recorded. `Reader.paginateBite` is retained, so DevTools can also attribute
individual bites.

## Raw results

Cold startup (`am start -W`, milliseconds):

| Run | TotalTime | WaitTime |
| --- | ---: | ---: |
| warm-up | 2575 | 2596 |
| 1 | 1760 | 1767 |
| 2 | 1580 | 1590 |
| 3 | 1264 | 1276 |
| 4 | 1329 | 1344 |
| 5 | 1550 | 1563 |

Reader timings are measured from the first actual `Reader.paginateBite` event.
The final column is the post-frame interval between complete pagination and
`Reader.firstReadablePage`.

| Run | Pagination (ms) | First readable (ms) | Final frame (ms) |
| --- | ---: | ---: | ---: |
| warm-up | 8352.890 | 8492.200 | 139.310 |
| 1 | 8219.399 | 8366.070 | 146.671 |
| 2 | 7653.048 | 7795.385 | 142.337 |
| 3 | 8329.723 | 8468.299 | 138.576 |
| 4 | 8319.461 | 8452.287 | 132.826 |
| 5 | 8305.322 | 8434.093 | 134.771 |

Import timeline (warm-up only):

| Event | Duration (ms) |
| --- | ---: |
| `Import.total` | 888.995 |
| `Import.fileRead` | 8.219 |
| `Import.fingerprint` | 23.699 |
| `Epub.parse` | 519.009 |
| `Epub.archiveDecode` | 15.805 |
| `Epub.packageParse` | 204.320 |
| `Epub.contentCanonicalization` | 79.998 |
| `Import.biteGeneration` | 153.926 |
| `Import.managedFiles` | 40.131 |
| `Import.databasePublication` | 39.980 |

Flutter frame report for recorded reader opens:

| Run | Frames | Build avg/p99/worst (ms) | Build misses | Raster avg/p99/worst (ms) | Raster misses |
| --- | ---: | --- | ---: | --- | ---: |
| 1 | 212 | 1.193 / 23.066 / 27.063 | 3 | 3.136 / 4.155 / 4.803 | 0 |
| 2 | 212 | 1.218 / 21.011 / 22.717 | 3 | 3.198 / 4.596 / 18.616 | 1 |
| 3 | 212 | 1.393 / 19.138 / 22.753 | 4 | 3.260 / 4.120 / 4.874 | 0 |
| 4 | 212 | 1.303 / 15.478 / 22.101 | 2 | 3.309 / 7.013 / 9.191 | 0 |
| 5 | 212 | 1.543 / 20.739 / 42.613 | 4 | 3.284 / 5.517 / 6.048 | 0 |

Point-in-time device samples were 151122 KB total PSS at the library and
213719 KB while the integration reader/profile trace was active. The latter
includes integration-test and VM timeline overhead, so this is a conservative
ceiling, not a claimed 62597 KB production reader delta. A `top` sample during
reader work showed 46.6% process CPU. The five Flutter reports recorded 12-18
new-generation and 4-6 old-generation collections per run.

No BookBites ANR, input timeout, fatal signal, or fatal Dart/Android exception
appeared in the captured logcat. One initial harness run failed because the
fixture's first page is a cover figure rather than `SelectableText`; the
behavior-neutral assertion was corrected and the failed run was not included
in the five measurements.

## Summary

| Measurement | Minimum | Median | Maximum |
| --- | ---: | ---: | ---: |
| cold startup TotalTime (ms) | 1264 | 1550 | 1760 |
| cold startup WaitTime (ms) | 1276 | 1563 | 1767 |
| complete pagination (ms) | 7653.048 | 8305.322 | 8329.723 |
| first readable content (ms) | 7795.385 | 8434.093 | 8468.299 |
| pagination-to-readable frame (ms) | 132.826 | 138.576 | 146.671 |

The highest-confidence M1 bottleneck is the reader's serial, complete-book
pagination before publishing any page. It consumes about 98% of measured
tap-to-readable latency for this fixture; parsing and import occur only once
and are an order of magnitude smaller. M1 should make the first anchored page
available before the remaining book is paginated, while retaining canonical
anchors and BookBites' vertical bite presentation.
