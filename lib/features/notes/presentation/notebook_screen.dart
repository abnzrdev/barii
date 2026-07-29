import 'package:flutter/material.dart';

import '../../../core/database/app_database.dart';
import '../../reader/presentation/reader_screen.dart';

class NotebookScreen extends StatelessWidget {
  const NotebookScreen({super.key, required this.database, required this.book});

  final AppDatabase database;
  final Book book;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('${book.title} notes')),
    body: FutureBuilder<List<ReaderNote>>(
      future: database.notesForBook(book.id),
      builder: (context, snapshot) {
        final notes = snapshot.data;
        if (notes == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (notes.isEmpty) return const Center(child: Text('No notes yet'));
        return ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];
            return ListTile(
              leading: const Icon(Icons.note_outlined),
              title: Text(note.noteText),
              subtitle: Text(note.updatedAt.toLocal().toString()),
              onTap: () async {
                final bites = await database.bitesForBook(book.id);
                final position = bites.indexWhere(
                  (bite) => bite.id == note.biteId,
                );
                if (position >= 0) {
                  await database.saveProgress(book.id, note.biteId, position);
                }
                if (context.mounted) {
                  await Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          ReaderScreen(database: database, book: book),
                    ),
                  );
                }
              },
            );
          },
        );
      },
    ),
  );
}
