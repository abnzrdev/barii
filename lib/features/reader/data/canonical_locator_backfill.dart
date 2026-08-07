import 'dart:convert';
import 'dart:io';

import '../../library/data/epub_parser.dart';
import '../../library/domain/canonical_publication.dart';
import '../domain/bite_generator.dart';
import '../../../core/database/app_database.dart';

class CanonicalBackfillResult {
  const CanonicalBackfillResult({required this.updated, required this.skipped});

  final int updated;
  final int skipped;
}

class CanonicalLocatorBackfill {
  const CanonicalLocatorBackfill(
    this.database, {
    this.parser = const EpubParser(),
    this.generator = const BiteGenerator(),
  });

  final AppDatabase database;
  final EpubParser parser;
  final BiteGenerator generator;

  Future<CanonicalBackfillResult> backfill(Book book) async {
    if (book.fileType != 'epub') {
      return const CanonicalBackfillResult(updated: 0, skipped: 1);
    }
    final progress = await database.progressFor(book.id);
    final bookmarks = await database.bookmarksForBook(book.id);
    final notes = await database.notesForBook(book.id);
    final highlights = await database.highlightsForBook(book.id);
    final missing = [
      if (progress != null && progress.canonicalLocator == null) progress,
      ...bookmarks.where((item) => item.canonicalLocator == null),
      ...notes.where((item) => item.canonicalLocator == null),
      ...highlights.where((item) => item.canonicalLocator == null),
    ];
    if (missing.isEmpty) {
      return const CanonicalBackfillResult(updated: 0, skipped: 0);
    }
    final source = File(book.filePath);
    if (!await source.exists()) {
      return CanonicalBackfillResult(updated: 0, skipped: missing.length);
    }

    try {
      final parsed = await parser.parse(await source.readAsBytes());
      final canonical = parsed.canonical;
      if (canonical == null) {
        return CanonicalBackfillResult(updated: 0, skipped: missing.length);
      }
      if (await database.canonicalPublicationFor(book.id) == null) {
        await database.saveCanonicalPublication(
          bookId: book.id,
          modelVersion: CanonicalPublication.modelVersion,
          parserVersion: CanonicalPublication.parserVersion,
          projectionVersion: CanonicalPublication.projectionVersion,
          publicationJson: jsonEncode(canonical.toJson()),
        );
      }
      final generated = generator.generate(
        bookFingerprint: book.fingerprint,
        sections: parsed.sections,
      );
      final candidates = {for (final bite in generated) bite.id: bite};
      final stored = {
        for (final bite in await database.bitesForBook(book.id)) bite.id: bite,
      };
      final occurrences = <CanonicalSpineOccurrence>[];
      final resources = <String>{};
      for (final occurrence in canonical.readingOrder) {
        if (resources.add(occurrence.resourceHref)) occurrences.add(occurrence);
      }

      String? locatorFor(String biteId, int start, [int? end, String? exact]) {
        final bite = stored[biteId];
        final candidate = candidates[biteId];
        if (bite == null ||
            candidate == null ||
            candidate.text != bite.content ||
            candidate.sectionIndex >= occurrences.length) {
          return null;
        }
        final occurrence = occurrences[candidate.sectionIndex];
        final localStart = start.clamp(0, bite.content.length);
        final localEnd = (end ?? localStart).clamp(
          localStart,
          bite.content.length,
        );
        final locator = CanonicalLocator(
          href: occurrence.resourceHref,
          mediaType: occurrence.mediaType,
          spineOccurrence: occurrence.occurrenceId,
          startOffset: bite.sourceStart + localStart,
          endOffset: bite.sourceStart + localEnd,
          before: bite.content.substring(
            (localStart - 32).clamp(0, bite.content.length),
            localStart,
          ),
          highlight: exact,
          after: bite.content.substring(
            localEnd,
            (localEnd + 32).clamp(0, bite.content.length),
          ),
        );
        return jsonEncode(locator.toJson());
      }

      var updated = 0;
      var skipped = 0;
      if (progress != null && progress.canonicalLocator == null) {
        final locator = locatorFor(progress.biteId, progress.sourceOffset);
        if (locator == null) {
          skipped++;
        } else {
          updated += await database.setProgressCanonicalLocator(
            book.id,
            locator,
          );
        }
      }
      for (final bookmark in bookmarks.where(
        (item) => item.canonicalLocator == null,
      )) {
        final locator = locatorFor(bookmark.biteId, bookmark.sourceOffset);
        if (locator == null) {
          skipped++;
        } else {
          updated += await database.setBookmarkCanonicalLocator(
            bookmark.bookId,
            bookmark.biteId,
            bookmark.sourceOffset,
            locator,
          );
        }
      }
      for (final note in notes.where((item) => item.canonicalLocator == null)) {
        final bite = stored[note.biteId];
        final locator = locatorFor(
          note.biteId,
          0,
          bite?.content.length,
          bite?.content,
        );
        if (locator == null) {
          skipped++;
        } else {
          updated += await database.setReaderNoteCanonicalLocator(
            note.id,
            locator,
          );
        }
      }
      for (final highlight in highlights.where(
        (item) => item.canonicalLocator == null,
      )) {
        final locator = locatorFor(
          highlight.biteId,
          highlight.startOffset,
          highlight.endOffset,
          highlight.selectedText,
        );
        if (locator == null) {
          skipped++;
        } else {
          updated += await database.setHighlightCanonicalLocator(
            highlight.id,
            locator,
          );
          if (highlight.noteId != null) {
            await database.setHighlightNoteCanonicalLocator(
              highlight.noteId!,
              locator,
            );
          }
        }
      }
      return CanonicalBackfillResult(updated: updated, skipped: skipped);
    } catch (_) {
      return CanonicalBackfillResult(updated: 0, skipped: missing.length);
    }
  }
}
