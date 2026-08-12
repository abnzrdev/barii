import 'package:barii/core/database/app_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('persists reader view mode per book', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    await database.addBook(
      id: 'book',
      fingerprint: 'hash',
      title: 'Book',
      author: 'Author',
      filePath: '/managed.epub',
      fileType: 'epub',
    );

    expect(await database.readerViewMode('book'), 'barii');
    await database.saveReaderViewMode('book', 'original');
    expect(await database.readerViewMode('book'), 'original');
  });

  test('stores canonical locators beside legacy anchors', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    await database.addBook(
      id: 'located-book',
      fingerprint: 'located-hash',
      title: 'Book',
      author: 'Author',
      filePath: '/managed.epub',
      fileType: 'epub',
    );
    await database.replaceContent(
      'located-book',
      sections: const [StoredSection(id: 'located-section', position: 0)],
      bites: const [
        StoredBite(
          id: 'located-bite',
          sectionId: 'located-section',
          position: 0,
          text: 'Located text.',
          sourceStart: 0,
          sourceEnd: 13,
        ),
      ],
    );
    const locator = '{"href":"one.xhtml","spineOccurrence":"itemref-1"}';
    await database.saveProgressWithLocator(
      bookId: 'located-book',
      biteId: 'located-bite',
      position: 0,
      sourceOffset: 3,
      canonicalLocator: locator,
    );
    await database.addBookmark(
      bookId: 'located-book',
      biteId: 'located-bite',
      sourceOffset: 3,
      now: DateTime.utc(2026),
      canonicalLocator: locator,
    );

    expect(
      (await database.progressFor('located-book'))!.canonicalLocator,
      locator,
    );
    expect(
      (await database.bookmarksForBook('located-book')).single.canonicalLocator,
      locator,
    );
    await database.saveProgress('located-book', 'located-bite', 0, 4);
    expect(
      (await database.progressFor('located-book'))!.canonicalLocator,
      locator,
    );
  });

  late AppDatabase database;

  setUp(() => database = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() => database.close());

  test('saves and restores progress by stable bite ID', () async {
    await _createBook(database);
    await database.saveProgress('book', 'bite', 0, 7);

    expect((await database.progressFor('book'))?.biteId, 'bite');
    expect((await database.progressFor('book'))?.sourceOffset, 7);
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

  test('saves and restores reader experience preferences', () async {
    await database.savePreferences(
      fontSize: 24,
      lineHeight: 1.8,
      alignment: 'justify',
      readingWidth: 720,
      pageMargin: 32,
      autoHideControls: false,
      hapticsEnabled: false,
    );

    final preferences = await database.preferences();
    expect(preferences.pageMargin, 32);
    expect(preferences.autoHideControls, isFalse);
    expect(preferences.hapticsEnabled, isFalse);
    expect(preferences.showProgress, isFalse);
  });

  test('persists dictionary source state and priority', () async {
    final installed = DateTime.utc(2026, 7, 29);
    await database.saveDictionarySource(
      id: 'dictionary',
      name: 'Fixture English',
      language: 'en',
      format: 'limmud-sqlite',
      sizeBytes: 118784,
      filePath: '/tmp/fixture.dict.sqlite',
      contentHash: 'dictionary-hash',
      source: 'Kaikki/Wiktionary',
      licenseName: 'CC BY-SA 4.0 and GFDL',
      attribution: 'Wiktionary contributors',
      installedAt: installed,
    );
    await database.setDictionaryEnabled('dictionary', false);

    final source = (await database.allDictionarySources()).single;
    expect(source.name, 'Fixture English');
    expect(source.enabled, isFalse);
    expect(source.priority, 0);
    expect(source.contentHash, 'dictionary-hash');
  });

  test('persists highlight offsets, context, style, and note', () async {
    await _createBook(database);
    final now = DateTime.utc(2026, 7, 29);
    await database.saveHighlightNote(
      id: 'highlight-note',
      bookId: 'book',
      biteId: 'bite',
      text: 'Important',
      now: now,
    );
    await database.saveHighlight(
      id: 'highlight',
      bookId: 'book',
      biteId: 'bite',
      startOffset: 0,
      endOffset: 4,
      selectedText: 'Text',
      prefixContext: '',
      suffixContext: '.',
      contentChecksum: 'checksum',
      style: 'highlight',
      color: 'yellow',
      noteId: 'highlight-note',
      resolved: true,
      now: now,
    );

    final highlight = (await database.highlightsForBite('bite')).single;
    expect(highlight.selectedText, 'Text');
    expect(highlight.startOffset, 0);
    expect(highlight.endOffset, 4);
    expect(highlight.noteId, 'highlight-note');
    expect(
      (await database.highlightNote('highlight-note'))?.noteText,
      'Important',
    );
  });

  test('deleting a book cascades highlights and highlight notes', () async {
    await _createBook(database);
    final now = DateTime.utc(2026, 7, 29);
    await database.saveHighlightNote(
      id: 'highlight-note',
      bookId: 'book',
      biteId: 'bite',
      text: 'Important',
      now: now,
    );
    await database.saveHighlight(
      id: 'highlight',
      bookId: 'book',
      biteId: 'bite',
      startOffset: 0,
      endOffset: 4,
      selectedText: 'Text',
      prefixContext: '',
      suffixContext: '.',
      contentChecksum: 'checksum',
      style: 'underline',
      color: 'blue',
      noteId: 'highlight-note',
      resolved: true,
      now: now,
    );

    await database.deleteBookRecord('book');

    expect(await database.highlightsForBook('book'), isEmpty);
    expect(await database.highlightNote('highlight-note'), isNull);
  });

  test('toggles a bookmark at an exact stable location', () async {
    await _createBook(database);

    await database.addBookmark(
      bookId: 'book',
      biteId: 'bite',
      sourceOffset: 3,
      now: DateTime.utc(2026, 8, 3),
    );
    expect(await database.bookmarksForBook('book'), hasLength(1));
    expect(await database.isBookmarked('book', 'bite', 3), isTrue);

    await database.removeBookmark('book', 'bite', 3);
    expect(await database.bookmarksForBook('book'), isEmpty);
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
