import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as path;

import '../../../core/database/app_database.dart';
import '../../reader/domain/bite_generator.dart';
import 'epub_parser.dart';

class BookImportService {
  BookImportService({
    required this.database,
    required this.storageDirectory,
    this.epubParser = const EpubParser(),
    this.biteGenerator = const BiteGenerator(),
  });

  final AppDatabase database;
  final Directory storageDirectory;
  final EpubParser epubParser;
  final BiteGenerator biteGenerator;

  Future<Book> importFile(String sourcePath) async {
    final source = File(sourcePath);
    if (!await source.exists()) {
      throw const BookImportException('The selected file no longer exists.');
    }
    final extension = path.extension(sourcePath).toLowerCase();
    if (extension != '.txt' && extension != '.epub') {
      throw const UnsupportedBookException();
    }
    final bytes = await source.readAsBytes();
    final fingerprint = sha256.convert(bytes).toString();
    final existing = await database.bookByFingerprint(fingerprint);
    if (existing != null) return existing;

    final ParsedPublication publication;
    if (extension == '.epub') {
      publication = await epubParser.parse(bytes);
    } else {
      final text = await source.readAsString();
      final paragraphs = text
          .split(RegExp(r'\n\s*\n'))
          .map((part) => part.replaceAll(RegExp(r'\s+'), ' ').trim())
          .where((part) => part.isNotEmpty)
          .toList();
      if (paragraphs.isEmpty) throw const EmptyBookException();
      publication = ParsedPublication(
        title: path.basenameWithoutExtension(sourcePath),
        author: 'Unknown author',
        sections: [SourceSection(index: 0, paragraphs: paragraphs)],
      );
    }

    final generated = biteGenerator.generate(
      bookFingerprint: fingerprint,
      sections: publication.sections,
    );
    if (generated.isEmpty) throw const EmptyBookException();
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
    try {
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
      });
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
