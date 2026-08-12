import 'package:barii/features/dictionary/data/bundled_dictionary.dart';
import 'package:barii/features/dictionary/domain/dictionary_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final DictionaryRepository repository = BundledDictionary();

  test('looks up normalized bundled words', () async {
    expect(
      (await repository.lookupEntry('Lantern'))?.definition,
      'A portable light protected by a transparent case.',
    );
  });

  test('returns no result for an unknown offline word', () async {
    expect(await repository.lookupEntry('unlistedword'), isNull);
  });
}
