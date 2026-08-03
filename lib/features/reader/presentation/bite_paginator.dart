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
    final bitePages = <DisplayPage>[];
    if (bite.kind == 'figure') {
      pages.add(
        DisplayPage(bite: bite, startOffset: 0, endOffset: bite.content.length),
      );
      continue;
    }
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
      bitePages.add(
        DisplayPage(bite: bite, startOffset: start, endOffset: end),
      );
      start = end;
    }
    if (bitePages.length > 1 &&
        _lineCount(
              bitePages.last.text,
              width,
              style,
              textAlign,
              textDirection,
              textScaler,
            ) <=
            1) {
      final previous = bitePages[bitePages.length - 2];
      final last = bitePages.last;
      final split = _balancedSplit(
        bite.content,
        previous.startOffset,
        last.endOffset,
        width,
        height,
        style,
        textAlign,
        textDirection,
        textScaler,
      );
      if (split != null) {
        bitePages[bitePages.length - 2] = DisplayPage(
          bite: bite,
          startOffset: previous.startOffset,
          endOffset: split,
        );
        bitePages[bitePages.length - 1] = DisplayPage(
          bite: bite,
          startOffset: split,
          endOffset: last.endOffset,
        );
      }
    }
    pages.addAll(bitePages);
  }
  return pages;
}

int? _balancedSplit(
  String text,
  int start,
  int end,
  double width,
  double height,
  TextStyle style,
  TextAlign align,
  TextDirection direction,
  TextScaler scaler,
) {
  int? best;
  var bestDifference = 1 << 30;
  for (var split = start + 1; split < end; split++) {
    if (!RegExp(r'\s').hasMatch(text[split - 1])) continue;
    final first = text.substring(start, split);
    final second = text.substring(split, end);
    final firstLines = _lineCount(
      first,
      width,
      style,
      align,
      direction,
      scaler,
      maxHeight: height,
    );
    final secondLines = _lineCount(
      second,
      width,
      style,
      align,
      direction,
      scaler,
      maxHeight: height,
    );
    if (firstLines < 2 || secondLines < 2) continue;
    final difference = (firstLines - secondLines).abs();
    if (difference < bestDifference) {
      best = split;
      bestDifference = difference;
    }
  }
  return best;
}

int _lineCount(
  String text,
  double width,
  TextStyle style,
  TextAlign align,
  TextDirection direction,
  TextScaler scaler, {
  double? maxHeight,
}) {
  final painter = TextPainter(
    text: TextSpan(text: text, style: style),
    textAlign: align,
    textDirection: direction,
    textScaler: scaler,
  )..layout(maxWidth: width);
  if (maxHeight != null && painter.height > maxHeight) return 0;
  return painter.computeLineMetrics().length;
}

bool _isHighSurrogate(int value) => value >= 0xD800 && value <= 0xDBFF;
bool _isLowSurrogate(int value) => value >= 0xDC00 && value <= 0xDFFF;
