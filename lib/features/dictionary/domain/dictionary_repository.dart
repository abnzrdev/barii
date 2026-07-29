class DictionaryEntry {
  const DictionaryEntry({
    required this.word,
    required this.definition,
    required this.sourceName,
    this.partOfSpeech,
    this.pronunciation,
    this.attribution,
    this.sourceId,
  });

  final String word;
  final String definition;
  final String sourceName;
  final String? partOfSpeech;
  final String? pronunciation;
  final String? attribution;
  final String? sourceId;
}

abstract interface class DictionaryRepository {
  Future<DictionaryEntry?> lookupEntry(String word);

  Future<List<String>> suggest(String word, {int limit = 8});
}
