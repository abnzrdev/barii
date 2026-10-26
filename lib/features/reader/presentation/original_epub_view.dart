import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_all/webview_all.dart';

import '../data/original_epub_server.dart';
import 'original_epub_navigator.dart';
import '../../dictionary/domain/reader_word_selection.dart';

class OriginalEpubView extends StatefulWidget {
  const OriginalEpubView({
    super.key,
    required this.epubPath,
    required this.initialSpineIndex,
    required this.initialOffset,
    required this.onLocationChanged,
    this.fontFamily = 'serif',
    this.fontSize = 20,
    this.lineHeight = 1.6,
    this.readingWidth = 680,
    this.pageMargin = 24,
    this.backgroundColor = const Color(0xfff4f1ea),
    this.textColor = const Color(0xff2d3321),
    this.onFirstReadable,
    this.onToggleFullscreen,
    this.onEscape,
    this.onWordPreview,
    this.onWordExpand,
    this.onWordDismiss,
    this.returnLocator,
  });

  final String epubPath;
  final int initialSpineIndex;
  final int initialOffset;
  final ValueChanged<OriginalEpubLocation> onLocationChanged;
  final String fontFamily;
  final double fontSize;
  final double lineHeight;
  final double readingWidth;
  final double pageMargin;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onFirstReadable;
  final VoidCallback? onToggleFullscreen;
  final VoidCallback? onEscape;
  final void Function(ReaderWordSelection, Rect)? onWordPreview;
  final ValueChanged<ReaderWordSelection>? onWordExpand;
  final VoidCallback? onWordDismiss;
  final Map<String, dynamic>? returnLocator;

  @override
  State<OriginalEpubView> createState() => _OriginalEpubViewState();
}

