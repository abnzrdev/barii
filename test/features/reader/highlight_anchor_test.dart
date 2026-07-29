import 'package:bookbites/features/reader/domain/highlight_anchor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('restores the same repeated phrase using surrounding context', () {
    const content = 'First calm phrase. Then calm phrase ends.';
    final start = content.lastIndexOf('calm phrase');
    final anchor = HighlightAnchor.fromSelection(
      content,
      start,
      start + 'calm phrase'.length,
    );

    final resolved = anchor.resolve(
      'Intro. First calm phrase. Then calm phrase ends.',
    );

    expect(resolved?.start, 31);
    expect(resolved?.end, 42);
  });

  test('returns null when selected text no longer exists', () {
    const anchor = HighlightAnchor(
      start: 2,
      end: 6,
      text: 'gone',
      prefix: '',
      suffix: '',
    );

    expect(anchor.resolve('completely different'), isNull);
  });

  test('does not guess between identical occurrences without context', () {
    const anchor = HighlightAnchor(
      start: 99,
      end: 103,
      text: 'same',
      prefix: '',
      suffix: '',
    );

    expect(anchor.resolve('same and same'), isNull);
  });
}
