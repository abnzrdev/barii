import 'dart:async';
import 'dart:io';

import 'package:barii/core/database/app_database.dart';
import 'package:barii/features/library/data/book_import_service.dart';
import 'package:barii/features/library/presentation/library_screen.dart';
import 'package:barii/features/reader/presentation/reader_screen.dart';
import 'package:drift/native.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:webview_all/webview_all.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  const settingsProfileOnly = bool.fromEnvironment(
    'BARII_SETTINGS_PROFILE_ONLY',
  );
  const baselineProfileOnly = bool.fromEnvironment(
    'BARII_BASELINE_PROFILE_ONLY',
  );
  const originalProfileOnly = bool.fromEnvironment(
    'BARII_ORIGINAL_PROFILE_ONLY',
  );
  const benchmarkEpubPath = String.fromEnvironment('BARII_BENCHMARK_EPUB_PATH');
  const benchmarkSetupDelay = int.fromEnvironment(
    'BARII_BENCHMARK_SETUP_DELAY_SECONDS',
  );

  if (originalProfileOnly) {
    testWidgets('switches between Barii and original EPUB', (tester) async {
      if (benchmarkSetupDelay > 0) {
        await Future<void>.delayed(Duration(seconds: benchmarkSetupDelay));
      }
      final fixture = File(benchmarkEpubPath);
      expect(await fixture.exists(), isTrue, reason: benchmarkEpubPath);
      final directory = await Directory.systemTemp.createTemp(
        'barii-original-',
      );
      addTearDown(() => directory.delete(recursive: true));
      final database = AppDatabase.forTesting(
        NativeDatabase(File('${directory.path}/barii.sqlite')),
      );
      addTearDown(database.close);
      final book = await BookImportService(
        database: database,
        storageDirectory: Directory('${directory.path}/books'),
      ).importFile(fixture.path);

      await tester.pumpWidget(
        MaterialApp(
          home: ReaderScreen(database: database, book: book),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(PageView), findsOneWidget);
      await tester.tap(find.byTooltip('Switch to Original EPUB'));
      await tester.pump(const Duration(seconds: 3));
      expect(find.byType(WebViewWidget), findsOneWidget);
      expect(await database.readerViewMode(book.id), 'original');
      await tester.tap(find.byTooltip('Switch to Barii'));
      await tester.pumpAndSettle();
      expect(find.byType(PageView), findsOneWidget);
      expect(await database.readerViewMode(book.id), 'barii');
    });
  }

  if (baselineProfileOnly) {
    testWidgets('profiles import and six reader opens', (tester) async {
      if (benchmarkSetupDelay > 0) {
        await Future<void>.delayed(Duration(seconds: benchmarkSetupDelay));
      }
      final fixture = File(benchmarkEpubPath);
      expect(await fixture.exists(), isTrue, reason: benchmarkEpubPath);
      final directory = await Directory.systemTemp.createTemp(
        'barii-baseline-',
      );
      addTearDown(() => directory.delete(recursive: true));
      final database = AppDatabase.forTesting(
        NativeDatabase(File('${directory.path}/barii.sqlite')),
      );
      addTearDown(database.close);
      final importer = BookImportService(
        database: database,
        storageDirectory: Directory('${directory.path}/books'),
      );
      late Book book;

      await binding.traceAction(() async {
        book = await importer.importFile(fixture.path);
      }, reportKey: 'baseline_import_timeline');

      for (var run = 0; run < 6; run++) {
        await tester.pumpWidget(
          MaterialApp(
            home: LibraryScreen(
              database: database,
              storageDirectory: Directory('${directory.path}/books'),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await binding.watchPerformance(
          () => binding.traceAction(() async {
            await tester.tap(find.text(book.title));
            await tester.pumpAndSettle();
            expect(find.byType(PageView), findsOneWidget);
          }, reportKey: 'baseline_open_${run}_timeline'),
          reportKey: 'baseline_open_${run}_frames',
        );
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpAndSettle();
      }
    });
  }

  if (!settingsProfileOnly && !baselineProfileOnly && !originalProfileOnly) {
    testWidgets('responsive pages retain their canonical anchor', (
      tester,
    ) async {
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
      final directory = await Directory.systemTemp.createTemp('barii-figure-');
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
      await _enterText(tester, find.byType(SearchBar), 'searchable');
      await _pumpUntil(
        tester,
        () => find
            .textContaining('Second searchable location.')
            .evaluate()
            .isNotEmpty,
        'search result',
      );
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
  }

  testWidgets('sustained settings changes preserve location and persistence', (
    tester,
  ) async {
    if (baselineProfileOnly || originalProfileOnly) return;
    addTearDown(tester.view.resetPhysicalSize);
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final bites = List.generate(
      80,
      (index) => StoredBite(
        id: 'stress-$index',
        sectionId: 'section',
        position: index,
        text: List.generate(80, (word) => 'stress${index}_$word').join(' '),
        sourceStart: index * 10000,
        sourceEnd: index * 10000 + 4000,
      ),
    );
    final book = await _bookWithBites(database, bites);
    await database.saveProgress(book.id, 'stress-40', 40, 17);
    var themeMode = ThemeMode.system;

    Future<void> openReader() => tester.pumpWidget(
      StatefulBuilder(
        builder: (context, setHostState) => MaterialApp(
          themeMode: themeMode,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          home: ReaderScreen(
            database: database,
            book: book,
            themeMode: themeMode,
            onThemeChanged: (value) {
              setHostState(() => themeMode = value);
            },
          ),
        ),
      ),
    );

    await openReader();
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Reader settings'));
    await tester.pumpAndSettle();

    Future<void> exerciseSettings() async {
      for (var sliderIndex = 0; sliderIndex < 4; sliderIndex++) {
        final slider = find.byType(Slider).at(sliderIndex);
        await tester.ensureVisible(slider);
        await tester.pumpAndSettle();
        final gesture = await tester.startGesture(tester.getCenter(slider));
        for (var frame = 0; frame < 320; frame++) {
          await gesture.moveBy(Offset(frame.isEven ? 6 : -6, 0));
          await tester.pump(const Duration(milliseconds: 16));
        }
        await gesture.up();
        await tester.pump(const Duration(milliseconds: 220));
      }

      await tester.ensureVisible(find.text('Theme'));
      for (final theme in ['Dark', 'Light', 'System', 'Dark', 'System']) {
        await tester.tap(find.text(theme));
        await tester.pump(const Duration(milliseconds: 50));
      }
      final portraitSize = tester.view.physicalSize;
      tester.view.physicalSize = Size(portraitSize.height, portraitSize.width);
      await tester.pumpAndSettle();
      expect(find.text('Reader settings'), findsOneWidget);
      tester.view.physicalSize = portraitSize;
      await tester.pumpAndSettle();
    }

    if (settingsProfileOnly) {
      await binding.watchPerformance(
        () => binding.traceAction(
          exerciseSettings,
          reportKey: 'settings_timeline',
        ),
        reportKey: 'settings_performance',
      );
    } else {
      await exerciseSettings();
    }
    await tester.tapAt(const Offset(8, 8));
    await tester.pumpAndSettle();

    final beforeRestart = await database.progressFor(book.id);
    final preferences = await database.preferences();
    expect(beforeRestart?.biteId, 'stress-40');
    expect(beforeRestart?.sourceOffset, 17);
    expect(preferences.fontSize, isNot(20));

    await tester.pumpWidget(const SizedBox.shrink());
    await openReader();
    await tester.pumpAndSettle();
    expect(find.textContaining('stress40_'), findsOneWidget);
    expect((await database.preferences()).fontSize, preferences.fontSize);
    expect(tester.takeException(), isNull);
  });

  if (!settingsProfileOnly && !baselineProfileOnly && !originalProfileOnly) {
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

      await tester.tap(find.byTooltip('Notes'));
      await tester.pumpAndSettle();
      expect(find.text('Notes for this bite'), findsOneWidget);
      await _enterText(tester, find.byType(TextField).last, 'Phone note');
      await tester.tap(find.text('Save note'));
      await _pumpUntil(
        tester,
        () async => (await database.notesForBook(book.id)).length == 1,
        'saved note',
      );
      expect(await database.notesForBook(book.id), hasLength(1));
      await tester.tap(find.byTooltip('Close notes'));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Dictionary'));
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
      final restored = tester.widget<SelectableText>(
        find.byType(SelectableText),
      );
      expect(
        restored.textSpan!.children!.whereType<TextSpan>().any(
          (span) => span.style?.backgroundColor != null,
        ),
        isTrue,
      );
      expect(await database.notesForBook(book.id), hasLength(1));
    });
  }
}

Future<void> _pumpUntil(
  WidgetTester tester,
  FutureOr<bool> Function() condition,
  String description,
) async {
  final deadline = DateTime.now().add(const Duration(seconds: 5));
  while (!await condition()) {
    if (DateTime.now().isAfter(deadline)) {
      fail('Timed out waiting for $description');
    }
    await tester.pump(const Duration(milliseconds: 16));
  }
  await tester.pump();
}

Future<void> _enterText(WidgetTester tester, Finder finder, String text) async {
  final wasRegistered = tester.testTextInput.isRegistered;
  if (!wasRegistered) tester.testTextInput.register();
  try {
    await tester.enterText(finder, text);
    await tester.pump();
  } finally {
    if (!wasRegistered) tester.testTextInput.unregister();
  }
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
