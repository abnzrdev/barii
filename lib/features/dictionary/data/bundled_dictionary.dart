import '../domain/dictionary_repository.dart';
import '../domain/word_normalizer.dart';

class BundledDictionary implements DictionaryRepository {
  const BundledDictionary();

  static const _definitions = {
    'book': 'A written or printed work consisting of pages.',
    'bite': 'A small, manageable portion of something.',
    'chapter': 'A main division of a book.',
    'lantern': 'A portable light protected by a transparent case.',
    'read': 'To look at and understand written words.',
    'sentence': 'A set of words expressing a complete statement.',
    'word': 'A single distinct element of speech or writing.',
  };

  @override
  Future<String?> lookup(String word) async =>
      _definitions[normalizeWord(word)];
}
