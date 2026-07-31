import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/database/app_database.dart';
import '../../dictionary/data/bundled_dictionary.dart';
import '../../dictionary/domain/dictionary_repository.dart';
import '../../dictionary/presentation/dictionary_panel.dart';
import '../../notes/presentation/notes_panel.dart';
import '../domain/highlight_anchor.dart';
import 'bite_paginator.dart';
import 'reader_navigation.dart';

enum _OpenPanel { notes, dictionary }

class ReaderScreen extends StatefulWidget {
  const ReaderScreen({
    super.key,
    required this.database,
    required this.book,
    this.themeMode = ThemeMode.system,
    this.onThemeChanged,
    this.hapticFeedback,
    this.dictionaryRepository = const BundledDictionary(),
  });

  final AppDatabase database;
  final Book book;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode>? onThemeChanged;
  final Future<void> Function()? hapticFeedback;
  final DictionaryRepository dictionaryRepository;

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen>
    with WidgetsBindingObserver {
  final _focusNode = FocusNode();
  PageController? _pageController;
  Timer? _focusTimer;
  Timer? _panelReturnTimer;
  List<Bite> _bites = const [];
  List<DisplayPage> _pages = const [];
  var _index = 0;
  var _sourceOffset = 0;
  var _restoringViewport = false;
  int? _paginationSignature;
  String? _anchorBiteId;
  var _drag = Offset.zero;
  var _horizontalOffset = 0.0;
  var _ignoreHorizontalDrag = false;
  var _selectionActive = false;
  _OpenPanel? _dragPreview;
  var _fontSize = 20.0;
  var _lineHeight = 1.6;
  var _readingWidth = 680.0;
  var _pageMargin = 24.0;
  var _autoHideControls = true;
  var _hapticsEnabled = true;
  var _chromeVisible = true;
  var _alignment = TextAlign.start;
  String _recentWord = 'book';
  _OpenPanel? _panel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _load();
  }

