import 'package:flutter/services.dart';

enum ReaderAction {
  previous,
  next,
  notes,
  dictionary,
  toggleControls,
  closePanel,
}

ReaderAction? readerActionForKey(LogicalKeyboardKey key) {
  if (key == LogicalKeyboardKey.arrowUp || key == LogicalKeyboardKey.keyK) {
    return ReaderAction.previous;
  }
  if (key == LogicalKeyboardKey.arrowDown ||
      key == LogicalKeyboardKey.space ||
      key == LogicalKeyboardKey.keyJ) {
    return ReaderAction.next;
  }
  if (key == LogicalKeyboardKey.arrowLeft || key == LogicalKeyboardKey.keyN) {
    return ReaderAction.notes;
  }
  if (key == LogicalKeyboardKey.arrowRight || key == LogicalKeyboardKey.keyD) {
    return ReaderAction.dictionary;
  }
  if (key == LogicalKeyboardKey.keyT) return ReaderAction.toggleControls;
  if (key == LogicalKeyboardKey.escape) return ReaderAction.closePanel;
  return null;
}

ReaderAction? readerActionForDrag(Offset delta, {double threshold = 56}) {
  final horizontal = delta.dx.abs();
  final vertical = delta.dy.abs();
  if (horizontal < threshold && vertical < threshold) return null;
  if (horizontal > vertical * 1.35) {
    return delta.dx < 0 ? ReaderAction.notes : ReaderAction.dictionary;
  }
  if (vertical > horizontal * 1.35) {
    return delta.dy < 0 ? ReaderAction.next : ReaderAction.previous;
  }
  return null;
}
