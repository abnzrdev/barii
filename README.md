# Barii

**Offline-first reading, one bite at a time.**

Barii is a local-first reading workspace for Android and Linux. The current
beta focuses on EPUB and TXT books and keeps the reading experience fast,
focused, and available offline.

The name **Barii** evokes dawn and the beginning of daylight in Afaan Oromo.

## What Barii does

- Imports EPUB and TXT books from local storage.
- Presents focused reading in small text bites.
- Includes original EPUB reading modes.
- Keeps reading progress locally.
- Supports notes, highlights, word selection, and dictionary workflows.
- Provides reader themes and typography controls.
- Runs on Android and Linux.

Barii is currently a beta. EPUB and TXT are the supported publication formats
today; broader document support is future product direction.

## Privacy and offline use

Barii is designed as an offline-first application. Books, progress, notes, and
other reading state are handled locally rather than requiring a cloud account.

## Download

Beta builds are published from the GitHub Releases section.

## Build from source

```bash
flutter pub get
flutter analyze
flutter test
flutter run -d linux
```

## License

Barii is free software licensed under the GNU Affero General Public License
v3.0 or later (`AGPL-3.0-or-later`).

See [LICENSE](LICENSE) and [NOTICE](NOTICE).

Barii may adapt selected components from
[Readest](https://github.com/readest/readest), which is also licensed under
AGPL-3.0-or-later.
