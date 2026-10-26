import 'package:barii/features/dictionary/domain/dictionary_repository.dart';
import 'package:barii/features/dictionary/presentation/quick_definition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final scale in [1.0, 2.0]) {
    for (final definition in [
      'A portable light.',
      'A portable light with a protective case, carried when walking outside after dark.',
    ]) {
      testWidgets(
        'measured popup stays eight pixels from word (scale=$scale, $definition)',
        (tester) async {
          tester.view.physicalSize = const Size(600, 800);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          const anchor = Rect.fromLTWH(270, 450, 55, 24);
          await tester.pumpWidget(_preview(anchor, definition, scale: scale));
          final card = tester.getRect(
            find.descendant(
              of: find.byType(QuickDefinition),
              matching: find.byType(Material),
            ),
          );
          expect(anchor.top - card.bottom, closeTo(8, .1));
          expect(card.height, lessThanOrEqualTo(220));
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  for (final anchor in [
    const Rect.fromLTWH(2, 4, 35, 20),
    const Rect.fromLTWH(555, 750, 35, 20),
  ]) {
    testWidgets(
      'popup stays on screen and leaves underlying reading clickable: $anchor',
      (tester) async {
        tester.view.physicalSize = const Size(600, 800);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        var taps = 0;
        await tester.pumpWidget(
          _preview(anchor, 'A portable light.', onReadingTap: () => taps++),
        );
        final card = tester.getRect(
          find.descendant(
            of: find.byType(QuickDefinition),
            matching: find.byType(Material),
          ),
        );
        expect(card.left, greaterThanOrEqualTo(12));
        expect(card.right, lessThanOrEqualTo(588));
        expect(card.top, greaterThanOrEqualTo(8));
        expect(card.bottom, lessThanOrEqualTo(792));
        expect(card.overlaps(anchor), isFalse);
        expect(
          anchor.top < 30 ? card.top - anchor.bottom : anchor.top - card.bottom,
          closeTo(8, .1),
        );
        await tester.tap(find.text('Reading control'));
        expect(taps, 1);
      },
    );
  }
}

Widget _preview(
  Rect bounds,
  String definition, {
  double scale = 1,
  VoidCallback? onReadingTap,
}) => MaterialApp(
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
    child: child!,
  ),
  home: Scaffold(
    body: Stack(
      children: [
        Positioned(
          left: 10,
          top: 350,
          child: TextButton(
            onPressed: onReadingTap ?? () {},
            child: const Text('Reading control'),
          ),
        ),
        QuickDefinition(
          word: 'lantern',
          bounds: bounds,
          entry: DictionaryEntry(
            word: 'lantern',
            definition: definition,
            sourceName: 'Test',
          ),
          busy: false,
          onExpand: () {},
          onEnter: () {},
          onExit: () {},
        ),
      ],
    ),
  ),
);
