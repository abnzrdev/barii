import 'package:flutter/material.dart';

import '../../../core/database/app_database.dart';
import '../data/bundled_dictionary.dart';
import '../domain/dictionary_repository.dart';
import '../domain/word_normalizer.dart';

class DictionaryPanel extends StatefulWidget {
  const DictionaryPanel({
    super.key,
    required this.database,
    required this.book,
    required this.bite,
    required this.word,
    required this.onClose,
    this.onSaved,
    this.repository = const BundledDictionary(),
  });

  final AppDatabase database;
  final Book book;
  final Bite bite;
  final String word;
  final VoidCallback onClose;
  final Future<void> Function()? onSaved;
  final DictionaryRepository repository;

  @override
  State<DictionaryPanel> createState() => _DictionaryPanelState();
}

class _DictionaryPanelState extends State<DictionaryPanel> {
  late final TextEditingController _controller;
  String? _definition;
  var _lookedUp = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.word);
    _lookup();
  }

  Future<void> _lookup() async {
    final definition = await widget.repository.lookup(_controller.text);
    if (mounted) {
      setState(() {
        _definition = definition;
        _lookedUp = true;
      });
    }
  }

  Future<void> _save() async {
    final definition = _definition;
    final word = _controller.text.trim();
    if (definition == null || word.isEmpty) return;
    final now = DateTime.now().toUtc();
    await widget.database.saveVocabulary(
      id: '${widget.book.id}-${normalizeWord(word)}',
      word: word,
      normalizedWord: normalizeWord(word),
      definition: definition,
      sourceSentence: widget.bite.content,
      bookId: widget.book.id,
      biteId: widget.bite.id,
      now: now,
    );
    await widget.onSaved?.call();
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Saved to vocabulary')));
    }
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
                    'Offline dictionary',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  tooltip: 'Close dictionary',
                  onPressed: widget.onClose,
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            TextField(
              controller: _controller,
              onSubmitted: (_) => _lookup(),
              decoration: InputDecoration(
                labelText: 'Word',
                suffixIcon: IconButton(
                  tooltip: 'Look up',
                  onPressed: _lookup,
                  icon: const Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (!_lookedUp)
              const Center(child: CircularProgressIndicator())
            else
              Text(
                _definition ?? 'No offline definition found',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _definition == null ? null : _save,
              icon: const Icon(Icons.bookmark_add_outlined),
              label: const Text('Save word'),
            ),
          ],
        ),
      ),
    ),
  );
}
