import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/barii_theme.dart';
import '../../../core/database/app_database.dart';
import '../../dictionary/data/sqlite_dictionary_repository.dart';
import '../../dictionary/presentation/dictionary_settings_screen.dart';
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
  late final DictionaryPackService _dictionaryPacks = DictionaryPackService(
    database: widget.database,
    storageDirectory: Directory('${widget.storageDirectory.path}/dictionaries'),
  );
  late final SqliteDictionaryRepository _dictionary =
      SqliteDictionaryRepository(widget.database);
  late final BookImportService _imports = BookImportService(
    database: widget.database,
    storageDirectory: widget.storageDirectory,
  );
  late Future<List<Book>> _books;
  var _busy = false;

  @override
  void initState() {
    super.initState();
    _books = _reload();
  }

  Future<List<Book>> _reload() async {
    await _imports.refreshStaleEpubs();
    return widget.database.allBooks();
  }

  Future<void> _import() async {
    const types = XTypeGroup(
      label: 'Books',
      extensions: ['epub', 'txt'],
      mimeTypes: ['application/epub+zip', 'text/plain'],
    );
    final result = await openFile(acceptedTypeGroups: [types]);
    final selected = result?.path;
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
      _books = _reload();
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
      setState(() => _books = _reload());
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
      setState(() => _books = _reload());
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Row(
        children: [_BariiMark(size: 22), SizedBox(width: 10), Text('Barii')],
      ),
      actions: [
        IconButton(
          tooltip: 'Offline dictionaries',
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => DictionarySettingsScreen(
                database: widget.database,
                packs: _dictionaryPacks,
              ),
            ),
          ),
          icon: const Icon(Icons.book_outlined),
        ),
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
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48),
                  const SizedBox(height: 16),
                  const Text(
                    'Your library could not be loaded.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => setState(() => _books = _reload()),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }
        final books = snapshot.data;
        if (books == null || _busy) {
          return const Center(child: CircularProgressIndicator());
        }
        if (books.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _BariiMark(size: 72),
                const SizedBox(height: 16),
                Text(
                  'YOUR SHELF',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    letterSpacing: 3.2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
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
            final columns = (constraints.maxWidth / 132).floor().clamp(2, 6);
            return GridView.builder(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 88),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                childAspectRatio: 0.56,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return _ShelfCard(
                  book: book,
                  onOpen: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => ReaderScreen(
                        database: widget.database,
                        book: book,
                        themeMode: widget.themeMode,
                        onThemeChanged: widget.onThemeChanged,
                        dictionaryRepository: _dictionary,
                      ),
                    ),
                  ),
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
                              dictionaryRepository: _dictionary,
                            ),
                          ),
                        );
                      case 'vocabulary':
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => VocabularyScreen(
                              database: widget.database,
                              book: book,
                              dictionaryRepository: _dictionary,
                            ),
                          ),
                        );
                      case 'delete':
                        _delete(book);
                    }
                  },
                );
              },
            );
          },
        );
      },
    ),
  );
}

class _ShelfCard extends StatelessWidget {
  const _ShelfCard({
    required this.book,
    required this.onOpen,
    required this.onSelected,
  });

  final Book book;
  final VoidCallback onOpen;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final cover = book.cover;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: scheme.onSurface.withValues(alpha: 0.14),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onOpen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (cover != null && cover.isNotEmpty)
                      Image.memory(
                        cover,
                        fit: BoxFit.cover,
                        gaplessPlayback: true,
                        semanticLabel: book.title,
                        errorBuilder: (_, _, _) => _CoverFace(book: book),
                      )
                    else
                      _CoverFace(book: book),
                    Positioned(
                      top: 2,
                      right: 2,
                      child: PopupMenuButton<String>(
                        tooltip: 'Book actions',
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.more_vert, size: 18),
                        style: IconButton.styleFrom(
                          backgroundColor: scheme.surface.withValues(
                            alpha: 0.9,
                          ),
                          foregroundColor: scheme.onSurface,
                          minimumSize: const Size(28, 28),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onSelected: onSelected,
                        itemBuilder: (_) => const [
                          PopupMenuItem(value: 'rename', child: Text('Rename')),
                          PopupMenuItem(
                            value: 'notes',
                            child: Text('Notebook'),
                          ),
                          PopupMenuItem(
                            value: 'vocabulary',
                            child: Text('Vocabulary'),
                          ),
                          PopupMenuItem(value: 'delete', child: Text('Delete')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Text(
                      book.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BariiMark extends StatelessWidget {
  const _BariiMark({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return CustomPaint(
      size: Size.square(size),
      painter: _BariiMarkPainter(
        ink: scheme.onSurface,
        paper: scheme.surface,
        sage: BariiTheme.accent,
      ),
    );
  }
}

class _BariiMarkPainter extends CustomPainter {
  const _BariiMarkPainter({
    required this.ink,
    required this.paper,
    required this.sage,
  });

  final Color ink;
  final Color paper;
  final Color sage;

  @override
  void paint(Canvas canvas, Size size) {
    final book = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.08,
        size.height * 0.12,
        size.width * 0.84,
        size.height * 0.76,
      ),
      Radius.circular(size.width * 0.08),
    );
    canvas.drawRRect(book, Paint()..color = ink);
    final page = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.16,
        size.height * 0.2,
        size.width * 0.68,
        size.height * 0.6,
      ),
      Radius.circular(size.width * 0.05),
    );
    canvas.drawRRect(page, Paint()..color = paper);
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.47,
        size.height * 0.2,
        size.width * 0.06,
        size.height * 0.6,
      ),
      Paint()..color = ink,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.56,
        size.height * 0.2,
        size.width * 0.08,
        size.height * 0.28,
      ),
      Paint()..color = sage,
    );
  }

  @override
  bool shouldRepaint(covariant _BariiMarkPainter oldDelegate) =>
      oldDelegate.ink != ink ||
      oldDelegate.paper != paper ||
      oldDelegate.sage != sage;
}

class _CoverFace extends StatelessWidget {
  const _CoverFace({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ColoredBox(
      color: scheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 16, 10, 10),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            book.title,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
      ),
    );
  }
}
