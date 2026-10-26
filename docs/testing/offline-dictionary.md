# Bundled dictionary verification

Barii includes 178,776 lexical entries, 239,354 senses and 134,886 form mappings
from Simple English Wiktionary and Open English WordNet 2025. Entries are not
unique headword counts. 55,111 entries contain spaces; this includes compounds
as well as idioms. The pack is 21,913,768 bytes compressed and 62,742,528 bytes
after local installation, excluding the small application catalogue row.

Startup installs the bundled asset into the existing dictionary-pack catalogue
before opening the library. Installation verifies SHA-256 and uses a temporary
file. An existing installation is reused. There is no runtime downloader,
remote lookup, translation API, or AI model. Dictionaries settings can disable
or reorder sources; the bundled pack cannot be removed through that screen.

## Interaction

- Focused reader: hold a word for a quick definition; release to dismiss. Drag
  upward while holding to expand. Drag sideways/downward to select text and
  access Define, Highlight, Underline, Note and Copy.
- Original EPUB: hover on desktop or hold on touch for a preview. Click the
  preview or drag upward while holding to expand. Desktop selected phrases
  can be looked up with D. Original EPUB retains native browser selection.
- Expanded dictionary: mobile draggable sheet initially occupies 70% of the
  screen; desktop uses a side dialog. Close, Escape, Back or drag down returns
  to reading. Save is explicit. Search browsing is not falsely attached to the
  previously selected occurrence.
- Vocabulary: tap a saved occurrence to return. Quote and surrounding text
  validate source offsets; ambiguous recovery must not guess. A temporary
  highlight marks the restored word without adding a permanent annotation.

## Checks

Run `flutter test test/features/dictionary`, migration tests and reader tests.
The production-pack test installs from real assets into a fresh temporary
directory and tests common/advanced words, inflections, phrase matching,
multiple senses, synonyms, missing entries, idempotence and lookup timings.
Run `flutter test integration_test/reader_windows_test.dart -d windows` for
real WebView2 lookup, saving, layout, fullscreen and chapter-navigation checks.

For an airplane-mode device check: install the complete package, disconnect
before first launch, import a local EPUB, look up words, save one, restart and
return from vocabulary. Keep the app's existing data when upgrading.

Context ranking uses dictionary-attested phrases, morphology and lexical
overlap. It cannot reliably disambiguate every sentence. All available meanings
remain accessible. Definitions are original source text, not automatically
simplified; some WordNet explanations are technical.

Word-of-the-Day notifications, PDF/OCR and web import remain separate roadmap
features and are not required to look up or save words offline.

## Verified release: 0.2.0-beta.1+2

- Formatting: no outstanding changes; static analysis: no issues.
- Full Flutter test suite: 144 passed, one pre-existing skip. This includes
  authentic database migrations v1–v13, interrupted appearance-upgrade recovery,
  vocabulary retention after reparse, actual bundled-pack coverage and gesture
  tests. Startup golden references were visually reviewed before refreshing.
- Windows native integration: passed. Real WebView2 hover lookup, full-panel
  save, exact saved-word return and temporary CSS highlight were exercised,
  alongside layout, appearance, fullscreen, selection and chapter navigation.
- A copy of the existing Windows library upgraded successfully. The final ZIP
  was extracted and launched against the existing library; books remained
  available, reading resumed, and the complete dictionary panel was visually
  checked.
- Windows release ZIP: 36,679,799 bytes. SHA-256:
  `c6fbe5b5b5c9eacf9775def29151161cb4d0565e194f415d7352ce06f8c06c66`.
- Android universal release APK: 90,614,970 bytes, version code 2, minimum API
  24, arm64-v8a/armeabi-v7a/x86_64. V2 and V3 signatures verify. It uses the
  same local Android development certificate as the previous debug APK, for
  personal testing; this is not a store-signing setup. SHA-256:
  `255b3f52a326e33beffe67008f8f8f431fcbc02a18c7205b3ebed5b26b56fe93`.
- Both delivered archives contain the real dictionary and all data licences.
  The packaged asset SHA-256 was checked directly inside each archive against
  the manifest. No separate dictionary download is needed.

Android phone execution remains unverified because the attached device reports
`unauthorized` to ADB. Touch behavior is covered by Flutter widget tests, and
the native EPUB bridge is exercised on Windows. Linux cannot be built or run
on this Windows host. These are platform-verification limits, not claims of
device testing. Future release builds should allow Flutter's normal tooling
preparation (`flutter build apk --release`): `--no-pub` can retain a stale
development-plugin registrant after integration tests.

## Popup correction for published build +3

The quick card now uses its measured layout height rather than reserving 220
pixels above a word. Regression tests verify an 8-pixel gap, short/long
definitions, enlarged text, screen edges and clicks outside the card. Desktop
hover dwell is 250 ms; touch remains 450 ms. Original EPUB builds its immutable
text/context index once after dwell instead of scanning on every pointer move.

The full suite passes 150 tests with one existing skip; static analysis passes.
The native Windows test verifies the real card's 8-pixel separation and measured
363 ms from hover event through local lookup and layout. Both release packages
are rebuilt as 0.2.0-beta.1+3; final asset checksums accompany the GitHub release.

Final download SHA-256:

- `barii-0.2.0-beta.1-windows-x64.zip`:
  `46fc2098b43012d15ffd093fd745b837714bf74cd8e32da411169bc68a8a0066`
- `barii-0.2.0-beta.1-android.apk`:
  `5467428ac2835b33918815c463398b5049734907d52d5118ddea0ce6a5e16d5f`
