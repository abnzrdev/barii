import 'package:flutter/material.dart';

import '../../../core/database/app_database.dart';
import '../data/bundled_dictionary.dart';
import '../domain/dictionary_repository.dart';
import '../../reader/presentation/reader_screen.dart';

class VocabularyScreen extends StatelessWidget {
  const VocabularyScreen({
    super.key,
    required this.database,
    required this.book,
    this.dictionaryRepository = const BundledDictionary(),
  });

  final AppDatabase database;
  final Book book;
  final DictionaryRepository dictionaryRepository;

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
              onTap: entry.sourceSentence.isEmpty
                  ? null
                  : () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => ReaderScreen(
                          database: database,
                          book: book,
                          dictionaryRepository: dictionaryRepository,
                          initialVocabulary: entry,
                        ),
                      ),
                    ),
              trailing: entry.sourceSentence.isEmpty
                  ? null
                  : const Icon(Icons.arrow_forward),
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
