import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:path/path.dart' as path;
import 'package:xml/xml.dart';

const _csp =
    "default-src 'self' data: blob:; script-src 'none'; "
    "connect-src 'none'; frame-src 'none'; object-src 'none'; "
    "form-action 'none'; base-uri 'self'";

class OriginalEpubPublication {
  OriginalEpubPublication._({
    required this.resources,
    required this.spinePaths,
    required this.isFixedLayout,
    required this.hasScriptedContent,
    required this.renditionFlow,
  });

  factory OriginalEpubPublication.fromBytes(List<int> bytes) {
    final archive = ZipDecoder().decodeBytes(bytes, verify: true);
    final resources = <String, Uint8List>{};
    for (final file in archive.files) {
      final safe = _safePath(file.name);
      if (file.isFile && safe != null) {
        resources[safe] = Uint8List.fromList(file.content as List<int>);
      }
    }
    final container = _xml(resources['META-INF/container.xml']);
    final packagePath = _safePath(
      container.findAllElements('rootfile').first.getAttribute('full-path') ??
          '',
    );
    if (packagePath == null || !resources.containsKey(packagePath)) {
      throw const FormatException('EPUB package is missing.');
    }
    final package = _xml(resources[packagePath]);
    final packageDirectory = path.posix.dirname(packagePath);
    final manifest = <String, ({String path, String properties})>{};
    for (final item in package.findAllElements('item')) {
      final id = item.getAttribute('id');
      final href = item.getAttribute('href');
      if (id == null || href == null) continue;
      final resolved = _safePath(path.posix.join(packageDirectory, href));
      if (resolved != null) {
        manifest[id] = (
          path: resolved,
          properties: item.getAttribute('properties') ?? '',
        );
      }
    }
    final spine = package
        .findAllElements('itemref')
        .map((item) {
          final idref = item.getAttribute('idref');
          return idref == null ? null : manifest[idref]?.path;
        })
        .whereType<String>()
        .toList();
    final metadataLayout = package
        .findAllElements('meta')
        .where(
          (element) => element.getAttribute('property') == 'rendition:layout',
        )
        .map((element) => element.innerText.trim())
        .contains('pre-paginated');
    final renditionFlow = package
        .findAllElements('meta')
        .where(
          (element) => element.getAttribute('property') == 'rendition:flow',
        )
        .map((element) => element.innerText.trim())
        .firstOrNull;
    final itemrefLayout = package
        .findAllElements('itemref')
        .any(
          (item) => (item.getAttribute('properties') ?? '')
              .split(RegExp(r'\s+'))
              .contains('rendition:layout-pre-paginated'),
        );
    final manifestScripted = manifest.values.any(
      (item) => item.properties.split(RegExp(r'\s+')).contains('scripted'),
    );
    final sourceScripted = spine.any((file) {
      final source = utf8.decode(
        resources[file] ?? const [],
        allowMalformed: true,
      );
      return RegExp(
        r'<\s*(script|form)\b',
        caseSensitive: false,
      ).hasMatch(source);
    });
    return OriginalEpubPublication._(
      resources: Map.unmodifiable(resources),
      spinePaths: List.unmodifiable(spine),
      isFixedLayout: metadataLayout || itemrefLayout,
      hasScriptedContent: manifestScripted || sourceScripted,
      renditionFlow: renditionFlow,
    );
  }

  final Map<String, Uint8List> resources;
  final List<String> spinePaths;
  final bool isFixedLayout;
  final bool hasScriptedContent;
  final String? renditionFlow;

  Future<OriginalEpubServer> serve() => OriginalEpubServer._start(this);
}

class OriginalEpubServer {
  OriginalEpubServer._(
    this._publication,
    this._server,
    this._token,
    this.origin,
  );

