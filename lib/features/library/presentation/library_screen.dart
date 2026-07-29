import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/database/app_database.dart';
import '../../dictionary/presentation/vocabulary_screen.dart';
import '../../notes/presentation/notebook_screen.dart';
import '../../reader/presentation/reader_screen.dart';
import '../data/book_import_service.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({
    super.key,
    required this.database,
    required this.storageDirectory,
    this.themeMode = ThemeMode.system,
    this.onThemeChanged,
  });

  final AppDatabase database;
  final Directory storageDirectory;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode>? onThemeChanged;

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late final BookImportService _imports = BookImportService(
    database: widget.database,
    storageDirectory: widget.storageDirectory,
  );
  late Future<List<Book>> _books = widget.database.allBooks();
  var _busy = false;

  Future<void> _import() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['epub', 'txt'],
    );
    final selected = result?.files.single.path;
    if (selected != null) await _runImport(selected);
  }

  Future<void> _sample() async {
    final source = File('${widget.storageDirectory.path}/sample-source.txt');
    await source.parent.create(recursive: true);
    await source.writeAsString(
      await rootBundle.loadString('assets/sample_book.txt'),
    );
    try {
      await _runImport(source.path);
    } finally {
      if (await source.exists()) await source.delete();
    }
  }

  Future<void> _runImport(String path) async {
    setState(() => _busy = true);
    try {
      await _imports.importFile(path);
      _books = widget.database.allBooks();
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

  Future<void> _rename(Book book) async {
    final controller = TextEditingController(text: book.title);
    final title = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename book'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Title'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Rename'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (title != null && title.isNotEmpty) {
      await widget.database.renameBook(book.id, title);
      setState(() => _books = widget.database.allBooks());
    }
  }

  Future<void> _delete(Book book) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete book?'),
        content: Text(
          'Delete “${book.title}”, its progress, notes, and vocabulary?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _imports.deleteBook(book);
      setState(() => _books = widget.database.allBooks());
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('BookBites'),
      actions: [
        if (widget.onThemeChanged != null)
          PopupMenuButton<ThemeMode>(
            tooltip: 'Theme',
            initialValue: widget.themeMode,
            icon: const Icon(Icons.brightness_6_outlined),
            onSelected: widget.onThemeChanged,
            itemBuilder: (_) => const [
              PopupMenuItem(value: ThemeMode.system, child: Text('System')),
              PopupMenuItem(value: ThemeMode.light, child: Text('Light')),
              PopupMenuItem(value: ThemeMode.dark, child: Text('Dark')),
            ],
          ),
        IconButton(
          tooltip: 'Import EPUB or TXT',
          onPressed: _busy ? null : _import,
          icon: const Icon(Icons.file_open),
        ),
      ],
    ),
    floatingActionButton: FloatingActionButton.extended(
      tooltip: 'Import EPUB or TXT',
      onPressed: _busy ? null : _import,
      icon: const Icon(Icons.add),
      label: const Text('Import'),
    ),
    body: FutureBuilder<List<Book>>(
      future: _books,
      builder: (context, snapshot) {
        final books = snapshot.data;
        if (books == null || _busy) {
          return const Center(child: CircularProgressIndicator());
        }
        if (books.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.auto_stories_outlined, size: 64),
                const SizedBox(height: 16),
                Text(
                  'Your library is empty',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                const Text('Import a DRM-free EPUB or TXT book.'),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  onPressed: _sample,
                  icon: const Icon(Icons.book_outlined),
                  label: const Text('Add sample book'),
                ),
              ],
            ),
          );
        }
        return LayoutBuilder(
          builder: (context, constraints) {
            final columns = (constraints.maxWidth / 260).floor().clamp(1, 5);
            return GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                childAspectRatio: 1.35,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            ReaderScreen(database: widget.database, book: book),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.menu_book),
                              const Spacer(),
                              PopupMenuButton<String>(
                                tooltip: 'Book actions',
                                onSelected: (action) {
                                  switch (action) {
                                    case 'rename':
                                      _rename(book);
                                    case 'notes':
                                      Navigator.of(context).push(
                                        MaterialPageRoute<void>(
                                          builder: (_) => NotebookScreen(
                                            database: widget.database,
                                            book: book,
                                          ),
                                        ),
                                      );
                                    case 'vocabulary':
                                      Navigator.of(context).push(
                                        MaterialPageRoute<void>(
                                          builder: (_) => VocabularyScreen(
                                            database: widget.database,
                                            book: book,
                                          ),
                                        ),
                                      );
                                    case 'delete':
                                      _delete(book);
                                  }
                                },
                                itemBuilder: (_) => const [
                                  PopupMenuItem(
                                    value: 'rename',
                                    child: Text('Rename'),
                                  ),
                                  PopupMenuItem(
                                    value: 'notes',
                                    child: Text('Notebook'),
                                  ),
                                  PopupMenuItem(
                                    value: 'vocabulary',
                                    child: Text('Vocabulary'),
                                  ),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Text('Delete'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            book.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            book.author,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    ),
  );
}
