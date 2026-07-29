import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

import '../../../core/database/app_database.dart';
import '../../dictionary/data/bundled_dictionary.dart';
import '../../dictionary/domain/dictionary_repository.dart';
import '../../reader/presentation/reader_screen.dart';

class NotebookScreen extends StatefulWidget {
  const NotebookScreen({
    super.key,
    required this.database,
    required this.book,
    this.dictionaryRepository = const BundledDictionary(),
  });

  final AppDatabase database;
  final Book book;
  final DictionaryRepository dictionaryRepository;

  @override
  State<NotebookScreen> createState() => _NotebookScreenState();
}

class _NotebookScreenState extends State<NotebookScreen> {
  String? _color;
  late Future<_NotebookData> _data = _load();

  Future<_NotebookData> _load() async {
    final highlights = await widget.database.highlightsForBook(widget.book.id);
    return _NotebookData(
      notes: await widget.database.notesForBook(widget.book.id),
      highlights: highlights,
      highlightNotes: {
        for (final highlight in highlights)
          if (highlight.noteId != null)
            highlight.id: await widget.database.highlightNote(
              highlight.noteId!,
            ),
      },
    );
  }

  void _refresh() => setState(() => _data = _load());

  Future<void> _openBite(String biteId) async {
    final bites = await widget.database.bitesForBook(widget.book.id);
    final position = bites.indexWhere((bite) => bite.id == biteId);
    if (position < 0) return;
    await widget.database.saveProgress(widget.book.id, biteId, position);
    if (mounted) {
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => ReaderScreen(
            database: widget.database,
            book: widget.book,
            dictionaryRepository: widget.dictionaryRepository,
          ),
        ),
      );
    }
  }

  Future<void> _editNote(Highlight highlight, HighlightNote? existing) async {
    final controller = TextEditingController(text: existing?.noteText);
    final note = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Highlight note'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: 5,
          decoration: const InputDecoration(hintText: 'Write a note'),
        ),
        actions: [
          if (existing != null)
            TextButton(
              onPressed: () => Navigator.pop(context, ''),
              child: const Text('Delete note'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (note == null) return;
    if (note.isEmpty) {
      if (highlight.noteId != null) {
        await widget.database.deleteHighlightNote(highlight.noteId!);
        await _resaveHighlight(highlight, noteId: null);
      }
    } else {
      final id = highlight.noteId ?? '${highlight.id}-note';
      await widget.database.saveHighlightNote(
        id: id,
        bookId: highlight.bookId,
        biteId: highlight.biteId,
        text: note,
        now: DateTime.now().toUtc(),
      );
      await _resaveHighlight(highlight, noteId: id);
    }
    _refresh();
  }

  Future<void> _resaveHighlight(
    Highlight highlight, {
    required String? noteId,
  }) => widget.database.saveHighlight(
    id: highlight.id,
    bookId: highlight.bookId,
    biteId: highlight.biteId,
    startOffset: highlight.startOffset,
    endOffset: highlight.endOffset,
    selectedText: highlight.selectedText,
    prefixContext: highlight.prefixContext,
    suffixContext: highlight.suffixContext,
    contentChecksum: highlight.contentChecksum,
    style: highlight.style,
    color: highlight.color,
    noteId: noteId,
    resolved: highlight.resolved,
    now: DateTime.now().toUtc(),
  );

  Future<void> _export(_NotebookData data, bool markdown) async {
    final location = await getSaveLocation(
      suggestedName:
          '${widget.book.title}-highlights.${markdown ? 'md' : 'txt'}',
    );
    if (location == null) return;
    final buffer = StringBuffer();
    if (markdown) buffer.writeln('# ${widget.book.title}\n');
    buffer.writeln('Author: ${widget.book.author}\n');
    for (final highlight in data.highlights) {
      final note = data.highlightNotes[highlight.id]?.noteText;
      final chapter = await widget.database.sectionHeadingForBite(
        highlight.biteId,
      );
      if (markdown) {
        buffer.writeln('> ${highlight.selectedText}\n');
        if (note != null) buffer.writeln('$note\n');
        if (chapter != null) buffer.writeln('Chapter: $chapter\n');
        buffer.writeln(
          '_${highlight.style}, ${highlight.color}; '
          'bite `${highlight.biteId}`; ${highlight.createdAt.toLocal()}_\n',
        );
      } else {
        buffer.writeln('"${highlight.selectedText}"');
        if (note != null) buffer.writeln(note);
        if (chapter != null) buffer.writeln('Chapter: $chapter');
        buffer.writeln(
          '${highlight.style}, ${highlight.color}; '
          'bite ${highlight.biteId}; ${highlight.createdAt.toLocal()}\n',
        );
      }
    }
    await File(location.path).writeAsString(buffer.toString());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('${widget.book.title} notebook'),
      actions: [
        PopupMenuButton<bool>(
          tooltip: 'Export highlights',
          onSelected: (markdown) async => _export(await _data, markdown),
          itemBuilder: (_) => const [
            PopupMenuItem(value: true, child: Text('Export Markdown')),
            PopupMenuItem(value: false, child: Text('Export plain text')),
          ],
        ),
      ],
    ),
    body: FutureBuilder<_NotebookData>(
      future: _data,
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (data == null) {
          return const Center(child: CircularProgressIndicator());
        }
        final highlights = data.highlights
            .where((item) => _color == null || item.color == _color)
            .toList();
        if (data.notes.isEmpty && highlights.isEmpty) {
          return const Center(child: Text('No notes or highlights yet'));
        }
        return ListView(
          padding: const EdgeInsets.all(12),
          children: [
            if (data.highlights.isNotEmpty)
              DropdownButtonFormField<String?>(
                initialValue: _color,
                decoration: const InputDecoration(labelText: 'Highlight color'),
                items: const [
                  DropdownMenuItem(value: null, child: Text('All colors')),
                  DropdownMenuItem(value: 'yellow', child: Text('Yellow')),
                  DropdownMenuItem(value: 'green', child: Text('Green')),
                  DropdownMenuItem(value: 'blue', child: Text('Blue')),
                  DropdownMenuItem(value: 'pink', child: Text('Pink')),
                ],
                onChanged: (value) => setState(() => _color = value),
              ),
            for (final highlight in highlights)
              Card(
                child: ListTile(
                  leading: Icon(
                    highlight.style == 'underline'
                        ? Icons.format_underline
                        : Icons.highlight,
                  ),
                  title: Text('“${highlight.selectedText}”'),
                  subtitle: Text(
                    [
                      if (data.highlightNotes[highlight.id] case final note?)
                        note.noteText,
                      if (!highlight.resolved) 'Original text changed',
                      '${highlight.style} · ${highlight.color}',
                    ].join('\n'),
                  ),
                  onTap: () => _openBite(highlight.biteId),
                  trailing: PopupMenuButton<String>(
                    tooltip: 'Highlight actions',
                    onSelected: (action) async {
                      if (action == 'note') {
                        await _editNote(
                          highlight,
                          data.highlightNotes[highlight.id],
                        );
                      } else if (action == 'delete') {
                        await widget.database.deleteHighlight(
                          highlight.id,
                          deleteNote: true,
                        );
                        _refresh();
                      } else {
                        final parts = action.split(':');
                        await widget.database.updateHighlightAppearance(
                          highlight.id,
                          style: parts.first,
                          color: parts.last,
                        );
                        _refresh();
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'note', child: Text('Edit note')),
                      PopupMenuItem(
                        value: 'highlight:yellow',
                        child: Text('Yellow highlight'),
                      ),
                      PopupMenuItem(
                        value: 'highlight:green',
                        child: Text('Green highlight'),
                      ),
                      PopupMenuItem(
                        value: 'highlight:blue',
                        child: Text('Blue highlight'),
                      ),
                      PopupMenuItem(
                        value: 'highlight:pink',
                        child: Text('Pink highlight'),
                      ),
                      PopupMenuItem(
                        value: 'underline:yellow',
                        child: Text('Underline'),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete highlight'),
                      ),
                    ],
                  ),
                ),
              ),
            for (final note in data.notes)
              ListTile(
                leading: const Icon(Icons.note_outlined),
                title: Text(note.noteText),
                subtitle: Text(note.updatedAt.toLocal().toString()),
                onTap: () => _openBite(note.biteId),
              ),
          ],
        );
      },
    ),
  );
}

class _NotebookData {
  const _NotebookData({
    required this.notes,
    required this.highlights,
    required this.highlightNotes,
  });

  final List<ReaderNote> notes;
  final List<Highlight> highlights;
  final Map<String, HighlightNote?> highlightNotes;
}