class _OriginalEpubViewState extends State<OriginalEpubView>
    with WidgetsBindingObserver {
  OriginalEpubServer? _server;
  WebViewController? _controller;
  Object? _error;
  var _spineIndex = 0;
  var _generation = 0;
  var _lastOffset = 0;
  String? _pendingFragment;
  String _pageProgressionDirection = 'default';
  final _history = <({Uri uri, int offset})>[];
  final _webviewKey = GlobalKey();
  var _navigationInFlight = false;
  final _openTask = TimelineTask()..start('OriginalEpub.open');
  var _reportedReadable = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _open();
  }

  @override
  void didUpdateWidget(covariant OriginalEpubView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fontFamily != widget.fontFamily ||
        oldWidget.fontSize != widget.fontSize ||
        oldWidget.lineHeight != widget.lineHeight ||
        oldWidget.readingWidth != widget.readingWidth ||
        oldWidget.pageMargin != widget.pageMargin ||
        oldWidget.backgroundColor != widget.backgroundColor ||
        oldWidget.textColor != widget.textColor) {
      _generation++;
      unawaited(_installNavigator());
    }
  }

  Future<void> _open() async {
    final previousServer = _server;
    _server = null;
    if (previousServer != null) await previousServer.close();
    if (mounted) {
      setState(() {
        _error = null;
        _controller = null;
      });
    }
    try {
      final publication = await OriginalEpubPublication.openFile(
        widget.epubPath,
      );
      if (publication.spinePaths.isEmpty) {
        throw const FormatException('This EPUB has no readable spine.');
      }
      if (publication.isFixedLayout) {
        throw UnsupportedError(
          'Original view does not yet support fixed-layout EPUBs.',
        );
      }
      _pageProgressionDirection = publication.pageProgressionDirection;
      final server = await publication.serve();
      if (!mounted) {
        await server.close();
        return;
      }
      _spineIndex = widget.initialSpineIndex.clamp(
        0,
        publication.spinePaths.length - 1,
      );
      final controller = WebViewController(
        onPermissionRequest: (request) => request.deny(),
      );
      await controller.setJavaScriptMode(JavaScriptMode.unrestricted);
      if (!mounted) {
        await server.close();
        return;
      }
      await controller.addJavaScriptChannel(
        'BariiLocation',
        onMessageReceived: _receiveLocation,
      );
      await controller.setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) => _navigate(request.url, server),
          onPageFinished: (url) {
            _navigationInFlight = false;
            final index = server.spineIndexFor(Uri.parse(url));
            if (index != null) _spineIndex = index;
            _installNavigator();
            if (!_reportedReadable) {
              _reportedReadable = true;
              Timeline.timeSync('OriginalEpub.firstReadable', () {});
              _openTask.finish();
              widget.onFirstReadable?.call();
            }
          },
          onWebResourceError: (error) {
            if (error.isForMainFrame == true) _navigationInFlight = false;
          },
        ),
      );
      if (!mounted) {
        await server.close();
        return;
      }
      setState(() {
        _server = server;
        _controller = controller;
      });
      await controller.loadRequest(server.spineUri(_spineIndex));
    } catch (error) {
      if (!_reportedReadable) {
        _reportedReadable = true;
        _openTask.finish(arguments: {'error': error.runtimeType.toString()});
      }
      if (mounted) setState(() => _error = error);
    }
  }

  Future<NavigationDecision> _navigate(
    String value,
    OriginalEpubServer server,
  ) async {
    final uri = Uri.tryParse(value);
    if (uri == null) return NavigationDecision.prevent;
    if (uri.scheme == 'http' &&
        uri.host == server.origin.host &&
        uri.port == server.origin.port &&
        uri.path.startsWith(server.origin.path)) {
      return NavigationDecision.navigate;
    }
    if (uri.scheme != 'http' && uri.scheme != 'https') {
      return NavigationDecision.prevent;
    }
    if (!mounted) return NavigationDecision.prevent;
    final open = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Open external link?'),
        content: Text(uri.toString()),
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
    if (open == true) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    return NavigationDecision.prevent;
  }

  void _receiveLocation(JavaScriptMessage message) {
    final value = jsonDecode(message.message);
    if (value is! Map<String, dynamic> || value['generation'] != _generation) {
      return;
    }
    if (value['type'] == 'word') {
      if (value['action'] == 'dismiss') {
        widget.onWordDismiss?.call();
        return;
      }
      final word = value['word'];
      if (word is! String || word.isEmpty || word.length > 160) return;
      final locator = jsonEncode({
        'renderer': 'original',
        'href': _server?.spinePath(_spineIndex),
        'spineIndex': _spineIndex,
        'startOffset': value['startOffset'],
        'endOffset': value['endOffset'],
        'quote': word,
        'before': value['before'],
        'after': value['after'],
      });
      final selection = ReaderWordSelection(
        word: word,
        context: value['context'] as String? ?? word,
        contextOffset: value['contextOffset'] as int? ?? 0,
        startOffset: value['startOffset'] as int?,
        endOffset: value['endOffset'] as int?,
        canonicalLocator: locator,
      );
      if (value['action'] == 'expand') {
        widget.onWordExpand?.call(selection);
        return;
      }
      final box = _webviewKey.currentContext?.findRenderObject() as RenderBox?;
      if (box == null || value['rect'] is! Map) return;
      final rect = value['rect'] as Map;
      final origin = box.localToGlobal(Offset.zero);
      widget.onWordPreview?.call(
        selection,
        Rect.fromLTWH(
          origin.dx + (rect['x'] as num).toDouble(),
          origin.dy + (rect['y'] as num).toDouble(),
          (rect['width'] as num).toDouble(),
          (rect['height'] as num).toDouble(),
        ),
      );
      return;
    }
    if (value['type'] == 'link' && value['href'] is String) {
      unawaited(_goTo(Uri.parse(value['href'] as String), addHistory: true));
      return;
    }
    if (value['type'] == 'boundary' && value['delta'] is num) {
      unawaited(_moveSpine((value['delta'] as num).sign.toInt()));
      return;
    }
    if (value['type'] == 'key') {
      switch (value['action']) {
        case 'previous':
          unawaited(_turn(-1));
        case 'next':
          unawaited(_turn(1));
        case 'back':
          unawaited(_goBack());
        case 'fullscreen':
          widget.onToggleFullscreen?.call();
        case 'escape':
          widget.onEscape?.call();
      }
      return;
    }
    if (value['type'] != 'relocate') return;
    final server = _server;
    if (server == null) return;
    final location = OriginalEpubLocation.fromMessage(
      message.message,
      spineIndex: _spineIndex,
      href: server.spinePath(_spineIndex),
    );
    _lastOffset = location.offset;
    widget.onLocationChanged(location);
  }

  Future<void> _installNavigator() async {
    final controller = _controller;
    if (controller == null) return;
    try {
      await controller.runJavaScript(
        OriginalEpubNavigatorScript(
          returnLocator: widget.returnLocator,
          presentation: OriginalEpubPresentation.scroll,
          initialOffset: _lastOffset == 0 ? widget.initialOffset : _lastOffset,
          initialFragment: _pendingFragment,
          generation: _generation,
          pageProgressionDirection: _pageProgressionDirection,
          fontFamily: widget.fontFamily,
          fontSize: widget.fontSize,
          lineHeight: widget.lineHeight,
          readingWidth: widget.readingWidth,
          pageMargin: widget.pageMargin,
          backgroundColor: _cssColor(widget.backgroundColor),
          textColor: _cssColor(widget.textColor),
        ).source,
      );
    } on Object catch (error) {
      debugPrint('Could not apply EPUB reader layout: $error');
    }
  }

  Future<void> _goTo(Uri uri, {bool addHistory = false, int offset = 0}) async {
    final server = _server;
    final controller = _controller;
    if (server == null ||
        controller == null ||
        !server.owns(uri) ||
        _navigationInFlight) {
      return;
    }
    final index = server.spineIndexFor(uri);
    if (index == null) return;
    _navigationInFlight = true;
    if (addHistory) {
      _history.add((uri: server.spineUri(_spineIndex), offset: _lastOffset));
      if (mounted) setState(() {});
    }
    try {
      _generation++;
      _spineIndex = index;
      _lastOffset = offset;
      _pendingFragment = uri.fragment.isEmpty ? null : uri.fragment;
      await controller.runJavaScript(OriginalEpubNavigatorScript.teardown);
      await controller.loadRequest(uri);
    } catch (_) {
      _navigationInFlight = false;
      rethrow;
    }
  }

  Future<void> _goBack() async {
    if (_history.isEmpty || _navigationInFlight) return;
    final target = _history.removeLast();
    if (mounted) setState(() {});
    await _goTo(target.uri, offset: target.offset);
  }

  Future<void> _moveSpine(int delta) async {
    final server = _server;
    if (server == null) return;
    final index = server.adjacentLinearSpine(_spineIndex, delta);
    if (index != null) await _goTo(server.spineUri(index));
  }

  Future<void> _turn(int delta) async {
    await _moveSpine(delta);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null) return;
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      unawaited(
        controller.runJavaScript('window.__bariiOriginalReader?.report();'),
      );
    } else if (state == AppLifecycleState.resumed) {
      _generation++;
      unawaited(_installNavigator());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (!_reportedReadable) {
      _reportedReadable = true;
      _openTask.finish(arguments: {'cancelled': true});
    }
    final controller = _controller;
    if (controller != null) {
      unawaited(controller.runJavaScript(OriginalEpubNavigatorScript.teardown));
    }
    _generation++;
    _server?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final error = _error;
    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: 16),
              const Text(
                'This book could not be opened in Original view.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(error.toString(), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _open,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    final controller = _controller;
    if (controller == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Stack(
      children: [
        WebViewWidget(key: _webviewKey, controller: controller),
        if (_history.isNotEmpty)
          Positioned(
            top: 8,
            left: 8,
            child: IconButton.filledTonal(
              tooltip: 'Previous EPUB location',
              onPressed: _goBack,
              icon: const Icon(Icons.history),
            ),
          ),
      ],
    );
  }
}

String _cssColor(Color color) =>
    '#${(color.toARGB32() & 0xffffff).toRadixString(16).padLeft(6, '0')}';
