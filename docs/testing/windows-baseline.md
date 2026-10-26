# Windows baseline

Windows x64 is built through the existing Flutter runner in `windows/`.
CI uses Flutter 3.47.6 on Windows, Linux, and Android. The Windows job uploads
the complete release directory, including native libraries, assets, LICENSE,
and NOTICE. It does not publish a release or install prerequisites.

## Reading fullscreen

The reader uses `window_manager` 0.5.2 for native desktop fullscreen. The
plugin preserves native window placement; Barii keeps its existing text anchor
through viewport changes. F11 toggles fullscreen without reacting to key repeat.
Escape closes a reader panel first and then leaves fullscreen. Navigating away
from the reader exits fullscreen. Original EPUB keyboard events travel through
the existing JavaScript channel, including F11 and Escape.

## Validation on Windows

Run from the repository root with Flutter on PATH:

```powershell
flutter analyze
flutter test test/core test/features
flutter test integration_test/reader_windows_test.dart -d windows
flutter build windows --release
```

The native integration test creates its own temporary on-disk database and
book storage. It imports TXT and an EPUB fixture, verifies native fullscreen
and restored window bounds, checks progress across reopening, and verifies
F11/Escape through the real WebView2 JavaScript bridge. It never opens the
normal application library. The fixture opened in Original view is valid XHTML.

The initial Windows validation passed 132 core/feature tests with one existing
skip, and the native Windows integration test passed. Formatting and static
analysis passed. Linux and Android native builds were not run on this host.

The full `flutter test` run additionally found three bootstrap golden-image
comparisons that do not match the checked-in reference images on this checkout
and SDK. Their reference images were preserved. Failure artifacts were moved
under `build/bootstrap-golden-failures/` for inspection; this is not a claim
that the full suite is green.

## Distribution limits

Run `build/windows/x64/runner/Release/barii.exe`. Copy or zip the entire
`Release` directory when distributing it, not only the executable.

Original EPUB view needs the Microsoft WebView2 Runtime. Offline deployment
to a machine without the runtime must supply Microsoft's Evergreen Standalone
Installer. The portable Barii bundle does not currently install it. Test a
future installer on a clean offline Windows machine before describing setup
as self-contained.

The production dictionary is a subsequent milestone. This baseline still has
the existing dictionary behavior and seven development fallback definitions.
