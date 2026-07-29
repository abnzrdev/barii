import 'dart:io';

import 'package:bookbites/core/database/app_database.dart';
import 'package:bookbites/features/library/data/book_import_service.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory source;
  late Directory storage;
  late AppDatabase database;

  setUp(() async {
    source = await Directory.systemTemp.createTemp('bookbites-source-');
    storage = await Directory.systemTemp.createTemp('bookbites-storage-');
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

  test('rejects empty and duplicate TXT files', () async {
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
    await service.importFile(book.path);
    expect(
      () => service.importFile(book.path),
      throwsA(isA<DuplicateBookException>()),
    );
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
