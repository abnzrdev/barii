import 'dart:io';

import 'package:bookbites/core/database/app_database.dart';
import 'package:bookbites/features/reader/presentation/reader_screen.dart';
import 'package:drift/native.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('responsive pages retain their canonical anchor', (tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final content = List.generate(
      180,
      (index) => 'Marker$index keeps every character readable.',
    ).join(' ');
    final book = await _bookWithBites(database, [
      StoredBite(
        id: 'long-bite',
        sectionId: 'section',
        position: 0,
        text: content,
        sourceStart: 0,
        sourceEnd: content.length,
      ),
    ]);
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: ReaderScreen(database: database, book: book),
      ),
    );
    await tester.pumpAndSettle();
    final nextButton = tester
        .widgetList<IconButton>(find.byType(IconButton))
        .firstWhere(
          (button) => (button.icon as Icon).icon == Icons.keyboard_arrow_down,
        );
    expect(nextButton.onPressed, isNotNull);
    await tester.drag(find.byType(PageView), const Offset(0, -900));
    await tester.pumpAndSettle();
    final saved = (await database.progressFor(book.id))!;
    expect(saved.biteId, 'long-bite');
    expect(saved.sourceOffset, greaterThan(0));

    tester.view.physicalSize = const Size(2400, 1080);
    await tester.pumpAndSettle();
    final token = RegExp(
      r'\w+',
    ).firstMatch(content.substring(saved.sourceOffset))!.group(0)!;
    expect(find.textContaining(token), findsOneWidget);
    expect(
      (await database.progressFor(book.id))!.sourceOffset,
      saved.sourceOffset,
    );

    tester.view.physicalSize = const Size(1080, 2400);
    await tester.pumpAndSettle();
    expect(find.textContaining(token), findsOneWidget);
    tester.view.physicalSize = const Size(2400, 1080);
    await tester.pumpAndSettle();
    expect(find.textContaining(token), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(
      MaterialApp(
        home: ReaderScreen(database: database, book: book),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining(token), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsNothing);
    expect(find.byTooltip('Next bite'), findsOneWidget);
  });

  testWidgets('stored SVG figures render and open zoom', (tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final directory = await Directory.systemTemp.createTemp(
      'bookbites-figure-',
    );
    addTearDown(() => directory.delete(recursive: true));
    final svg = File('${directory.path}/figure.svg');
    await svg.writeAsString(
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 10 10"><circle cx="5" cy="5" r="4"/></svg>',
    );
    final book = await _bookWithBites(database, [
      StoredBite(
        id: 'figure-bite',
        sectionId: 'section',
        position: 0,
        text: 'Calm circle\nA contained SVG',
        sourceStart: 0,
        sourceEnd: 27,
        kind: 'figure',
        assetPath: svg.path,
        altText: 'Calm circle',
        caption: 'A contained SVG',
      ),
    ]);

    await tester.pumpWidget(
      MaterialApp(
        home: ReaderScreen(database: database, book: book),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel(RegExp('Calm circle')), findsOneWidget);
    expect(find.text('A contained SVG'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('figure-figure-bite')));
    await tester.pumpAndSettle();
    expect(find.byType(InteractiveViewer), findsOneWidget);
    await tester.tap(find.byTooltip('Close figure'));
    await tester.pumpAndSettle();
    expect(find.byType(InteractiveViewer), findsNothing);
  });

  testWidgets('adaptive toolbar panel bookmarks search and settings work', (
    tester,
  ) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    await database.savePreferences(
      fontSize: 20,
      lineHeight: 1.6,
      alignment: 'start',
      readingWidth: 680,
      pageMargin: 24,
      autoHideControls: true,
      hapticsEnabled: false,
      showProgress: true,
    );
    final book = await _bookWithBites(database, const [
      StoredBite(
        id: 'first',
        sectionId: 'section',
        position: 0,
        text: 'First calm location.',
        sourceStart: 0,
        sourceEnd: 20,
      ),
      StoredBite(
        id: 'second',
        sectionId: 'section',
        position: 1,
        text: 'Second searchable location.',
        sourceStart: 21,
        sourceEnd: 48,
      ),
    ]);
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: ReaderScreen(database: database, book: book),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(find.byTooltip('Contents'), findsOneWidget);
    expect(find.byTooltip('Search book'), findsOneWidget);

    await tester.tap(find.byTooltip('Contents'));
    await tester.pumpAndSettle();
    expect(find.text('Contents'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Bookmarks'), findsOneWidget);
    expect(find.text('Notes'), findsOneWidget);
    await tester.tap(find.byTooltip('Close reader panel'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Add bookmark'));
    await tester.pumpAndSettle();
    expect(await database.bookmarksForBook(book.id), hasLength(1));

    await tester.tap(find.byTooltip('Search book'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(SearchBar), 'searchable');
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Second searchable location.').last);
    await tester.pumpAndSettle();
    expect(find.text('Second searchable location.'), findsOneWidget);
    expect((await database.progressFor(book.id))?.sourceOffset, 7);

    await tester.tap(find.byTooltip('Reader settings'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Subtle progress'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Subtle progress'), findsOneWidget);
    await tester.tapAt(const Offset(8, 8));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(PageView));
    await tester.pump();
    expect(find.byType(LinearProgressIndicator), findsNothing);
  });

  testWidgets('large text selection notes dictionary and footnotes persist', (
    tester,
  ) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final book = await _bookWithBites(database, const [
      StoredBite(
        id: 'linked',
        sectionId: 'section',
        position: 0,
        text: 'Jump lantern word.',
        sourceStart: 0,
        sourceEnd: 18,
        markup:
            '{"marks":[{"start":0,"end":4,"kind":"link","href":"chapter.xhtml#footnote"}],"anchors":{}}',
      ),
      StoredBite(
        id: 'footnote',
        sectionId: 'section',
        position: 1,
        text: 'Footnote text.',
        sourceStart: 19,
        sourceEnd: 33,
        markup:
            '{"marks":[{"start":0,"end":14,"kind":"footnote"}],"anchors":{"chapter.xhtml#footnote":0}}',
      ),
    ]);

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(2)),
            child: ReaderScreen(database: database, book: book),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await database.saveHighlight(
      id: 'phone-highlight',
      bookId: book.id,
      biteId: 'linked',
      startOffset: 0,
      endOffset: 4,
      selectedText: 'Jump',
      prefixContext: '',
      suffixContext: ' lantern word.',
      contentChecksum: 'fixture',
      style: 'highlight',
      color: 'yellow',
      noteId: null,
      resolved: true,
      now: DateTime.utc(2026, 8, 3),
    );
    expect(await database.highlightsForBite('linked'), hasLength(1));

    await tester.drag(find.byType(PageView), const Offset(-300, 0));
    await tester.pumpAndSettle();
    expect(find.text('Notes for this bite'), findsOneWidget);
    await tester.enterText(find.byType(TextField).last, 'Phone note');
    await tester.tap(find.text('Save note'));
    await tester.pumpAndSettle();
    expect(await database.notesForBook(book.id), hasLength(1));
    await tester.tap(find.byTooltip('Close notes'));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(PageView), const Offset(300, 0));
    await tester.pumpAndSettle();
    expect(find.text('Offline dictionary'), findsOneWidget);
    await tester.tap(find.byTooltip('Close dictionary'));
    await tester.pumpAndSettle();

    final selectable = tester.widget<SelectableText>(
      find.byType(SelectableText),
    );
    final link = selectable.textSpan!.children!
        .whereType<TextSpan>()
        .singleWhere((span) => span.recognizer != null);
    (link.recognizer! as TapGestureRecognizer).onTap!();
    await tester.pumpAndSettle();
    expect(find.text('Footnote text.'), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('Jump lantern word.'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(
      MaterialApp(
        home: ReaderScreen(database: database, book: book),
      ),
    );
    await tester.pumpAndSettle();
    final restored = tester.widget<SelectableText>(find.byType(SelectableText));
    expect(
      restored.textSpan!.children!.whereType<TextSpan>().any(
        (span) => span.style?.backgroundColor != null,
      ),
      isTrue,
    );
    expect(await database.notesForBook(book.id), hasLength(1));
  });
}

Future<Book> _bookWithBites(
  AppDatabase database,
  List<StoredBite> bites,
) async {
  await database.addBook(
    id: 'book',
    fingerprint: 'fingerprint',
    title: 'Android reader fixture',
    author: 'Author',
    filePath: '/tmp/book.epub',
    fileType: 'epub',
  );
  await database.replaceContent(
    'book',
    sections: const [StoredSection(id: 'section', position: 0)],
    bites: bites,
  );
  return (await database.bookById('book'))!;
}
