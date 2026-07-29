import 'package:flutter/material.dart';

import '../../../core/database/app_database.dart';

class VocabularyScreen extends StatelessWidget {
  const VocabularyScreen({
    super.key,
    required this.database,
    required this.book,
  });

  final AppDatabase database;
  final Book book;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('${book.title} vocabulary')),
    body: FutureBuilder<List<VocabularyEntry>>(
      future: database.vocabularyForBook(book.id),
      builder: (context, snapshot) {
        final entries = snapshot.data;
        if (entries == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (entries.isEmpty) {
          return const Center(child: Text('No saved vocabulary yet'));
        }
        return ListView.builder(
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index];
            return ListTile(
              title: Text(entry.word),
              subtitle: Text('${entry.definition}\n${entry.sourceSentence}'),
              isThreeLine: true,
            );
          },
        );
      },
    ),
  );
}
