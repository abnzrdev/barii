import 'package:flutter/material.dart';

import '../../../core/database/app_database.dart';

class NotesPanel extends StatefulWidget {
  const NotesPanel({
    super.key,
    required this.database,
    required this.book,
    required this.bite,
    required this.onClose,
    this.onSaved,
  });

  final AppDatabase database;
  final Book book;
  final Bite bite;
  final VoidCallback onClose;
  final Future<void> Function()? onSaved;

  @override
  State<NotesPanel> createState() => _NotesPanelState();
}

class _NotesPanelState extends State<NotesPanel> {
  final _controller = TextEditingController();
  var _notes = const <ReaderNote>[];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final notes = (await widget.database.notesForBook(
      widget.book.id,
    )).where((note) => note.biteId == widget.bite.id).toList();
    if (mounted) setState(() => _notes = notes);
  }

  Future<void> _save() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final now = DateTime.now().toUtc();
    await widget.database.saveNote(
      id: '${widget.bite.id}-${now.microsecondsSinceEpoch}',
      bookId: widget.book.id,
      biteId: widget.bite.id,
      text: text,
      now: now,
    );
    _controller.clear();
    await _load();
    await widget.onSaved?.call();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Material(
    color: Theme.of(context).colorScheme.surfaceContainer,
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Notes for this bite',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  tooltip: 'Close notes',
                  onPressed: widget.onClose,
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            Text(
              widget.bite.content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              minLines: 2,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Note',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('Save note'),
            ),
            const Divider(height: 32),
            Expanded(
              child: _notes.isEmpty
                  ? const Center(child: Text('No notes for this bite'))
                  : ListView(
                      children: [
                        for (final note in _notes)
                          ListTile(
                            title: Text(note.noteText),
                            trailing: IconButton(
                              tooltip: 'Delete note',
                              onPressed: () async {
                                await widget.database.deleteNote(note.id);
                                await _load();
                              },
                              icon: const Icon(Icons.delete_outline),
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
