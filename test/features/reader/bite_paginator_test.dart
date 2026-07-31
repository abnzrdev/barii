import 'package:bookbites/core/database/app_database.dart';
import 'package:bookbites/features/reader/presentation/bite_paginator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('measured pages preserve every source character exactly once', () {
    final content = List.generate(
      80,
      (index) => 'Sentence $index keeps multilingual text café 世界 readable.',
    ).join(' ');
    final pages = paginateBites(
      bites: [_bite(content)],
      width: 240,
      height: 180,
      style: const TextStyle(fontSize: 24, height: 1.8),
      textAlign: TextAlign.start,
      textDirection: TextDirection.ltr,
      textScaler: TextScaler.noScaling,
    );

    expect(pages.length, greaterThan(1));
    expect(pages.map((page) => page.text).join(), content);
    for (var index = 1; index < pages.length; index++) {
      expect(pages[index - 1].endOffset, pages[index].startOffset);
    }
  });

  test('page source offsets locate the same anchor after repagination', () {
    final content = List.generate(50, (index) => 'word$index').join(' ');
    final bite = _bite(content);
    final portrait = _pages(bite, 260);
    final anchor = portrait[1].startOffset;
    final landscape = _pages(bite, 500);

    final restored = landscape.singleWhere(
      (page) => anchor >= page.startOffset && anchor < page.endOffset,
    );
    expect(
      restored.text,
      content.substring(restored.startOffset, restored.endOffset),
    );
  });
}

List<DisplayPage> _pages(Bite bite, double width) => paginateBites(
  bites: [bite],
  width: width,
  height: 160,
  style: const TextStyle(fontSize: 22, height: 1.5),
  textAlign: TextAlign.start,
  textDirection: TextDirection.ltr,
  textScaler: TextScaler.noScaling,
);

Bite _bite(String content) => Bite(
  id: 'bite',
  bookId: 'book',
  sectionId: 'section',
  position: 0,
  content: content,
  sourceStart: 0,
  sourceEnd: content.length,
);
