String normalizeWord(String value) {
  final runes = value.trim().runes.toList();
  var start = 0;
  var end = runes.length;
  while (start < end && !_isWordRune(runes[start])) {
    start++;
  }
  while (end > start && !_isWordRune(runes[end - 1])) {
    end--;
  }
  return String.fromCharCodes(
    runes.sublist(start, end),
  ).replaceAll('\u2019', "'").replaceAll(RegExp(r'\s+'), ' ').toLowerCase();
}

List<String> lookupCandidates(String value, {String language = 'en'}) {
  final normalized = normalizeWord(value);
  if (normalized.isEmpty) return const [];
  final candidates = <String>{normalized};
  if (language == 'en') {
    const irregular = {
      'gave': 'give',
      'given': 'give',
      'went': 'go',
      'gone': 'go',
      'was': 'be',
      'were': 'be',
      'been': 'be',
      'am': 'be',
      'is': 'be',
      'are': 'be',
      'did': 'do',
      'done': 'do',
      'had': 'have',
      'has': 'have',
      'made': 'make',
      'took': 'take',
      'taken': 'take',
      'saw': 'see',
      'seen': 'see',
      'thought': 'think',
      'bought': 'buy',
      'brought': 'bring',
      'felt': 'feel',
      'found': 'find',
      'knew': 'know',
      'known': 'know',
      'said': 'say',
      'told': 'tell',
      'children': 'child',
      'men': 'man',
      'women': 'woman',
      'feet': 'foot',
      'teeth': 'tooth',
      'mice': 'mouse',
      'better': 'good',
      'best': 'good',
    };
    if (irregular[normalized] case final String lemma) candidates.add(lemma);
    if (normalized.endsWith("'s") && normalized.length > 2) {
      candidates.add(normalized.substring(0, normalized.length - 2));
    } else if (normalized.endsWith('ies') && normalized.length > 3) {
      candidates.add('${normalized.substring(0, normalized.length - 3)}y');
    } else if (normalized.endsWith('es') && normalized.length > 2) {
      candidates.add(normalized.substring(0, normalized.length - 2));
    } else if (normalized.endsWith('s') && normalized.length > 1) {
      candidates.add(normalized.substring(0, normalized.length - 1));
    }
    if (normalized.endsWith('ing') && normalized.length > 4) {
      final stem = normalized.substring(0, normalized.length - 3);
      candidates.addAll([stem, '${stem}e']);
      if (stem.length > 2 && stem[stem.length - 1] == stem[stem.length - 2]) {
        candidates.add(stem.substring(0, stem.length - 1));
      }
    }
    if (normalized.endsWith('ed') && normalized.length > 3) {
      final stem = normalized.substring(0, normalized.length - 2);
      candidates.addAll([stem, '${stem}e']);
      if (stem.endsWith('i')) {
        candidates.add('${stem.substring(0, stem.length - 1)}y');
      }
      if (stem.length > 2 && stem[stem.length - 1] == stem[stem.length - 2]) {
        candidates.add(stem.substring(0, stem.length - 1));
      }
    }
  }
  return candidates.toList();
}

/// Only dictionary-attested phrases can win; suffix candidates are not definitions.
List<String> contextualCandidates(String word, String context, int? offset) {
  final result = <String>{};
  final selected = normalizeWord(word);
  if (selected.contains(' ')) result.addAll(_phraseForms(selected));
  final tokens = RegExp(
    r"[A-Za-z]+(?:['’-][A-Za-z]+)*",
  ).allMatches(context).toList();
  final position = offset ?? context.toLowerCase().indexOf(selected);
  final target = tokens.indexWhere(
    (token) => token.start <= position && token.end > position,
  );
  if (target >= 0) {
    for (var length = 4; length >= 2; length--) {
      for (
        var start = (target - length + 1).clamp(0, tokens.length);
        start <= target;
        start++
      ) {
        final end = start + length;
        if (end > tokens.length) continue;
        final phrase = context.substring(
          tokens[start].start,
          tokens[end - 1].end,
        );
        if (!RegExp(r'[.!?;:,\n]').hasMatch(phrase)) {
          result.addAll(_phraseForms(phrase));
        }
      }
    }
  }
  result.addAll(lookupCandidates(word));
  return result.take(80).toList();
}

Iterable<String> _phraseForms(String value) sync* {
  final parts = normalizeWord(value).split(' ');
  yield parts.join(' ');
  if (parts.length > 1) {
    for (final lemma in lookupCandidates(parts.first).skip(1)) {
      yield [lemma, ...parts.skip(1)].join(' ');
    }
  }
}

Set<String> meaningTokens(String value) {
  const stop = {
    'the',
    'and',
    'for',
    'that',
    'this',
    'with',
    'from',
    'into',
    'have',
    'has',
    'was',
    'were',
    'are',
    'not',
    'but',
    'you',
    'your',
    'its',
    'they',
    'their',
    'which',
    'when',
    'where',
    'what',
    'who',
    'can',
    'will',
    'would',
    'could',
    'should',
    'one',
    'some',
    'something',
    'someone',
    'about',
    'than',
    'then',
  };
  return RegExp(r'[a-z]{3,}')
      .allMatches(value.toLowerCase())
      .map((m) => m.group(0)!)
      .where((token) => !stop.contains(token))
      .map(
        (token) =>
            token.endsWith('s') ? token.substring(0, token.length - 1) : token,
      )
      .toSet();
}

String sourceSentenceFor(String content, String selectedText) {
  final selection = selectedText.trim();
  var offset = selection.isEmpty ? -1 : content.indexOf(selection);
  if (offset < 0) {
    offset = content.toLowerCase().indexOf(selection.toLowerCase());
  }
  if (offset < 0) return content.trim();
  const boundaries = '.!?\n。！？';
  var start = offset;
  while (start > 0 && !boundaries.contains(content[start - 1])) {
    start--;
  }
  var end = offset + selection.length;
  while (end < content.length && !boundaries.contains(content[end])) {
    end++;
  }
  if (end < content.length && content[end] != '\n') end++;
  return content.substring(start, end).trim();
}

bool _isWordRune(int rune) {
  if (rune == 0x27 || rune == 0x2019) return true;
  if (rune >= 0x30 && rune <= 0x39) return true;
  if (rune >= 0x41 && rune <= 0x5a || rune >= 0x61 && rune <= 0x7a) {
    return true;
  }
  if (rune <= 0x7f) return false;
  return !(rune >= 0x2000 && rune <= 0x206f) &&
      !(rune >= 0x3000 && rune <= 0x303f) &&
      !(rune >= 0xff00 && rune <= 0xff65);
}
