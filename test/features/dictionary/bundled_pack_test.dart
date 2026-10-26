import 'dart:io';

import 'package:barii/core/database/app_database.dart';
import 'package:barii/features/dictionary/data/bundled_dictionary_pack.dart';
import 'package:barii/features/dictionary/data/sqlite_dictionary_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'production pack installs offline, covers reading vocabulary and retains senses',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'barii-bundled-pack-',
      );
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(() async {
        await database.close();
        await directory.delete(recursive: true);
      });
      await ensureBundledDictionary(database, directory);
      final sources = await database.allDictionarySources();
      expect(sources, hasLength(1));
      expect(sources.single.format, 'barii-bundled-v1');
      expect(sources.single.sizeBytes, lessThan(100 * 1024 * 1024));
      await ensureBundledDictionary(database, directory);
      expect(await database.allDictionarySources(), hasLength(1));
      final repository = SqliteDictionaryRepository(database);
      final timings = <int>[];
      for (final word in [
        'accuracy',
        'classification',
        'precision',
        'recall',
        'sensitivity',
        'specificity',
        'evaluating',
        'running',
        'gave',
        'children',
        'ephemeral',
        'ubiquitous',
        'serendipity',
        'lantern',
        'book',
        'bank',
        'give up',
        'look after',
      ]) {
        final watch = Stopwatch()..start();
        final entry = await repository.lookupEntry(word);
        timings.add(watch.elapsedMilliseconds);
        expect(entry, isNotNull, reason: word);
        expect(entry!.definition, isNotEmpty, reason: word);
        expect(entry.senses, isNotEmpty, reason: word);
      }
      final river = await repository.lookupEntry(
        'bank',
        context: 'He sat on the bank of the river beside his canoe.',
        contextOffset: 14,
      );
      expect(
        '${river!.definition} ${river.senses.first.examples.join(' ')}'
            .toLowerCase(),
        anyOf(contains('river'), contains('water')),
      );
      expect(river.senses.length, greaterThan(3));
      final phrase = await repository.lookupEntry(
        'gave',
        context: 'She gave up trying.',
        contextOffset: 4,
      );
      expect(phrase?.word, 'give up');
      expect(
        (await repository.lookupEntry(
          'precision',
        ))?.senses.any((s) => s.synonyms.isNotEmpty),
        isTrue,
      );
      expect(await repository.lookupEntry('zzxxunlistedexampleword'), isNull);
      timings.sort();
      // A generous CI ceiling, with the measured distribution printed for review.
      expect(
        timings[(timings.length * .95).floor().clamp(0, timings.length - 1)],
        lessThan(500),
      );
      final watch = Stopwatch()..start();
      await repository.lookupEntry('precision');
      expect(watch.elapsedMilliseconds, lessThan(100));
      // ignore: avoid_print
      print(
        'Dictionary cold lookup milliseconds: $timings; warm=${watch.elapsedMilliseconds}',
      );
    },
  );
}
