# Readest Reference

Readest was studied at local revision `21e1ed5` as an AGPL-3.0 behavioral and
architectural reference. No Readest source was copied or mechanically
translated.

Ideas reused independently:

- Keep publication identity separate from mutable metadata.
- Represent reading location with a stable content locator rather than a
  viewport-dependent page number.
- Store annotations with stable location, context text, created/updated times,
  and deletion semantics.
- Keep per-book progress and view preferences separate from publication data.
- Offer dictionary lookup adjacent to text selection with an explicit missing
  result.
- Make reader navigation available through touch, keyboard, and labeled
  controls.
- Use responsive side panels on wide screens and sheets on compact screens.
- Surface import failures as specific user-facing errors and never leave
  partial library entries.

Readest features intentionally not reused for this MVP include sync, OPDS,
translation, TTS, PDF/fixed-layout reading, global highlights, custom shortcut
editing, cloud dictionaries, and embedded web publication rendering.

Directly adapted source: none.
