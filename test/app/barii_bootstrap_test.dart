import 'dart:async';
import 'dart:io';

import 'package:barii/app/barii_bootstrap.dart';
import 'package:barii/core/database/app_database.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders startup loading before initialization completes', (
    tester,
  ) async {
    final pending = Completer<BariiStartup>();

    await tester.pumpWidget(BariiBootstrap(initializer: () => pending.future));

    expect(find.text('Opening your library…'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/bootstrap_loading.png'),
    );

    pending.completeError(StateError('test cleanup'));
    await tester.pump();
  });

  testWidgets('renders the app after successful initialization', (
    tester,
  ) async {
    late Directory storage;
    late AppDatabase database;
    await tester.runAsync(() async {
      storage = await Directory.systemTemp.createTemp('barii-bootstrap-');
      database = AppDatabase.forTesting(NativeDatabase.memory());
      await database.ensurePreferences();
    });
    addTearDown(() async {
      await database.close();
      await storage.delete(recursive: true);
    });

    await tester.pumpWidget(
      BariiBootstrap(
        initializer: () async =>
            BariiStartup(database: database, storageDirectory: storage),
      ),
    );
    await _pumpUntil(tester, find.text('Your library is empty'));

    expect(find.text('Your library is empty'), findsOneWidget);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/bootstrap_success.png'),
    );
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('startup failure exposes diagnostics and retries safely', (
    tester,
  ) async {
    String? copiedDiagnostics;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copiedDiagnostics = (call.arguments as Map)['text'] as String?;
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    late Directory storage;
    late AppDatabase database;
    await tester.runAsync(() async {
      storage = await Directory.systemTemp.createTemp('barii-retry-');
      database = AppDatabase.forTesting(NativeDatabase.memory());
      await database.ensurePreferences();
    });
    addTearDown(() async {
      await database.close();
      await storage.delete(recursive: true);
    });
    var attempts = 0;

    await tester.pumpWidget(
      BariiBootstrap(
        initializer: () async {
          attempts++;
          if (attempts == 1) {
            throw StateError('/private/library/path must not be shown');
          }
          return BariiStartup(database: database, storageDirectory: storage);
        },
      ),
    );
    await _pumpUntil(tester, find.text('Barii could not open your library.'));

    expect(find.text('Barii could not open your library.'), findsOneWidget);
    expect(find.textContaining('/private/library/path'), findsNothing);
    expect(find.textContaining('StateError'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Retry'), findsOneWidget);
    expect(
      find.widgetWithText(OutlinedButton, 'Copy diagnostics'),
      findsOneWidget,
    );
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/bootstrap_failure.png'),
    );

    await tester.tap(find.widgetWithText(OutlinedButton, 'Copy diagnostics'));
    await tester.pump();
    expect(copiedDiagnostics, contains('StateError'));

    await tester.tap(find.widgetWithText(FilledButton, 'Retry'));
    await _pumpUntil(tester, find.text('Your library is empty'));

    expect(attempts, 2);
    expect(find.text('Your library is empty'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}

Future<void> _pumpUntil(WidgetTester tester, Finder target) async {
  for (var attempt = 0; attempt < 40; attempt++) {
    await tester.pump(const Duration(milliseconds: 50));
    if (target.evaluate().isNotEmpty) return;
  }
}
