# Limmud Offline Dictionary Research

Inspected local project:
`/home/abnzr/Applications/Offline-Learning/limmud`.
The path in the request (`~/Applications/limmud`) did not exist.

Git remote: `git@github.com:abnzrdev/LearningAppOffline.git`.
The GitHub repository is
[`abnzrdev/LearningAppOffline`](https://github.com/abnzrdev/LearningAppOffline).
At inspection time its latest commit was `810e12f` (`chore: prepare public
release`) and its only open repository item was a Dependabot pull request.
The local checkout contains unrelated uncommitted work and was not modified.

## Architecture

Limmud application code is MIT licensed. Its dictionary runtime is a Tauri/Rust
service using bundled `rusqlite` and read-only SQLite/FTS5 packs. A Python
standard-library builder streams Kaikki/Wiktextract JSONL or JSONL.GZ into a
versioned pack. Optional Open English WordNet 2025 enrichment is stored in
separate tables.

Schema version 1 contains:

- `pack_metadata` with schema, pack version, build date, and completion marker;
- `dictionary_sources` with source version, licence, attribution, and homepage;
- `entries`, `senses`, `examples`, `pronunciations`, `forms`, `relations`, and
  optional `translations`;
- optional `wordnet_synsets`, `wordnet_lemmas`, and `wordnet_relations`;
- indexes for normalized headwords, forms, relations, and WordNet lemmas;
- `dictionary_fts`, an FTS5 index over headwords, forms, definitions, and
  synonyms.

Installation validates `PRAGMA integrity_check`, schema version, completion
marker, required tables, source records, and source licences. It checks free
space, copies through a temporary file, validates the copy, and atomically
renames it into application data. Runtime lookups open the pack read-only and
run off the UI thread.

Search priority is normalized headword, normalized inflected form, headword
prefix, then bounded FTS. Results are deduplicated by entry ID without merging
legitimate homographs. Python normalization is Unicode `casefold`; Rust uses
Unicode lowercase. Apostrophes, hyphens, and diacritics are preserved.
Morphology is data-driven through the `forms` table rather than a universal
stemmer.

Entries represent headword, part of speech, ordered senses, examples, IPA,
region, audio filename metadata, forms, relations, etymology, and contributing
sources. Audio files are not bundled.

The runtime is desktop-only Tauri. The pack format itself is portable.
Barii proved the same fixture pack can be opened read-only and queried,
including FTS5, through Flutter's current SQLite runtime. That runtime supports
both Android and Linux.

## Data licences

- Limmud code: MIT.
- Kaikki/Wiktextract-derived Wiktionary data: CC BY-SA and GFDL; attribution
  and share-alike obligations apply to dictionary content and derived packs.
- Open English WordNet 2025: CC BY 4.0.
- Limmud's small Kaikki-shaped fixture: independently authored, CC BY-SA 4.0.
- Limmud's synthetic WordNet-shaped fixture: CC BY 4.0.

Application-code licensing does not grant redistribution rights to dictionary
data. Barii therefore does not bundle a production dictionary dump.

## Reuse decision

Reused independently: the SQLite pack contract, validation rules, bounded
search order, immutable definition snapshots, source metadata, atomic import
workflow, and test cases. No Rust, TypeScript, Python, or dictionary records
were copied into Barii. Users may import a compatible Limmud pack they
build or obtain under appropriate data terms.

