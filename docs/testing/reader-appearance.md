# Reader appearance and EPUB fit

Reader settings now include Reading font (Book serif, Clean sans, Monospace)
and Reading background (App theme, Paper, Sepia, Night). The options apply to
both reader views and persist in reader preferences. Font families use local
system fallbacks; no fonts or services are fetched while reading.

Schema 13 adds `font_family` and `reading_background`, defaulting to the
previous serif and application-theme behavior. Migration tests cover authentic
schema fixtures from versions 1 through 12 and preserve existing reading data.

Original EPUB view now uses scrolling consistently. Legacy `original-pages`
preferences still open the same book in Original view, using scroll layout.
The floating previous/next section buttons and Scroll/Pages switch are removed.
Keyboard chapter navigation remains available. A fresh upward swipe starting
at the bottom of a chapter opens the next linear chapter; a downward swipe
starting at the top opens the previous one. Active text selection suppresses
edge gestures. Mouse-wheel chapter navigation requires a gesture beginning
at an edge; arriving there during a continuous wheel gesture does not arm it.

The EPUB viewport is inserted when absent. Reader styles use the XHTML
namespace, enforce bounded widths and responsive images, and allow code blocks
and tables to scroll inside themselves. The local content policy permits inline
styles while continuing to block publication scripts and network connections.
Injected styles apply the chosen font, size, spacing, margins, foreground and
background. Appearance changes capture the existing DOM text location before
reinstalling styles.

`webview_all` is pinned to 1.4.7. The previous version retained a desktop-sized
viewport when the Flutter widget was narrowed in the Windows native test;
the new version passes the phone-width viewport checks.

## Validation

- 133 core/feature tests pass; one existing test is skipped.
- Windows native integration passes with a 390-pixel reading area. It measures
  actual DOM widths, image fit, padding, font size and background colour, and
  verifies selection suppresses chapter-edge navigation before checking a
  successful chapter transition and the fullscreen keyboard bridge.
- Static analysis and formatting pass.
- Android debug APK builds successfully. Android touch behavior still needs
  confirmation on a physical phone; desktop phone-width checks do not replace it.
- Startup golden references have since been visually reviewed and refreshed for
  the current theme, library icon and pinned Flutter SDK; see the dictionary
  verification record for the latest full-suite results.

To check manually, open a book, use the settings gear, change the reading font
and background, then switch between Barii and Original views. Resize the window
or use a phone and confirm ordinary paragraphs need no horizontal scrolling.
Check a chapter-ending swipe only after releasing any text selection.
