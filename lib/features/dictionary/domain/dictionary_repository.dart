class DictionarySense {
  const DictionarySense({
    required this.id,
    required this.definition,
    required this.sourceName,
    this.partOfSpeech,
    this.examples = const [],
    this.synonyms = const [],
    this.labels = const [],
    this.sourceUrl,
    this.entryId,
  });
  final String id;
  final String definition;
  final String sourceName;
  final String? partOfSpeech;
  final List<String> examples;
  final List<String> synonyms;
  final List<String> labels;
  final String? sourceUrl;
  final String? entryId;
}

class DictionaryEntry {
  const DictionaryEntry({
    required this.word,
    required this.definition,
    required this.sourceName,
    this.partOfSpeech,
    this.pronunciation,
    this.attribution,
    this.sourceId,
    this.entryId,
    this.senses = const [],
  });

  final String word;
  final String definition;
  final String sourceName;
  final String? partOfSpeech;
  final String? pronunciation;
  final String? attribution;
  final String? sourceId;
  final String? entryId;
  final List<DictionarySense> senses;
}

abstract interface class DictionaryRepository {
  Future<DictionaryEntry?> lookupEntry(
    String word, {
    String context = '',
    int? contextOffset,
  });

  Future<List<String>> suggest(String word, {int limit = 8});
}
