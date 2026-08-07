import 'dart:io';

import 'package:bookbites/core/database/app_database.dart';
import 'package:bookbites/features/library/data/book_import_service.dart';
import 'package:bookbites/features/reader/data/canonical_locator_backfill.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/epub_fixture.dart';

void main() {
  test('backfills only exactly validated legacy anchors', () async {
    final directory = await Directory.systemTemp.createTemp(
      'locator-backfill-',
    );
    addTearDown(() => directory.delete(recursive: true));
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final source = File('${directory.path}/book.epub');
    await source.writeAsBytes(epubFixtureBytes(richText: true));
    final book = await BookImportService(
      database: database,
      storageDirectory: Directory('${directory.path}/managed'),
    ).importFile(source.path);
    final bite = (await database.bitesForBook(
      book.id,
    )).firstWhere((bite) => bite.content.contains('Bold words'));
    await database.saveProgress(book.id, bite.id, bite.position, 2);
    await database.addBookmark(
      bookId: book.id,
      biteId: bite.id,
      sourceOffset: 3,
      now: DateTime.utc(2026),
    );
    await database.saveNote(
      id: 'note',
      bookId: book.id,
      biteId: bite.id,
      text: 'Keep',
      now: DateTime.utc(2026),
    );

    final result = await CanonicalLocatorBackfill(database).backfill(book);

    expect(result.updated, 3);
    expect((await database.progressFor(book.id))!.canonicalLocator, isNotNull);
    expect(
      (await database.bookmarksForBook(book.id)).single.canonicalLocator,
      isNotNull,
    );
    expect(
      (await database.notesForBook(book.id)).single.canonicalLocator,
      isNotNull,
    );
  });

  test('leaves unmatched legacy data untouched', () async {
    final directory = await Directory.systemTemp.createTemp(
      'locator-unmatched-',
    );
    addTearDown(() => directory.delete(recursive: true));
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final source = File('${directory.path}/book.epub');
    await source.writeAsBytes(epubFixtureBytes());
    final book = await BookImportService(
      database: database,
      storageDirectory: Directory('${directory.path}/managed'),
    ).importFile(source.path);
    await database.replaceContent(
      book.id,
      sections: const [StoredSection(id: 'section', position: 0)],
      bites: const [
        StoredBite(
          id: 'legacy-bite',
          sectionId: 'section',
          position: 0,
          text: 'Legacy text.',
          sourceStart: 0,
          sourceEnd: 12,
        ),
      ],
    );
    await database.saveProgress(book.id, 'legacy-bite', 0, 2);
    final result = await CanonicalLocatorBackfill(database).backfill(book);
    expect(result.updated, 0);
    expect(result.skipped, 1);
    expect((await database.progressFor(book.id))!.canonicalLocator, isNull);
  });
}
