import 'dart:io';

import 'package:archive/archive.dart';
import 'package:barii/core/database/app_database.dart';
import 'package:barii/features/library/data/book_import_service.dart';
import 'package:barii/features/library/data/epub_parser.dart';
import 'package:drift/native.dart';
import 'package:epubx/epubx.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('BARII_DEBUG_EPUB imports', () async {
    final envPath = Platform.environment['BARII_DEBUG_EPUB'] ?? '';
    if (envPath.isEmpty) {
      markTestSkipped('Set BARII_DEBUG_EPUB to the failing file.');
      return;
    }
    final bytes = await File(envPath).readAsBytes();
    ZipDecoder().decodeBytes(bytes, verify: true);
    await EpubReader.openBook(bytes);
    await EpubReader.readBook(bytes);
    final publication = await const EpubParser().parse(bytes);
    expect(publication.sections, isNotEmpty);
    expect(publication.title, isNotEmpty);

    final storage = await Directory.systemTemp.createTemp('barii-grokking-');
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(() async {
      await database.close();
      await storage.delete(recursive: true);
    });
    final book = await BookImportService(
      database: database,
      storageDirectory: storage,
    ).importFile(envPath);
    expect(book.fileType, 'epub');
    expect(await database.bitesForBook(book.id), isNotEmpty);
  }, timeout: const Timeout(Duration(minutes: 5)));
}
