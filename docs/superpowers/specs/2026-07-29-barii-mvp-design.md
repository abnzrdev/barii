# Barii MVP Design

## Scope

Barii is an offline-first Flutter reader for Android and Linux. It imports
DRM-free EPUB and TXT files, copies them into app storage, converts them into
stable 100–180-word reading bites, and stores all reader data locally. PDF,
DRM, accounts, sync, downloads, and non-target platform setup are excluded.

## Architecture

Use a small feature-first Flutter application. Riverpod owns application
services and observable UI state. One Drift database owns books, source
sections, bites, progress, notes, vocabulary, and reader preferences. Import
services parse TXT directly and EPUB through `epubx`, sanitize EPUB HTML with
`html`, fingerprint source bytes with `crypto`, and persist one normalized copy
of each book. Flutter widgets render bites directly; no embedded EPUB viewer is
the reader core.

The stable book fingerprint is the duplicate-import key. A bite ID is SHA-256
of the fingerprint, ordered source-section index, and source text offsets.
Progress stores a bite ID, with ordinal fallback if a bite is unavailable.

## UI and interaction

The library is a responsive Material 3 grid/list with import, bundled sample,
rename, delete confirmation, notebook, and vocabulary entry points. The reader
shows exactly one bite, never a page total or chapter length. A centered reading
column adapts to phone and desktop widths.

Vertical drag completion changes bites only after direction and threshold are
unambiguous. Horizontal drag completion opens notes or dictionary and never
also changes the bite. Edge padding keeps gesture starts away from Android
system-navigation edges. Buttons, tooltips, semantics, and Linux shortcuts
offer equivalent access. Notes and dictionary use a side panel on wide layouts
and a modal bottom sheet on narrow layouts.

## Data and failures

Database schema version 1 starts with explicit foreign keys, cascading record
deletion, uniqueness constraints, and indexes. File deletion happens after the
database transaction succeeds; a failed file removal is reported and may be
retried. Import rejects unsupported extensions, empty content, corrupt EPUB
archives, encrypted/DRM resources detectable from EPUB metadata, and duplicates
without corrupting the library. Missing metadata falls back to filename and
“Unknown author”.

Parsing remains on the main isolate for the MVP. The UI shows an importing
state; isolates are added only after profiling shows frame stalls on realistic
large fixtures.

## Testing

Pure unit tests cover bite boundaries, headings, long/short inputs, Unicode,
stable IDs, sanitization, malformed input, TXT import, EPUB metadata, and word
normalization. An in-memory Drift database covers progress, notes, vocabulary,
constraints, and cascades. Widget tests cover rendering, controls, gestures,
keyboard navigation, panels, and semantics. Final validation runs formatting,
dependency resolution, analysis, tests, Linux build, Android debug build when
available, and a Linux launch smoke test when a display is available.

## License boundary

Readest is used only as behavioral and architectural research. No Readest
source is copied or mechanically translated. Dependency licenses and platform
support are recorded separately.
