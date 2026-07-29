# Readest Dictionary and Annotation Research

Readest was inspected locally at `../_references/readest`. It is AGPL-3.0.
BookBites uses its behavior and terminology as a reference; no Readest source
was copied or mechanically translated.

## Dictionary findings

Readest separates dictionary discovery/priority from format readers and
lookup-candidate generation. It supports multiple custom dictionaries,
including StarDict and MDict/MDX resources. Readers use bounded random access,
binary lookup, and small caches rather than loading dictionary bodies for each
query. Results retain dictionary identity so priority and attribution remain
visible.

Useful independent ideas:

- deterministic exact and normalized lookup candidates;
- ordered enabled sources with source identity on every result;
- separate metadata/content identifiers for installed resources;
- no fabricated fallback when all sources miss;
- resource files remain owned by their dictionary source;
- dictionary settings own installation, enablement, priority, and removal.

## Annotation findings

Readest models highlights and notes as persistent annotations with stable
publication locations, selected text, style, color, and timestamps. Selection,
annotation editing, notebook state, and rendering are separate concerns.
Range editing anchors the non-dragged endpoint and commits only a completed
range. Notebook navigation returns through the annotation's stable locator.
Draft state is removed when creation is cancelled.

Useful independent ideas:

- native selection comes before reader navigation gestures;
- annotation creation is based on canonical text ranges, not selected text
  alone;
- highlight and underline are styles on one annotation model;
- a note may be attached without making every highlight require a note;
- editing and deletion preserve clear ownership and cascade behavior;
- notebook entries retain quotation and location context;
- range recovery must not blindly choose the first repeated sentence.

BookBites uses stable bite IDs plus UTF-16 offsets and surrounding context
instead of EPUB CFI/XPointer because BookBites renders canonical generated
bites rather than publication DOM ranges.

