abstract interface class DictionaryRepository {
  Future<String?> lookup(String word);
}