  @override
  void didChangeMetrics() {
    if (_bites.isEmpty || !(_pageController?.hasClients ?? false)) return;
    final anchor = _currentPage;
    if (anchor != null) {
      _anchorBiteId = anchor.bite.id;
      _sourceOffset = anchor.startOffset;
    }
    _paginationSignature = null;
    _restoringViewport = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !(_pageController?.hasClients ?? false)) return;
      _pageController!.jumpToPage(_index);
      _restoringViewport = false;
    });
  }

  Future<void> _load() async {
    final bites = await widget.database.bitesForBook(widget.book.id);
    final progress = await widget.database.progressFor(widget.book.id);
    final preferences = await widget.database.preferences();
    final restored = progress == null
        ? 0
        : bites.indexWhere((bite) => bite.id == progress.biteId);
    if (mounted) {
      final index = (restored < 0 ? progress?.bitePosition ?? 0 : restored)
          .clamp(0, bites.isEmpty ? 0 : bites.length - 1);
      setState(() {
        _bites = bites;
        _index = 0;
        _anchorBiteId = bites.isEmpty ? null : bites[index].id;
        _sourceOffset = progress?.sourceOffset ?? 0;
        _pageController = PageController();
        _fontSize = preferences.fontSize;
        _lineHeight = preferences.lineHeight;
        _readingWidth = preferences.readingWidth;
        _pageMargin = preferences.pageMargin;
        _autoHideControls = preferences.autoHideControls;
        _hapticsEnabled = preferences.hapticsEnabled;
        _alignment = switch (preferences.alignment) {
          'center' => TextAlign.center,
          'justify' => TextAlign.justify,
          _ => TextAlign.start,
        };
        if (bites.isNotEmpty) _recentWord = _firstWord(bites[_index].content);
      });
      _focusNode.requestFocus();
      _resetFocusTimer();
    }
  }

  void _resetFocusTimer({bool show = true}) {
    _focusTimer?.cancel();
    if (show && mounted && !_chromeVisible) {
      setState(() => _chromeVisible = true);
    }
    if (_autoHideControls && _panel == null) {
      _focusTimer = Timer(const Duration(seconds: 4), () {
        if (mounted && _panel == null) setState(() => _chromeVisible = false);
      });
    }
  }

  void _toggleChrome() {
    _focusTimer?.cancel();
    setState(() => _chromeVisible = !_chromeVisible);
    if (_chromeVisible) _resetFocusTimer(show: false);
  }

  Future<void> _feedback() async {
    if (!_hapticsEnabled) return;
    if (widget.hapticFeedback != null) {
      await widget.hapticFeedback!();
    } else if (Platform.isAndroid) {
      await HapticFeedback.selectionClick();
    }
  }

  void _openPanel(_OpenPanel panel) {
    if (_bites.isEmpty || _panel == panel) return;
    _focusTimer?.cancel();
    setState(() {
      _chromeVisible = true;
      _panel = panel;
    });
    _feedback();
  }

  void _closePanel() {
    if (_panel == null) return;
    setState(() => _panel = null);
    _resetFocusTimer();
  }

  Future<void> _move(int change) async {
    if (_pages.isEmpty) return;
    final next = (_index + change).clamp(0, _pages.length - 1);
    if (next == _index) return;
    setState(() => _panel = null);
    _resetFocusTimer();
    if (MediaQuery.disableAnimationsOf(context)) {
      _pageController?.jumpToPage(next);
      await _saveCompletedPage(next);
    } else {
      await _pageController?.animateToPage(
        next,
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
      );
    }
  }

  Future<void> _completePageChange() async {
    if (_restoringViewport ||
        _pages.isEmpty ||
        !(_pageController?.hasClients ?? false)) {
      return;
    }
    final next = (_pageController!.page?.round() ?? _index).clamp(
      0,
      _pages.length - 1,
    );
    await _saveCompletedPage(next);
  }

  Future<void> _saveCompletedPage(int next) async {
    if (next == _index || _pages.isEmpty) return;
    final page = _pages[next];
    setState(() {
      _index = next;
      _anchorBiteId = page.bite.id;
      _sourceOffset = page.startOffset;
      _panel = null;
      _recentWord = _firstWord(page.text);
    });
    await widget.database.saveProgress(
      widget.book.id,
      page.bite.id,
      page.bite.position,
      _sourceOffset,
    );
    await _feedback();
    _resetFocusTimer();
  }

  void _perform(ReaderAction? action) {
    switch (action) {
      case ReaderAction.previous:
        _move(-1);
      case ReaderAction.next:
        _move(1);
      case ReaderAction.notes:
        _openPanel(_OpenPanel.notes);
      case ReaderAction.dictionary:
        _openPanel(_OpenPanel.dictionary);
      case ReaderAction.toggleControls:
        _toggleChrome();
      case ReaderAction.closePanel:
        if (_panel != null) {
          _closePanel();
        } else {
          Navigator.maybePop(context);
        }
      case null:
        break;
    }
  }

  Map<ShortcutActivator, VoidCallback> _shortcuts() {
    final bindings = <ShortcutActivator, VoidCallback>{
      const SingleActivator(LogicalKeyboardKey.escape): () =>
          _perform(ReaderAction.closePanel),
    };
    if (_panel != null) return bindings;
    void bind(LogicalKeyboardKey key, ReaderAction action) {
      bindings[SingleActivator(key)] = () => _perform(action);
    }

    bind(LogicalKeyboardKey.arrowUp, ReaderAction.previous);
    bind(LogicalKeyboardKey.keyK, ReaderAction.previous);
    bind(LogicalKeyboardKey.arrowDown, ReaderAction.next);
    bind(LogicalKeyboardKey.space, ReaderAction.next);
    bind(LogicalKeyboardKey.keyJ, ReaderAction.next);
    bind(LogicalKeyboardKey.arrowLeft, ReaderAction.notes);
    bind(LogicalKeyboardKey.keyN, ReaderAction.notes);
    bind(LogicalKeyboardKey.arrowRight, ReaderAction.dictionary);
    bind(LogicalKeyboardKey.keyD, ReaderAction.dictionary);
    bind(LogicalKeyboardKey.keyT, ReaderAction.toggleControls);
    return bindings;
  }

  Future<void> _showSettings() async {
    _focusTimer?.cancel();
    if (!_chromeVisible) setState(() => _chromeVisible = true);
    var selectedTheme = widget.themeMode;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Reader settings'),
                SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment(
                      value: ThemeMode.system,
                      label: Text('System'),
                    ),
                    ButtonSegment(value: ThemeMode.light, label: Text('Light')),
                    ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
                  ],
                  selected: {selectedTheme},
                  onSelectionChanged: (value) {
                    selectedTheme = value.first;
                    widget.onThemeChanged?.call(value.first);
                    widget.database.saveTheme(value.first.name);
                    setSheetState(() {});
                  },
                ),
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
                Semantics(
                  label: 'Horizontal page margin',
                  child: Slider(
                    value: _pageMargin,
                    min: 12,
                    max: 64,
                    onChanged: (value) {
                      setState(() => _pageMargin = value);
                      setSheetState(() {});
                    },
                  ),
                ),
                SegmentedButton<TextAlign>(
                  segments: const [
                    ButtonSegment(value: TextAlign.start, label: Text('Start')),
                    ButtonSegment(
                      value: TextAlign.center,
                      label: Text('Center'),
                    ),
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
                SwitchListTile(
                  title: const Text('Automatically hide reader controls'),
                  value: _autoHideControls,
                  onChanged: (value) {
                    setState(() => _autoHideControls = value);
                    setSheetState(() {});
                  },
                ),
                SwitchListTile(
                  title: const Text('Haptic feedback'),
                  value: _hapticsEnabled,
                  onChanged: (value) {
                    setState(() => _hapticsEnabled = value);
                    setSheetState(() {});
                  },
                ),
              ],
            ),
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
      pageMargin: _pageMargin,
      autoHideControls: _autoHideControls,
      hapticsEnabled: _hapticsEnabled,
    );
    _resetFocusTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageController?.dispose();
    _focusTimer?.cancel();
    _panelReturnTimer?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bite = _currentPage?.bite;
    Widget? panelFor(_OpenPanel? selection) => bite == null
        ? null
        : switch (selection) {
            _OpenPanel.notes => NotesPanel(
              database: widget.database,
              book: widget.book,
              bite: bite,
              onClose: _closePanel,
              onSaved: _feedback,
            ),
            _OpenPanel.dictionary => DictionaryPanel(
              database: widget.database,
              book: widget.book,
              bite: bite,
              word: _recentWord,
              onClose: _closePanel,
              onSaved: _feedback,
              repository: widget.dictionaryRepository,
            ),
            null => null,
          };
    final panel = panelFor(_panel);
    final textStyle = Theme.of(
      context,
    ).textTheme.bodyLarge?.copyWith(fontSize: _fontSize, height: _lineHeight);
    return PopScope(
      canPop: _panel == null,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _closePanel();
      },
      child: CallbackShortcuts(
        bindings: _shortcuts(),
        child: Focus(
          focusNode: _focusNode,
          autofocus: true,
          child: Scaffold(
            appBar: AppBar(
              leading: AnimatedOpacity(
                opacity: _chromeVisible ? 1 : 0,
                alwaysIncludeSemantics: true,
                duration: MediaQuery.disableAnimationsOf(context)
                    ? Duration.zero
                    : const Duration(milliseconds: 180),
                child: IgnorePointer(
                  ignoring: !_chromeVisible,
                  child: BackButton(
                    onPressed: () => Navigator.maybePop(context),
                  ),
                ),
              ),
              title: AnimatedOpacity(
                key: const ValueKey('reader-title'),
                opacity: _chromeVisible ? 1 : 0,
                alwaysIncludeSemantics: true,
                duration: MediaQuery.disableAnimationsOf(context)
                    ? Duration.zero
                    : const Duration(milliseconds: 180),
                child: Text(widget.book.title),
              ),
              actions: [
                AnimatedOpacity(
                  opacity: _chromeVisible ? 1 : 0,
                  alwaysIncludeSemantics: true,
                  duration: MediaQuery.disableAnimationsOf(context)
                      ? Duration.zero
                      : const Duration(milliseconds: 180),
                  child: IgnorePointer(
                    ignoring: !_chromeVisible,
                    child: IconButton(
                      tooltip: 'Reader settings',
                      onPressed: _showSettings,
                      icon: const Icon(Icons.text_fields),
                    ),
                  ),
                ),
              ],
            ),
            body: LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= 900;
                final reader = Column(
                  children: [
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, viewport) {
                          _paginate(viewport, textStyle!);
                          return Listener(
                            behavior: HitTestBehavior.opaque,
                            onPointerDown: (event) {
                              final insets = MediaQuery.systemGestureInsetsOf(
                                context,
                              );
                              final width = MediaQuery.sizeOf(context).width;
                              final leftEdge = insets.left.clamp(
                                24,
                                double.infinity,
                              );
                              final rightEdge = insets.right.clamp(
                                24,
                                double.infinity,
                              );
                              _ignoreHorizontalDrag =
                                  _selectionActive ||
                                  event.position.dx <= leftEdge ||
                                  event.position.dx >= width - rightEdge;
                              _drag = Offset.zero;
                              _horizontalOffset = 0;
                            },
                            onPointerMove: (event) {
                              if (_ignoreHorizontalDrag || _selectionActive) {
                                return;
                              }
                              _drag += event.delta;
                              if (_drag.dx.abs() <= _drag.dy.abs()) return;
                              setState(() {
                                _horizontalOffset += event.delta.dx;
                                _dragPreview = _horizontalOffset < 0
                                    ? _OpenPanel.notes
                                    : _OpenPanel.dictionary;
                              });
                              _resetFocusTimer();
                            },
                            onPointerUp: (event) {
                              if (_ignoreHorizontalDrag || _selectionActive) {
                                return;
                              }
                              if (_drag.distance < 8) {
                                _toggleChrome();
                                return;
                              }
                              var action = readerActionForDrag(_drag);
                              setState(() {
                                _horizontalOffset = 0;
                                if (action != null) _dragPreview = null;
                              });
                              if (action == null) {
                                _panelReturnTimer?.cancel();
                                _panelReturnTimer = Timer(
                                  const Duration(milliseconds: 180),
                                  () {
                                    if (mounted) {
                                      setState(() => _dragPreview = null);
                                    }
                                  },
                                );
                              }
                              _perform(action);
                            },
                            onPointerCancel: (_) {
                              _drag = Offset.zero;
                              _horizontalOffset = 0;
                              _dragPreview = null;
                            },
                            child: _pageController == null
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : NotificationListener<ScrollNotification>(
                                    onNotification: (notification) {
                                      if (notification
                                          is ScrollStartNotification) {
                                        _resetFocusTimer();
                                      } else if (notification
                                          is ScrollEndNotification) {
                                        _completePageChange();
                                      }
                                      return false;
                                    },
                                    child: PageView.builder(
                                      controller: _pageController,
                                      scrollDirection: Axis.vertical,
                                      pageSnapping: true,
                                      itemCount: _pages.length,
                                      itemBuilder: (context, pageIndex) {
                                        final page = _pages[pageIndex];
                                        final pageBite = page.bite;
                                        return KeyedSubtree(
                                          key: ValueKey(
                                            '${pageBite.id}:${page.startOffset}',
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 0,
                                            ),
                                            child: Center(
                                              child: ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxWidth: _readingWidth,
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: _pageMargin,
                                                  ),
                                                  child: Semantics(
                                                    label: 'Reading bite',
                                                    child:
                                                        pageBite.kind ==
                                                            'figure'
                                                        ? _FigurePage(
                                                            bite: pageBite,
                                                            style: textStyle,
                                                          )
                                                        : _BiteText(
                                                            database:
                                                                widget.database,
                                                            book: widget.book,
                                                            bite: pageBite,
                                                            startOffset: page
                                                                .startOffset,
                                                            endOffset:
                                                                page.endOffset,
                                                            style: textStyle,
                                                            alignment:
                                                                _alignment,
                                                            onWord: (word) {
                                                              _recentWord =
                                                                  word;
                                                              _openPanel(
                                                                _OpenPanel
                                                                    .dictionary,
                                                              );
                                                            },
                                                            onSelectionChanged:
                                                                (active) {
                                                                  _selectionActive =
                                                                      active;
                                                                },
                                                          ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                          );
                        },
                      ),
                    ),
                    AnimatedOpacity(
                      key: const ValueKey('reader-controls'),
                      opacity: _chromeVisible ? 1 : 0,
                      alwaysIncludeSemantics: true,
                      duration: MediaQuery.disableAnimationsOf(context)
                          ? Duration.zero
                          : const Duration(milliseconds: 180),
                      child: IgnorePointer(
                        ignoring: !_chromeVisible,
                        child: SafeArea(
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
                                onPressed: _index >= _pages.length - 1
                                    ? null
                                    : () => _perform(ReaderAction.next),
                                icon: const Icon(Icons.keyboard_arrow_down),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
                final base = wide
                    ? Row(
                        children: [
                          Expanded(child: reader),
                          if (panel != null) SizedBox(width: 380, child: panel),
                        ],
                      )
                    : Stack(
                        children: [
                          reader,
                          if (panel != null)
                            Positioned.fill(
                              top: constraints.maxHeight * 0.25,
                              child: panel,
                            ),
                        ],
                      );
                final previewSelection = _dragPreview;
                if (previewSelection == null || bite == null) return base;
                final preview = panelFor(previewSelection)!;
                final panelWidth = wide ? 380.0 : constraints.maxWidth;
                final revealed = (_horizontalOffset.abs() / panelWidth).clamp(
                  0,
                  1,
                );
                final translation = previewSelection == _OpenPanel.notes
                    ? panelWidth * (1 - revealed)
                    : -panelWidth * (1 - revealed);
                return Stack(
                  clipBehavior: Clip.hardEdge,
                  children: [
                    base,
                    Positioned(
                      top: wide ? 0 : constraints.maxHeight * 0.25,
                      bottom: 0,
                      width: panelWidth,
                      right: previewSelection == _OpenPanel.notes ? 0 : null,
                      left: previewSelection == _OpenPanel.dictionary
                          ? 0
                          : null,
                      child: AnimatedContainer(
                        duration: MediaQuery.disableAnimationsOf(context)
                            ? Duration.zero
                            : const Duration(milliseconds: 180),
                        curve: Curves.easeOutCubic,
                        transform: Matrix4.translationValues(translation, 0, 0),
                        child: IgnorePointer(child: preview),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  static String _firstWord(String text) =>
      RegExp(r'\S+').firstMatch(text)?.group(0) ?? 'book';

  DisplayPage? get _currentPage =>
      _pages.isEmpty ? null : _pages[_index.clamp(0, _pages.length - 1)];

  void _paginate(BoxConstraints viewport, TextStyle style) {
    final width = (_readingWidth.clamp(0, viewport.maxWidth) - 2 * _pageMargin)
        .clamp(1.0, double.infinity);
    final textScaler = MediaQuery.textScalerOf(context);
    final signature = Object.hash(
      viewport.maxWidth,
      viewport.maxHeight,
      width,
      style.fontSize,
      style.height,
      _alignment,
      textScaler,
      _bites.length,
    );
    if (_paginationSignature == signature) return;
    final current = _currentPage;
    final biteId = current?.bite.id ?? _anchorBiteId;
    final offset = current?.startOffset ?? _sourceOffset;
    final pages = paginateBites(
      bites: _bites,
      width: width,
      height: viewport.maxHeight,
      style: style,
      textAlign: _alignment,
      textDirection: Directionality.of(context),
      textScaler: textScaler,
    );
    final restored = pages.indexWhere(
      (page) =>
          page.bite.id == biteId &&
          offset >= page.startOffset &&
          (offset < page.endOffset ||
              page.endOffset == page.bite.content.length),
    );
    _pages = pages;
    _index = restored < 0 ? 0 : restored;
    _paginationSignature = signature;
    _restoringViewport = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !(_pageController?.hasClients ?? false)) return;
      _pageController!.jumpToPage(_index);
      _restoringViewport = false;
    });
  }
}

class _FigurePage extends StatelessWidget {
  const _FigurePage({required this.bite, required this.style});

  final Bite bite;
  final TextStyle style;

  Widget _image({BoxFit fit = BoxFit.contain}) {
    final assetPath = bite.assetPath;
    if (assetPath == null) return const Icon(Icons.broken_image_outlined);
    return assetPath.toLowerCase().endsWith('.svg')
        ? SvgPicture.file(File(assetPath), fit: fit)
        : Image.file(
            File(assetPath),
            fit: fit,
            errorBuilder: (_, _, _) {
              return const Icon(Icons.broken_image_outlined);
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    final label = bite.altText ?? bite.caption ?? 'Book figure';
    return Semantics(
      label: label,
      button: true,
      child: Tooltip(
        message: 'Tap to zoom figure',
        child: InkWell(
          key: ValueKey('figure-${bite.id}'),
          onTap: () => showDialog<void>(
            context: context,
            builder: (context) => Dialog.fullscreen(
              child: SafeArea(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: InteractiveViewer(
                        minScale: 0.5,
                        maxScale: 5,
                        child: Center(child: _image()),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        tooltip: 'Close figure',
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Center(child: _image())),
              if (bite.caption?.isNotEmpty ?? false)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    bite.caption!,
                    style: style,
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BiteText extends StatefulWidget {
  const _BiteText({
    required this.database,
    required this.book,
    required this.bite,
    required this.startOffset,
    required this.endOffset,
    required this.style,
    required this.alignment,
    required this.onWord,
    required this.onSelectionChanged,
  });

  final AppDatabase database;
  final Book book;
  final Bite bite;
  final int startOffset;
  final int endOffset;
  final TextStyle style;
  final TextAlign alignment;
  final ValueChanged<String> onWord;
  final ValueChanged<bool> onSelectionChanged;

  @override
  State<_BiteText> createState() => _BiteTextState();
}

class _BiteTextState extends State<_BiteText> {
  List<Highlight> _highlights = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant _BiteText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bite.id != widget.bite.id) _load();
  }

  Future<void> _load() async {
    final highlights = await widget.database.highlightsForBite(widget.bite.id);
    for (final highlight in highlights) {
      final resolved =
          HighlightAnchor(
            start: highlight.startOffset,
            end: highlight.endOffset,
            text: highlight.selectedText,
            prefix: highlight.prefixContext,
            suffix: highlight.suffixContext,
          ).resolve(widget.bite.content) !=
          null;
      if (resolved != highlight.resolved) {
        await widget.database.setHighlightResolved(highlight.id, resolved);
      }
    }
    if (mounted) setState(() => _highlights = highlights);
  }

  TextSelection? _selection(EditableTextState state) {
    final selection = state.textEditingValue.selection;
    if (!selection.isValid || selection.isCollapsed) return null;
    return TextSelection(
      baseOffset: selection.start,
      extentOffset: selection.end,
    );
  }

  void _dismissSelection(EditableTextState state) {
    final offset = state.textEditingValue.selection.end;
    state.userUpdateTextEditingValue(
      state.textEditingValue.copyWith(
        selection: TextSelection.collapsed(offset: offset),
      ),
      SelectionChangedCause.toolbar,
    );
    state.hideToolbar();
    widget.onSelectionChanged(false);
  }

  Future<void> _saveSelection(
    EditableTextState state, {
    String? note,
    String style = 'highlight',
  }) async {
    final selection = _selection(state);
    if (selection == null) return;
    final content = widget.bite.content;
    final anchor = HighlightAnchor.fromSelection(
      content,
      selection.start + widget.startOffset,
      selection.end + widget.startOffset,
    );
    if (anchor.text.trim().isEmpty) return;
    final id = sha256
        .convert(
          utf8.encode(
            '${widget.bite.id}:${anchor.start}:${anchor.end}:${anchor.text}',
          ),
        )
        .toString();
    final now = DateTime.now().toUtc();
    final noteId = note == null ? null : '$id-note';
    if (note != null) {
      await widget.database.saveHighlightNote(
        id: noteId!,
        bookId: widget.book.id,
        biteId: widget.bite.id,
        text: note,
        now: now,
      );
    }
    var replaced = false;
    for (final highlight in _highlights) {
      if (highlight.id != id &&
          anchor.start < highlight.endOffset &&
          anchor.end > highlight.startOffset) {
        await widget.database.deleteHighlight(highlight.id, deleteNote: true);
        replaced = true;
      }
    }
    await widget.database.saveHighlight(
      id: id,
      bookId: widget.book.id,
      biteId: widget.bite.id,
      startOffset: anchor.start,
      endOffset: anchor.end,
      selectedText: anchor.text,
      prefixContext: anchor.prefix,
      suffixContext: anchor.suffix,
      contentChecksum: sha256.convert(utf8.encode(content)).toString(),
      style: style,
      color: 'yellow',
      noteId: noteId,
      resolved: true,
      now: now,
    );
    _dismissSelection(state);
    await _load();
    if (replaced && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Overlapping highlight replaced')),
      );
    }
  }

  Future<void> _removeSelection(EditableTextState state) async {
    final selection = _selection(state);
    if (selection == null) return;
    for (final highlight in _highlights.where(
      (highlight) =>
          selection.start + widget.startOffset < highlight.endOffset &&
          selection.end + widget.startOffset > highlight.startOffset,
    )) {
      await widget.database.deleteHighlight(highlight.id, deleteNote: true);
    }
    _dismissSelection(state);
    await _load();
  }

  Future<void> _addNote(EditableTextState state) async {
    final controller = TextEditingController();
    final note = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Note on selection'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: 5,
          decoration: const InputDecoration(hintText: 'Write a note'),
        ),
        actions: [
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
    if (note != null && note.isNotEmpty) {
      await _saveSelection(state, note: note);
    }
  }

  List<TextSpan> _spans() {
    final content = widget.bite.content;
    final anchored =
        _highlights
            .map(
              (highlight) => (
                highlight: highlight,
                range: HighlightAnchor(
                  start: highlight.startOffset,
                  end: highlight.endOffset,
                  text: highlight.selectedText,
                  prefix: highlight.prefixContext,
                  suffix: highlight.suffixContext,
                ).resolve(content),
              ),
            )
            .where((item) => item.range != null)
            .toList()
          ..sort((a, b) => a.range!.start.compareTo(b.range!.start));
    final spans = <TextSpan>[];
    var offset = widget.startOffset;
    for (final item in anchored) {
      final range = item.range!;
      if (range.end <= widget.startOffset || range.start >= widget.endOffset) {
        continue;
      }
      final start = range.start.clamp(widget.startOffset, widget.endOffset);
      final end = range.end.clamp(widget.startOffset, widget.endOffset);
      if (end <= offset) continue;
      if (start > offset) {
        spans.add(TextSpan(text: content.substring(offset, start)));
      }
      spans.add(
        TextSpan(
          text: content.substring(start, end),
          style: _highlightStyle(item.highlight),
        ),
      );
      offset = end;
    }
    if (offset < widget.endOffset) {
      spans.add(TextSpan(text: content.substring(offset, widget.endOffset)));
    }
    return spans;
  }

  TextStyle _highlightStyle(Highlight highlight) {
    final scheme = Theme.of(context).colorScheme;
    final color = switch (highlight.color) {
      'green' => Colors.green.withValues(alpha: 0.28),
      'blue' => Colors.blue.withValues(alpha: 0.25),
      'pink' => Colors.pink.withValues(alpha: 0.25),
      _ => Colors.amber.withValues(alpha: 0.30),
    };
    return highlight.style == 'underline'
        ? TextStyle(
            decoration: TextDecoration.underline,
            decorationColor: scheme.primary,
            decorationThickness: 2,
          )
        : TextStyle(backgroundColor: color);
  }

  @override
  Widget build(BuildContext context) => SelectableText.rich(
    TextSpan(style: widget.style, children: _spans()),
    textAlign: widget.alignment,
    onSelectionChanged: (selection, _) =>
        widget.onSelectionChanged(!selection.isCollapsed),
    contextMenuBuilder: (context, state) {
      final selected = _selection(state);
      final items = [...state.contextMenuButtonItems];
      if (selected != null) {
        final text = widget.bite.content.substring(
          selected.start + widget.startOffset,
          selected.end + widget.startOffset,
        );
        items.addAll([
          ContextMenuButtonItem(
            label: 'Define',
            onPressed: () {
              _dismissSelection(state);
              widget.onWord(text);
            },
          ),
          ContextMenuButtonItem(
            label: 'Highlight',
            onPressed: () => _saveSelection(state),
          ),
          ContextMenuButtonItem(
            label: 'Underline',
            onPressed: () => _saveSelection(state, style: 'underline'),
          ),
          ContextMenuButtonItem(
            label: 'Add note',
            onPressed: () => _addNote(state),
          ),
          if (_highlights.any(
            (highlight) =>
                selected.start + widget.startOffset < highlight.endOffset &&
                selected.end + widget.startOffset > highlight.startOffset,
          ))
            ContextMenuButtonItem(
              label: 'Remove highlight',
              onPressed: () => _removeSelection(state),
            ),
        ]);
      }
      return AdaptiveTextSelectionToolbar.buttonItems(
        anchors: state.contextMenuAnchors,
        buttonItems: items,
      );
    },
  );
}
