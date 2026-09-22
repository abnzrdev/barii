import 'package:barii/features/reader/presentation/original_epub_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('failed original EPUB open offers retry', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OriginalEpubView(
            epubPath: '/a/path/that/does/not/exist.epub',
            initialSpineIndex: 0,
            initialOffset: 0,
            onLocationChanged: (_) {},
          ),
        ),
      ),
    );
    for (var attempt = 0; attempt < 20; attempt++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pump();
      if (find
          .text('This book could not be opened in Original view.')
          .evaluate()
          .isNotEmpty) {
        break;
      }
    }

    expect(
      find.text('This book could not be opened in Original view.'),
      findsOneWidget,
    );
    expect(find.widgetWithText(FilledButton, 'Retry'), findsOneWidget);
  });
}
