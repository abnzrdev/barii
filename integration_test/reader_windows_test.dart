import 'dart:convert';
import 'dart:io';

import 'package:barii/app/barii_theme.dart';
import 'package:barii/core/database/app_database.dart';
import 'package:barii/features/library/data/book_import_service.dart';
import 'package:barii/features/dictionary/data/bundled_dictionary_pack.dart';
import 'package:barii/features/dictionary/data/sqlite_dictionary_repository.dart';
import 'package:barii/features/dictionary/presentation/quick_definition.dart';
import 'package:barii/features/dictionary/presentation/dictionary_panel.dart';
import 'package:barii/features/reader/presentation/reader_screen.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:webview_all/webview_all.dart';
import 'package:window_manager/window_manager.dart';

import '../test/support/epub_fixture.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Windows import, fullscreen, resume and Original EPUB bridge', (
    tester,
  ) async {
    await windowManager.ensureInitialized();
    final storage = await Directory.systemTemp.createTemp(
      'barii-windows-test-',
    );
    final database = AppDatabase.forTesting(
      NativeDatabase(File('${storage.path}/test.sqlite')),
    );
    addTearDown(() async {
      await windowManager.setFullScreen(false);
      await database.close();
      await storage.delete(recursive: true);
    });
    await database.ensurePreferences();
    await ensureBundledDictionary(
      database,
      Directory('${storage.path}/dictionaries'),
    );
    final dictionary = SqliteDictionaryRepository(database);
    expect((await dictionary.lookupEntry('accuracy'))?.senses, isNotEmpty);
    await database.savePreferences(
      fontFamily: 'sans',
      readingBackground: 'sepia',
      fontSize: 24,
      lineHeight: 1.6,
      alignment: 'start',
      readingWidth: 680,
      pageMargin: 24,
      autoHideControls: false,
      hapticsEnabled: false,
    );
    final imports = BookImportService(
      database: database,
      storageDirectory: Directory('${storage.path}/books'),
    );
    final textFile = File('${storage.path}/sample.txt');
    await textFile.writeAsString('A lantern lights the quiet room.');
    final textBook = await imports.importFile(textFile.path);
    expect(await File(textBook.filePath).exists(), isTrue);
    final epubFile = File('${storage.path}/sample.epub');
    await epubFile.writeAsBytes(
      epubFixtureBytes(
        firstXhtml: '''<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>Windows reading fixture</title></head>
<body style="width: 1600px; min-width: 1200px"><div style="width: 1400px">
<h1>Chapter One</h1><p>First safe sentence.</p>
<img width="1400" height="30" alt="Wide fixture" src="images/dot.png"/>
<pre>an_extremely_long_unbroken_code_line_that_must_scroll_inside_its_own_block_without_widening_the_reader</pre></div>
<p>Second safe sentence.</p></body></html>''',
        figures: true,
        secondXhtml: '''<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>Second chapter</title></head><body><h1>Chapter Two</h1>
<p>A calm second chapter.</p></body></html>''',
      ),
    );
    final book = await imports.importFile(epubFile.path);
    expect(await database.canonicalPublicationFor(book.id), isNotNull);

    Widget reader() => MaterialApp(
      theme: BariiTheme.light(),
      home: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: 390,
          child: ReaderScreen(
            database: database,
            book: book,
            dictionaryRepository: dictionary,
          ),
        ),
      ),
    );
    await tester.pumpWidget(reader());
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    final before = await database.progressFor(book.id);
    expect(before, isNotNull);
    final bounds = await windowManager.getBounds();
    await tester.tap(find.byTooltip('Fullscreen (F11)'));
    await tester.pumpAndSettle();
    expect(await windowManager.isFullScreen(), isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(await windowManager.isFullScreen(), isFalse);
    final restoredBounds = await windowManager.getBounds();
    expect(restoredBounds.left, closeTo(bounds.left, 2));
    expect(restoredBounds.top, closeTo(bounds.top, 2));
    expect(restoredBounds.width, closeTo(bounds.width, 2));
    expect(restoredBounds.height, closeTo(bounds.height, 2));
    final after = await database.progressFor(book.id);
    expect(after?.biteId, before?.biteId);
    expect(after?.sourceOffset, before?.sourceOffset);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
    await tester.pumpWidget(reader());
    await tester.pumpAndSettle();
    expect((await database.progressFor(book.id))?.biteId, before?.biteId);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Switch to Original EPUB'));
    await tester.pumpAndSettle();
    await _waitFor(
      tester,
      () async => find.byType(WebViewWidget).evaluate().isNotEmpty,
    );
    final webview = tester.widget<WebViewWidget>(find.byType(WebViewWidget));
    final controller = webview.platform.params.controller;
    await _waitFor(tester, () async {
      try {
        final ready = await controller.runJavaScriptReturningResult(
          'Boolean(window.__bariiOriginalReader)',
        );
        return ready == true || ready.toString() == 'true';
      } on PlatformException {
        return false;
      }
    });
    expect(find.text('Scroll'), findsNothing);
    expect(find.text('Pages'), findsNothing);
    expect(find.byTooltip('Next EPUB section'), findsNothing);
    final appearance =
        jsonDecode(
              (await controller.runJavaScriptReturningResult(
                "JSON.stringify({font: getComputedStyle(document.body).fontFamily, size: getComputedStyle(document.body).fontSize, background: getComputedStyle(document.body).backgroundColor})",
              )).toString(),
            )
            as Map<String, dynamic>;
    expect(appearance['font'], contains('Arial'));
    expect(appearance['size'], '24px');
    expect(appearance['background'], 'rgb(238, 226, 200)');
    await _waitFor(
      tester,
      () async =>
          (await controller.runJavaScriptReturningResult('innerWidth < 450')) ==
          true,
    );
    final geometry =
        jsonDecode(
              (await controller.runJavaScriptReturningResult(
                "JSON.stringify({viewport: innerWidth, page: document.documentElement.scrollWidth, body: document.body.getBoundingClientRect().width, image: document.querySelector('img').getBoundingClientRect().width, padding: getComputedStyle(document.body).paddingLeft})",
              )).toString(),
            )
            as Map<String, dynamic>;
    expect(
      geometry['page'] as num,
      lessThanOrEqualTo((geometry['viewport'] as num) + 1),
    );
    expect(
      geometry['body'] as num,
      lessThanOrEqualTo(geometry['viewport'] as num),
    );
    expect(geometry['image'] as num, lessThan(geometry['viewport'] as num));
    expect(geometry['padding'], isNot('0px'));
    final hoverWatch = Stopwatch()..start();
    await controller.runJavaScript('''
      (() => {
        const node = document.querySelector('p').firstChild;
        const range = document.createRange(); range.setStart(node, 6); range.setEnd(node, 10);
        const rect = range.getBoundingClientRect();
        document.dispatchEvent(new PointerEvent('pointermove', {pointerType: 'mouse',
          clientX: rect.x + rect.width / 2, clientY: rect.y + rect.height / 2, bubbles: true}));
      })();
    ''');
    await _waitFor(
      tester,
      () async => find.byType(QuickDefinition).evaluate().isNotEmpty,
    );
    await _waitFor(
      tester,
      () async =>
          tester.widget<QuickDefinition>(find.byType(QuickDefinition)).entry !=
          null,
    );
    expect(
      tester.widget<QuickDefinition>(find.byType(QuickDefinition)).entry!.word,
      'safe',
    );
    final preview = tester.widget<QuickDefinition>(
      find.byType(QuickDefinition),
    );
    final previewCard = find.descendant(
      of: find.byType(QuickDefinition),
      matching: find.byType(InkWell),
    );
    final cardBounds = tester.getRect(previewCard);
    expect(cardBounds.overlaps(preview.bounds), isFalse);
    final gap = cardBounds.bottom <= preview.bounds.top
        ? preview.bounds.top - cardBounds.bottom
        : cardBounds.top - preview.bounds.bottom;
    expect(gap, closeTo(8, .5));
    // Includes native browser events, channel delivery, local lookup and layout.
    expect(hoverWatch.elapsedMilliseconds, lessThan(1500));
    debugPrint(
      'Native EPUB hover to definition: ${hoverWatch.elapsedMilliseconds}ms',
    );
    await tester.tap(previewCard);
    await tester.pumpAndSettle();
    expect(find.byType(DictionaryPanel), findsOneWidget);
    await tester.tap(find.text('Save word'));
    await tester.pumpAndSettle();
    final saved = (await database.vocabularyForBook(book.id)).single;
    expect(saved.word, 'safe');
    expect(saved.canonicalLocator, contains('original'));
    expect(saved.dictionarySenseId, isNotNull);
    await tester.tap(find.byTooltip('Close dictionary'));
    await tester.pumpAndSettle();
    await controller.runJavaScript('''
      document.scrollingElement.scrollTo(0, document.scrollingElement.scrollHeight);
      const range = document.createRange();
      range.selectNodeContents(document.querySelector('p'));
      getSelection().removeAllRanges(); getSelection().addRange(range);
    ''');
    await tester.pumpAndSettle();
    const edgeSwipe = '''
      (() => {
        const start = new Event('touchstart', {bubbles: true});
        Object.defineProperty(start, 'touches', {value: [{clientX: 100, clientY: 300}]});
        document.dispatchEvent(start);
        const end = new Event('touchend', {bubbles: true});
        Object.defineProperty(end, 'changedTouches', {value: [{clientX: 100, clientY: 180}]});
        document.dispatchEvent(end);
      })();
    ''';
    await controller.runJavaScript(edgeSwipe);
    await tester.pump(const Duration(milliseconds: 250));
    expect((await controller.currentUrl()), endsWith('one.xhtml'));
    await controller.runJavaScript('getSelection().removeAllRanges();');
    await controller.runJavaScript(edgeSwipe);
    await _waitFor(
      tester,
      () async =>
          (await controller.currentUrl())?.endsWith('two.xhtml') == true,
    );
    await _waitFor(
      tester,
      () async =>
          (await controller.runJavaScriptReturningResult(
            'Boolean(window.__bariiOriginalReader)',
          )) ==
          true,
    );
    await controller.runJavaScript(
      "document.dispatchEvent(new KeyboardEvent('keydown', {key: 'F11', bubbles: true}));",
    );
    await _waitFor(tester, windowManager.isFullScreen);
    await controller.runJavaScript(
      "document.dispatchEvent(new KeyboardEvent('keydown', {key: 'Escape', bubbles: true}));",
    );
    await _waitFor(tester, () async => !await windowManager.isFullScreen());
    await windowManager.setBounds(bounds);
    expect(
      find.text('This book could not be opened in Original view.'),
      findsNothing,
    );
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
    await tester.pumpWidget(
      MaterialApp(
        theme: BariiTheme.light(),
        home: ReaderScreen(
          database: database,
          book: book,
          dictionaryRepository: dictionary,
          initialVocabulary: saved,
        ),
      ),
    );
    await _waitFor(
      tester,
      () async => find.byType(WebViewWidget).evaluate().isNotEmpty,
    );
    final returnedController = tester
        .widget<WebViewWidget>(find.byType(WebViewWidget))
        .platform
        .params
        .controller;
    await _waitFor(tester, () async {
      try {
        return await returnedController.runJavaScriptReturningResult(
              "Boolean(window.CSS?.highlights?.has('barii-return'))",
            ) ==
            true;
      } on PlatformException {
        return false;
      }
    });
    expect(await returnedController.currentUrl(), endsWith('one.xhtml'));
    expect(
      await returnedController.runJavaScriptReturningResult(
        "Array.from(CSS.highlights.get('barii-return'))[0].toString()",
      ),
      'safe',
    );
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  }, skip: !Platform.isWindows);
}

Future<void> _waitFor(
  WidgetTester tester,
  Future<bool> Function() ready,
) async {
  for (var attempt = 0; attempt < 100; attempt++) {
    if (await ready()) return;
    await tester.pump(const Duration(milliseconds: 100));
  }
  fail('Windows reader did not become ready within 10 seconds.');
}
