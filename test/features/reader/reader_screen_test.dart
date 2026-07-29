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
    final pageView = tester.widget<PageView>(find.byType(PageView));
    expect(pageView.scrollDirection, Axis.vertical);
    expect(pageView.pageSnapping, isTrue);
    expect(find.byType(LinearProgressIndicator), findsNothing);
    expect(
      find.bySemanticsLabel(RegExp('progress', caseSensitive: false)),
      findsNothing,
    );
    expect(find.textContaining('%'), findsNothing);
    expect(
      find.textContaining(
        RegExp(r'\b(?:bite|page)\s+\d', caseSensitive: false),
      ),
      findsNothing,
    );
    expect(find.byTooltip('Previous bite'), findsOneWidget);
    expect(find.byTooltip('Next bite'), findsOneWidget);
    expect(find.byTooltip('Notes'), findsOneWidget);
    expect(find.byTooltip('Dictionary'), findsOneWidget);
    expect(find.textContaining('of 2'), findsNothing);
  });

  testWidgets('completed swipe saves and cancelled swipe does not', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ReaderScreen(database: database, book: book),
      ),
    );
    await tester.pumpAndSettle();

    await tester.drag(find.byType(PageView), const Offset(0, -500));
    await tester.pumpAndSettle();
    expect(find.text('Second quiet sentence.'), findsOneWidget);
    expect((await database.progressFor('book'))?.biteId, 'bite-2');

    await tester.drag(find.byType(PageView), const Offset(0, 20));
    await tester.pumpAndSettle();
    expect(find.text('Second quiet sentence.'), findsOneWidget);
    expect((await database.progressFor('book'))?.biteId, 'bite-2');
  });

  testWidgets('keyboard navigation saves, restores, and closes panels', (
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

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(
      MaterialApp(
        home: ReaderScreen(database: database, book: book),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Second quiet sentence.'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.keyN);
    await tester.pumpAndSettle();
    expect(find.text('Notes for this bite'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('Notes for this bite'), findsNothing);
  });

  testWidgets('focus controls hide and return after a tap', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ReaderScreen(database: database, book: book),
      ),
    );
    await tester.pumpAndSettle();

    await tester.pump(const Duration(seconds: 5));
    expect(
      tester
          .widget<AnimatedOpacity>(
            find.byKey(const ValueKey('reader-controls')),
          )
          .opacity,
      0,
    );

    await tester.tap(find.byType(PageView));
    await tester.pump();
    expect(
      tester
          .widget<AnimatedOpacity>(
            find.byKey(const ValueKey('reader-controls')),
          )
          .opacity,
      1,
    );
  });

  testWidgets('automatic control hiding can be disabled', (tester) async {
    await database.savePreferences(
      fontSize: 20,
      lineHeight: 1.6,
      alignment: 'start',
      readingWidth: 680,
      pageMargin: 24,
      autoHideControls: false,
      hapticsEnabled: true,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: ReaderScreen(database: database, book: book),
      ),
    );
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 5));

    expect(
      tester
          .widget<AnimatedOpacity>(
            find.byKey(const ValueKey('reader-controls')),
          )
          .opacity,
      1,
    );
  });

  testWidgets('horizontal swipes open panels but vertical diagonals do not', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ReaderScreen(database: database, book: book),
      ),
    );
    await tester.pumpAndSettle();

    await tester.drag(find.byType(PageView), const Offset(-300, 0));
    await tester.pumpAndSettle();
    expect(find.text('Notes for this bite'), findsOneWidget);

    await tester.tap(find.byTooltip('Close notes'));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(PageView), const Offset(300, 0));
    await tester.pumpAndSettle();
    expect(find.text('Offline dictionary'), findsOneWidget);

    await tester.tap(find.byTooltip('Close dictionary'));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(PageView), const Offset(30, -400));
    await tester.pumpAndSettle();
    expect(find.text('Notes for this bite'), findsNothing);
    expect(find.text('Offline dictionary'), findsNothing);
  });

  testWidgets('Android Back closes an open panel before the reader', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ReaderScreen(database: database, book: book),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Notes'));
    await tester.pumpAndSettle();

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('Notes for this bite'), findsNothing);
    expect(find.byType(ReaderScreen), findsOneWidget);
  });

  testWidgets('haptic feedback fires once only after completed actions', (
    tester,
  ) async {
    var feedbackCount = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: ReaderScreen(
          database: database,
          book: book,
          hapticFeedback: () async => feedbackCount++,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.drag(find.byType(PageView), const Offset(0, -500));
    await tester.pumpAndSettle();
    expect(feedbackCount, 1);

    await tester.drag(find.byType(PageView), const Offset(0, 20));
    await tester.pumpAndSettle();
    expect(feedbackCount, 1);
  });

  testWidgets('haptic feedback can be disabled', (tester) async {
    await database.savePreferences(
      fontSize: 20,
      lineHeight: 1.6,
      alignment: 'start',
      readingWidth: 680,
      pageMargin: 24,
      autoHideControls: false,
      hapticsEnabled: false,
    );
    var feedbackCount = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: ReaderScreen(
          database: database,
          book: book,
          hapticFeedback: () async => feedbackCount++,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.drag(find.byType(PageView), const Offset(0, -500));
    await tester.pumpAndSettle();

    expect(feedbackCount, 0);
  });

  testWidgets('reduced motion removes chrome fade duration', (tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: MaterialApp(
          home: ReaderScreen(database: database, book: book),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<AnimatedOpacity>(
            find.byKey(const ValueKey('reader-controls')),
          )
          .duration,
      Duration.zero,
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.keyJ);
    await tester.pump();
    expect((await database.progressFor('book'))?.biteId, 'bite-2');
  });

  testWidgets('large text keeps main reader controls usable', (tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: MaterialApp(
          home: ReaderScreen(database: database, book: book),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byTooltip('Notes'), findsOneWidget);
    expect(find.byTooltip('Dictionary'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('many-bite books build only nearby pages', (tester) async {
    await database.replaceContent(
      'book',
      sections: const [StoredSection(id: 'section', position: 0)],
      bites: List.generate(
        200,
        (index) => StoredBite(
          id: 'bite-$index',
          sectionId: 'section',
          position: index,
          text: 'Lazy bite $index.',
          sourceStart: index * 10,
          sourceEnd: index * 10 + 9,
        ),
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: ReaderScreen(database: database, book: book),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.bySemanticsLabel('Reading bite').evaluate().length,
      lessThanOrEqualTo(3),
    );
    expect(find.text('Lazy bite 199.'), findsNothing);
  });
}
