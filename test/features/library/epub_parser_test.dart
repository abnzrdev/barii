import 'package:bookbites/features/library/data/epub_parser.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/epub_fixture.dart';

void main() {
  const parser = EpubParser();

  test('extracts metadata and sanitized chapters in spine order', () async {
    final publication = await parser.parse(epubFixtureBytes());

    expect(publication.title, 'Fixture Book');
    expect(publication.author, 'Fixture Author');
    expect(publication.sections.map((section) => section.heading), [
      'Chapter One',
      'Chapter Two',
    ]);
    expect(publication.sections.first.paragraphs, [
      'First safe sentence.',
      'Second safe sentence.',
    ]);
    expect(
      publication.sections.expand((section) => section.paragraphs).join(' '),
      isNot(contains('remove me')),
    );
  });

  test('reports invalid archives without leaking parser errors', () async {
    expect(() => parser.parse([1, 2, 3]), throwsA(isA<BookParseException>()));
  });

  test('rejects EPUBs without readable content', () async {
    expect(
      () => parser.parse(epubFixtureBytes(emptyContent: true)),
      throwsA(isA<BookParseException>()),
    );
  });

  test('rejects encrypted EPUB resources', () async {
    expect(
      () => parser.parse(epubFixtureBytes(encrypted: true)),
      throwsA(isA<UnsupportedDrmException>()),
    );
  });

  test('extracts nested list paragraphs exactly once', () async {
    final publication = await parser.parse(epubFixtureBytes(nestedList: true));
    const text = 'If you are a coach, build a reliable system.';

    expect(
      publication.sections.expand((section) => section.paragraphs),
      contains(text),
    );
    expect(
      publication.sections
          .expand((section) => section.paragraphs)
          .where((paragraph) => paragraph == text),
      hasLength(1),
    );
  });

  test(
    'processes anchored parent and subchapters from one spine file once',
    () async {
      final publication = await parser.parse(
        epubFixtureBytes(anchoredNavigation: true),
      );
      final paragraphs = publication.sections
          .expand((section) => section.paragraphs)
          .toList();

      expect(publication.sections, hasLength(2));
      expect(
        paragraphs.where((text) => text == 'Previously duplicated sentence.'),
        hasLength(1),
      );
      expect(
        paragraphs.where((text) => text == 'Intentional refrain.'),
        hasLength(2),
      );
      expect(paragraphs, contains('Unicode punctuation: “calm”—always.'));
    },
  );

  test(
    'preserves raster, external SVG, and inline SVG figures in order',
    () async {
      final publication = await parser.parse(epubFixtureBytes(figures: true));
      final blocks = publication.sections.first.blocks;
      final figureIndexes = <String, int>{
        for (var index = 0; index < blocks.length; index++)
          if (blocks[index].isFigure) blocks[index].altText!: index,
      };

      expect(figureIndexes.keys, [
        'Green dot',
        'JPEG portrait',
        'External SVG',
        'Inline SVG',
      ]);
      expect(figureIndexes['Green dot'], greaterThan(1));
      expect(blocks[figureIndexes['Green dot']!].caption, 'PNG caption');
      expect(publication.assets, hasLength(4));
      expect(publication.assets.keys, everyElement(isNot(startsWith('../'))));
    },
  );

  test('preserves rich text roles, links, and stable anchors', () async {
    final publication = await parser.parse(epubFixtureBytes(richText: true));
    final blocks = publication.sections.first.blocks;

    expect(blocks.any((block) => block.kind == 'heading'), isTrue);
    expect(blocks.any((block) => block.kind == 'blockquote'), isTrue);
    expect(blocks.where((block) => block.kind == 'list'), hasLength(2));
    expect(
      blocks.expand((block) => block.marks).map((mark) => mark.kind),
      containsAll(['bold', 'italic', 'link']),
    );
    expect(
      blocks.expand((block) => block.marks).map((mark) => mark.href),
      containsAll(['one.xhtml#footnote', 'https://example.com']),
    );
    expect(
      blocks
          .where((block) => block.anchor != null)
          .map((block) => block.anchor),
      contains('one.xhtml#footnote'),
    );
  });
}
