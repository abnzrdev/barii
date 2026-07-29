import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

import '../../../core/database/app_database.dart';
import '../data/sqlite_dictionary_repository.dart';

class DictionarySettingsScreen extends StatefulWidget {
  const DictionarySettingsScreen({
    super.key,
    required this.database,
    required this.packs,
  });

  final AppDatabase database;
  final DictionaryPackService packs;

  @override
  State<DictionarySettingsScreen> createState() =>
      _DictionarySettingsScreenState();
}

class _DictionarySettingsScreenState extends State<DictionarySettingsScreen> {
  List<DictionarySource> _sources = const [];
  var _busy = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final sources = await widget.database.allDictionarySources();
    if (mounted) setState(() => _sources = sources);
  }

  Future<void> _import() async {
    final result = await openFile(
      acceptedTypeGroups: const [
        XTypeGroup(
          label: 'Limmud dictionary pack',
          extensions: ['sqlite', 'db'],
        ),
      ],
    );
    if (result == null) return;
    setState(() => _busy = true);
    try {
      await widget.packs.import(File(result.path));
      await _refresh();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString())));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _remove(DictionarySource source) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove dictionary?'),
        content: Text('Remove “${source.name}” from this device?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await widget.packs.remove(source);
    await _refresh();
  }

  Future<void> _reorder(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex--;
    setState(() {
      final source = _sources.removeAt(oldIndex);
      _sources.insert(newIndex, source);
    });
    await widget.database.setDictionaryPriorities(
      _sources.map((source) => source.id).toList(),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Offline dictionaries'),
      actions: [
        IconButton(
          tooltip: 'Import dictionary pack',
          onPressed: _busy ? null : _import,
          icon: const Icon(Icons.file_open),
        ),
      ],
    ),
    body: _busy
        ? const Center(child: CircularProgressIndicator())
        : _sources.isEmpty
        ? const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'The small bundled dictionary is active. Import a validated '
                'Limmud SQLite dictionary pack for broader coverage.',
                textAlign: TextAlign.center,
              ),
            ),
          )
        : ReorderableListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: _sources.length,
            onReorderItem: _reorder,
            itemBuilder: (context, index) {
              final source = _sources[index];
              return Card(
                key: ValueKey(source.id),
                child: ExpansionTile(
                  leading: ReorderableDragStartListener(
                    index: index,
                    child: const Icon(Icons.drag_handle),
                  ),
                  title: Text(source.name),
                  subtitle: Text(source.licenseName),
                  trailing: Switch(
                    value: source.enabled,
                    onChanged: (enabled) async {
                      await widget.database.setDictionaryEnabled(
                        source.id,
                        enabled,
                      );
                      await _refresh();
                    },
                  ),
                  children: [
                    ListTile(
                      title: const Text('Attribution'),
                      subtitle: Text(source.attribution),
                    ),
                    ListTile(
                      title: const Text('Source'),
                      subtitle: Text(source.source),
                    ),
                    ListTile(
                      title: const Text('Stored size'),
                      subtitle: Text(
                        '${(source.sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB',
                      ),
                      trailing: IconButton(
                        tooltip: 'Remove dictionary',
                        onPressed: () => _remove(source),
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: _busy ? null : _import,
      icon: const Icon(Icons.add),
      label: const Text('Import pack'),
    ),
  );
}
