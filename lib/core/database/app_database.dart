import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class Books extends Table {
  TextColumn get id => text()();
  TextColumn get fingerprint => text().unique()();
  TextColumn get title => text()();
  TextColumn get author => text()();
  TextColumn get filePath => text()();
  TextColumn get fileType => text()();
  BlobColumn get cover => blob().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Sections extends Table {
  TextColumn get id => text()();
  TextColumn get bookId =>
      text().references(Books, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();
  TextColumn get heading => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {bookId, position},
  ];
}

class Bites extends Table {
  TextColumn get id => text()();
  TextColumn get bookId =>
      text().references(Books, #id, onDelete: KeyAction.cascade)();
  TextColumn get sectionId =>
      text().references(Sections, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();
  TextColumn get content => text()();
  IntColumn get sourceStart => integer()();
  IntColumn get sourceEnd => integer()();
  TextColumn get kind => text().withDefault(const Constant('text'))();
  TextColumn get assetPath => text().nullable()();
  TextColumn get altText => text().nullable()();
  TextColumn get caption => text().nullable()();
  TextColumn get markup => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {bookId, position},
  ];
}

class ReadingProgress extends Table {
  TextColumn get bookId =>
      text().references(Books, #id, onDelete: KeyAction.cascade)();
  TextColumn get biteId =>
      text().references(Bites, #id, onDelete: KeyAction.cascade)();
  IntColumn get bitePosition => integer()();
  IntColumn get sourceOffset => integer().withDefault(const Constant(0))();
  TextColumn get canonicalLocator => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {bookId};
}

class Bookmarks extends Table {
  TextColumn get bookId =>
      text().references(Books, #id, onDelete: KeyAction.cascade)();
  TextColumn get biteId =>
      text().references(Bites, #id, onDelete: KeyAction.cascade)();
  IntColumn get sourceOffset => integer()();
  TextColumn get canonicalLocator => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {bookId, biteId, sourceOffset};
}

class ReaderNotes extends Table {
  TextColumn get id => text()();
  TextColumn get bookId =>
      text().references(Books, #id, onDelete: KeyAction.cascade)();
  TextColumn get biteId =>
      text().references(Bites, #id, onDelete: KeyAction.cascade)();
  TextColumn get noteText => text()();
  TextColumn get canonicalLocator => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class VocabularyEntries extends Table {
  TextColumn get id => text()();
  TextColumn get word => text()();
  TextColumn get normalizedWord => text()();
  TextColumn get definition => text()();
  TextColumn get sourceSentence => text()();
  TextColumn get bookId =>
      text().references(Books, #id, onDelete: KeyAction.cascade)();
  TextColumn get biteId =>
      text().references(Bites, #id, onDelete: KeyAction.cascade)();
  TextColumn get dictionarySourceId => text().nullable().references(
    DictionarySources,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get dictionarySourceName =>
      text().withDefault(const Constant('Bundled dictionary'))();
  TextColumn get partOfSpeech => text().nullable()();
  TextColumn get pronunciation => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class DictionarySources extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get language => text()();
  TextColumn get format => text()();
  IntColumn get sizeBytes => integer()();
  TextColumn get filePath => text()();
  TextColumn get contentHash => text().unique()();
  TextColumn get source => text()();
  TextColumn get licenseName => text()();
  TextColumn get attribution => text()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  IntColumn get priority => integer()();
  DateTimeColumn get installedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class DictionaryImportStates extends Table {
  TextColumn get sourceId =>
      text().references(DictionarySources, #id, onDelete: KeyAction.cascade)();
  TextColumn get stage => text()();
  IntColumn get completed => integer().withDefault(const Constant(0))();
  IntColumn get total => integer().withDefault(const Constant(1))();
  TextColumn get error => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {sourceId};
}

class HighlightNotes extends Table {
  TextColumn get id => text()();
  TextColumn get bookId =>
      text().references(Books, #id, onDelete: KeyAction.cascade)();
  TextColumn get biteId =>
      text().references(Bites, #id, onDelete: KeyAction.cascade)();
  TextColumn get noteText => text()();
  TextColumn get canonicalLocator => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Highlights extends Table {
  TextColumn get id => text()();
  TextColumn get bookId =>
      text().references(Books, #id, onDelete: KeyAction.cascade)();
  TextColumn get biteId =>
      text().references(Bites, #id, onDelete: KeyAction.cascade)();
  IntColumn get startOffset => integer()();
  IntColumn get endOffset => integer()();
  TextColumn get selectedText => text()();
  TextColumn get prefixContext => text()();
  TextColumn get suffixContext => text()();
  TextColumn get contentChecksum => text()();
  TextColumn get style => text()();
  TextColumn get color => text()();
  TextColumn get noteId => text().nullable().references(
    HighlightNotes,
    #id,
    onDelete: KeyAction.setNull,
  )();
  BoolColumn get resolved => boolean().withDefault(const Constant(true))();
  TextColumn get canonicalLocator => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {biteId, startOffset, endOffset},
  ];
}

class ReaderPreferences extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get theme => text().withDefault(const Constant('system'))();
  RealColumn get fontSize => real().withDefault(const Constant(20))();
  RealColumn get lineHeight => real().withDefault(const Constant(1.6))();
  TextColumn get alignment => text().withDefault(const Constant('start'))();
  RealColumn get readingWidth => real().withDefault(const Constant(680))();
  RealColumn get pageMargin => real().withDefault(const Constant(24))();
  BoolColumn get autoHideControls =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get hapticsEnabled =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get showProgress => boolean().withDefault(const Constant(false))();
  BoolColumn get plainReadingMode =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class ReaderViewModes extends Table {
  TextColumn get bookId =>
      text().references(Books, #id, onDelete: KeyAction.cascade)();
  TextColumn get mode => text().withDefault(const Constant('bookbites'))();

  @override
  Set<Column> get primaryKey => {bookId};
}

class CanonicalPublicationRecords extends Table {
  TextColumn get bookId =>
      text().references(Books, #id, onDelete: KeyAction.cascade)();
  IntColumn get modelVersion => integer()();
  IntColumn get parserVersion => integer()();
  IntColumn get projectionVersion => integer()();
  TextColumn get publicationJson => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {bookId};
}

class StoredSection {
  const StoredSection({required this.id, required this.position, this.heading});

  final String id;
  final int position;
  final String? heading;
}

class StoredBite {
  const StoredBite({
    required this.id,
    required this.sectionId,
    required this.position,
    required this.text,
    required this.sourceStart,
    required this.sourceEnd,
    this.kind = 'text',
    this.assetPath,
    this.altText,
    this.caption,
    this.markup,
  });

  final String id;
  final String sectionId;
  final int position;
  final String text;
  final int sourceStart;
  final int sourceEnd;
  final String kind;
  final String? assetPath;
  final String? altText;
  final String? caption;
  final String? markup;
}

@DriftDatabase(
  tables: [
    Books,
    Sections,
    Bites,
    ReadingProgress,
    Bookmarks,
    ReaderNotes,
    VocabularyEntries,
    DictionarySources,
    DictionaryImportStates,
    HighlightNotes,
    Highlights,
    ReaderPreferences,
    ReaderViewModes,
    CanonicalPublicationRecords,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'bookbites'));
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 12;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
      await customStatement('PRAGMA foreign_keys = ON');
      await customStatement(
        'CREATE INDEX bites_book_position ON bites (book_id, position)',
      );
      await customStatement(
        'CREATE INDEX notes_book_bite ON reader_notes (book_id, bite_id)',
      );
      await customStatement(
        'CREATE INDEX bookmarks_book_location '
        'ON bookmarks (book_id, bite_id, source_offset)',
      );
      await customStatement(
        'CREATE INDEX vocabulary_book_word '
        'ON vocabulary_entries (book_id, normalized_word)',
      );
      await customStatement(
        'CREATE INDEX dictionary_enabled_priority '
        'ON dictionary_sources (enabled, priority)',
      );
      await customStatement(
        'CREATE INDEX highlights_book_bite '
        'ON highlights (book_id, bite_id)',
      );
      await customStatement(
        'CREATE INDEX highlight_notes_book_bite '
        'ON highlight_notes (book_id, bite_id)',
      );
    },
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.addColumn(
          readerPreferences,
          readerPreferences.pageMargin,
        );
        await migrator.addColumn(
          readerPreferences,
          readerPreferences.autoHideControls,
        );
        await migrator.addColumn(
          readerPreferences,
          readerPreferences.hapticsEnabled,
        );
      }
      if (from < 3) {
        await migrator.createTable(dictionarySources);
        await migrator.createTable(dictionaryImportStates);
        await migrator.createTable(highlightNotes);
        await migrator.createTable(highlights);
        await migrator.addColumn(
          vocabularyEntries,
          vocabularyEntries.dictionarySourceId,
        );
        await migrator.addColumn(
          vocabularyEntries,
          vocabularyEntries.dictionarySourceName,
        );
        await migrator.addColumn(
          vocabularyEntries,
          vocabularyEntries.partOfSpeech,
        );
        await migrator.addColumn(
          vocabularyEntries,
          vocabularyEntries.pronunciation,
        );
        await customStatement(
          'CREATE INDEX dictionary_enabled_priority '
          'ON dictionary_sources (enabled, priority)',
        );
        await customStatement(
          'CREATE INDEX highlights_book_bite '
          'ON highlights (book_id, bite_id)',
        );
        await customStatement(
          'CREATE INDEX highlight_notes_book_bite '
          'ON highlight_notes (book_id, bite_id)',
        );
      }
      if (from < 4) {
        await migrator.addColumn(readingProgress, readingProgress.sourceOffset);
      }
      if (from < 5) {
        await migrator.addColumn(bites, bites.kind);
        await migrator.addColumn(bites, bites.assetPath);
        await migrator.addColumn(bites, bites.altText);
        await migrator.addColumn(bites, bites.caption);
      }
      if (from < 6) {
        await migrator.createTable(bookmarks);
        await customStatement(
          'CREATE INDEX bookmarks_book_location '
          'ON bookmarks (book_id, bite_id, source_offset)',
        );
      }
      if (from < 7) {
        await migrator.addColumn(
          readerPreferences,
          readerPreferences.showProgress,
        );
      }
      if (from < 8) {
        await migrator.addColumn(bites, bites.markup);
      }
      if (from < 9) {
        await migrator.addColumn(
          readerPreferences,
          readerPreferences.plainReadingMode,
        );
      }
      if (from < 10) {
        await migrator.createTable(readerViewModes);
      }
      if (from < 11) {
        await migrator.createTable(canonicalPublicationRecords);
      }
      if (from < 12) {
        await migrator.addColumn(
          readingProgress,
          readingProgress.canonicalLocator,
        );
        await migrator.addColumn(readerNotes, readerNotes.canonicalLocator);
        if (from >= 6) {
          await migrator.addColumn(bookmarks, bookmarks.canonicalLocator);
        }
        if (from >= 3) {
          await migrator.addColumn(
            highlightNotes,
            highlightNotes.canonicalLocator,
          );
          await migrator.addColumn(highlights, highlights.canonicalLocator);
        }
      }
    },
    beforeOpen: (_) => customStatement('PRAGMA foreign_keys = ON'),
  );

  Future<void> addBook({
    required String id,
    required String fingerprint,
    required String title,
    required String author,
    required String filePath,
    required String fileType,
    Uint8List? cover,
  }) => into(books).insert(
    BooksCompanion.insert(
      id: id,
      fingerprint: fingerprint,
      title: title,
      author: author,
      filePath: filePath,
      fileType: fileType,
      cover: Value(cover),
    ),
  );

  Future<void> replaceContent(
    String bookId, {
    required List<StoredSection> sections,
    required List<StoredBite> bites,
  }) => transaction(() async {
    await (delete(this.bites)..where((row) => row.bookId.equals(bookId))).go();
    await (delete(
      this.sections,
    )..where((row) => row.bookId.equals(bookId))).go();
    await batch((batch) {
      batch.insertAll(
        this.sections,
        sections.map(
          (section) => SectionsCompanion.insert(
            id: section.id,
            bookId: bookId,
            position: section.position,
            heading: Value(section.heading),
          ),
        ),
      );
      batch.insertAll(
        this.bites,
        bites.map(
          (bite) => BitesCompanion.insert(
            id: bite.id,
            bookId: bookId,
            sectionId: bite.sectionId,
            position: bite.position,
            content: bite.text,
            sourceStart: bite.sourceStart,
            sourceEnd: bite.sourceEnd,
            kind: Value(bite.kind),
            assetPath: Value(bite.assetPath),
            altText: Value(bite.altText),
            caption: Value(bite.caption),
            markup: Value(bite.markup),
          ),
        ),
      );
    });
  });

  Future<List<Book>> allBooks() => (select(
    books,
  )..orderBy([(row) => OrderingTerm.desc(row.createdAt)])).get();

  Future<Book?> bookByFingerprint(String fingerprint) => (select(
    books,
  )..where((row) => row.fingerprint.equals(fingerprint))).getSingleOrNull();

  Future<Book?> bookById(String id) =>
      (select(books)..where((row) => row.id.equals(id))).getSingleOrNull();

  Future<void> renameBook(String id, String title) =>
      (update(books)..where((row) => row.id.equals(id))).write(
        BooksCompanion(title: Value(title.trim())),
      );

  Stream<List<Book>> watchBooks() => (select(
    books,
  )..orderBy([(row) => OrderingTerm.desc(row.createdAt)])).watch();

  Future<List<Bite>> bitesForBook(String bookId) =>
      (select(bites)
            ..where((row) => row.bookId.equals(bookId))
            ..orderBy([(row) => OrderingTerm.asc(row.position)]))
          .get();

  Future<String?> sectionHeadingForBite(String biteId) async {
    final query = select(bites).join([
      innerJoin(sections, sections.id.equalsExp(bites.sectionId)),
    ])..where(bites.id.equals(biteId));
    return (await query.getSingleOrNull())?.readTable(sections).heading;
  }

  Future<int?> sectionPositionForBite(String biteId) async {
    final query = select(bites).join([
      innerJoin(sections, sections.id.equalsExp(bites.sectionId)),
    ])..where(bites.id.equals(biteId));
    return (await query.getSingleOrNull())?.readTable(sections).position;
  }

  Future<Bite?> biteAtSectionOffset(
    String bookId,
    int sectionPosition,
    int sourceOffset,
  ) async {
    final query =
        select(
            bites,
          ).join([innerJoin(sections, sections.id.equalsExp(bites.sectionId))])
          ..where(
            bites.bookId.equals(bookId) &
                sections.position.equals(sectionPosition),
          )
          ..orderBy([OrderingTerm.asc(bites.sourceStart)]);
    final rows = await query.get();
    if (rows.isEmpty) return null;
    return rows
        .map((row) => row.readTable(bites))
        .lastWhere(
          (bite) => bite.sourceStart <= sourceOffset,
          orElse: () => rows.first.readTable(bites),
        );
  }

  Future<void> saveProgress(
    String bookId,
    String biteId,
    int position, [
    int sourceOffset = 0,
  ]) => _saveProgress(bookId, biteId, position, sourceOffset, null);

  Future<void> saveProgressWithLocator({
    required String bookId,
    required String biteId,
    required int position,
    required int sourceOffset,
    required String canonicalLocator,
  }) => _saveProgress(bookId, biteId, position, sourceOffset, canonicalLocator);

  Future<void> _saveProgress(
    String bookId,
    String biteId,
    int position,
    int sourceOffset,
    String? canonicalLocator,
  ) => into(readingProgress).insertOnConflictUpdate(
    ReadingProgressCompanion.insert(
      bookId: bookId,
      biteId: biteId,
      bitePosition: position,
      sourceOffset: Value(sourceOffset),
      canonicalLocator: canonicalLocator == null
          ? const Value.absent()
          : Value(canonicalLocator),
      updatedAt: DateTime.now().toUtc(),
    ),
  );

  Future<ReadingProgressData?> progressFor(String bookId) => (select(
    readingProgress,
  )..where((row) => row.bookId.equals(bookId))).getSingleOrNull();

  Future<void> addBookmark({
    required String bookId,
    required String biteId,
    required int sourceOffset,
    required DateTime now,
    String? canonicalLocator,
  }) => into(bookmarks).insert(
    BookmarksCompanion.insert(
      bookId: bookId,
      biteId: biteId,
      sourceOffset: sourceOffset,
      canonicalLocator: canonicalLocator == null
          ? const Value.absent()
          : Value(canonicalLocator),
      createdAt: now,
    ),
    mode: InsertMode.insertOrIgnore,
  );

  Future<void> removeBookmark(String bookId, String biteId, int sourceOffset) =>
      (delete(bookmarks)..where(
            (row) =>
                row.bookId.equals(bookId) &
                row.biteId.equals(biteId) &
                row.sourceOffset.equals(sourceOffset),
          ))
          .go();

  Future<bool> isBookmarked(
    String bookId,
    String biteId,
    int sourceOffset,
  ) async =>
      await (select(bookmarks)..where(
            (row) =>
                row.bookId.equals(bookId) &
                row.biteId.equals(biteId) &
                row.sourceOffset.equals(sourceOffset),
          ))
          .getSingleOrNull() !=
      null;

  Future<List<Bookmark>> bookmarksForBook(String bookId) =>
      (select(bookmarks)
            ..where((row) => row.bookId.equals(bookId))
            ..orderBy([(row) => OrderingTerm.desc(row.createdAt)]))
          .get();

  Future<List<Section>> sectionsForBook(String bookId) =>
      (select(sections)
            ..where((row) => row.bookId.equals(bookId))
            ..orderBy([(row) => OrderingTerm.asc(row.position)]))
          .get();

  Future<void> saveNote({
    required String id,
    required String bookId,
    required String biteId,
    required String text,
    required DateTime now,
    String? canonicalLocator,
  }) async {
    final existing = await (select(
      readerNotes,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
    await into(readerNotes).insertOnConflictUpdate(
      ReaderNotesCompanion.insert(
        id: id,
        bookId: bookId,
        biteId: biteId,
        noteText: text,
        canonicalLocator: canonicalLocator == null
            ? const Value.absent()
            : Value(canonicalLocator),
        createdAt: existing?.createdAt ?? now,
        updatedAt: now,
      ),
    );
  }

  Future<List<ReaderNote>> notesForBook(String bookId) =>
      (select(readerNotes)
            ..where((row) => row.bookId.equals(bookId))
            ..orderBy([(row) => OrderingTerm.desc(row.updatedAt)]))
          .get();

  Future<void> deleteNote(String id) =>
      (delete(readerNotes)..where((row) => row.id.equals(id))).go();

  Future<void> saveVocabulary({
    required String id,
    required String word,
    required String normalizedWord,
    required String definition,
    required String sourceSentence,
    required String bookId,
    required String biteId,
    required DateTime now,
    String? dictionarySourceId,
    String dictionarySourceName = 'Bundled dictionary',
    String? partOfSpeech,
    String? pronunciation,
  }) => into(vocabularyEntries).insertOnConflictUpdate(
    VocabularyEntriesCompanion.insert(
      id: id,
      word: word,
      normalizedWord: normalizedWord,
      definition: definition,
      sourceSentence: sourceSentence,
      bookId: bookId,
      biteId: biteId,
      dictionarySourceId: Value(dictionarySourceId),
      dictionarySourceName: Value(dictionarySourceName),
      partOfSpeech: Value(partOfSpeech),
      pronunciation: Value(pronunciation),
      createdAt: now,
    ),
  );

  Future<List<VocabularyEntry>> vocabularyForBook(String bookId) =>
      (select(vocabularyEntries)
            ..where((row) => row.bookId.equals(bookId))
            ..orderBy([(row) => OrderingTerm.desc(row.createdAt)]))
          .get();

  Future<void> saveDictionarySource({
    required String id,
    required String name,
    required String language,
    required String format,
    required int sizeBytes,
    required String filePath,
    required String contentHash,
    required String source,
    required String licenseName,
    required String attribution,
    required DateTime installedAt,
  }) async {
    final nextPriority = await allDictionarySources().then(
      (sources) => sources.length,
    );
    await into(dictionarySources).insert(
      DictionarySourcesCompanion.insert(
        id: id,
        name: name,
        language: language,
        format: format,
        sizeBytes: sizeBytes,
        filePath: filePath,
        contentHash: contentHash,
        source: source,
        licenseName: licenseName,
        attribution: attribution,
        priority: nextPriority,
        installedAt: installedAt,
      ),
    );
  }

  Future<List<DictionarySource>> allDictionarySources() => (select(
    dictionarySources,
  )..orderBy([(row) => OrderingTerm.asc(row.priority)])).get();

  Future<DictionarySource?> dictionarySourceByHash(String hash) => (select(
    dictionarySources,
  )..where((row) => row.contentHash.equals(hash))).getSingleOrNull();

  Future<void> setDictionaryEnabled(String id, bool enabled) =>
      (update(dictionarySources)..where((row) => row.id.equals(id))).write(
        DictionarySourcesCompanion(enabled: Value(enabled)),
      );

  Future<void> setDictionaryPriorities(List<String> sourceIds) =>
      transaction(() async {
        for (var index = 0; index < sourceIds.length; index++) {
          await (update(dictionarySources)
                ..where((row) => row.id.equals(sourceIds[index])))
              .write(DictionarySourcesCompanion(priority: Value(index)));
        }
      });

  Future<void> deleteDictionarySource(String id) =>
      (delete(dictionarySources)..where((row) => row.id.equals(id))).go();

  Future<void> saveDictionaryImportState({
    required String sourceId,
    required String stage,
    required int completed,
    required int total,
    String? error,
  }) => into(dictionaryImportStates).insertOnConflictUpdate(
    DictionaryImportStatesCompanion.insert(
      sourceId: sourceId,
      stage: stage,
      completed: Value(completed),
      total: Value(total),
      error: Value(error),
      updatedAt: DateTime.now().toUtc(),
    ),
  );

  Future<DictionaryImportState?> dictionaryImportState(String sourceId) =>
      (select(
        dictionaryImportStates,
      )..where((row) => row.sourceId.equals(sourceId))).getSingleOrNull();

  Future<void> saveHighlightNote({
    required String id,
    required String bookId,
    required String biteId,
    required String text,
    required DateTime now,
    String? canonicalLocator,
  }) async {
    final existing = await highlightNote(id);
    await into(highlightNotes).insertOnConflictUpdate(
      HighlightNotesCompanion.insert(
        id: id,
        bookId: bookId,
        biteId: biteId,
        noteText: text,
        canonicalLocator: canonicalLocator == null
            ? const Value.absent()
            : Value(canonicalLocator),
        createdAt: existing?.createdAt ?? now,
        updatedAt: now,
      ),
    );
  }

  Future<HighlightNote?> highlightNote(String id) => (select(
    highlightNotes,
  )..where((row) => row.id.equals(id))).getSingleOrNull();

  Future<void> deleteHighlightNote(String id) =>
      (delete(highlightNotes)..where((row) => row.id.equals(id))).go();

  Future<void> saveHighlight({
    required String id,
    required String bookId,
    required String biteId,
    required int startOffset,
    required int endOffset,
    required String selectedText,
    required String prefixContext,
    required String suffixContext,
    required String contentChecksum,
    required String style,
    required String color,
    required String? noteId,
    required bool resolved,
    required DateTime now,
    String? canonicalLocator,
  }) async {
    final existing = await (select(
      highlights,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
    await into(highlights).insertOnConflictUpdate(
      HighlightsCompanion.insert(
        id: id,
        bookId: bookId,
        biteId: biteId,
        startOffset: startOffset,
        endOffset: endOffset,
        selectedText: selectedText,
        prefixContext: prefixContext,
        suffixContext: suffixContext,
        contentChecksum: contentChecksum,
        style: style,
        color: color,
        noteId: Value(noteId),
        resolved: Value(resolved),
        canonicalLocator: canonicalLocator == null
            ? const Value.absent()
            : Value(canonicalLocator),
        createdAt: existing?.createdAt ?? now,
        updatedAt: now,
      ),
    );
  }

  Future<List<Highlight>> highlightsForBite(String biteId) =>
      (select(highlights)
            ..where((row) => row.biteId.equals(biteId))
            ..orderBy([(row) => OrderingTerm.asc(row.startOffset)]))
          .get();

  Future<List<Highlight>> highlightsForBook(String bookId) =>
      (select(highlights)
            ..where((row) => row.bookId.equals(bookId))
            ..orderBy([(row) => OrderingTerm.desc(row.updatedAt)]))
          .get();

  Future<void> updateHighlightAppearance(
    String id, {
    required String style,
    required String color,
  }) => (update(highlights)..where((row) => row.id.equals(id))).write(
    HighlightsCompanion(
      style: Value(style),
      color: Value(color),
      updatedAt: Value(DateTime.now().toUtc()),
    ),
  );

  Future<void> setHighlightResolved(String id, bool resolved) =>
      (update(highlights)..where((row) => row.id.equals(id))).write(
        HighlightsCompanion(resolved: Value(resolved)),
      );

  Future<void> deleteHighlight(String id, {bool deleteNote = false}) =>
      transaction(() async {
        final highlight = await (select(
          highlights,
        )..where((row) => row.id.equals(id))).getSingleOrNull();
        await (delete(highlights)..where((row) => row.id.equals(id))).go();
        if (deleteNote && highlight?.noteId != null) {
          await deleteHighlightNote(highlight!.noteId!);
        }
      });

  Future<void> deleteBookRecord(String bookId) =>
      (delete(books)..where((row) => row.id.equals(bookId))).go();

  Future<void> ensurePreferences() => transaction(() async {
    await into(readerPreferences).insert(
      const ReaderPreferencesCompanion(id: Value(1)),
      mode: InsertMode.insertOrIgnore,
    );
    await (delete(
      readerPreferences,
    )..where((row) => row.id.isNotValue(1))).go();
  });

  Future<ReaderPreference> preferences() async {
    await ensurePreferences();
    return select(readerPreferences).getSingle();
  }

  Future<void> savePreferences({
    required double fontSize,
    required double lineHeight,
    required String alignment,
    required double readingWidth,
    required double pageMargin,
    required bool autoHideControls,
    required bool hapticsEnabled,
    bool showProgress = false,
    bool plainReadingMode = false,
  }) async {
    await ensurePreferences();
    await update(readerPreferences).write(
      ReaderPreferencesCompanion(
        fontSize: Value(fontSize),
        lineHeight: Value(lineHeight),
        alignment: Value(alignment),
        readingWidth: Value(readingWidth),
        pageMargin: Value(pageMargin),
        autoHideControls: Value(autoHideControls),
        hapticsEnabled: Value(hapticsEnabled),
        showProgress: Value(showProgress),
        plainReadingMode: Value(plainReadingMode),
      ),
    );
  }

  Future<void> saveTheme(String theme) => update(
    readerPreferences,
  ).write(ReaderPreferencesCompanion(theme: Value(theme)));

  Future<String> readerViewMode(String bookId) async =>
      (await (select(
        readerViewModes,
      )..where((row) => row.bookId.equals(bookId))).getSingleOrNull())?.mode ??
      'bookbites';

  Future<void> saveReaderViewMode(String bookId, String mode) =>
      into(readerViewModes).insertOnConflictUpdate(
        ReaderViewModesCompanion.insert(bookId: bookId, mode: Value(mode)),
      );

  Future<void> saveCanonicalPublication({
    required String bookId,
    required int modelVersion,
    required int parserVersion,
    required int projectionVersion,
    required String publicationJson,
  }) => into(canonicalPublicationRecords).insertOnConflictUpdate(
    CanonicalPublicationRecordsCompanion.insert(
      bookId: bookId,
      modelVersion: modelVersion,
      parserVersion: parserVersion,
      projectionVersion: projectionVersion,
      publicationJson: publicationJson,
      createdAt: DateTime.now().toUtc(),
    ),
  );

  Future<CanonicalPublicationRecord?> canonicalPublicationFor(String bookId) =>
      (select(
        canonicalPublicationRecords,
      )..where((row) => row.bookId.equals(bookId))).getSingleOrNull();

  Future<int> setProgressCanonicalLocator(String bookId, String locator) =>
      (update(readingProgress)..where(
            (row) => row.bookId.equals(bookId) & row.canonicalLocator.isNull(),
          ))
          .write(ReadingProgressCompanion(canonicalLocator: Value(locator)));

  Future<int> setBookmarkCanonicalLocator(
    String bookId,
    String biteId,
    int sourceOffset,
    String locator,
  ) =>
      (update(bookmarks)..where(
            (row) =>
                row.bookId.equals(bookId) &
                row.biteId.equals(biteId) &
                row.sourceOffset.equals(sourceOffset) &
                row.canonicalLocator.isNull(),
          ))
          .write(BookmarksCompanion(canonicalLocator: Value(locator)));

  Future<int> setReaderNoteCanonicalLocator(String id, String locator) =>
      (update(readerNotes)
            ..where((row) => row.id.equals(id) & row.canonicalLocator.isNull()))
          .write(ReaderNotesCompanion(canonicalLocator: Value(locator)));

  Future<int> setHighlightCanonicalLocator(String id, String locator) =>
      (update(highlights)
            ..where((row) => row.id.equals(id) & row.canonicalLocator.isNull()))
          .write(HighlightsCompanion(canonicalLocator: Value(locator)));

  Future<int> setHighlightNoteCanonicalLocator(String id, String locator) =>
      (update(highlightNotes)
            ..where((row) => row.id.equals(id) & row.canonicalLocator.isNull()))
          .write(HighlightNotesCompanion(canonicalLocator: Value(locator)));
}
