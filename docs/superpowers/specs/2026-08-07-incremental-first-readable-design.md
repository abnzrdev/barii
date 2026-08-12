# Incremental first-readable pagination

Barii will treat `biteId + sourceOffset` as the authoritative reader
location. On each pagination generation it will paginate that bite first,
publish the containing page after one frame, and then materialize the remaining
bites incrementally. Each later publication will resolve the same canonical
location again, so inserting pages before the visible page cannot cause a jump.

The existing `BitePaginationCache`, page splitting, visual presentation,
database schema, progress format, and EPUB model remain unchanged. A generation
check before work and publication cancels resize, settings, Plain Reading Mode,
and disposal supersessions. Only one unawaited pagination task is created for a
generation.

`Reader.pagination` continues to cover the complete operation and
`Reader.paginateBite` remains intact. `Reader.foregroundPagination` measures
the target bite through its first publication; `Reader.firstReadablePage`
continues to mean that readable content has reached a rendered frame.

This independently implements the target-first and adjacent-later lifecycle
observed in Readest `6469cbb5b5799912b6376765d57175f5552eedf7` and its pinned
MIT-licensed Foliate-js `f6bce4ce81d7cc6cd5df156a9867e3f0daa0427c`, principally
`view.js` navigation/relocation and `paginator.js` `#display`, progressive fill,
and view cleanup. No upstream source is copied or translated.
