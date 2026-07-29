class HighlightAnchor {
  const HighlightAnchor({
    required this.start,
    required this.end,
    required this.text,
    required this.prefix,
    required this.suffix,
  });

  final int start;
  final int end;
  final String text;
  final String prefix;
  final String suffix;

  static HighlightAnchor fromSelection(
    String content,
    int start,
    int end, {
    int contextLength = 24,
  }) {
    final safeStart = start.clamp(0, content.length);
    final safeEnd = end.clamp(safeStart, content.length);
    return HighlightAnchor(
      start: safeStart,
      end: safeEnd,
      text: content.substring(safeStart, safeEnd),
      prefix: content.substring(
        (safeStart - contextLength).clamp(0, safeStart),
        safeStart,
      ),
      suffix: content.substring(
        safeEnd,
        (safeEnd + contextLength).clamp(safeEnd, content.length),
      ),
    );
  }

  ({int start, int end})? resolve(String content) {
    if (start >= 0 &&
        end <= content.length &&
        start <= end &&
        content.substring(start, end) == text) {
      return (start: start, end: end);
    }
    final matches = <({int start, int end, int score})>[];
    var candidate = content.indexOf(text);
    while (candidate >= 0) {
      final candidateEnd = candidate + text.length;
      var score = 0;
      if (prefix.isNotEmpty &&
          content.substring(0, candidate).endsWith(prefix)) {
        score += 2;
      }
      if (suffix.isNotEmpty &&
          content.substring(candidateEnd).startsWith(suffix)) {
        score += 2;
      }
      matches.add((start: candidate, end: candidateEnd, score: score));
      candidate = content.indexOf(text, candidate + 1);
    }
    if (matches.length == 1) {
      return (start: matches.single.start, end: matches.single.end);
    }
    final bestScore = matches.fold(
      0,
      (best, match) => match.score > best ? match.score : best,
    );
    final best = matches.where((match) => match.score == bestScore).toList();
    return bestScore > 0 && best.length == 1
        ? (start: best.single.start, end: best.single.end)
        : null;
  }
}
