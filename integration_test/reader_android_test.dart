import 'dart:io';

import 'package:bookbites/core/database/app_database.dart';
import 'package:bookbites/features/reader/presentation/reader_screen.dart';
import 'package:drift/native.dart';
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
