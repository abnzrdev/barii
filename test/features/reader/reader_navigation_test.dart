import 'package:barii/features/reader/presentation/reader_navigation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps Linux reading keys to actions', () {
    expect(
      readerActionForKey(LogicalKeyboardKey.arrowUp),
      ReaderAction.previous,
    );
    expect(readerActionForKey(LogicalKeyboardKey.keyK), ReaderAction.previous);
    expect(readerActionForKey(LogicalKeyboardKey.arrowDown), ReaderAction.next);
    expect(readerActionForKey(LogicalKeyboardKey.space), ReaderAction.next);
    expect(readerActionForKey(LogicalKeyboardKey.keyJ), ReaderAction.next);
    expect(readerActionForKey(LogicalKeyboardKey.keyN), ReaderAction.notes);
    expect(
      readerActionForKey(LogicalKeyboardKey.arrowLeft),
      ReaderAction.notes,
    );
    expect(
      readerActionForKey(LogicalKeyboardKey.keyD),
      ReaderAction.dictionary,
    );
    expect(
      readerActionForKey(LogicalKeyboardKey.arrowRight),
      ReaderAction.dictionary,
    );
    expect(
      readerActionForKey(LogicalKeyboardKey.keyT),
      ReaderAction.toggleControls,
    );
    expect(
      readerActionForKey(LogicalKeyboardKey.escape),
      ReaderAction.closePanel,
    );
  });

  test('classifies only decisive single-axis swipes', () {
    expect(readerActionForDrag(const Offset(2, -80)), ReaderAction.next);
    expect(readerActionForDrag(const Offset(1, 80)), ReaderAction.previous);
    expect(readerActionForDrag(const Offset(-80, 2)), ReaderAction.notes);
    expect(readerActionForDrag(const Offset(80, 2)), ReaderAction.dictionary);
    expect(readerActionForDrag(const Offset(35, 30)), isNull);
    expect(readerActionForDrag(const Offset(10, -20)), isNull);
  });
}
