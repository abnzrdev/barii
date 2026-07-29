# EPUB Options

Research checked package documentation and linked source on 2026-07-29 rather
than relying only on pub.dev platform badges.

| Option | License | Actual target support | Fit |
|---|---|---|---|
| `epubx` 4.0.0 | MIT | Pure Dart parser; Android and Linux work because parsing is not a platform view. Last stable release is older but its archive/XML approach remains portable. | Chosen for local metadata/content extraction. |
| `flutter_epub_viewer` 2.0.0 | BSD-3-Clause | Uses `flutter_inappwebview`; current package targets Android, iOS, macOS, and web, not Linux. Android also needs WebView-specific cleartext setup. | Rejected as reader core and for Linux. |
| `flutter_readium` | BSD-3-Clause | Documentation lists Android, iOS, and web. Native Linux is absent; Android requires API 24 and a fragment activity. | Rejected for Linux and custom bite rendering. |
| `epub_view` 3.2.0 | MIT | Pure Flutter rendering documents Android and Linux support, but it renders publications/pages rather than BookBites’ normalized stable bites. | Credible cross-platform viewer, rejected as core. |
| `katbook_epub_reader` 2.1.2 | MIT | Pure Flutter and advertises Android/Linux, but has a small user base and pulls rendering/font dependencies unnecessary for parsing. | Rejected in favor of the narrower parser. |

BookBites therefore uses `epubx` only for EPUB container, metadata, and spine
content extraction. HTML is sanitized separately and bites are rendered by
ordinary Flutter widgets. This keeps Android/Linux behavior identical and
avoids coupling progress to a third-party viewport or CFI renderer.
