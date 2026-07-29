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
  return String.fromCharCodes(runes.sublist(start, end)).toLowerCase();
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
