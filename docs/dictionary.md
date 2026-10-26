# Offline English dictionary

The full English dictionary ships with Barii, works from the first offline
launch, and requires no separate data download. Its compressed asset adds
about 22 MB to the package and uses about 63 MB of installed data storage.
It contains 178,776 entries and 239,354 meanings, with inflections, phrases,
synonyms and available examples. Definitions come from Simple English
Wiktionary and Open English WordNet 2025. Some definitions are technical.

On desktop, pause the pointer on a word to peek at its meaning. Click the
preview for more meanings. On touch, hold a word, release to dismiss, or move
upward while holding to expand. In the focused reader, moving sideways or
downward while holding selects text for highlighting, notes and Define.
Original EPUB supports native text selection; on desktop press D with a word
or short phrase selected. The dictionary toolbar button remains available.

Expanded definitions can be dismissed with the close button, Escape, Back,
or by dragging the mobile sheet down. Reading stays in place. Saving is
explicit: choose Save word or Save this meaning. Open a book's Vocabulary
from the library menu and tap an occurrence to return to its context.
Browsing a different word using dictionary search saves it without inventing
an occurrence at the previous word's location.

Context ranking is deterministic and approximate. It uses attested phrase
matching, word-form normalization and overlap with source definitions and
examples. It does not understand every sentence or guarantee the right
meaning. Other available senses are always shown in the expanded panel.
Unknown words produce a small red indicator instead of interrupting reading.

Full data licences and attribution are bundled under
assets/dictionary/licenses/. Source input hashes and sizes are recorded in
assets/dictionary/manifest.json. See [verification](testing/offline-dictionary.md).
