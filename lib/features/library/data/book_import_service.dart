import 'dart:io';
import 'dart:developer';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as path;

import '../../../core/database/app_database.dart';
import '../domain/canonical_publication.dart';
import 'book_processing_worker.dart';

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
