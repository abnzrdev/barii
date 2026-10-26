import 'dart:io';
import 'dart:developer';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as path;

import '../../../core/database/app_database.dart';
import '../domain/canonical_publication.dart';
import 'book_processing_worker.dart';
import 'epub_parser.dart';

class BookImportService {
  BookImportService({
    required this.database,
    required this.storageDirectory,
    this.processingWorker = const BookProcessingWorker(),
  });

  final AppDatabase database;
  final Directory storageDirectory;
  final BookProcessingWorker processingWorker;

  Future<Book> importFile(String sourcePath) async {
    final importTask = TimelineTask()..start('Import.total');
    try {
      return await _importFile(sourcePath);
    } finally {
      importTask.finish();
    }
  }

  Future<Book> _importFile(String sourcePath) async {
    final source = File(sourcePath);
    if (!await source.exists()) {
      throw const BookImportException('The selected file no longer exists.');
    }
    final extension = path.extension(sourcePath).toLowerCase();
    if (extension != '.txt' && extension != '.epub') {
      throw const UnsupportedBookException();
    }
    final fingerprint = await processingWorker.fingerprint(sourcePath);
    final existing = await database.bookByFingerprint(fingerprint);
    if (existing != null) return existing;

    late final ProcessedBook processed;
    try {
      processed = await processingWorker.process(
        sourcePath: sourcePath,
        extension: extension,
        fingerprint: fingerprint,
      );
    } on EmptyProcessedBookException {
      throw const EmptyBookException();
    }
    final publication = processed.publication;
    final generated = processed.bites;
    final filesTask = TimelineTask()..start('Import.managedFiles');
    await storageDirectory.create(recursive: true);
    final destination = File(
      path.join(storageDirectory.path, '$fingerprint$extension'),
    );
    await source.copy(destination.path);
    final assetDirectory = Directory(
      path.join(storageDirectory.path, '$fingerprint-assets'),
    );
    final assetPaths = <String, String>{};
    if (publication.assets.isNotEmpty) {
      await assetDirectory.create(recursive: true);
      for (final entry in publication.assets.entries) {
        final name = sha256.convert(entry.key.codeUnits).toString();
        final file = File(
          path.join(assetDirectory.path, '$name${entry.value.extension}'),
        );
        await file.writeAsBytes(entry.value.bytes, flush: true);
        assetPaths[entry.key] = file.path;
      }
    }
    filesTask.finish(arguments: {'assets': publication.assets.length});
    try {
      final databaseTask = TimelineTask()..start('Import.databasePublication');
      await database.transaction(() async {
        await database.addBook(
          id: fingerprint,
          fingerprint: fingerprint,
          title: publication.title,
          author: publication.author,
          filePath: destination.path,
          fileType: extension.substring(1),
          cover: publication.cover,
        );
        final sections = publication.sections
            .map(
              (section) => StoredSection(
                id: '$fingerprint-section-${section.index}',
                position: section.index,
                heading: section.heading,
              ),
            )
            .toList();
        await database.replaceContent(
          fingerprint,
          sections: sections,
          bites: generated
              .map(
                (bite) => StoredBite(
                  id: bite.id,
                  sectionId: '$fingerprint-section-${bite.sectionIndex}',
                  position: bite.position,
                  text: bite.text,
                  sourceStart: bite.sourceStart,
                  sourceEnd: bite.sourceEnd,
                  kind: bite.kind,
                  assetPath: assetPaths[bite.assetKey],
                  altText: bite.altText,
                  caption: bite.caption,
                  markup: bite.markup,
                ),
              )
              .toList(),
        );
        final canonical = publication.canonical;
        if (canonical != null) {
          await database.saveCanonicalPublication(
            bookId: fingerprint,
            modelVersion: CanonicalPublication.modelVersion,
            parserVersion: CanonicalPublication.parserVersion,
            projectionVersion: CanonicalPublication.projectionVersion,
            publicationJson: jsonEncode(canonical.toJson()),
          );
        }
      });
      databaseTask.finish(arguments: {'bites': generated.length});
    } catch (_) {
      if (await destination.exists()) await destination.delete();
      if (await assetDirectory.exists()) {
        await assetDirectory.delete(recursive: true);
      }
      rethrow;
    }
    return (await database.bookById(fingerprint))!;
  }

