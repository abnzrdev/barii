import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import 'app/bookbites_app.dart';
import 'core/database/app_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final documents = await getApplicationDocumentsDirectory();
  final storage = Directory('${documents.path}/books');
  final database = AppDatabase();
  await database.ensurePreferences();
  await database.allBooks();

  runApp(
    ProviderScope(
      child: BookBitesApp(database: database, storageDirectory: storage),
    ),
  );
}
