# Duplicate EPUB content

## Root cause

The Atomic Habits source XHTML contains the affected coach and entrepreneur
sentences once. Duplication first appeared during EPUB extraction:

- nested list markup was read once from the `<li>` and again from its child
  `<p>`;
- EPUB navigation entries with different anchors could expose the same spine
  XHTML more than once.

Barii now extracts only leaf text blocks and traverses canonical OPF spine
files once, using navigation data only for titles. It does not globally
deduplicate text, so intentional repeated paragraphs remain intact.

## Regression coverage

- the structured EPUB fixture includes nested list paragraphs, multiple
  anchored navigation entries into one XHTML file, Unicode punctuation, and an
  intentional repeated refrain;
- parser tests require affected paragraphs once and the intentional refrain
  twice;
- import tests require stable bite IDs, unique stored bites, and preserved
  progress and notes when the same file is selected again;
- reader tests require persisted affected text to render once.

## Existing imports

Previously generated bites are stored in SQLite and are not silently rewritten.
Delete the affected imported book and import the EPUB again to regenerate it
through the corrected extraction pipeline.
