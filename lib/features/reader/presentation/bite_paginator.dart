import 'package:flutter/material.dart';

import '../../../core/database/app_database.dart';

class DisplayPage {
  const DisplayPage({
    required this.bite,
    required this.startOffset,
    required this.endOffset,
  });

  final Bite bite;
  final int startOffset;
  final int endOffset;

  String get text => bite.content.substring(startOffset, endOffset);
}

List<DisplayPage> paginateBites({
  required List<Bite> bites,
  required double width,
  required double height,
  required TextStyle style,
  required TextAlign textAlign,
  required TextDirection textDirection,
  required TextScaler textScaler,
}) {
  final pages = <DisplayPage>[];
  for (final bite in bites) {
    var start = 0;
    while (start < bite.content.length) {
      var low = start + 1;
      var high = bite.content.length;
      var end = low;
      while (low <= high) {
        final middle = (low + high) ~/ 2;
        final painter = TextPainter(
          text: TextSpan(
            text: bite.content.substring(start, middle),
            style: style,
          ),
          textAlign: textAlign,
          textDirection: textDirection,
          textScaler: textScaler,
        )..layout(maxWidth: width);
        if (painter.height <= height) {
          end = middle;
          low = middle + 1;
        } else {
          high = middle - 1;
        }
      }
      if (end < bite.content.length) {
        final whitespace = bite.content.lastIndexOf(RegExp(r'\s'), end - 1);
        if (whitespace >= start) end = whitespace + 1;
      }
      if (end < bite.content.length &&
          end > start &&
          _isHighSurrogate(bite.content.codeUnitAt(end - 1)) &&
          _isLowSurrogate(bite.content.codeUnitAt(end))) {
        end--;
      }
      if (end <= start) end = start + 1;
      pages.add(DisplayPage(bite: bite, startOffset: start, endOffset: end));
      start = end;
    }
  }
  return pages;
}

bool _isHighSurrogate(int value) => value >= 0xD800 && value <= 0xDBFF;
bool _isLowSurrogate(int value) => value >= 0xDC00 && value <= 0xDFFF;