  static Future<OriginalEpubServer> _start(
    OriginalEpubPublication publication,
  ) async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final token = List.generate(
      24,
      (_) => Random.secure().nextInt(256).toRadixString(16).padLeft(2, '0'),
    ).join();
    final origin = Uri.parse('http://127.0.0.1:${server.port}/$token/');
    final result = OriginalEpubServer._(publication, server, token, origin);
    server.listen(result._handle);
    return result;
  }

  final OriginalEpubPublication _publication;
  final HttpServer _server;
  final String _token;
  final Uri origin;

  Uri spineUri(int index, {String? fragment}) => origin
      .resolve(_publication.spinePaths[index])
      .replace(fragment: fragment);

  String spinePath(int index) => _publication.spinePaths[index];

  bool owns(Uri uri) =>
      uri.scheme == origin.scheme &&
      uri.host == origin.host &&
      uri.port == origin.port &&
      uri.path.startsWith(origin.path);

  int? adjacentLinearSpine(int index, int delta) {
    final next = index + delta;
    return next < 0 || next >= _publication.spinePaths.length ? null : next;
  }

  int? spineIndexFor(Uri uri) {
    if (uri.host != origin.host || uri.port != origin.port) return null;
    final prefix = origin.path;
    if (!uri.path.startsWith(prefix)) return null;
    final resource = _safePath(
      Uri.decodeComponent(uri.path.substring(prefix.length)),
    );
    final index = resource == null
        ? -1
        : _publication.spinePaths.indexOf(resource);
    return index < 0 ? null : index;
  }

  Future<void> close() => _server.close(force: true);

  Future<void> _handle(HttpRequest request) async {
    final prefix = '/$_token/';
    final rawPath = request.uri.path;
    final resourcePath = rawPath.startsWith(prefix)
        ? _safePath(Uri.decodeComponent(rawPath.substring(prefix.length)))
        : null;
    final bytes = resourcePath == null
        ? null
        : _publication.resources[resourcePath];
    if (request.method != 'GET' || bytes == null) {
      request.response.statusCode = HttpStatus.notFound;
      await request.response.close();
      return;
    }
    final mediaType = _mediaType(resourcePath!);
    final isHtml =
        mediaType == 'application/xhtml+xml' || mediaType == 'text/html';
    request.response.headers
      ..contentType = ContentType.parse(
        isHtml ? '$mediaType; charset=utf-8' : mediaType,
      )
      ..set('Content-Security-Policy', _csp)
      ..set('X-Content-Type-Options', 'nosniff')
      ..set('Cache-Control', 'private, max-age=300');
    if (isHtml) {
      final source = utf8.decode(bytes, allowMalformed: true);
      request.response.add(utf8.encode(_withCsp(_withUtf8Encoding(source))));
    } else {
      request.response.add(bytes);
    }
    await request.response.close();
  }
}

XmlDocument _xml(Uint8List? bytes) {
  if (bytes == null) throw const FormatException('EPUB metadata is missing.');
  return XmlDocument.parse(utf8.decode(bytes, allowMalformed: true));
}

String? _safePath(String value) {
  final decoded = Uri.decodeComponent(value.replaceAll('\\', '/'));
  if (decoded.startsWith('/') || decoded.contains('\x00')) return null;
  final normalized = path.posix.normalize(decoded);
  if (normalized == '.' || normalized == '..' || normalized.startsWith('../')) {
    return null;
  }
  return normalized;
}

String _withUtf8Encoding(String source) {
  final xmlDeclaration = RegExp(r'<\?xml\b[^?]*\?>', caseSensitive: false);
  final meta = RegExp(r'<meta\b[^>]*>', caseSensitive: false);
  final encoding = RegExp(
    r'''(encoding\s*=\s*)(["'])[^"']+\2''',
    caseSensitive: false,
  );
  final charset = RegExp(
    r'''(charset\s*=\s*)(["']?)[^"'\s;>]+\2''',
    caseSensitive: false,
  );
  String normalize(String value, RegExp attribute) => value.replaceAllMapped(
    attribute,
    (match) => '${match[1]}${match[2]}UTF-8${match[2]}',
  );
  return source
      .replaceAllMapped(
        xmlDeclaration,
        (match) => normalize(match[0]!, encoding),
      )
      .replaceAllMapped(meta, (match) => normalize(match[0]!, charset));
}

String _withCsp(String source) {
  final meta = '<meta http-equiv="Content-Security-Policy" content="$_csp"/>';
  final head = RegExp(
    r'<head(?:\s[^>]*)?>',
    caseSensitive: false,
  ).firstMatch(source);
  if (head != null) return source.replaceRange(head.end, head.end, meta);
  final html = RegExp(
    r'<html(?:\s[^>]*)?>',
    caseSensitive: false,
  ).firstMatch(source);
  if (html != null) {
    return source.replaceRange(html.end, html.end, '<head>$meta</head>');
  }
  return '<html><head>$meta</head><body>$source</body></html>';
}

String _mediaType(String file) => switch (path.extension(file).toLowerCase()) {
  '.xhtml' || '.html' || '.htm' => 'application/xhtml+xml',
  '.css' => 'text/css',
  '.svg' => 'image/svg+xml',
  '.png' => 'image/png',
  '.jpg' || '.jpeg' => 'image/jpeg',
  '.gif' => 'image/gif',
  '.webp' => 'image/webp',
  '.woff' => 'font/woff',
  '.woff2' => 'font/woff2',
  '.otf' => 'font/otf',
  '.ttf' => 'font/ttf',
  _ => 'application/octet-stream',
};
