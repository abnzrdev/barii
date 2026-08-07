import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/database/app_database.dart';
import '../../dictionary/data/bundled_dictionary.dart';
import '../../dictionary/domain/dictionary_repository.dart';
import '../../dictionary/presentation/dictionary_panel.dart';
import '../domain/highlight_anchor.dart';
import 'bite_paginator.dart';
import '../data/canonical_locator_backfill.dart';
import 'reader_navigation.dart';
import 'original_epub_view.dart';
import 'reader_panel.dart';

enum _OpenPanel { reader, dictionary }

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
  static const _paginationWindowRadius = 4;
  static const _paginationPrefetchThreshold = 1;

  final _openTask = TimelineTask();
  final _focusNode = FocusNode();
  PageController? _pageController;
  Timer? _focusTimer;
  Timer? _repaginationTimer;
  Future<void> _databaseWrites = Future.value();
  final _paginationCache = BitePaginationCache();
  List<Bite> _bites = const [];
  List<DisplayPage> _pages = const [];
  var _index = 0;
  var _sourceOffset = 0;
  var _restoringViewport = false;
  int? _paginationSignature;
  var _paginationGeneration = 0;
  var _materializedStart = 0;
  var _materializedEnd = -1;
  var _firstReadableReported = false;
  String? _anchorBiteId;
  var _drag = Offset.zero;
  var _horizontalOffset = 0.0;
  var _ignoreHorizontalDrag = false;
  var _selectionActive = false;
  _OpenPanel? _dragPreview;
  var _readerTab = ReaderPanelTab.contents;
  var _bookmarked = false;
  var _refreshBookmarkAfterPagination = false;
  final _linkHistory = <ReaderLocation>[];
  var _fontSize = 20.0;
  var _lineHeight = 1.6;
  var _paginationFontSize = 20.0;
  var _paginationLineHeight = 1.6;
  var _readingWidth = 680.0;
  var _pageMargin = 24.0;
  var _paginationReadingWidth = 680.0;
  var _paginationPageMargin = 24.0;
  var _autoHideControls = true;
  var _hapticsEnabled = true;
  var _showProgress = false;
  var _plainReadingMode = false;
  var _originalView = false;
  var _originalSpineIndex = 0;
  var _canonicalBackfillStarted = false;
  var _chromeVisible = true;
  var _alignment = TextAlign.start;
  String _recentWord = 'book';
  _OpenPanel? _panel;

  @override
  void initState() {
    super.initState();
    _openTask.start('Reader.open');
    WidgetsBinding.instance.addObserver(this);
    _load();
  }

  @override
  void didChangeMetrics() {
    if (_bites.isEmpty || !(_pageController?.hasClients ?? false)) return;
    final anchor = _currentPage;
    if (anchor != null) {
      _anchorBiteId = anchor.bite.id;
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
    final loadTask = TimelineTask()..start('Reader.contentLoad');
    final bites = await widget.database.bitesForBook(widget.book.id);
    final progress = await widget.database.progressFor(widget.book.id);
    final preferences = await widget.database.preferences();
    final viewMode = await widget.database.readerViewMode(widget.book.id);
    loadTask.finish(arguments: {'bites': bites.length});
    final restored = progress == null
        ? 0
        : bites.indexWhere((bite) => bite.id == progress.biteId);
    if (mounted) {
      final index = (restored < 0 ? progress?.bitePosition ?? 0 : restored)
          .clamp(0, bites.isEmpty ? 0 : bites.length - 1);
      final spineIndex = bites.isEmpty
          ? 0
          : await widget.database.sectionPositionForBite(bites[index].id) ?? 0;
      if (!mounted) return;
      setState(() {
        _bites = bites;
        _index = 0;
        _anchorBiteId = bites.isEmpty ? null : bites[index].id;
        _sourceOffset = progress?.sourceOffset ?? 0;
        _pageController = PageController();
        _fontSize = preferences.fontSize;
        _lineHeight = preferences.lineHeight;
        _paginationFontSize = preferences.fontSize;
        _paginationLineHeight = preferences.lineHeight;
        _readingWidth = preferences.readingWidth;
        _pageMargin = preferences.pageMargin;
        _paginationReadingWidth = preferences.readingWidth;
        _paginationPageMargin = preferences.pageMargin;
        _autoHideControls = preferences.autoHideControls;
        _hapticsEnabled = preferences.hapticsEnabled;
        _showProgress = preferences.showProgress;
        _plainReadingMode = preferences.plainReadingMode;
        _originalView =
            viewMode == 'original' && widget.book.fileType == 'epub';
        _originalSpineIndex = spineIndex;
        _alignment = switch (preferences.alignment) {
          'center' => TextAlign.center,
          'justify' => TextAlign.justify,
          _ => TextAlign.start,
        };
        if (bites.isNotEmpty) _recentWord = _firstWord(bites[_index].content);
      });
      _focusNode.requestFocus();
      _resetFocusTimer();
      _refreshBookmark();
    }
  }

  Future<void> _toggleReaderView() async {
    if (widget.book.fileType != 'epub') return;
    final original = !_originalView;
    if (!original) {
      _paginationSignature = null;
    } else if (_anchorBiteId != null) {
      _originalSpineIndex =
          await widget.database.sectionPositionForBite(_anchorBiteId!) ?? 0;
    }
    if (!mounted) return;
    setState(() => _originalView = original);
    await widget.database.saveReaderViewMode(
      widget.book.id,
      original ? 'original' : 'bookbites',
    );
  }

  Future<void> _updateOriginalLocation(OriginalEpubLocation location) async {
    final bite = await widget.database.biteAtSectionOffset(
      widget.book.id,
      location.spineIndex,
      location.offset,
    );
    if (bite == null || !mounted || !_originalView) return;
    _anchorBiteId = bite.id;
    _sourceOffset = (location.offset - bite.sourceStart).clamp(
      0,
      bite.content.length,
    );
    await _serializeWrite(
      () => widget.database.saveProgress(
        widget.book.id,
        bite.id,
        bite.position,
        _sourceOffset,
      ),
    );
  }

  void _backfillCanonicalLocations() {
    if (_canonicalBackfillStarted) return;
    _canonicalBackfillStarted = true;
    unawaited(CanonicalLocatorBackfill(widget.database).backfill(widget.book));
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

  void _openReaderPanel(ReaderPanelTab tab) {
    _readerTab = tab;
    _openPanel(_OpenPanel.reader);
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
      final biteIndex = _bites.indexWhere((bite) => bite.id == page.bite.id);
      if (biteIndex >= 0 &&
          ((_materializedStart > 0 &&
                  biteIndex <=
                      _materializedStart + _paginationPrefetchThreshold) ||
              (_materializedEnd < _bites.length - 1 &&
                  biteIndex >=
                      _materializedEnd - _paginationPrefetchThreshold))) {
        _paginationSignature = null;
      }
    });
    await widget.database.saveProgress(
      widget.book.id,
      page.bite.id,
      page.bite.position,
      _sourceOffset,
    );
    await _refreshBookmark();
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
        _openReaderPanel(ReaderPanelTab.notes);
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

  Future<void> _refreshBookmark() async {
    final page = _currentPage;
    if (page == null) return;
    final bookmarked = await widget.database.isBookmarked(
      widget.book.id,
      page.bite.id,
      page.startOffset,
    );
    if (mounted) setState(() => _bookmarked = bookmarked);
  }

  Future<void> _toggleBookmark() async {
    final page = _currentPage;
    if (page == null) return;
    if (_bookmarked) {
      await widget.database.removeBookmark(
        widget.book.id,
        page.bite.id,
        page.startOffset,
      );
    } else {
      await widget.database.addBookmark(
        bookId: widget.book.id,
        biteId: page.bite.id,
        sourceOffset: page.startOffset,
        now: DateTime.now().toUtc(),
      );
    }
    await _refreshBookmark();
    await _feedback();
  }

  Future<void> _jumpTo(ReaderLocation location) async {
    final page = _pages.indexWhere(
      (page) =>
          page.bite.id == location.biteId &&
          location.sourceOffset >= page.startOffset &&
          (location.sourceOffset < page.endOffset ||
              page.endOffset == page.bite.content.length),
    );
    if (page < 0) {
      final biteIndex = _bites.indexWhere((bite) => bite.id == location.biteId);
      if (biteIndex < 0) return;
      _closePanel();
      setState(() {
        _anchorBiteId = location.biteId;
        _sourceOffset = location.sourceOffset;
        _paginationSignature = null;
        _refreshBookmarkAfterPagination = true;
      });
      final target = _bites[biteIndex];
      await widget.database.saveProgress(
        widget.book.id,
        target.id,
        target.position,
        location.sourceOffset,
      );
      return;
    }
    _closePanel();
    if (MediaQuery.disableAnimationsOf(context)) {
      _pageController?.jumpToPage(page);
    } else {
      await _pageController?.animateToPage(
        page,
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
      );
    }
    final target = _pages[page];
    setState(() {
      _index = page;
      _anchorBiteId = target.bite.id;
      _sourceOffset = location.sourceOffset;
      _recentWord = _firstWord(target.text);
    });
    await widget.database.saveProgress(
      widget.book.id,
      target.bite.id,
      target.bite.position,
      location.sourceOffset,
    );
    await _refreshBookmark();
  }

  Future<void> _followLink(String href) async {
    final uri = Uri.tryParse(href);
    if (uri == null) return;
    if (uri.scheme == 'http' || uri.scheme == 'https') {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Open external link?'),
          content: Text(href),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Open'),
            ),
          ],
        ),
      );
      if (confirmed == true) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return;
    }
    for (final bite in _bites) {
      final offset = _RichMetadata.parse(bite.markup).anchors[href];
      if (offset == null) continue;
      final current = _currentPage;
      if (current != null) {
        _linkHistory.add(ReaderLocation(current.bite.id, _sourceOffset));
      }
      await _jumpTo(ReaderLocation(bite.id, offset));
      return;
    }
  }

  Future<void> _backFromLink() async {
    if (_linkHistory.isEmpty) {
      await Navigator.maybePop(context);
      return;
    }
    await _jumpTo(_linkHistory.removeLast());
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
    Widget settings(BuildContext context) => StatefulBuilder(
      builder: (context, setSheetState) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Reader settings', style: TextStyle(fontSize: 20)),
              const _SettingsSection('Font'),
              _SettingsValue(
                label: 'Font size',
                value: '${_fontSize.round()} sp',
                range: '16–32 sp',
                onReset: () {
                  setState(() => _fontSize = 20);
                  setSheetState(() {});
                  _finishStyleDrag();
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
                  onChangeEnd: (_) => _finishStyleDrag(),
                ),
              ),
              const _SettingsSection('Layout'),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Plain reading mode'),
                subtitle: const Text('Show calm paragraph content only'),
                value: _plainReadingMode,
                onChanged: (value) {
                  setState(() {
                    _plainReadingMode = value;
                    _paginationSignature = null;
                  });
                  setSheetState(() {});
                  _savePreferences();
                },
              ),
              _SettingsValue(
                label: 'Line spacing',
                value: _lineHeight.toStringAsFixed(1),
                range: '1.2–2.0',
                onReset: () {
                  setState(() => _lineHeight = 1.6);
                  setSheetState(() {});
                  _finishStyleDrag();
                },
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
                  onChangeEnd: (_) => _finishStyleDrag(),
                ),
              ),
              _SettingsValue(
                label: 'Reading width',
                value: '${_readingWidth.round()} px',
                range: '420–900 px',
                onReset: () {
                  setState(() => _readingWidth = 680);
                  setSheetState(() {});
                  _finishStyleDrag();
                },
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
                  onChangeEnd: (_) => _finishStyleDrag(),
                ),
              ),
              _SettingsValue(
                label: 'Horizontal margin',
                value: '${_pageMargin.round()} px',
                range: '12–64 px',
                onReset: () {
                  setState(() => _pageMargin = 24);
                  setSheetState(() {});
                  _finishStyleDrag();
                },
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
                  onChangeEnd: (_) => _finishStyleDrag(),
                ),
              ),
              _SettingsValue(
                label: 'Text alignment',
                value: _alignment.name,
                range: 'Start, center, or justify',
                onReset: () {
                  setState(() {
                    _alignment = TextAlign.start;
                    _paginationSignature = null;
                  });
                  setSheetState(() {});
                  _savePreferences();
                },
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SegmentedButton<TextAlign>(
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
              ),
              const _SettingsSection('Theme'),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Color theme'),
                subtitle: Text('Current: ${selectedTheme.name}'),
                trailing: IconButton(
                  tooltip: 'Reset color theme',
                  onPressed: () {
                    selectedTheme = ThemeMode.system;
                    widget.onThemeChanged?.call(selectedTheme);
                    _serializeWrite(
                      () => widget.database.saveTheme(selectedTheme.name),
                    );
                    setSheetState(() {});
                  },
                  icon: const Icon(Icons.restart_alt),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SegmentedButton<ThemeMode>(
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
                    _serializeWrite(
                      () => widget.database.saveTheme(value.first.name),
                    );
                    setSheetState(() {});
                  },
                ),
              ),
              const _SettingsSection('Behavior'),
              SwitchListTile(
                title: const Text('Automatically hide reader controls'),
                subtitle: Text(
                  'Current: ${_autoHideControls ? 'On' : 'Off'} · Range: On or off',
                ),
                secondary: IconButton(
                  tooltip: 'Reset automatically hide reader controls',
                  onPressed: () {
                    setState(() => _autoHideControls = true);
                    setSheetState(() {});
                    _savePreferences();
                  },
                  icon: const Icon(Icons.restart_alt),
                ),
                value: _autoHideControls,
                onChanged: (value) {
                  setState(() => _autoHideControls = value);
                  setSheetState(() {});
                },
              ),
              SwitchListTile(
                title: const Text('Haptic feedback'),
                subtitle: Text(
                  'Current: ${_hapticsEnabled ? 'On' : 'Off'} · Range: On or off',
                ),
                secondary: IconButton(
                  tooltip: 'Reset haptic feedback',
                  onPressed: () {
                    setState(() => _hapticsEnabled = true);
                    setSheetState(() {});
                    _savePreferences();
                  },
                  icon: const Icon(Icons.restart_alt),
                ),
                value: _hapticsEnabled,
                onChanged: (value) {
                  setState(() => _hapticsEnabled = value);
                  setSheetState(() {});
                },
              ),
              SwitchListTile(
                title: const Text('Subtle progress'),
                subtitle: Text(
                  'Current: ${_showProgress ? 'On' : 'Off'} · Range: On or off · Shown only with controls',
                ),
                secondary: IconButton(
                  tooltip: 'Reset subtle progress',
                  onPressed: () {
                    setState(() => _showProgress = false);
                    setSheetState(() {});
                    _savePreferences();
                  },
                  icon: const Icon(Icons.restart_alt),
                ),
                value: _showProgress,
                onChanged: (value) {
                  setState(() => _showProgress = value);
                  setSheetState(() {});
                },
              ),
            ],
          ),
        ),
      ),
    );
    if (MediaQuery.sizeOf(context).width >= 700) {
      await showDialog<void>(
        context: context,
        builder: (context) => Dialog(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560, maxHeight: 700),
            child: settings(context),
          ),
        ),
      );
    } else {
      await showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        isScrollControlled: true,
        builder: (context) =>
            FractionallySizedBox(heightFactor: 0.9, child: settings(context)),
      );
    }
    await _savePreferences();
    _resetFocusTimer();
  }

  void _finishStyleDrag() {
    _repaginationTimer?.cancel();
    _repaginationTimer = Timer(const Duration(milliseconds: 180), () {
      if (!mounted) return;
      setState(() {
        _paginationFontSize = _fontSize;
        _paginationLineHeight = _lineHeight;
        _paginationReadingWidth = _readingWidth;
        _paginationPageMargin = _pageMargin;
        _paginationSignature = null;
      });
    });
    _savePreferences();
  }

  Future<void> _savePreferences() => _serializeWrite(
    () => widget.database.savePreferences(
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
      showProgress: _showProgress,
      plainReadingMode: _plainReadingMode,
    ),
  );

  Future<void> _serializeWrite(Future<void> Function() write) {
    final operation = _databaseWrites.catchError((_) {}).then((_) => write());
    _databaseWrites = operation.catchError((_) {});
    return operation;
  }

  @override
  void dispose() {
    if (!_firstReadableReported) {
      _openTask.finish(arguments: {'cancelled': true});
    }
    WidgetsBinding.instance.removeObserver(this);
    _pageController?.dispose();
    _focusTimer?.cancel();
    _repaginationTimer?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bite = _currentPage?.bite;
    Widget? panelFor(_OpenPanel? selection) => bite == null
        ? null
        : switch (selection) {
            _OpenPanel.reader => ReaderPanel(
              database: widget.database,
              book: widget.book,
              bites: _bites,
              currentBite: bite,
              initialTab: _readerTab,
              onNavigate: _jumpTo,
              onClose: _closePanel,
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
    final textStyle =
        (Theme.of(context).textTheme.bodyLarge ?? const TextStyle()).copyWith(
          fontSize: _fontSize,
          height: _lineHeight,
        );
    final paginationStyle = textStyle.copyWith(
      fontSize: _paginationFontSize,
      height: _paginationLineHeight,
    );
    return PopScope(
      canPop: _panel == null && _linkHistory.isEmpty,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (_panel != null) {
          _closePanel();
        } else {
          _backFromLink();
        }
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
                  child: BackButton(onPressed: _backFromLink),
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
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.book.fileType == 'epub')
                          IconButton(
                            tooltip: _originalView
                                ? 'Switch to BookBites'
                                : 'Switch to Original EPUB',
                            onPressed: _toggleReaderView,
                            icon: Icon(
                              _originalView
                                  ? Icons.view_agenda_outlined
                                  : Icons.chrome_reader_mode_outlined,
                            ),
                          ),
                        IconButton(
                          tooltip: 'Contents',
                          onPressed: () =>
                              _openReaderPanel(ReaderPanelTab.contents),
                          icon: const Icon(Icons.list_alt),
                        ),
                        IconButton(
                          tooltip: 'Search book',
                          onPressed: () =>
                              _openReaderPanel(ReaderPanelTab.search),
                          icon: const Icon(Icons.search),
                        ),
                        IconButton(
                          tooltip: _bookmarked
                              ? 'Remove bookmark'
                              : 'Add bookmark',
                          onPressed: bite == null ? null : _toggleBookmark,
                          icon: Icon(
                            _bookmarked
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                          ),
                        ),
                        IconButton(
                          tooltip: 'Reader settings',
                          onPressed: _showSettings,
                          icon: const Icon(Icons.text_fields),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            body: _originalView
                ? OriginalEpubView(
                    key: ValueKey('original-${widget.book.id}'),
                    epubPath: widget.book.filePath,
                    initialSpineIndex: _originalSpineIndex,
                    initialOffset: _canonicalSourceOffset,
                    onLocationChanged: _updateOriginalLocation,
                    onFirstReadable: _backfillCanonicalLocations,
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      final wide = constraints.maxWidth >= 900;
                      final reader = Column(
                        children: [
                          if (_showProgress && _chromeVisible)
                            LinearProgressIndicator(
                              value: _bookProgress,
                              minHeight: 2,
                              backgroundColor: Colors.transparent,
                            ),
                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, viewport) {
                                _paginate(viewport, paginationStyle);
                                return Listener(
                                  behavior: HitTestBehavior.opaque,
                                  onPointerDown: (event) {
                                    final insets =
                                        MediaQuery.systemGestureInsetsOf(
                                          context,
                                        );
                                    final width = MediaQuery.sizeOf(
                                      context,
                                    ).width;
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
                                    if (_ignoreHorizontalDrag ||
                                        _selectionActive) {
                                      return;
                                    }
                                    _drag += event.delta;
                                    if (_drag.dx.abs() <= _drag.dy.abs()) {
                                      return;
                                    }
                                    setState(() {
                                      _horizontalOffset += event.delta.dx;
                                      _dragPreview = _horizontalOffset < 0
                                          ? _OpenPanel.reader
                                          : _OpenPanel.dictionary;
                                    });
                                    _resetFocusTimer();
                                  },
                                  onPointerUp: (event) {
                                    if (_ignoreHorizontalDrag ||
                                        _selectionActive) {
                                      return;
                                    }
                                    if (_drag.distance < 8) {
                                      _toggleChrome();
                                      return;
                                    }
                                    var action = readerActionForDrag(_drag);
                                    setState(() {
                                      _horizontalOffset = 0;
                                      _dragPreview = null;
                                    });
                                    _perform(action);
                                  },
                                  onPointerCancel: (_) {
                                    setState(() {
                                      _drag = Offset.zero;
                                      _horizontalOffset = 0;
                                      _dragPreview = null;
                                    });
                                  },
                                  child: _pageController == null
                                      ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : NotificationListener<
                                          ScrollNotification
                                        >(
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
                                            key: ValueKey(_pageController),
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
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 0,
                                                      ),
                                                  child: Center(
                                                    child: ConstrainedBox(
                                                      constraints:
                                                          BoxConstraints(
                                                            maxWidth:
                                                                _readingWidth,
                                                          ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal:
                                                                  _pageMargin,
                                                            ),
                                                        child: Semantics(
                                                          label: 'Reading bite',
                                                          child:
                                                              pageBite.kind ==
                                                                  'figure'
                                                              ? _FigurePage(
                                                                  bite:
                                                                      pageBite,
                                                                  style:
                                                                      textStyle,
                                                                )
                                                              : _BiteText(
                                                                  database: widget
                                                                      .database,
                                                                  book: widget
                                                                      .book,
                                                                  bite:
                                                                      pageBite,
                                                                  startOffset: page
                                                                      .startOffset,
                                                                  endOffset: page
                                                                      .endOffset,
                                                                  style:
                                                                      textStyle,
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
                                                                  onLink:
                                                                      _followLink,
                                                                  plainReadingMode:
                                                                      _plainReadingMode,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      tooltip: 'Previous bite',
                                      onPressed: _index == 0
                                          ? null
                                          : () =>
                                                _perform(ReaderAction.previous),
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
                                          : () => _perform(
                                              ReaderAction.dictionary,
                                            ),
                                      icon: const Icon(
                                        Icons.menu_book_outlined,
                                      ),
                                    ),
                                    IconButton(
                                      tooltip: 'Next bite',
                                      onPressed: _index >= _pages.length - 1
                                          ? null
                                          : () => _perform(ReaderAction.next),
                                      icon: const Icon(
                                        Icons.keyboard_arrow_down,
                                      ),
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
                                if (panel != null)
                                  SizedBox(width: 380, child: panel),
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
                      final revealed = (_horizontalOffset.abs() / panelWidth)
                          .clamp(0, 1);
                      final translation = previewSelection == _OpenPanel.reader
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
                            right: previewSelection == _OpenPanel.reader
                                ? 0
                                : null,
                            left: previewSelection == _OpenPanel.dictionary
                                ? 0
                                : null,
                            child: AnimatedContainer(
                              duration: MediaQuery.disableAnimationsOf(context)
                                  ? Duration.zero
                                  : const Duration(milliseconds: 180),
                              curve: Curves.easeOutCubic,
                              transform: Matrix4.translationValues(
                                translation,
                                0,
                                0,
                              ),
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

  int get _canonicalSourceOffset {
    final index = _bites.indexWhere((bite) => bite.id == _anchorBiteId);
    if (index < 0) return _sourceOffset;
    return _bites[index].sourceStart + _sourceOffset;
  }

  double get _bookProgress {
    if (_bites.isEmpty) return 0;
    final biteIndex = _bites.indexWhere((bite) => bite.id == _anchorBiteId);
    if (biteIndex < 0) return 0;
    final length = _bites[biteIndex].content.length;
    final fraction = length == 0 ? 0.0 : (_sourceOffset / length).clamp(0, 1);
    return ((biteIndex + fraction) / _bites.length).clamp(0, 1);
  }

  void _paginate(BoxConstraints viewport, TextStyle style) {
    final width =
        (_paginationReadingWidth.clamp(0, viewport.maxWidth) -
                2 * _paginationPageMargin)
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
      _plainReadingMode,
    );
    if (_paginationSignature == signature) return;
    _paginationSignature = signature;
    final generation = ++_paginationGeneration;
    final biteId = _anchorBiteId;
    final paginationTask = TimelineTask()..start('Reader.pagination');
    unawaited(
      _repaginate(
        timelineTask: paginationTask,
        generation: generation,
        signature: signature,
        biteId: biteId,
        width: width,
        height: viewport.maxHeight,
        style: style,
        direction: Directionality.of(context),
        textScaler: textScaler,
      ),
    );
  }

  Future<void> _repaginate({
    required TimelineTask timelineTask,
    required int generation,
    required int signature,
    required String? biteId,
    required double width,
    required double height,
    required TextStyle style,
    required TextDirection direction,
    required TextScaler textScaler,
  }) async {
    final pagesByBite = <int, List<DisplayPage>>{};
    if (_bites.isEmpty) {
      timelineTask.finish(
        arguments: {'status': 'completed', 'bites': 0, 'pages': 0},
      );
      return;
    }
    final anchorIndex = _bites.indexWhere((bite) => bite.id == biteId);
    final targetIndex = anchorIndex < 0 ? 0 : anchorIndex;
    final windowStart = (targetIndex - _paginationWindowRadius).clamp(
      0,
      _bites.length - 1,
    );
    final windowEnd = (targetIndex + _paginationWindowRadius).clamp(
      0,
      _bites.length - 1,
    );
    final order = <int>[targetIndex];
    order.addAll(
      List.generate(windowEnd - targetIndex, (i) => targetIndex + i + 1),
    );
    order.addAll(
      List.generate(targetIndex - windowStart, (i) => targetIndex - i - 1),
    );
    final foregroundTask = TimelineTask()..start('Reader.foregroundPagination');
    var foregroundFinished = false;
    await WidgetsBinding.instance.endOfFrame;
    for (final biteIndex in order) {
      if (!mounted || generation != _paginationGeneration) {
        if (!foregroundFinished) {
          foregroundTask.finish(arguments: {'status': 'cancelled'});
        }
        timelineTask.finish(arguments: {'status': 'cancelled'});
        return;
      }
      final bite = _bites[biteIndex];
      final bitePages = Timeline.timeSync(
        'Reader.paginateBite',
        () => _paginationCache.pagesFor(
          bite: bite,
          width: width,
          height: height,
          style: style,
          textAlign: _alignment,
          textDirection: direction,
          textScaler: textScaler,
        ),
        arguments: {'biteId': bite.id, 'characters': bite.content.length},
      );
      pagesByBite[biteIndex] = _plainReadingMode && bite.kind != 'figure'
          ? bitePages.where((page) {
              final headings = _RichMetadata.parse(
                bite.markup,
              ).marks.where((mark) => mark.kind == 'heading');
              return !headings.any(
                (heading) =>
                    heading.start <= page.startOffset &&
                    heading.end >= page.endOffset,
              );
            }).toList()
          : bitePages;
      if (biteIndex == targetIndex || pagesByBite.length == order.length) {
        final pages = pagesByBite.entries.toList()
          ..sort((left, right) => left.key.compareTo(right.key));
        final publishedPages = pages.expand((entry) => entry.value).toList();
        await _publishPagination(
          pages: publishedPages,
          generation: generation,
          signature: signature,
        );
        if (!_firstReadableReported &&
            generation == _paginationGeneration &&
            publishedPages.isNotEmpty) {
          _firstReadableReported = true;
          Timeline.timeSync(
            'Reader.firstReadablePage',
            () {},
            arguments: {
              'biteId': publishedPages[_index].bite.id,
              'page': _index,
            },
          );
          _openTask.finish();
        }
      }
      if (biteIndex == targetIndex) {
        foregroundTask.finish(
          arguments: {'biteId': bite.id, 'pages': bitePages.length},
        );
        foregroundFinished = true;
      }
      await WidgetsBinding.instance.endOfFrame;
    }
    if (!mounted ||
        generation != _paginationGeneration ||
        signature != _paginationSignature) {
      timelineTask.finish(arguments: {'status': 'cancelled'});
      return;
    }
    timelineTask.finish(
      arguments: {
        'status': 'completed',
        'bites': order.length,
        'pages': _pages.length,
        'windowStart': windowStart,
        'windowEnd': windowEnd,
        'cacheEntries': _paginationCache.length,
        'cacheEvictions': _paginationCache.evictions,
      },
    );
    _materializedStart = windowStart;
    _materializedEnd = windowEnd;
  }

  Future<void> _publishPagination({
    required List<DisplayPage> pages,
    required int generation,
    required int signature,
  }) async {
    if (!mounted ||
        generation != _paginationGeneration ||
        signature != _paginationSignature) {
      return;
    }
    final biteId = _anchorBiteId;
    final offset = _sourceOffset;
    final restored = pages.indexWhere(
      (page) =>
          page.bite.id == biteId &&
          offset >= page.startOffset &&
          (offset < page.endOffset ||
              page.endOffset == page.bite.content.length),
    );
    final anchorBite = _bites.indexWhere((bite) => bite.id == biteId);
    final following = restored >= 0
        ? restored
        : pages.indexWhere((page) {
            final pageBite = _bites.indexWhere(
              (bite) => bite.id == page.bite.id,
            );
            return pageBite > anchorBite ||
                (pageBite == anchorBite && page.endOffset > offset);
          });
    final previousController = _pageController;
    final replacementController = PageController(
      initialPage: following < 0
          ? (pages.isEmpty ? 0 : pages.length - 1)
          : following,
    );
    setState(() {
      _pages = pages;
      _index = following < 0
          ? (pages.isEmpty ? 0 : pages.length - 1)
          : following;
      _pageController = replacementController;
      _restoringViewport = true;
    });
    await WidgetsBinding.instance.endOfFrame;
    previousController?.dispose();
    if (!mounted ||
        generation != _paginationGeneration ||
        !(_pageController?.hasClients ?? false)) {
      return;
    }
    _restoringViewport = false;
    setState(() {});
    if (_refreshBookmarkAfterPagination) {
      _refreshBookmarkAfterPagination = false;
      await _refreshBookmark();
    }
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Align(
    alignment: AlignmentDirectional.centerStart,
    child: Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 4),
      child: Text(label, style: Theme.of(context).textTheme.titleMedium),
    ),
  );
}

class _SettingsValue extends StatelessWidget {
  const _SettingsValue({
    required this.label,
    required this.value,
    required this.range,
    required this.onReset,
  });

  final String label;
  final String value;
  final String range;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(label),
    subtitle: Text('Current: $value · Range: $range'),
    trailing: IconButton(
      tooltip: 'Reset $label',
      onPressed: onReset,
      icon: const Icon(Icons.restart_alt),
    ),
  );
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
    required this.onLink,
    required this.plainReadingMode,
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
  final ValueChanged<String> onLink;
  final bool plainReadingMode;

  @override
  State<_BiteText> createState() => _BiteTextState();
}

class _BiteTextState extends State<_BiteText> {
  List<Highlight> _highlights = const [];
  final _linkRecognizers = <TapGestureRecognizer>[];

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

  @override
  void dispose() {
    for (final recognizer in _linkRecognizers) {
      recognizer.dispose();
    }
    super.dispose();
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
    for (final recognizer in _linkRecognizers) {
      recognizer.dispose();
    }
    _linkRecognizers.clear();
    final metadata = _RichMetadata.parse(widget.bite.markup);
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
    final boundaries = <int>{widget.startOffset, widget.endOffset};
    for (final mark in metadata.marks) {
      if (mark.end > widget.startOffset && mark.start < widget.endOffset) {
        boundaries
          ..add(mark.start.clamp(widget.startOffset, widget.endOffset))
          ..add(mark.end.clamp(widget.startOffset, widget.endOffset));
      }
    }
    for (final item in anchored) {
      final range = item.range!;
      if (range.end > widget.startOffset && range.start < widget.endOffset) {
        boundaries
          ..add(range.start.clamp(widget.startOffset, widget.endOffset))
          ..add(range.end.clamp(widget.startOffset, widget.endOffset));
      }
    }
    final points = boundaries.toList()..sort();
    return [
      for (var index = 0; index < points.length - 1; index++)
        _richSpan(
          content,
          points[index],
          points[index + 1],
          metadata,
          anchored,
        ),
    ];
  }

  TextSpan _richSpan(
    String content,
    int start,
    int end,
    _RichMetadata metadata,
    List<({Highlight highlight, ({int start, int end})? range})> highlights,
  ) {
    TextStyle? style;
    String? href;
    var text = content.substring(start, end);
    for (final mark in metadata.marks.where(
      (mark) => mark.start <= start && mark.end >= end,
    )) {
      final next = switch (mark.kind) {
        'heading' =>
          widget.plainReadingMode
              ? const TextStyle(fontSize: 0, height: 0)
              : TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: widget.style.fontSize,
                ),
        'bold' => const TextStyle(fontWeight: FontWeight.bold),
        'italic' => const TextStyle(fontStyle: FontStyle.italic),
        'blockquote' =>
          widget.plainReadingMode
              ? null
              : TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
        'footnote' => TextStyle(
          fontSize: (widget.style.fontSize ?? 20) * 0.9,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        'link' => TextStyle(
          color: Theme.of(context).colorScheme.primary,
          decoration: TextDecoration.underline,
        ),
        _ => null,
      };
      if (next != null) style = style?.merge(next) ?? next;
      if (mark.kind == 'link') href = mark.href;
      if (widget.plainReadingMode && mark.kind == 'heading') {
        text = '\u200B' * text.length;
      }
      if (widget.plainReadingMode &&
          (mark.kind == 'list' || mark.kind == 'blockquote')) {
        text = text.replaceAllMapped(
          RegExp(r'^\s*(?:(?:[-*+•‣◦]|\d+[.)])\s+|>\s*)', multiLine: true),
          (match) => '\u200B' * match.group(0)!.length,
        );
      }
    }
    for (final item in highlights) {
      final range = item.range;
      if (range != null && range.start <= start && range.end >= end) {
        final next = _highlightStyle(item.highlight);
        style = style?.merge(next) ?? next;
      }
    }
    GestureRecognizer? recognizer;
    if (href != null) {
      final link = TapGestureRecognizer()..onTap = () => widget.onLink(href!);
      _linkRecognizers.add(link);
      recognizer = link;
    }
    return TextSpan(text: text, style: style, recognizer: recognizer);
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

class _RichMetadata {
  const _RichMetadata(this.marks, this.anchors);

  final List<_RichMark> marks;
  final Map<String, int> anchors;

  static _RichMetadata parse(String? source) {
    if (source == null || source.isEmpty) {
      return const _RichMetadata([], {});
    }
    try {
      final json = jsonDecode(source) as Map<String, dynamic>;
      return _RichMetadata(
        [
          for (final value in json['marks'] as List<dynamic>? ?? const [])
            _RichMark.fromJson(value as Map<String, dynamic>),
        ],
        (json['anchors'] as Map<String, dynamic>? ?? const {}).map(
          (key, value) => MapEntry(key, value as int),
        ),
      );
    } on FormatException {
      return const _RichMetadata([], {});
    }
  }
}

class _RichMark {
  const _RichMark(this.start, this.end, this.kind, this.href);

  factory _RichMark.fromJson(Map<String, dynamic> json) => _RichMark(
    json['start'] as int,
    json['end'] as int,
    json['kind'] as String,
    json['href'] as String?,
  );

  final int start;
  final int end;
  final String kind;
  final String? href;
}
