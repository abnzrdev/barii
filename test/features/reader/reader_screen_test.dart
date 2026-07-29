import 'package:bookbites/core/database/app_database.dart';
import 'package:bookbites/features/reader/presentation/reader_screen.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late Book book;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    await database.addBook(
      id: 'book',
      fingerprint: 'fingerprint',
      title: 'Reader Fixture',
      author: 'Author',
      filePath: '/tmp/book.txt',
      fileType: 'txt',
    );
    await database.replaceContent(
      'book',
      sections: const [StoredSection(id: 'section', position: 0)],
      bites: const [
        StoredBite(
          id: 'bite-1',
          sectionId: 'section',
          position: 0,
          text: 'First lantern sentence.',
          sourceStart: 0,
          sourceEnd: 23,
        ),
        StoredBite(
          id: 'bite-2',
          sectionId: 'section',
          position: 1,
          text: 'Second quiet sentence.',
          sourceStart: 24,
          sourceEnd: 46,
        ),
      ],
    );
    book = (await database.bookById('book'))!;
  });

  tearDown(() => database.close());

  testWidgets('renders one bite with accessible equivalent controls', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ReaderScreen(database: database, book: book),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('First lantern sentence.'), findsOneWidget);
    expect(find.byTooltip('Previous bite'), findsOneWidget);
    expect(find.byTooltip('Next bite'), findsOneWidget);
    expect(find.byTooltip('Notes'), findsOneWidget);
    expect(find.byTooltip('Dictionary'), findsOneWidget);
    expect(find.textContaining('of 2'), findsNothing);
  });

  testWidgets('keyboard navigation saves progress and Escape closes panels', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ReaderScreen(database: database, book: book),
      ),
    );
    await tester.pumpAndSettle();

    await tester.sendKeyEvent(LogicalKeyboardKey.keyJ);
    await tester.pumpAndSettle();
    expect(find.text('Second quiet sentence.'), findsOneWidget);
    expect((await database.progressFor('book'))?.biteId, 'bite-2');

    await tester.sendKeyEvent(LogicalKeyboardKey.keyN);
    await tester.pumpAndSettle();
    expect(find.text('Notes for this bite'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('Notes for this bite'), findsNothing);
  });
}
