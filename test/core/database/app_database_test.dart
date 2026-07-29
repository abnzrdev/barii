import 'package:bookbites/core/database/app_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;

  setUp(() => database = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() => database.close());

  test('saves and restores progress by stable bite ID', () async {
    await _createBook(database);
    await database.saveProgress('book', 'bite', 0);

    expect((await database.progressFor('book'))?.biteId, 'bite');
  });

  test('persists note timestamps and vocabulary context', () async {
    await _createBook(database);
    final created = DateTime.utc(2026, 7, 29);
    await database.saveNote(
      id: 'note',
      bookId: 'book',
      biteId: 'bite',
      text: 'Remember this',
      now: created,
    );
    await database.saveVocabulary(
      id: 'word',
      word: 'Lantern',
      normalizedWord: 'lantern',
      definition: 'A portable light.',
      sourceSentence: 'She carried the lantern.',
      bookId: 'book',
      biteId: 'bite',
      now: created,
    );

    expect(
      (await database.notesForBook('book')).single.createdAt.toUtc(),
      created,
    );
    expect(
      (await database.vocabularyForBook('book')).single.sourceSentence,
      'She carried the lantern.',
    );
  });

  test('deleting a book cascades to dependent records', () async {
    await _createBook(database);
    await database.saveProgress('book', 'bite', 0);
    await database.deleteBookRecord('book');

    expect(await database.progressFor('book'), isNull);
    expect(await database.bitesForBook('book'), isEmpty);
  });

  test('repeated initialization keeps one reader preference row', () async {
    await database.ensurePreferences();
    await database.ensurePreferences();

    expect((await database.preferences()).id, 1);
    expect(
      await database.select(database.readerPreferences).get(),
      hasLength(1),
    );
  });
}

Future<void> _createBook(AppDatabase database) async {
  await database.addBook(
    id: 'book',
    fingerprint: 'fingerprint',
    title: 'Book',
    author: 'Author',
    filePath: '/tmp/book.txt',
    fileType: 'txt',
  );
  await database.replaceContent(
    'book',
    sections: const [
      StoredSection(id: 'section', position: 0, heading: 'Heading'),
    ],
    bites: const [
      StoredBite(
        id: 'bite',
        sectionId: 'section',
        position: 0,
        text: 'Text.',
        sourceStart: 0,
        sourceEnd: 5,
      ),
    ],
  );
}
