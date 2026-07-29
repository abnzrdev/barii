# Persistent Highlight Architecture

Highlights are anchored to canonical bite text with:

- book and stable bite IDs;
- UTF-16 start/end offsets used by Flutter text selection;
- selected text, prefix/suffix context, and SHA-256 content checksum;
- highlight/underline style and accessible color;
- created/updated timestamps, resolution state, and optional note ID.

On load, offsets are accepted only when the selected text matches. If the bite
checksum changed, the resolver searches every occurrence and requires a unique
context match. Ambiguous or missing matches are marked unresolved and never
rendered at an arbitrary first occurrence.

Creating a range that overlaps an existing annotation replaces the overlapping
annotation and reports that replacement. Adjacent ranges and multiple
non-overlapping ranges are supported.

The reader renders only the current/nearby bite's ranges through
`SelectableText.rich` spans. Flutter's native selection handles, copy action,
Linux mouse selection, and adaptive toolbar remain intact. Custom Define,
Highlight, Underline, and Add note actions are inserted through
`contextMenuBuilder`; no custom handles are implemented.

Selection activity temporarily suppresses page and side-panel gestures.
Dismissal restores normal reader gestures. Notebook entries combine highlights
and notes, filter by color, and navigate by stable bite ID.
