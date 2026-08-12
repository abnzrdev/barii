import 'dart:io';

import 'package:barii/core/database/app_database.dart';
import 'package:barii/features/library/data/book_import_service.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/epub_fixture.dart';

void main() {
  late Directory source;
  late Directory storage;
  late AppDatabase database;

  setUp(() async {
    source = await Directory.systemTemp.createTemp('barii-source-');
    storage = await Directory.systemTemp.createTemp('barii-storage-');
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
    await source.delete(recursive: true);
    await storage.delete(recursive: true);
  });

  test('imports TXT into controlled storage and creates bites', () async {
    final file = File('${source.path}/A Small Book.txt');
    await file.writeAsString(
      'A heading\n\nFirst sentence. Second sentence.\n\nLast sentence.',
    );
    final service = BookImportService(
      database: database,
      storageDirectory: storage,
    );

    final book = await service.importFile(file.path);

    expect(book.title, 'A Small Book');
    expect(book.fileType, 'txt');
    expect(book.filePath, startsWith(storage.path));
    expect(await File(book.filePath).exists(), isTrue);
    expect(await database.bitesForBook(book.id), isNotEmpty);
  });

  test('rejects empty TXT and reuses duplicate imports', () async {
    final empty = File('${source.path}/empty.txt');
    await empty.writeAsString(' \n ');
    final book = File('${source.path}/book.txt');
    await book.writeAsString('One complete sentence.');
    final service = BookImportService(
      database: database,
      storageDirectory: storage,
    );

    expect(
      () => service.importFile(empty.path),
      throwsA(isA<EmptyBookException>()),
    );
    final first = await service.importFile(book.path);
    final second = await service.importFile(book.path);
    expect(second.id, first.id);
    expect(await database.bitesForBook(first.id), hasLength(1));
  });

  test('EPUB re-import preserves stable bites, progress, and notes', () async {
    final file = File('${source.path}/anchored.epub');
    await file.writeAsBytes(
      epubFixtureBytes(anchoredNavigation: true, nestedList: true),
    );
    final service = BookImportService(
      database: database,
      storageDirectory: storage,
    );
    final first = await service.importFile(file.path);
    final originalBites = await database.bitesForBook(first.id);
    final target = originalBites.firstWhere(
      (bite) => bite.content.contains('Previously duplicated sentence.'),
    );
    final now = DateTime.utc(2026, 7, 29);
    await database.saveProgress(first.id, target.id, target.position);
    await database.saveNote(
      id: 'anchored-note',
      bookId: first.id,
      biteId: target.id,
      text: 'Keep this note.',
      now: now,
    );

    final second = await service.importFile(file.path);
    final reimportedBites = await database.bitesForBook(second.id);

    expect(second.id, first.id);
    expect(
      reimportedBites.map((bite) => bite.id),
      originalBites.map((bite) => bite.id),
    );
    expect(
      reimportedBites.map((bite) => bite.id).toSet(),
      hasLength(reimportedBites.length),
    );
    expect(
      reimportedBites
          .where(
            (bite) => bite.content.contains('Previously duplicated sentence.'),
          )
          .single
          .content
          .split('Previously duplicated sentence.')
          .length,
      2,
    );
    expect((await database.progressFor(first.id))?.biteId, target.id);
    expect(await database.notesForBook(first.id), hasLength(1));
  });

  test(
    'copies EPUB figure assets into managed storage and deletes them',
    () async {
      final file = File('${source.path}/figures.epub');
      await file.writeAsBytes(epubFixtureBytes(figures: true));
      final service = BookImportService(
        database: database,
        storageDirectory: storage,
      );

      final book = await service.importFile(file.path);
      final figures = (await database.bitesForBook(
        book.id,
      )).where((bite) => bite.kind == 'figure').toList();

      expect(figures, hasLength(4));
      expect(figures.map((bite) => bite.altText), contains('Green dot'));
      expect(figures.map((bite) => bite.caption), contains('PNG caption'));
      for (final figure in figures) {
        expect(figure.assetPath, startsWith(storage.path));
        expect(await File(figure.assetPath!).exists(), isTrue);
      }

      final assetDirectory = Directory('${storage.path}/${book.id}-assets');
      await service.deleteBook(book);
      expect(await assetDirectory.exists(), isFalse);
    },
  );

  test('persists rich EPUB metadata with generated bites', () async {
    final file = File('${source.path}/rich.epub');
    await file.writeAsBytes(epubFixtureBytes(richText: true));
    final service = BookImportService(
      database: database,
      storageDirectory: storage,
    );

    final book = await service.importFile(file.path);
    final rich = (await database.bitesForBook(
      book.id,
    )).where((bite) => bite.markup?.contains('https://example.com') ?? false);

    expect(rich, hasLength(1));
    expect(rich.single.markup, contains('one.xhtml#footnote'));
    final canonical = await database.canonicalPublicationFor(book.id);
    expect(canonical, isNotNull);
    expect(canonical!.modelVersion, 1);
    expect(canonical.parserVersion, 1);
    expect(canonical.projectionVersion, 1);
    expect(canonical.publicationJson, contains('one.xhtml'));
  });

  test('rejects unsupported extensions and missing files', () async {
    final service = BookImportService(
      database: database,
      storageDirectory: storage,
    );

    expect(
      () => service.importFile('${source.path}/missing.txt'),
      throwsA(isA<BookImportException>()),
    );
    final pdf = File('${source.path}/book.pdf');
    await pdf.writeAsBytes([1, 2, 3]);
    expect(
      () => service.importFile(pdf.path),
      throwsA(isA<UnsupportedBookException>()),
    );
  });
}
