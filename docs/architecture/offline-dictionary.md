# Offline Dictionary Architecture

## Decision

The first production-capable provider is a Limmud-compatible SQLite/FTS5 pack.
BookBites keeps its tiny built-in development definitions as a lowest-priority
source and supports application-managed imports of validated SQLite packs.

| Option | Android/Linux reality | Licence | Decision |
|---|---|---|---|
| Limmud SQLite/FTS5 | Proven through Flutter SQLite PoC on Linux; same bundled SQLite runtime on Android | MIT code; data licences embedded per pack | Selected |
| `mdict_flutter` 0.1.1 | Pure Dart random access and LRU; claims both platforms; only three repository commits and no releases | BSD-3-Clause | Deferred |
| `dict_reader` 1.6.0 | Pure Dart and active, but lacks checksum, LZO, MDict 3.0, and encrypted record-block support | MIT | Deferred |
| StarDict | Readest proves the format, but its reader is AGPL and no maintained Dart package was found | Format data-dependent | Deferred |
| Bundled SQLite | Fast and portable, but a useful production dataset cannot be bundled until redistribution obligations are accepted | Data-dependent | Tiny development fallback only |

No MDict or StarDict dependency is added. Those formats become providers only
after a legal fixture and Android/Linux proof pass.

## Provider contract

`DictionaryRepository` exposes detailed lookup and suggestions.
`DictionaryPackService` owns validated import/removal, while Drift owns
installed-source metadata, enablement, and priority. `BundledDictionary`
remains the no-setup fallback.

Lookup candidates are deterministic: exact selected form, punctuation-trimmed
form, Unicode lowercase, straight/curly apostrophe alternatives, and
English-only possessive/plural/simple inflection candidates for the current
English provider. Other language providers must supply their own candidate
rules rather than reusing English suffix stripping.

Imports are hashed before installation. Duplicate content is rejected, files
are copied through a temporary application-storage path, validated read-only,
and atomically renamed. Validation and integrity checks run in a Dart isolate.
Pack metadata and source licence fields are persisted in Drift. Lookups open
only enabled sources in priority order and retain the winning source.

Saved vocabulary stores a definition snapshot and source metadata. Removing a
dictionary cannot erase saved words.
