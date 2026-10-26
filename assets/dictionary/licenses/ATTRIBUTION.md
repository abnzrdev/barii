# Barii English dictionary data

The bundled database is a compact conversion of the following published data.
Definitions were not generated or rewritten. The Barii application licence does
not replace these data licences.

## Simple English Wiktionary

Copyright the contributors to Simple English Wiktionary.
Source: https://simple.wiktionary.org/
Extract: https://kaikki.org/dictionary/downloads/simple/simple-extract.jsonl.gz
Extraction by Wiktextract / Kaikki.org; Wikimedia dump dated 2026-10-02.
Entries link to their original Wiktionary pages; contributor histories are
available using the history tab of those pages.

Redistributed under Creative Commons Attribution-ShareAlike 4.0 International:
https://creativecommons.org/licenses/by-sa/4.0/
See CC-BY-SA-4.0.txt for the full licence. The Simple English derived content in
this database is available under the same licence. Changes: English-only
selection, normalized forms, compact SQLite conversion, omission of etymology,
translations, media, and examples (including third-party quotations). No
endorsement by Wikimedia, Wiktionary, or Kaikki.org is implied.

## Open English WordNet 2025

Copyright the Open English WordNet contributors and Princeton University.
Source: https://en-word.net/ (2025 release)
Archive: https://en-word.net/downloads/english-wordnet-2025-json.zip
Repository: https://github.com/globalwordnet/english-wordnet

Redistributed under Creative Commons Attribution 4.0 International with the
underlying Princeton WordNet licence notices. Full notices and licence text
are in OEWN-LICENSE.md and PRINCETON-LICENSE.txt. Changes: SQLite conversion,
selected definition/example/synonym/form fields, no lexical graph export.

## Reproduction and integrity

assets/dictionary/manifest.json records input URLs, exact SHA-256 hashes,
counts, and output hashes. tool/build_dictionary.dart converts the two local
source archives reproducibly. No network request is made by the application
to install or search this database. english.sqlite.gz is shipped in the app
and unpacked locally on first launch.
