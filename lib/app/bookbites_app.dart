import 'dart:io';

import 'package:flutter/material.dart';

import '../core/database/app_database.dart';
import '../features/library/presentation/library_screen.dart';

class BookBitesApp extends StatefulWidget {
  const BookBitesApp({
    super.key,
    required this.database,
    required this.storageDirectory,
  });

  final AppDatabase database;
  final Directory storageDirectory;

  @override
  State<BookBitesApp> createState() => _BookBitesAppState();
}

class _BookBitesAppState extends State<BookBitesApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final value = (await widget.database.preferences()).theme;
    if (mounted) {
      setState(() {
        _themeMode = switch (value) {
          'light' => ThemeMode.light,
          'dark' => ThemeMode.dark,
          _ => ThemeMode.system,
        };
      });
    }
  }

  Future<void> _setTheme(ThemeMode mode) async {
    setState(() => _themeMode = mode);
    await widget.database.saveTheme(mode.name);
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'BookBites',
    debugShowCheckedModeBanner: false,
    themeMode: _themeMode,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff52634f)),
      useMaterial3: true,
    ),
    darkTheme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xff9cb596),
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    ),
    home: LibraryScreen(
      database: widget.database,
      storageDirectory: widget.storageDirectory,
      themeMode: _themeMode,
      onThemeChanged: _setTheme,
    ),
  );
}
