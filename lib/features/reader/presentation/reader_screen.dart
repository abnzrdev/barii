import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/database/app_database.dart';
import '../../dictionary/presentation/dictionary_panel.dart';
import '../../notes/presentation/notes_panel.dart';
import 'reader_navigation.dart';

enum _OpenPanel { notes, dictionary }

class ReaderScreen extends StatefulWidget {
  const ReaderScreen({super.key, required this.database, required this.book});

  final AppDatabase database;
  final Book book;

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  final _focusNode = FocusNode();
  final _recognizers = <GestureRecognizer>[];
  List<Bite> _bites = const [];
  var _index = 0;
  var _drag = Offset.zero;
  var _fontSize = 20.0;
  var _lineHeight = 1.6;
  var _readingWidth = 680.0;
  var _alignment = TextAlign.start;
  String _recentWord = 'book';
  _OpenPanel? _panel;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final bites = await widget.database.bitesForBook(widget.book.id);
    final progress = await widget.database.progressFor(widget.book.id);
    final preferences = await widget.database.preferences();
    final restored = progress == null
        ? 0
        : bites.indexWhere((bite) => bite.id == progress.biteId);
    if (mounted) {
      setState(() {
        _bites = bites;
        _index = restored < 0 ? progress?.bitePosition ?? 0 : restored;
        _index = _index.clamp(0, bites.isEmpty ? 0 : bites.length - 1);
        _fontSize = preferences.fontSize;
        _lineHeight = preferences.lineHeight;
        _readingWidth = preferences.readingWidth;
        _alignment = switch (preferences.alignment) {
          'center' => TextAlign.center,
          'justify' => TextAlign.justify,
          _ => TextAlign.start,
        };
        if (bites.isNotEmpty) _recentWord = _firstWord(bites[_index].content);
      });
      _focusNode.requestFocus();
    }
  }

  Future<void> _move(int change) async {
    if (_bites.isEmpty) return;
    final next = (_index + change).clamp(0, _bites.length - 1);
    if (next == _index) return;
    setState(() {
      _index = next;
      _panel = null;
      _recentWord = _firstWord(_bites[next].content);
    });
    await widget.database.saveProgress(widget.book.id, _bites[next].id, next);
  }

  void _perform(ReaderAction? action) {
    switch (action) {
      case ReaderAction.previous:
        _move(-1);
      case ReaderAction.next:
        _move(1);
      case ReaderAction.notes:
        if (_bites.isNotEmpty) setState(() => _panel = _OpenPanel.notes);
      case ReaderAction.dictionary:
        if (_bites.isNotEmpty) setState(() => _panel = _OpenPanel.dictionary);
      case ReaderAction.closePanel:
        if (_panel != null) setState(() => _panel = null);
      case null:
        break;
    }
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final action = readerActionForKey(event.logicalKey);
    if (action == null) return KeyEventResult.ignored;
    _perform(action);
    return KeyEventResult.handled;
  }

  List<InlineSpan> _wordSpans(Bite bite, TextStyle style) {
    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
    _recognizers.clear();
    return RegExp(r'\s+|\S+').allMatches(bite.content).map((match) {
      final text = match.group(0)!;
      if (text.trim().isEmpty) return TextSpan(text: text, style: style);
      final recognizer = LongPressGestureRecognizer()
        ..onLongPress = () {
          setState(() {
            _recentWord = text;
            _panel = _OpenPanel.dictionary;
          });
        };
      _recognizers.add(recognizer);
      return TextSpan(text: text, style: style, recognizer: recognizer);
    }).toList();
  }

  Future<void> _showSettings() async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Reader settings'),
              Semantics(
                label: 'Font size',
                child: Slider(
                  value: _fontSize,
                  min: 16,
                  max: 32,
                  onChanged: (value) {
                    setState(() => _fontSize = value);
                    setSheetState(() {});
                  },
                ),
              ),
              Semantics(
                label: 'Line spacing',
                child: Slider(
                  value: _lineHeight,
                  min: 1.2,
                  max: 2,
                  onChanged: (value) {
                    setState(() => _lineHeight = value);
                    setSheetState(() {});
                  },
                ),
              ),
              Semantics(
                label: 'Reading width',
                child: Slider(
                  value: _readingWidth,
                  min: 420,
                  max: 900,
                  onChanged: (value) {
                    setState(() => _readingWidth = value);
                    setSheetState(() {});
                  },
                ),
              ),
              SegmentedButton<TextAlign>(
                segments: const [
                  ButtonSegment(value: TextAlign.start, label: Text('Start')),
                  ButtonSegment(value: TextAlign.center, label: Text('Center')),
                  ButtonSegment(
                    value: TextAlign.justify,
                    label: Text('Justify'),
                  ),
                ],
                selected: {_alignment},
                onSelectionChanged: (value) {
                  setState(() => _alignment = value.first);
                  setSheetState(() {});
                },
              ),
            ],
          ),
        ),
      ),
    );
    await widget.database.savePreferences(
      fontSize: _fontSize,
      lineHeight: _lineHeight,
      alignment: switch (_alignment) {
        TextAlign.center => 'center',
        TextAlign.justify => 'justify',
        _ => 'start',
      },
      readingWidth: _readingWidth,
    );
  }

  @override
  void dispose() {
    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bite = _bites.isEmpty ? null : _bites[_index];
    final panel = bite == null
        ? null
        : switch (_panel) {
            _OpenPanel.notes => NotesPanel(
              database: widget.database,
              book: widget.book,
              bite: bite,
              onClose: () => setState(() => _panel = null),
            ),
            _OpenPanel.dictionary => DictionaryPanel(
              database: widget.database,
              book: widget.book,
              bite: bite,
              word: _recentWord,
              onClose: () => setState(() => _panel = null),
            ),
            null => null,
          };
    final textStyle = Theme.of(
      context,
    ).textTheme.bodyLarge?.copyWith(fontSize: _fontSize, height: _lineHeight);
    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _onKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.book.title),
          actions: [
            IconButton(
              tooltip: 'Reader settings',
              onPressed: _showSettings,
              icon: const Icon(Icons.text_fields),
            ),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 900;
            final reader = Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onPanStart: (_) => _drag = Offset.zero,
                      onPanUpdate: (details) => _drag += details.delta,
                      onPanEnd: (_) => _perform(readerActionForDrag(_drag)),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: _readingWidth),
                          child: AnimatedSwitcher(
                            duration: MediaQuery.disableAnimationsOf(context)
                                ? Duration.zero
                                : const Duration(milliseconds: 180),
                            child: bite == null
                                ? const Text('This book has no readable bites.')
                                : Semantics(
                                    key: ValueKey(bite.id),
                                    label: 'Reading bite',
                                    child: Text.rich(
                                      TextSpan(
                                        children: _wordSpans(bite, textStyle!),
                                      ),
                                      textAlign: _alignment,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (_bites.length > 1)
                  LinearProgressIndicator(
                    value: (_index + 1) / _bites.length,
                    minHeight: 2,
                  ),
                SafeArea(
                  top: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        tooltip: 'Previous bite',
                        onPressed: _index == 0
                            ? null
                            : () => _perform(ReaderAction.previous),
                        icon: const Icon(Icons.keyboard_arrow_up),
                      ),
                      IconButton(
                        tooltip: 'Notes',
                        onPressed: bite == null
                            ? null
                            : () => _perform(ReaderAction.notes),
                        icon: const Icon(Icons.note_alt_outlined),
                      ),
                      IconButton(
                        tooltip: 'Dictionary',
                        onPressed: bite == null
                            ? null
                            : () => _perform(ReaderAction.dictionary),
                        icon: const Icon(Icons.menu_book_outlined),
                      ),
                      IconButton(
                        tooltip: 'Next bite',
                        onPressed: _index >= _bites.length - 1
                            ? null
                            : () => _perform(ReaderAction.next),
                        icon: const Icon(Icons.keyboard_arrow_down),
                      ),
                    ],
                  ),
                ),
              ],
            );
            if (wide) {
              return Row(
                children: [
                  Expanded(child: reader),
                  if (panel != null) SizedBox(width: 380, child: panel),
                ],
              );
            }
            return Stack(
              children: [
                reader,
                if (panel != null)
                  Positioned.fill(
                    top: constraints.maxHeight * 0.25,
                    child: panel,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  static String _firstWord(String text) =>
      RegExp(r'\S+').firstMatch(text)?.group(0) ?? 'book';
}
