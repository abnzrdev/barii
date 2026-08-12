import 'dart:io';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import 'app/barii_app.dart';
import 'core/database/app_database.dart';

Future<void> main() async {
  final startup = TimelineTask()..start('App.startup');
  WidgetsFlutterBinding.ensureInitialized();
  final documents = await getApplicationDocumentsDirectory();
  final storage = Directory('${documents.path}/books');
  final database = AppDatabase();
  await database.ensurePreferences();
  await database.allBooks();
  startup.finish();

  runApp(
    ProviderScope(
      child: BariiApp(database: database, storageDirectory: storage),
    ),
  );
}
