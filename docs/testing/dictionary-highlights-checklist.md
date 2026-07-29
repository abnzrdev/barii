# Dictionary and Highlight Testing Checklist

Automated coverage must prove:

- pack validation, duplicate/damaged import, metadata persistence, enablement,
  priority, removal, and one-time setup;
- exact, normalized, apostrophe, Unicode, form, prefix, priority, and missing
  lookup behavior;
- saved vocabulary definition/source snapshots survive dictionary removal;
- schema migration preserves books, progress, and existing notes;
- highlight offsets, repeated-text anchoring, persistence, rendering, styles,
  notes, deletion, notebook navigation, and export;
- active selection suppresses reader and side-panel gestures;
- large text and light/dark themes remain readable;
- no reader progress UI returns.

Manual Android and Linux checks:

1. Import or initialize a compatible dictionary.
2. Disable/re-enable it and verify lookup behavior.
3. Long-press/select text and use Define, Highlight, Add note, and Copy.
4. Reopen the book and confirm the exact highlight remains.
5. Open the notebook and return to the highlighted bite.
6. Confirm Back/Escape closes panels first.
7. Confirm the reader still displays no progress bar, page/bite count,
   percentage, remaining time, or chapter length.

