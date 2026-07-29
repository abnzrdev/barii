# BookBites Agent Instructions

## Working style

- Read this file before making changes.
- Use the installed Ponytail plugin in full mode.
- Reuse existing Flutter packages and platform features before writing custom code.
- Work on only one small milestone at a time.
- Do not generate the whole application in one response.
- Inspect existing code before proposing new abstractions.
- Avoid placeholder architecture that is not needed by the current milestone.
- Run formatting, analysis, and relevant tests after changes.

## Product

BookBites is an offline-first Flutter reader for Android and Linux.

The reader displays one small text bite at a time:

- Swipe up: next bite.
- Swipe down: previous bite.
- Swipe left: notes.
- Swipe right: dictionary.
- Long press: select or define a word.
- Hide page totals and chapter size while reading.

## Readest reference

Readest is available at:

    ../_references/readest

Study it before implementing reader features.

Useful areas to inspect:

- EPUB parsing and book structure
- Reading navigation
- Notes and highlights
- Dictionary lookup
- Local persistence
- Accessibility
- Keyboard navigation
- Reader themes and typography

Do not rebuild mature functionality when an appropriate maintained Flutter
package already exists.

## Licence rule

Readest itself uses AGPL-3.0.

Study its architecture, behavior, tests, dependency choices, and user experience.
Do not paste or mechanically translate Readest source into BookBites unless the
project owner explicitly chooses an AGPL-compatible licence and the required
attribution and source obligations are followed.

Prefer independently implementing the BookBites interface with permissively
licensed Flutter packages.

## Validation

Before finishing a milestone, run:

    dart format .
    flutter analyze
    flutter test
