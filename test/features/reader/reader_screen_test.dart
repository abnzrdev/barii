import 'package:bookbites/core/database/app_database.dart';
import 'package:bookbites/features/reader/presentation/reader_screen.dart';
import 'package:drift/native.dart';
import 'package:flutter/gestures.dart';
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
      sections: const [
        StoredSection(id: 'section', position: 0, heading: 'Heading'),
      ],
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

  testWidgets('renders persisted EPUB content exactly once', (tester) async {
    await database.replaceContent(
      'book',
      sections: const [StoredSection(id: 'section', position: 0)],
      bites: const [
        StoredBite(
          id: 'epub-bite',
          sectionId: 'section',
          position: 0,
          text: 'Previously duplicated sentence.',
          sourceStart: 0,
          sourceEnd: 31,
        ),
      ],
    );
    await tester.pumpWidget(
      MaterialApp(
        home: ReaderScreen(database: database, book: book),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Previously duplicated sentence.'),
      findsOneWidget,
    );
  });

  testWidgets('renders rich styles and confirms external links', (
    tester,
  ) async {
    await database.replaceContent(
      'book',
      sections: const [StoredSection(id: 'section', position: 0)],
      bites: const [
        StoredBite(
          id: 'rich',
          sectionId: 'section',
          position: 0,
          text: 'Heading Bold italic external',
          sourceStart: 0,
          sourceEnd: 28,
          markup:
              '{"marks":[{"start":0,"end":7,"kind":"heading"},{"start":8,"end":12,"kind":"bold"},{"start":13,"end":19,"kind":"italic"},{"start":20,"end":28,"kind":"link","href":"https://example.com"}],"anchors":{}}',
        ),
      ],
    );
    await tester.pumpWidget(
      MaterialApp(
        home: ReaderScreen(database: database, book: book),
      ),
    );
    await tester.pumpAndSettle();

    final selectable = tester.widget<SelectableText>(
      find.byType(SelectableText),
    );
    final spans = selectable.textSpan!.children!.whereType<TextSpan>().toList();
    expect(
      spans.any((span) => span.style?.fontWeight == FontWeight.bold),
      isTrue,
    );
    expect(
      spans.any((span) => span.style?.fontStyle == FontStyle.italic),
      isTrue,
    );
    final link = spans.singleWhere((span) => span.recognizer != null);
    (link.recognizer! as TapGestureRecognizer).onTap!();
    await tester.pumpAndSettle();

    expect(find.text('Open external link?'), findsOneWidget);
    expect(find.text('https://example.com'), findsOneWidget);
  });

  testWidgets('keeps EPUB presentation compact without dropping content', (
    tester,
  ) async {
    await database.replaceContent(
      'book',
      sections: const [StoredSection(id: 'section', position: 0)],
      bites: const [
        StoredBite(
          id: 'styled',
          sectionId: 'section',
          position: 0,
          text: 'A Quiet Heading\n  • Nested item',
          sourceStart: 0,
          sourceEnd: 31,
          markup:
              '{"marks":[{"start":0,"end":15,"kind":"heading"},{"start":16,"end":31,"kind":"list"}],"anchors":{}}',
        ),
        StoredBite(
          id: 'figure',
          sectionId: 'section',
          position: 1,
          text: 'Diagram\nA calm caption',
          sourceStart: 32,
          sourceEnd: 54,
          kind: 'figure',
          assetPath: '/tmp/bookbites-missing.png',
          altText: 'Diagram',
          caption: 'A calm caption',
        ),
      ],
    );
    await tester.pumpWidget(
      MaterialApp(
        home: ReaderScreen(database: database, book: book),
      ),
    );
    await tester.pumpAndSettle();

    final selectable = tester.widget<SelectableText>(
      find.byType(SelectableText),
    );
    final root = selectable.textSpan!;
    final heading = root.children!.whereType<TextSpan>().first;
    expect(
      heading.style!.fontSize!,
      lessThanOrEqualTo(root.style!.fontSize! * 1.1),
    );
    expect(root.toPlainText(), contains('A Quiet Heading\n  • Nested item'));
    expect(root.toPlainText().split('\n').last, startsWith('  • '));

    await tester.tap(find.byTooltip('Next bite'));
    await tester.pumpAndSettle();
    expect(tester.widget<Image>(find.byType(Image)).fit, BoxFit.contain);
    expect(find.text('A calm caption'), findsOneWidget);
  });

  testWidgets('plain reading mode hides and restores headings', (tester) async {
    await database.replaceContent(
      'book',
      sections: const [StoredSection(id: 'section', position: 0)],
      bites: const [
        StoredBite(
          id: 'plain-mode',
          sectionId: 'section',
          position: 0,
          text: '1.4. A Busy Heading\nA calm paragraph remains.',
          sourceStart: 0,
          sourceEnd: 46,
          markup:
              '{"marks":[{"start":0,"end":19,"kind":"heading"}],"anchors":{}}',
        ),
      ],
    );
    await tester.pumpWidget(
      MaterialApp(
        home: ReaderScreen(database: database, book: book),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Reader settings'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Plain reading mode'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Plain reading mode'));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(8, 8));
    await tester.pumpAndSettle();

    TextSpan content() =>
        tester.widget<SelectableText>(find.byType(SelectableText)).textSpan!;
    expect(content().toPlainText(), isNot(contains('1.4. A Busy Heading')));
    expect(find.textContaining('A calm paragraph remains.'), findsOneWidget);

    await tester.tap(find.byTooltip('Reader settings'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Plain reading mode'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Plain reading mode'));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(8, 8));
    await tester.pumpAndSettle();

    expect(content().toPlainText(), contains('1.4. A Busy Heading'));
  });

  testWidgets('internal links jump to anchors and support back navigation', (
    tester,
  ) async {
    await database.replaceContent(
      'book',
      sections: const [StoredSection(id: 'section', position: 0)],
      bites: const [
        StoredBite(
          id: 'source',
          sectionId: 'section',
          position: 0,
          text: 'Jump there.',
          sourceStart: 0,
          sourceEnd: 11,
          markup:
              '{"marks":[{"start":0,"end":4,"kind":"link","href":"chapter.xhtml#target"}],"anchors":{}}',
        ),
        StoredBite(
          id: 'target',
          sectionId: 'section',
          position: 1,
          text: 'Target text.',
          sourceStart: 12,
          sourceEnd: 24,
          markup: '{"marks":[],"anchors":{"chapter.xhtml#target":0}}',
        ),
      ],
    );
    await tester.pumpWidget(
      MaterialApp(
        home: ReaderScreen(database: database, book: book),
      ),
    );
    await tester.pumpAndSettle();

    final source = tester.widget<SelectableText>(find.byType(SelectableText));
    final link = source.textSpan!.children!.whereType<TextSpan>().singleWhere(
      (span) => span.recognizer != null,
    );
    (link.recognizer! as TapGestureRecognizer).onTap!();
    await tester.pumpAndSettle();
    expect(find.text('Target text.'), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('Jump there.'), findsOneWidget);
  });

  testWidgets('native selection toolbar can persist a highlight', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ReaderScreen(database: database, book: book),
      ),
    );
    await tester.pumpAndSettle();

    await tester.longPress(find.byType(SelectableText).first);
    await tester.pumpAndSettle();

    expect(find.text('Define'), findsOneWidget);
    expect(find.text('Highlight'), findsOneWidget);
    expect(find.text('Copy'), findsOneWidget);

    await tester.tap(find.text('Highlight'));
    await tester.pumpAndSettle();
    final highlights = await database.highlightsForBite('bite-1');
    expect(highlights, hasLength(1));
    expect(highlights.single.selectedText, isNotEmpty);

    await tester.drag(find.byType(PageView), const Offset(-300, 0));
    await tester.pumpAndSettle();
    expect(find.text('Notes'), findsOneWidget);
    await tester.tap(find.byTooltip('Close reader panel'));
    await tester.pumpAndSettle();

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(
      MaterialApp(
        home: ReaderScreen(database: database, book: book),
      ),
    );
    await tester.pumpAndSettle();
    final text = tester.widget<SelectableText>(
      find.byType(SelectableText).first,
    );
    expect(
      text.textSpan!.children!.whereType<TextSpan>().any(
        (span) => span.style?.backgroundColor != null,
      ),
      isTrue,
    );
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
    expect(find.text('Notes'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.byTooltip('Close reader panel'), findsNothing);
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

  testWidgets('hidden toolbar opens the unified reader panel', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ReaderScreen(database: database, book: book),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byTooltip('Contents'), findsOneWidget);
    expect(find.byTooltip('Search book'), findsOneWidget);
    expect(find.byTooltip('Add bookmark'), findsOneWidget);
    expect(find.byTooltip('Reader settings'), findsOneWidget);
    expect(
      tester
          .widget<Icon>(
            find.descendant(
              of: find.byTooltip('Reader settings'),
              matching: find.byType(Icon),
            ),
          )
          .icon,
      Icons.settings,
    );

    await tester.tap(find.byTooltip('Contents'));
    await tester.pumpAndSettle();
    expect(find.text('Contents'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Bookmarks'), findsOneWidget);
    expect(find.text('Notes'), findsOneWidget);
    expect(find.text('Heading'), findsOneWidget);
  });

  testWidgets('bookmark toolbar action persists the current location', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ReaderScreen(database: database, book: book),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Add bookmark'));
    await tester.pumpAndSettle();
    expect(await database.bookmarksForBook('book'), hasLength(1));
    expect(find.byTooltip('Remove bookmark'), findsOneWidget);
  });

  testWidgets('whole-book search jumps to the exact source offset', (
    tester,
  ) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: MaterialApp(
          home: ReaderScreen(database: database, book: book),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Search book'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(SearchBar), 'quiet');
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Second quiet sentence.').last);
    await tester.pumpAndSettle();

    expect(find.text('Second quiet sentence.'), findsOneWidget);
    final progress = await database.progressFor('book');
    expect(progress?.biteId, 'bite-2');
    expect(progress?.sourceOffset, 7);
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

  testWidgets('optional progress appears only with visible controls', (
    tester,
  ) async {
    await database.savePreferences(
      fontSize: 20,
      lineHeight: 1.6,
      alignment: 'start',
      readingWidth: 680,
      pageMargin: 24,
      autoHideControls: true,
      hapticsEnabled: true,
      showProgress: true,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: ReaderScreen(database: database, book: book),
      ),
    );
    await tester.pumpAndSettle();

    final indicator = tester.widget<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );
    expect(indicator.minHeight, 2);
    expect(find.textContaining('%'), findsNothing);

    await tester.tap(find.byType(PageView));
    await tester.pump();
    expect(find.byType(LinearProgressIndicator), findsNothing);
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
    expect(find.text('Notes'), findsOneWidget);

    await tester.tap(find.byTooltip('Close reader panel'));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(PageView), const Offset(300, 0));
    await tester.pumpAndSettle();
    expect(find.text('Offline dictionary'), findsOneWidget);

    await tester.tap(find.byTooltip('Close dictionary'));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(PageView), const Offset(30, -400));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Close reader panel'), findsNothing);
    expect(find.text('Offline dictionary'), findsNothing);
  });

  testWidgets('cancelled and diagonal drags clear panel previews immediately', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ReaderScreen(database: database, book: book),
      ),
    );
    await tester.pumpAndSettle();

    final center = tester.getCenter(find.byType(PageView));
    final cancelled = await tester.startGesture(center);
    await cancelled.moveBy(const Offset(-120, 0));
    await tester.pump();
    expect(find.text('Contents'), findsOneWidget);
    await cancelled.cancel();
    await tester.pump();
    expect(find.byTooltip('Close reader panel'), findsNothing);

    final diagonal = await tester.startGesture(center);
    await diagonal.moveBy(const Offset(-90, -80));
    await diagonal.up();
    await tester.pump();
    expect(find.byTooltip('Close reader panel'), findsNothing);
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

  testWidgets('settings scroll safely with large text on a narrow screen', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: MaterialApp(
          home: ReaderScreen(database: database, book: book),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Reader settings'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Haptic feedback'),
      200,
      scrollable: find.byType(Scrollable).last,
    );

    expect(find.text('Haptic feedback'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('settings use a dialog on wide screens', (tester) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        home: ReaderScreen(database: database, book: book),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Reader settings'));
    await tester.pumpAndSettle();

    expect(find.byType(Dialog), findsOneWidget);
    expect(find.text('Reader settings'), findsOneWidget);
  });

  testWidgets(
    'settings sections stay ordered and scroll in large-text landscape',
    (tester) async {
      tester.view.physicalSize = const Size(640, 360);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: MaterialApp(
            home: ReaderScreen(database: database, book: book),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Reader settings'));
      await tester.pumpAndSettle();

      final scrollable = find.byType(Scrollable).last;
      final sectionOffsets = <String, double>{};
      for (final section in ['Font', 'Layout', 'Theme', 'Behavior']) {
        await tester.scrollUntilVisible(
          find.text(section),
          150,
          scrollable: scrollable,
        );
        sectionOffsets[section] =
            tester.getTopLeft(find.text(section)).dy +
            tester.state<ScrollableState>(scrollable).position.pixels;
      }

      expect(
        sectionOffsets.values,
        orderedEquals(sectionOffsets.values.toList()..sort()),
      );
      expect(find.byTooltip('Reset subtle progress'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('font drag previews without losing the stable location', (
    tester,
  ) async {
    await database.saveProgress(book.id, 'bite-2', 1, 7);
    await tester.pumpWidget(
      MaterialApp(
        home: ReaderScreen(database: database, book: book),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Reader settings'));
    await tester.pumpAndSettle();

    final slider = find.byType(Slider).first;
    final gesture = await tester.startGesture(tester.getCenter(slider));
    for (var index = 0; index < 20; index++) {
      await gesture.moveBy(Offset(index.isEven ? 8 : -8, 0));
      await tester.pump(const Duration(milliseconds: 16));
    }
    await gesture.up();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.text('Second quiet sentence.'), findsOneWidget);
    expect((await database.progressFor(book.id))?.sourceOffset, 7);
    expect((await database.preferences()).fontSize, isNot(20));
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

  testWidgets('saved bite stays readable in a bounded lazy window', (
    tester,
  ) async {
    await database.replaceContent(
      'book',
      sections: const [StoredSection(id: 'section', position: 0)],
      bites: List.generate(
        200,
        (index) => StoredBite(
          id: 'bite-$index',
          sectionId: 'section',
          position: index,
          text: 'Incremental bite $index has enough text to render.',
          sourceStart: index * 50,
          sourceEnd: index * 50 + 48,
        ),
      ),
    );
    await database.saveProgress('book', 'bite-150', 150, 12);
    await database.savePreferences(
      fontSize: 20,
      lineHeight: 1.6,
      alignment: 'start',
      readingWidth: 680,
      pageMargin: 24,
      autoHideControls: true,
      hapticsEnabled: true,
      showProgress: true,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ReaderScreen(database: database, book: book),
      ),
    );
    for (var frame = 0; frame < 50; frame++) {
      await tester.pump(const Duration(milliseconds: 16));
    }

    expect(find.byKey(const ValueKey('bite-150:0')), findsOneWidget);
    expect((await database.progressFor('book'))?.biteId, 'bite-150');
    expect((await database.progressFor('book'))?.sourceOffset, 12);
    expect(
      tester
          .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
          .value,
      closeTo((150 + 12 / 47) / 200, 0.00001),
    );

    for (var frame = 0; frame < 100; frame++) {
      await tester.pump(const Duration(milliseconds: 16));
    }
    expect(find.byKey(const ValueKey('bite-150:0')), findsOneWidget);
    final pageView = tester.widget<PageView>(find.byType(PageView));
    expect(
      (pageView.childrenDelegate as SliverChildBuilderDelegate).childCount,
      lessThanOrEqualTo(9),
    );
    expect((await database.progressFor('book'))?.biteId, 'bite-150');
    expect((await database.progressFor('book'))?.sourceOffset, 12);

    for (var move = 0; move < 8; move++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.keyJ);
      await tester.pumpAndSettle();
    }
    expect((await database.progressFor('book'))?.biteId, 'bite-158');
    expect(find.byKey(const ValueKey('bite-158:0')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('search directly materializes an unloaded bite', (tester) async {
    await database.replaceContent(
      'book',
      sections: const [StoredSection(id: 'section', position: 0)],
      bites: List.generate(
        200,
        (index) => StoredBite(
          id: 'bite-$index',
          sectionId: 'section',
          position: index,
          text: index == 190 ? 'Unique distant destination.' : 'Bite $index.',
          sourceStart: index * 40,
          sourceEnd: index * 40 + 30,
        ),
      ),
    );
    await database.addBookmark(
      bookId: 'book',
      biteId: 'bite-190',
      sourceOffset: 0,
      now: DateTime.utc(2026),
    );
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: MaterialApp(
          home: ReaderScreen(database: database, book: book),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Search book'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(SearchBar), 'unique distant');
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Unique distant destination.').last);
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('bite-190:0')), findsOneWidget);
    expect((await database.progressFor('book'))?.biteId, 'bite-190');
    expect((await database.progressFor('book'))?.sourceOffset, 0);
    expect(find.byTooltip('Remove bookmark'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
