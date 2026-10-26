import 'package:flutter/material.dart';

import '../../../core/database/app_database.dart';
import '../data/bundled_dictionary.dart';
import '../domain/dictionary_repository.dart';
import '../domain/reader_word_selection.dart';
import '../domain/word_normalizer.dart';

class DictionaryPanel extends StatefulWidget {
  const DictionaryPanel({
    super.key,
    required this.database,
    required this.book,
    required this.bite,
    required this.word,
    required this.onClose,
    this.selection,
    this.initialEntry,
    this.scrollController,
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
  final ReaderWordSelection? selection;
  final DictionaryEntry? initialEntry;
  final ScrollController? scrollController;

  @override
  State<DictionaryPanel> createState() => _DictionaryPanelState();
}

class _DictionaryPanelState extends State<DictionaryPanel> {
  late final _controller = TextEditingController(text: widget.word);
  DictionaryEntry? _entry;
  List<String> _suggestions = [];
  var _busy = false;
  var _failed = false;
  var _searching = false;
  var _saved = false;
  var _request = 0;

  @override
  void initState() {
    super.initState();
    _entry = widget.initialEntry;
    if (_entry == null) _lookup();
  }

  Future<void> _lookup() async {
    final request = ++_request;
    setState(() {
      _busy = true;
      _failed = false;
      _saved = false;
    });
    try {
      final useContext = _controller.text == widget.word;
      final entry = await widget.repository.lookupEntry(
        _controller.text,
        context: useContext ? widget.selection?.context ?? '' : '',
        contextOffset: useContext ? widget.selection?.contextOffset : null,
      );
      final suggestions = entry == null
          ? await widget.repository.suggest(_controller.text)
          : <String>[];
      if (mounted && request == _request) {
        setState(() {
          _entry = entry;
          _suggestions = suggestions;
          _busy = false;
        });
      }
    } catch (_) {
      if (mounted && request == _request) {
        setState(() {
          _failed = true;
          _busy = false;
        });
      }
    }
  }

  Future<void> _save(DictionarySense? sense) async {
    final entry = _entry;
    if (entry == null) return;
    final fromReading = _controller.text == widget.word;
    final selection = fromReading ? widget.selection : null;
    final chosen = sense ?? (entry.senses.isEmpty ? null : entry.senses.first);
    final selected = selection?.word ?? _controller.text;
    await widget.database.saveVocabulary(
      id: '${widget.book.id}:${chosen?.id ?? normalizeWord(entry.word)}',
      word: selected,
      normalizedWord: normalizeWord(entry.word),
      definition: chosen?.definition ?? entry.definition,
      sourceSentence:
          selection?.context ??
          (fromReading
              ? sourceSentenceFor(widget.bite.content, widget.word)
              : ''),
      bookId: widget.book.id,
      biteId: fromReading ? selection?.biteId ?? widget.bite.id : null,
      dictionarySourceId: entry.sourceId,
      dictionarySourceName: chosen?.sourceName ?? entry.sourceName,
      partOfSpeech: chosen?.partOfSpeech ?? entry.partOfSpeech,
      pronunciation: entry.pronunciation,
      dictionaryEntryId: chosen?.entryId ?? entry.entryId,
      dictionarySenseId: chosen?.id,
      sourceOffset: selection?.startOffset,
      endOffset: selection?.endOffset,
      canonicalLocator: selection?.canonicalLocator,
      selectedText: selected,
      now: DateTime.now().toUtc(),
    );
    await widget.onSaved?.call();
    if (mounted) setState(() => _saved = true);
  }

  @override
  void dispose() {
    _request++;
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final entry = _entry;
    final senses = entry == null ? <DictionarySense>[] : entry.senses;
    return Material(
      color: scheme.surface,
      child: SafeArea(
        top: false,
        child: ListView(
          controller: widget.scrollController,
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
          children: [
            Row(
              children: [
                const Expanded(child: Text('Offline dictionary')),
                IconButton(
                  tooltip: 'Search dictionary',
                  icon: const Icon(Icons.search),
                  onPressed: () => setState(() => _searching = !_searching),
                ),
                IconButton(
                  tooltip: 'Close dictionary',
                  icon: const Icon(Icons.close),
                  onPressed: widget.onClose,
                ),
              ],
            ),
            if (_searching) ...[
              TextField(
                controller: _controller,
                autofocus: true,
                onSubmitted: (_) => _lookup(),
                decoration: InputDecoration(
                  labelText: 'Word or expression',
                  suffixIcon: IconButton(
                    tooltip: 'Look up',
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: _lookup,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
            Text(
              entry?.word ?? _controller.text,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            if (entry?.pronunciation case final String ipa)
              Text(ipa, style: TextStyle(color: scheme.onSurfaceVariant)),
            const SizedBox(height: 16),
            if (_busy)
              const LinearProgressIndicator(minHeight: 2)
            else if (_failed) ...[
              const Text('The local dictionary could not be read.'),
              TextButton(onPressed: _lookup, child: const Text('Retry')),
            ] else if (entry == null) ...[
              Row(
                children: [
                  Icon(Icons.circle, size: 7, color: scheme.error),
                  const SizedBox(width: 8),
                  const Expanded(child: Text('No offline definition found')),
                ],
              ),
              if (_suggestions.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final word in _suggestions)
                        ActionChip(
                          label: Text(word),
                          onPressed: () {
                            _controller.text = word;
                            _lookup();
                          },
                        ),
                    ],
                  ),
                ),
            ] else ...[
              if (senses.isEmpty)
                Text(
                  entry.definition,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              for (var i = 0; i < senses.length; i++) ...[
                if (i == 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: FilledButton.icon(
                      onPressed: _saved ? null : () => _save(null),
                      icon: Icon(
                        _saved
                            ? Icons.bookmark_added
                            : Icons.bookmark_add_outlined,
                      ),
                      label: Text(_saved ? 'Saved to vocabulary' : 'Save word'),
                    ),
                  ),
                if (i > 0)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(),
                  ),
                if (senses[i].partOfSpeech case final String pos)
                  Text(
                    pos,
                    style: TextStyle(
                      color: scheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                const SizedBox(height: 6),
                Text(
                  senses[i].definition,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                for (final example in senses[i].examples.take(2))
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      example,
                      style: TextStyle(
                        color: scheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                if (senses[i].synonyms.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      'Similar: ${senses[i].synonyms.take(8).join(', ')}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                Text(
                  senses[i].sourceName,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                if (i > 0)
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: TextButton.icon(
                      onPressed: () => _save(senses[i]),
                      icon: const Icon(Icons.bookmark_add_outlined, size: 18),
                      label: const Text('Save this meaning'),
                    ),
                  ),
              ],
              const SizedBox(height: 20),
              if (senses.length <= 1)
                FilledButton.icon(
                  onPressed: _saved ? null : () => _save(null),
                  icon: Icon(
                    _saved ? Icons.bookmark_added : Icons.bookmark_add_outlined,
                  ),
                  label: Text(_saved ? 'Saved to vocabulary' : 'Save word'),
                ),
              const SizedBox(height: 12),
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: const Text('Sources & licences'),
                children: [
                  Text(
                    entry.attribution ?? entry.sourceName,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Text(
                    'Simple English Wiktionary: CC BY-SA 4.0. Open English WordNet: CC BY 4.0 and Princeton WordNet terms.',
                  ),
                  for (final url
                      in senses
                          .map((s) => s.sourceUrl)
                          .whereType<String>()
                          .toSet())
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: SelectableText(
                        url,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
