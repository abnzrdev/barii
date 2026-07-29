import 'package:bookbites/features/dictionary/domain/word_normalizer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('normalizes case and edge punctuation without losing apostrophes', () {
    expect(normalizeWord('“L’ÉTÉ!”'), 'l’été');
    expect(normalizeWord("...don't..."), "don't");
  });

  test('preserves letters from multiple scripts', () {
    expect(normalizeWord('（Привет）'), 'привет');
    expect(normalizeWord('你好！'), '你好');
  });
}
