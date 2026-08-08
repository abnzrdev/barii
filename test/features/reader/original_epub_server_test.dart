import 'dart:convert';
import 'dart:io';

import 'package:bookbites/features/reader/data/original_epub_server.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/epub_fixture.dart';

void main() {
  test('serves only managed EPUB resources with restrictive CSP', () async {
    final publication = OriginalEpubPublication.fromBytes(epubFixtureBytes());
    final server = await publication.serve();
    addTearDown(server.close);

    final response = await _get(server.spineUri(0));
    expect(response.statusCode, HttpStatus.ok);
    expect(
      response.headers.value('content-security-policy'),
      contains("script-src 'none'"),
    );
    expect(response.body, contains('First safe sentence.'));
    expect(response.body, contains('Content-Security-Policy'));

    final blocked = await _get(server.origin.resolve('%2e%2e/pubspec.yaml'));
    expect(blocked.statusCode, HttpStatus.notFound);
  });

  test('serves transformed XHTML as UTF-8 without losing Unicode', () async {
    const unicode = 'ASCII — “curly” isn’t lost; café; العربية; 漢字; emoji 😀.';
    const xhtml =
        '''<?xml version="1.0" encoding="windows-1252"?>
<html xmlns="http://www.w3.org/1999/xhtml"><head>
<meta http-equiv="Content-Type" content="application/xhtml+xml; charset=windows-1252"/>
</head><body><p>$unicode</p><p>Note<sup><a href="#note-1">1</a></sup></p>
<aside id="note-1" epub:type="footnote">Unicode footnote — café.</aside>
</body></html>''';
    final publication = OriginalEpubPublication.fromBytes(
      epubFixtureBytes(firstXhtml: xhtml, figures: true),
    );
    final server = await publication.serve();
    addTearDown(server.close);

    final response = await _get(server.spineUri(0));
    expect(response.statusCode, HttpStatus.ok);
    expect(response.headers.contentType?.mimeType, 'application/xhtml+xml');
    expect(response.headers.contentType?.charset, 'utf-8');
    expect(response.body, contains(unicode));
    expect(response.body, contains('Unicode footnote — café.'));
    expect(response.body, contains('Content-Security-Policy'));
    expect(response.body, contains('encoding="UTF-8"'));
    expect(response.body, isNot(contains('charset=windows-1252')));

    final originalImage = base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=',
    );
    final image = await _get(server.origin.resolve('OEBPS/images/dot.png'));
    expect(image.statusCode, HttpStatus.ok);
    expect(image.headers.contentType?.mimeType, 'image/png');
    expect(image.bytes, originalImage);
  });

  test('spine resources retain order and managed relative assets', () async {
    final publication = OriginalEpubPublication.fromBytes(
      epubFixtureBytes(figures: true),
    );
    final server = await publication.serve();
    addTearDown(server.close);

    expect(publication.spinePaths, ['OEBPS/one.xhtml', 'OEBPS/two.xhtml']);
    final image = await _get(server.origin.resolve('OEBPS/images/dot.png'));
    expect(image.statusCode, HttpStatus.ok);
    expect(image.headers.contentType?.mimeType, 'image/png');
  });

  test('detects fixed-layout and scripted publications', () {
    final fixed = OriginalEpubPublication.fromBytes(
      epubFixtureBytes(canonicalSemantics: true),
    );
    expect(fixed.isFixedLayout, isTrue);

    final scripted = OriginalEpubPublication.fromBytes(epubFixtureBytes());
    expect(scripted.hasScriptedContent, isTrue);
  });

  test('reads the publisher preferred reflowable presentation', () {
    final paginated = OriginalEpubPublication.fromBytes(
      epubFixtureBytes(renditionFlow: 'paginated'),
    );
    final scrolled = OriginalEpubPublication.fromBytes(
      epubFixtureBytes(renditionFlow: 'scrolled-doc'),
    );

    expect(paginated.renditionFlow, 'paginated');
    expect(scrolled.renditionFlow, 'scrolled-doc');
  });

  test(
    'reads progression direction and skips non-linear spine items',
    () async {
      final publication = OriginalEpubPublication.fromBytes(
        epubFixtureBytes(
          pageProgressionDirection: 'rtl',
          nonLinearMiddle: true,
        ),
      );
      final server = await publication.serve();
      addTearDown(server.close);

      expect(publication.pageProgressionDirection, 'rtl');
      expect(publication.spinePaths, [
        'OEBPS/one.xhtml',
        'OEBPS/aside.xhtml',
        'OEBPS/two.xhtml',
      ]);
      expect(server.adjacentLinearSpine(0, 1), 2);
      expect(server.adjacentLinearSpine(2, -1), 0);
    },
  );
}

Future<({int statusCode, HttpHeaders headers, List<int> bytes, String body})>
_get(Uri uri) async {
  final client = HttpClient();
  try {
    final request = await client.getUrl(uri);
    final response = await request.close();
    final bytes = await response.fold<List<int>>(
      [],
      (result, chunk) => result..addAll(chunk),
    );
    return (
      statusCode: response.statusCode,
      headers: response.headers,
      bytes: bytes,
      body: utf8.decode(bytes, allowMalformed: true),
    );
  } finally {
    client.close(force: true);
  }
}
