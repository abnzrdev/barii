import 'package:bookbites/features/library/data/epub_parser.dart';
import 'package:bookbites/features/library/domain/canonical_publication.dart';
import 'package:bookbites/features/reader/domain/bite_generator.dart';
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
      blocks.where((block) => block.kind == 'list').map((block) => block.text),
      ['1. Outer item', '  • Nested item'],
    );
    expect(
      blocks.where((block) => block.text?.contains('Nested item') ?? false),
      hasLength(1),
    );
    expect(blocks.first.text, 'Chapter One');
    expect(
      blocks.map((block) => block.text),
      contains(
        'Bold words and italic words with a footnote and an external source.',
      ),
    );
    final repeated = blocks.singleWhere(
      (block) => block.text == 'Echo then Echo.',
    );
    final boldEchoes = repeated.marks.where((mark) => mark.kind == 'bold');
    expect(boldEchoes.map((mark) => mark.start), [0, 10]);
    expect(
      boldEchoes.map((mark) => repeated.text!.substring(mark.start, mark.end)),
      everyElement('Echo'),
    );
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

  test(
    'canonical blocks round-trip through bites without loss or duplication',
    () async {
      final publication = await parser.parse(epubFixtureBytes(richText: true));
      final section = publication.sections.first;
      final canonical = section.blocks
          .where((block) => !block.isFigure)
          .map((block) => block.text!)
          .join('\n\n');
      final bites = const BiteGenerator(
        targetWords: 6,
        maxWords: 10,
      ).generate(bookFingerprint: 'canonical', sections: [section]);
      final recombined = bites.map((bite) => bite.text).join('\n\n');

      expect(recombined, canonical);
      expect('Nested item'.allMatches(recombined), hasLength(1));
      expect(
        recombined.indexOf('Outer item'),
        lessThan(recombined.indexOf('Nested item')),
      );
      for (final bite in bites) {
        final markup = bite.markup ?? '';
        expect(markup, isNot(contains('"start":-')));
        expect(bite.sourceStart, lessThanOrEqualTo(bite.sourceEnd));
      }
    },
  );

  test(
    'preserves publication resources and distinct spine occurrences',
    () async {
      final publication = await parser.parse(
        epubFixtureBytes(canonicalSemantics: true),
      );
      final canonical = publication.canonical!;

      expect(canonical.metadata.languages, ['ar']);
      expect(canonical.rendition.layout, 'pre-paginated');
      expect(canonical.pageProgressionDirection, 'rtl');
      expect(
        canonical.resources['one.xhtml']?.mediaType,
        'application/xhtml+xml',
      );
      expect(canonical.readingOrder, hasLength(3));
      expect(canonical.readingOrder.take(2).map((item) => item.resourceHref), [
        'one.xhtml',
        'one.xhtml',
      ]);
      expect(
        canonical.readingOrder.take(2).map((item) => item.occurrenceId).toSet(),
        hasLength(2),
      );
      expect(canonical.readingOrder[1].linear, isFalse);
    },
  );

  test(
    'preserves semantic nodes, IDs, direction, and nested text order',
    () async {
      final publication = await parser.parse(
        epubFixtureBytes(canonicalSemantics: true),
      );
      final section = publication.canonical!.readingOrder.first;
      final paragraph = section.nodes
          .expand(_canonicalDescendants)
          .singleWhere((node) => node.elementId == 'semantic-start');
      final inner = paragraph.children
          .expand(_canonicalDescendants)
          .singleWhere((node) => node.elementId == 'inner-mark');

      expect(section.language, 'ar');
      expect(section.textDirection, 'rtl');
      expect(paragraph.logicalText, 'Alpha bold inner omega.');
      expect(inner.logicalText, 'inner');
      expect(paragraph.startOffset, lessThan(inner.startOffset));
      expect(inner.endOffset, lessThan(paragraph.endOffset));

      final projected = publication.sections.first.blocks.singleWhere(
        (block) => block.text == 'Alpha bold inner omega.',
      );
      expect(projected.kind, 'paragraph');
      expect(projected.anchor, 'one.xhtml#semantic-start');
    },
  );

  test('canonical tree preserves readable EPUB semantics', () async {
    final publication = await parser.parse(
      epubFixtureBytes(canonicalSemantics: true, semanticContent: true),
    );
    final canonical = publication.canonical!;
    final first = canonical.readingOrder.first;
    final nodes = first.nodes.expand(_canonicalDescendants).toList();
    CanonicalNode byId(String id) =>
        nodes.singleWhere((node) => node.elementId == id);

    expect(byId('main-content').kind, 'main');
    expect(byId('article').epubTypes, ['chapter']);
    expect(byId('main-content').role, 'main');
    expect(byId('semantic-section').language, 'en');
    expect(byId('semantic-section').textDirection, 'ltr');
    expect(byId('readable-container').language, 'en');
    expect(byId('french').language, 'fr');
    expect(byId('sample-code').logicalText, 'line one\n  line two let x = 1;');
    expect(byId('code-token').kind, 'code');
    expect(byId('data-table').kind, 'table');
    expect(byId('year-header').kind, 'th');
    expect(byId('ruby-word').kind, 'ruby');
    expect(byId('power').kind, 'sup');
    expect(byId('water-index').kind, 'sub');
    expect(byId('line-break').kind, 'br');
    expect(byId('divider').kind, 'hr');
    expect(byId('backlink').href, '#inline-semantics');
    expect(byId('footnote-body').role, 'doc-footnote');
    expect(
      byId('semantic-image').attributes,
      containsPair('alt', 'Semantic green dot'),
    );
    expect(
      nodes.map((node) => node.elementId),
      isNot(contains('excluded-script')),
    );
    expect(
      nodes.map((node) => node.logicalText).join(),
      isNot(contains('never readable')),
    );

    final drawing = canonical.readingOrder.singleWhere(
      (item) => item.resourceHref == 'drawing.svg',
    );
    final svgNodes = drawing.nodes.expand(_canonicalDescendants).toList();
    expect(drawing.mediaType, 'image/svg+xml');
    expect(drawing.layout, 'pre-paginated');
    expect(svgNodes.map((node) => node.elementId), contains('drawing-title'));
    expect(
      svgNodes.map((node) => node.logicalText).join(),
      contains('SVG label'),
    );
    expect(
      svgNodes.map((node) => node.logicalText).join(),
      isNot(contains('excluded svg script')),
    );
  });
}

Iterable<CanonicalNode> _canonicalDescendants(CanonicalNode node) sync* {
  yield node;
  for (final child in node.children) {
    yield* _canonicalDescendants(child);
  }
}
