import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_all/webview_all.dart';

import '../data/original_epub_server.dart';
import 'original_epub_navigator.dart';

class OriginalEpubView extends StatefulWidget {
  const OriginalEpubView({
    super.key,
    required this.epubPath,
    required this.initialSpineIndex,
    required this.initialOffset,
    required this.onLocationChanged,
    this.onFirstReadable,
  });

  final String epubPath;
  final int initialSpineIndex;
  final int initialOffset;
  final ValueChanged<OriginalEpubLocation> onLocationChanged;
  final VoidCallback? onFirstReadable;

  @override
  State<OriginalEpubView> createState() => _OriginalEpubViewState();
}

class _OriginalEpubViewState extends State<OriginalEpubView> {
  OriginalEpubServer? _server;
  WebViewController? _controller;
  Object? _error;
  var _spineIndex = 0;
  var _generation = 0;
  var _lastOffset = 0;
  String? _pendingFragment;
  final _openTask = TimelineTask()..start('OriginalEpub.open');
  var _reportedReadable = false;

  @override
  void initState() {
    super.initState();
    _open();
  }

  Future<void> _open() async {
    try {
      final publication = OriginalEpubPublication.fromBytes(
        await File(widget.epubPath).readAsBytes(),
      );
      if (publication.spinePaths.isEmpty) {
        throw const FormatException('This EPUB has no readable spine.');
      }
      if (publication.isFixedLayout) {
        throw UnsupportedError(
          'Original view does not yet support fixed-layout EPUBs.',
        );
      }
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
      await controller.addJavaScriptChannel(
        'BookBitesLocation',
        onMessageReceived: _receiveLocation,
      );
      await controller.setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) => _navigate(request.url, server),
          onPageFinished: (url) {
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
        ),
      );
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
    if (value['type'] == 'link' && value['href'] is String) {
      unawaited(_goTo(Uri.parse(value['href'] as String)));
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
          presentation: OriginalEpubPresentation.scroll,
          initialOffset: _lastOffset == 0 ? widget.initialOffset : _lastOffset,
          initialFragment: _pendingFragment,
          generation: _generation,
        ).source,
      );
    } on Object {
      // Rendering remains useful if a platform cannot expose relocation.
    }
  }

  Future<void> _goTo(Uri uri) async {
    final server = _server;
    final controller = _controller;
    if (server == null || controller == null || !server.owns(uri)) return;
    final index = server.spineIndexFor(uri);
    if (index == null) return;
    _generation++;
    _spineIndex = index;
    _lastOffset = 0;
    _pendingFragment = uri.fragment.isEmpty ? null : uri.fragment;
    await controller.runJavaScript(OriginalEpubNavigatorScript.teardown);
    await controller.loadRequest(uri);
  }

  Future<void> _moveSpine(int delta) async {
    final server = _server;
    if (server == null) return;
    final index = server.adjacentLinearSpine(_spineIndex, delta);
    if (index != null) await _goTo(server.spineUri(index));
  }

  @override
  void dispose() {
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
          child: Text(error.toString(), textAlign: TextAlign.center),
        ),
      );
    }
    final controller = _controller;
    if (controller == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Stack(
      children: [
        WebViewWidget(controller: controller),
        Positioned(
          left: 8,
          bottom: 8,
          child: IconButton.filledTonal(
            tooltip: 'Previous EPUB section',
            onPressed: () => _moveSpine(-1),
            icon: const Icon(Icons.chevron_left),
          ),
        ),
        Positioned(
          right: 8,
          bottom: 8,
          child: IconButton.filledTonal(
            tooltip: 'Next EPUB section',
            onPressed: () => _moveSpine(1),
            icon: const Icon(Icons.chevron_right),
          ),
        ),
      ],
    );
  }
}
