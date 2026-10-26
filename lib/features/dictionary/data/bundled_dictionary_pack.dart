import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';

import '../../../core/database/app_database.dart';
import 'sqlite_dictionary_repository.dart';

/// Installs a release-built asset. This code has no network dependency.
Future<void> ensureBundledDictionary(
  AppDatabase database,
  Directory directory,
) async {
  final manifest =
      jsonDecode(await rootBundle.loadString('assets/dictionary/manifest.json'))
          as Map<String, dynamic>;
  final hash = manifest['database_sha256'] as String;
  final installed = await database.dictionarySourceByHash(hash);
  if (installed != null &&
      await File(installed.filePath).exists() &&
      await File(installed.filePath).length() == manifest['installed_bytes']) {
    return;
  }
  final bytes = await rootBundle.load('assets/dictionary/english.sqlite.gz');
  await directory.create(recursive: true);
  final temporary = File('${directory.path}/bundled.installing');
  try {
    await Isolate.run(
      () => _unpack(
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes),
        temporary.path,
        manifest['asset_sha256'] as String,
        hash,
      ),
    );
    // A registered pack may have been removed or damaged outside the app.
    if (installed != null) await database.deleteDictionarySource(installed.id);
    await DictionaryPackService(
      database: database,
      storageDirectory: directory,
    ).import(temporary, bundled: true);
  } finally {
    if (await temporary.exists()) await temporary.delete();
  }
}

Future<void> _unpack(
  Uint8List bytes,
  String destination,
  String compressedHash,
  String expectedHash,
) async {
  if (sha256.convert(bytes).toString() != compressedHash) {
    throw const FormatException('Bundled dictionary checksum failed');
  }
  await Stream<List<int>>.value(
    bytes,
  ).transform(gzip.decoder).pipe(File(destination).openWrite());
  if ((await sha256.bind(File(destination).openRead()).first).toString() !=
      expectedHash) {
    throw const FormatException('Bundled dictionary is damaged');
  }
}
