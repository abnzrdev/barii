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
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {bookId};
}

class ReaderNotes extends Table {
  TextColumn get id => text()();
  TextColumn get bookId =>
      text().references(Books, #id, onDelete: KeyAction.cascade)();
  TextColumn get biteId =>
      text().references(Bites, #id, onDelete: KeyAction.cascade)();
  TextColumn get noteText => text()();
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
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class ReaderPreferences extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get theme => text().withDefault(const Constant('system'))();
  RealColumn get fontSize => real().withDefault(const Constant(20))();
  RealColumn get lineHeight => real().withDefault(const Constant(1.6))();
  TextColumn get alignment => text().withDefault(const Constant('start'))();
  RealColumn get readingWidth => real().withDefault(const Constant(680))();

  @override
  Set<Column> get primaryKey => {id};
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
  });

  final String id;
  final String sectionId;
  final int position;
  final String text;
  final int sourceStart;
  final int sourceEnd;
}

@DriftDatabase(
  tables: [
    Books,
    Sections,
    Bites,
    ReadingProgress,
    ReaderNotes,
    VocabularyEntries,
    ReaderPreferences,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'bookbites'));
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

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
        'CREATE INDEX vocabulary_book_word '
        'ON vocabulary_entries (book_id, normalized_word)',
      );
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

  Future<void> saveProgress(String bookId, String biteId, int position) =>
      into(readingProgress).insertOnConflictUpdate(
        ReadingProgressCompanion.insert(
          bookId: bookId,
          biteId: biteId,
          bitePosition: position,
          updatedAt: DateTime.now().toUtc(),
        ),
      );

  Future<ReadingProgressData?> progressFor(String bookId) => (select(
    readingProgress,
  )..where((row) => row.bookId.equals(bookId))).getSingleOrNull();

  Future<void> saveNote({
    required String id,
    required String bookId,
    required String biteId,
    required String text,
    required DateTime now,
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
  }) => into(vocabularyEntries).insertOnConflictUpdate(
    VocabularyEntriesCompanion.insert(
      id: id,
      word: word,
      normalizedWord: normalizedWord,
      definition: definition,
      sourceSentence: sourceSentence,
      bookId: bookId,
      biteId: biteId,
      createdAt: now,
    ),
  );

  Future<List<VocabularyEntry>> vocabularyForBook(String bookId) =>
      (select(vocabularyEntries)
            ..where((row) => row.bookId.equals(bookId))
            ..orderBy([(row) => OrderingTerm.desc(row.createdAt)]))
          .get();

  Future<void> deleteBookRecord(String bookId) =>
      (delete(books)..where((row) => row.id.equals(bookId))).go();
}
