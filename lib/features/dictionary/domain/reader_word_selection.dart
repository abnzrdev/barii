/// A quotation, independent of display pages and dictionary data.
class ReaderWordSelection {
  const ReaderWordSelection({
    required this.word,
    required this.context,
    required this.contextOffset,
    this.biteId,
    this.startOffset,
    this.endOffset,
    this.canonicalLocator,
  });
  final String word;
  final String context;
  final int contextOffset;
  final String? biteId;
  final int? startOffset;
  final int? endOffset;
  final String? canonicalLocator;
}
