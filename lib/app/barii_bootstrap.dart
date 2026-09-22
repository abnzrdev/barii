import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../core/database/app_database.dart';
import 'barii_app.dart';

class BariiStartup {
  const BariiStartup({required this.database, required this.storageDirectory});

  final AppDatabase database;
  final Directory storageDirectory;
}

typedef BariiInitializer = Future<BariiStartup> Function();

Future<BariiStartup> initializeBarii() async {
  final startup = TimelineTask()..start('App.startup');
  AppDatabase? database;
  try {
    final documents = await getApplicationDocumentsDirectory();
    final storage = Directory('${documents.path}/books');
    database = AppDatabase();
    await database.ensurePreferences();
    await database.allBooks();
    startup.finish();
    return BariiStartup(database: database, storageDirectory: storage);
  } catch (error) {
    startup.finish(arguments: {'error': error.runtimeType.toString()});
    await database?.close();
    rethrow;
  }
}

class BariiBootstrap extends StatefulWidget {
  const BariiBootstrap({super.key, this.initializer = initializeBarii});

  final BariiInitializer initializer;

  @override
  State<BariiBootstrap> createState() => _BariiBootstrapState();
}

class _BariiBootstrapState extends State<BariiBootstrap> {
  BariiStartup? _startup;
  Object? _error;
  var _attempt = 0;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final attempt = ++_attempt;
    setState(() {
      _startup = null;
      _error = null;
    });
    try {
      final startup = await widget.initializer();
      if (!mounted || attempt != _attempt) {
        await startup.database.close();
        return;
      }
      setState(() => _startup = startup);
    } catch (error) {
      if (mounted && attempt == _attempt) setState(() => _error = error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final startup = _startup;
    if (startup != null) {
      return BariiApp(
        database: startup.database,
        storageDirectory: startup.storageDirectory,
      );
    }
    final error = _error;
    return MaterialApp(
      title: 'Barii',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff52634f)),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: error == null
                  ? const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 20),
                        Text('Opening your library…'),
                      ],
                    )
                  : _StartupFailure(
                      diagnostic: 'Startup error: ${error.runtimeType}',
                      onRetry: _initialize,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StartupFailure extends StatelessWidget {
  const _StartupFailure({required this.diagnostic, required this.onRetry});

  final String diagnostic;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Icon(Icons.error_outline, size: 56),
      const SizedBox(height: 16),
      Text(
        'Barii could not open your library.',
        style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 8),
      const Text(
        'Your library has not been deleted or replaced.',
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 12),
      SelectableText(diagnostic, textAlign: TextAlign.center),
      const SizedBox(height: 20),
      FilledButton.icon(
        onPressed: onRetry,
        icon: const Icon(Icons.refresh),
        label: const Text('Retry'),
      ),
      const SizedBox(height: 8),
      OutlinedButton.icon(
        onPressed: () async {
          await Clipboard.setData(ClipboardData(text: diagnostic));
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Diagnostics copied')));
          }
        },
        icon: const Icon(Icons.copy),
        label: const Text('Copy diagnostics'),
      ),
    ],
  );
}