  /// Rebuilds EPUBs imported before empty XHTML anchors were closed.
  /// Bites whose text changed get new ids, so notes on those bites are dropped.
  Future<void> refreshStaleEpubs() async {
    for (final book in await database.allBooks()) {
      if (book.fileType != 'epub') continue;
      final stored = await database.canonicalPublicationFor(book.id);
      if (stored != null &&
          stored.parserVersion >= CanonicalPublication.parserVersion) {
        continue;
      }
      final source = File(book.filePath);
      if (!await source.exists()) continue;
      try {
        final processed = await processingWorker.process(
          sourcePath: source.path,
          extension: '.epub',
          fingerprint: book.fingerprint,
        );
        final existing = await database.bitesForBook(book.id);
        final next = processed.bites;
        final unchanged =
            existing.length == next.length &&
            [
              for (var i = 0; i < existing.length; i++)
                existing[i].id == next[i].id &&
                    existing[i].content == next[i].text &&
                    existing[i].markup == next[i].markup,
            ].every((same) => same);
        if (unchanged) {
          await _bumpParsedBook(book, processed.publication);
          continue;
        }
        await _replaceParsed(book, processed);
      } catch (_) {}
    }
  }

  Future<void> _bumpParsedBook(Book book, ParsedPublication publication) async {
    final canonical = publication.canonical;
    if (canonical != null) {
      await database.saveCanonicalPublication(
        bookId: book.id,
        modelVersion: CanonicalPublication.modelVersion,
        parserVersion: CanonicalPublication.parserVersion,
        projectionVersion: CanonicalPublication.projectionVersion,
        publicationJson: jsonEncode(canonical.toJson()),
      );
    }
    final cover = publication.cover;
    if (cover != null && book.cover == null) {
      await database.setBookCover(book.id, cover);
    }
  }

  Future<void> _replaceParsed(Book book, ProcessedBook processed) async {
    final publication = processed.publication;
    final assetDirectory = Directory(
      path.join(storageDirectory.path, '${book.fingerprint}-assets'),
    );
    final assetPaths = <String, String>{};
    if (publication.assets.isNotEmpty) {
      await assetDirectory.create(recursive: true);
      for (final entry in publication.assets.entries) {
        final name = sha256.convert(entry.key.codeUnits).toString();
        final file = File(
          path.join(assetDirectory.path, '$name${entry.value.extension}'),
        );
        await file.writeAsBytes(entry.value.bytes, flush: true);
        assetPaths[entry.key] = file.path;
      }
    }
    await database.transaction(() async {
      await database.replaceContent(
        book.id,
        sections: [
          for (final section in publication.sections)
            StoredSection(
              id: '${book.fingerprint}-section-${section.index}',
              position: section.index,
              heading: section.heading,
            ),
        ],
        bites: [
          for (final bite in processed.bites)
            StoredBite(
              id: bite.id,
              sectionId: '${book.fingerprint}-section-${bite.sectionIndex}',
              position: bite.position,
              text: bite.text,
              sourceStart: bite.sourceStart,
              sourceEnd: bite.sourceEnd,
              kind: bite.kind,
              assetPath: assetPaths[bite.assetKey],
              altText: bite.altText,
              caption: bite.caption,
              markup: bite.markup,
            ),
        ],
      );
      final canonical = publication.canonical;
      if (canonical != null) {
        await database.saveCanonicalPublication(
          bookId: book.id,
          modelVersion: CanonicalPublication.modelVersion,
          parserVersion: CanonicalPublication.parserVersion,
          projectionVersion: CanonicalPublication.projectionVersion,
          publicationJson: jsonEncode(canonical.toJson()),
        );
      }
      final cover = publication.cover;
      if (cover != null) await database.setBookCover(book.id, cover);
    });
  }

  Future<void> deleteBook(Book book) async {
    final source = File(book.filePath);
    final assets = Directory(
      path.join(storageDirectory.path, '${book.fingerprint}-assets'),
    );
    final staged = File('${book.filePath}.deleting');
    if (await source.exists()) await source.rename(staged.path);
    try {
      await database.deleteBookRecord(book.id);
      if (await staged.exists()) await staged.delete();
      if (await assets.exists()) await assets.delete(recursive: true);
    } catch (_) {
      if (await staged.exists()) await staged.rename(source.path);
      rethrow;
    }
  }
}

class BookImportException implements Exception {
  const BookImportException(this.message);
  final String message;

  @override
  String toString() => message;
}

class EmptyBookException extends BookImportException {
  const EmptyBookException() : super('The selected book is empty.');
}

class DuplicateBookException extends BookImportException {
  const DuplicateBookException()
    : super('This book is already in the library.');
}

class UnsupportedBookException extends BookImportException {
  const UnsupportedBookException()
    : super('Only DRM-free EPUB and TXT files are supported.');
}
