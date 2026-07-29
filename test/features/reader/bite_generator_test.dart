import 'package:bookbites/features/reader/domain/bite_generator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const generator = BiteGenerator(targetWords: 6, maxWords: 10);

  test('keeps sentence boundaries while grouping paragraphs', () {
    final bites = generator.generate(
      bookFingerprint: 'book',
      sections: const [
        SourceSection(
          index: 0,
          heading: 'Start',
          paragraphs: [
            'One two three. Four five six.',
            'Seven eight nine. Ten eleven twelve.',
          ],
        ),
      ],
    );

    expect(bites.map((bite) => bite.text), [
      'Start\n\nOne two three. Four five six.',
      'Seven eight nine. Ten eleven twelve.',
    ]);
  });

  test('splits a very long paragraph only after sentences', () {
    final bites = generator.generate(
      bookFingerprint: 'book',
      sections: const [
        SourceSection(
          index: 0,
          paragraphs: [
            'One two three four. Five six seven eight. Nine ten eleven twelve.',
          ],
        ),
      ],
    );

    expect(bites.map((bite) => bite.text), [
      'One two three four. Five six seven eight.',
      'Nine ten eleven twelve.',
    ]);
  });

  test('preserves multilingual Unicode and apostrophes', () {
    final bite = generator
        .generate(
          bookFingerprint: 'книга',
          sections: const [
            SourceSection(
              index: 0,
              heading: 'Глава',
              paragraphs: ['Привет, мир. 你好，世界。 L’été arrive.'],
            ),
          ],
        )
        .single;

    expect(bite.text, 'Глава\n\nПривет, мир. 你好，世界。 L’été arrive.');
  });

  test('unchanged source produces stable IDs and offsets affect IDs', () {
    const sections = [
      SourceSection(index: 0, paragraphs: ['First sentence. Second sentence.']),
    ];
    final first = generator.generate(
      bookFingerprint: 'abc',
      sections: sections,
    );
    final second = generator.generate(
      bookFingerprint: 'abc',
      sections: sections,
    );
    final changed = generator.generate(
      bookFingerprint: 'abc',
      sections: const [
        SourceSection(
          index: 1,
          paragraphs: ['First sentence. Second sentence.'],
        ),
      ],
    );

    expect(first.map((bite) => bite.id), second.map((bite) => bite.id));
    expect(first.single.id, isNot(changed.single.id));
  });

  test('ignores empty sections and whitespace', () {
    expect(
      generator.generate(
        bookFingerprint: 'abc',
        sections: const [
          SourceSection(index: 0, heading: ' ', paragraphs: ['', ' \n ']),
        ],
      ),
      isEmpty,
    );
  });

  test('positions remain unique across chapters', () {
    final bites = generator.generate(
      bookFingerprint: 'abc',
      sections: const [
        SourceSection(index: 0, paragraphs: ['First chapter sentence.']),
        SourceSection(index: 1, paragraphs: ['Second chapter sentence.']),
      ],
    );

    expect(bites.map((bite) => bite.position), [0, 1]);
  });

  test('chapter-opening bites include heading and keep stable IDs', () {
    const sections = [
      SourceSection(
        index: 4,
        heading: 'A Calm Beginning',
        paragraphs: ['Opening sentence. More opening text.'],
      ),
    ];

    final first = generator.generate(
      bookFingerprint: 'chapter-book',
      sections: sections,
    );
    final regenerated = generator.generate(
      bookFingerprint: 'chapter-book',
      sections: sections,
    );

    expect(
      first.single.text,
      'A Calm Beginning\n\nOpening sentence. More opening text.',
    );
    expect(regenerated.single.id, first.single.id);
  });
}
