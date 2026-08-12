import 'dart:io';

import 'package:barii/core/database/app_database.dart';
import 'package:barii/features/library/presentation/library_screen.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late Directory storage;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    await database.ensurePreferences();
    await database.allBooks();
    storage = await Directory.systemTemp.createTemp('barii-ui-');
  });

  tearDown(() async {
    await database.close();
    await storage.delete(recursive: true);
  });

  testWidgets('shows an accessible empty library and import actions', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LibraryScreen(database: database, storageDirectory: storage),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Your library is empty'), findsOneWidget);
    expect(find.byTooltip('Import EPUB or TXT'), findsWidgets);
    expect(find.text('Add sample book'), findsOneWidget);
  });
}
