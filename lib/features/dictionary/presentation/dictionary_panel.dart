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
  DictionaryEntry? _entry;
  List<String> _suggestions = const [];
  var _lookedUp = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.word);
    _lookup();
  }

  Future<void> _lookup() async {
    final (entry, suggestions) = await (
      widget.repository.lookupEntry(_controller.text),
      widget.repository.suggest(_controller.text),
    ).wait;
    if (mounted) {
      setState(() {
        _entry = entry;
        _suggestions = suggestions
            .where((word) => word != entry?.word)
            .toList();
        _lookedUp = true;
      });
    }
  }

  Future<void> _save() async {
    final entry = _entry;
    final word = _controller.text.trim();
    if (entry == null || word.isEmpty) return;
    final now = DateTime.now().toUtc();
    await widget.database.saveVocabulary(
      id: '${widget.book.id}-${normalizeWord(word)}',
      word: word,
      normalizedWord: normalizeWord(word),
      definition: entry.definition,
      sourceSentence: sourceSentenceFor(widget.bite.content, widget.word),
      bookId: widget.book.id,
      biteId: widget.bite.id,
      now: now,
      dictionarySourceName: entry.sourceName,
      partOfSpeech: entry.partOfSpeech,
      pronunciation: entry.pronunciation,
      dictionarySourceId: entry.sourceId,
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
            Text(
              'Selected: ${widget.word}\n'
              'Lookup form: ${normalizeWord(_controller.text)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            if (!_lookedUp)
              const Center(child: CircularProgressIndicator())
            else if (_entry == null)
              Text(
                'No offline definition found',
                style: Theme.of(context).textTheme.bodyLarge,
              )
            else ...[
              Text(
                _entry!.word,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (_entry!.pronunciation != null) Text(_entry!.pronunciation!),
              if (_entry!.partOfSpeech != null)
                Text(
                  _entry!.partOfSpeech!,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              const SizedBox(height: 8),
              Text(
                _entry!.definition,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 12),
              Text(
                _entry!.sourceName,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              if (_entry!.attribution != null)
                Text(
                  _entry!.attribution!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              if (_suggestions.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  'Alternative matches',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final suggestion in _suggestions)
                      ActionChip(
                        label: Text(suggestion),
                        onPressed: () {
                          _controller.text = suggestion;
                          _lookup();
                        },
                      ),
                  ],
                ),
              ],
            ],
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _entry == null ? null : _save,
              icon: const Icon(Icons.bookmark_add_outlined),
              label: const Text('Save word'),
            ),
          ],
        ),
      ),
    ),
  );
}
