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
  ).replaceAll('\u2019', "'").toLowerCase();
}

List<String> lookupCandidates(String value, {String language = 'en'}) {
  final normalized = normalizeWord(value);
  if (normalized.isEmpty) return const [];
  final candidates = <String>{normalized};
  if (language == 'en') {
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
      candidates.add(normalized.substring(0, normalized.length - 3));
    }
    if (normalized.endsWith('ed') && normalized.length > 3) {
      candidates.add(normalized.substring(0, normalized.length - 2));
    }
  }
  return candidates.toList();
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
