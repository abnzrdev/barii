<div align="center">
  <img src="docs/assets/barii-logo.webp" alt="Barii app icon" width="180" />

# Barii

**Offline-first reading, one bite at a time.**

A focused reading workspace for EPUB and TXT on Android and Linux.

![Status](https://img.shields.io/badge/status-beta-D8B66A)
![Flutter](https://img.shields.io/badge/Flutter-Dart-02569B?logo=flutter&logoColor=white)
![Platforms](https://img.shields.io/badge/platforms-Android%20%7C%20Linux-1F5A43)
![License](https://img.shields.io/badge/license-AGPL--3.0--or--later-1F5A43)

</div>

Barii is a local-first reading workspace built to make long-form reading feel lighter and more focused. Instead of filling the screen with an entire chapter, Barii can present a small **bite** at a time while keeping your library, progress, notes, highlights, and reading state on your device.

The name **Barii** evokes dawn and the beginning of daylight in Afaan Oromo.

## Why Barii?

Most reading apps optimize for showing pages. Barii experiments with a different question: **what if the reader only had to focus on the next small piece?**

The current beta combines that bite-sized reading flow with a more traditional EPUB view, so you can choose the reading style that fits the moment.

## Features

| | |
|---|---|
| **Focused bite reader** | Read one small text bite at a time with simple directional navigation. |
| **Original EPUB view** | Read EPUB content in its original structure with paginated navigation. |
| **Local library** | Import EPUB and TXT books directly from local storage. |
| **Progress** | Resume reading from locally stored progress. |
| **Notes & highlights** | Keep notes and highlights connected to what you are reading. |
| **Dictionary workflow** | Select words and move into dictionary/definition workflows while reading. |
| **Reader controls** | Adjust themes and typography for a more comfortable reading experience. |
| **Offline-first** | Core reading data stays local and the reading workflow does not depend on a cloud service. |

### Reader gestures

- **Swipe up** → next bite
- **Swipe down** → previous bite
- **Swipe left** → notes
- **Swipe right** → dictionary
- **Long press** → select or define a word

## Current scope

Barii is currently **`v0.1.0-beta.1`**.

- **Supported formats:** EPUB, TXT
- **Platforms:** Android, Linux
- **State:** beta / active development
- **Storage model:** local-first

Broader document support is a future product direction, not current behavior. Formats such as PDF, HTML, Markdown, papers, reports, manuals, articles, and notes should be evaluated carefully before they are added so that format-specific structure and reading semantics are preserved.

## Tech stack

Barii is built with Flutter and Dart, with a small feature-oriented structure.

- **Flutter + Dart** — cross-platform application
- **Riverpod** — application state
- **Drift + SQLite** — local persistence
- **epubx / HTML / WebView tooling** — EPUB parsing and rendering workflows
- **file_selector + path_provider** — local file access
- **Flutter integration tests + unit/widget tests** — validation

```text
lib/
├── app/          # application shell and app-level wiring
├── core/         # shared models, persistence, utilities
└── features/
    ├── dictionary/
    ├── library/
    ├── notes/
    └── reader/
```

## Build from source

### Requirements

- Flutter with a compatible Dart SDK
- Android SDK for Android builds
- Linux desktop dependencies for Flutter Linux builds

### Run

```bash
git clone https://github.com/abnzrdev/barii.git
cd barii
flutter pub get
flutter run -d linux
```

For Android, connect a device or start an emulator and run:

```bash
flutter devices
flutter run -d <device-id>
```

### Validate

```bash
dart format .
flutter analyze
flutter test
```

## Beta builds

The repository is tagged at **`v0.1.0-beta.1`**. Installable GitHub Release artifacts are not published yet, so the current beta should be built from source for now.

## Project notes

Architecture and research notes live under [`docs/`](docs/), including decisions around EPUB rendering, highlights, offline dictionary behavior, performance, and testing.

Barii studies [Readest](https://github.com/readest/readest) as an architectural and UX reference. See [`docs/readest-reference.md`](docs/readest-reference.md) and [`NOTICE`](NOTICE) for project notes and attribution details.

## License

Barii is free software licensed under the **GNU Affero General Public License v3.0 or later** (`AGPL-3.0-or-later`).

See [`LICENSE`](LICENSE) and [`NOTICE`](NOTICE).
