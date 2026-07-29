import 'package:bookbites/features/dictionary/domain/word_normalizer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('normalizes case and edge punctuation without losing apostrophes', () {
    expect(normalizeWord('“L’ÉTÉ!”'), "l'été");
    expect(normalizeWord("...don't..."), "don't");
  });

  test('preserves letters from multiple scripts', () {
    expect(normalizeWord('（Привет）'), 'привет');
    expect(normalizeWord('你好！'), '你好');
  });

  test('creates deterministic English candidates without changing Unicode', () {
    expect(lookupCandidates("Reader’s"), ["reader's", 'reader']);
    expect(lookupCandidates('stories'), ['stories', 'story']);
    expect(lookupCandidates('книги'), ['книги']);
  });

  test('extracts the selected source sentence', () {
    expect(
      sourceSentenceFor(
        'Before this. The lantern glows brightly! After.',
        'lantern',
      ),
      'The lantern glows brightly!',
    );
  });
}
