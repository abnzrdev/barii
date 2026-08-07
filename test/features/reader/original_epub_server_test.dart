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
}

Future<({int statusCode, HttpHeaders headers, String body})> _get(
  Uri uri,
) async {
  final client = HttpClient();
  try {
    final request = await client.getUrl(uri);
    final response = await request.close();
    final bytes = await response.fold<List<int>>(
      [],
      (result, chunk) => result..addAll(chunk),
    );
    final body = String.fromCharCodes(bytes);
    return (
      statusCode: response.statusCode,
      headers: response.headers,
      body: body,
    );
  } finally {
    client.close(force: true);
  }
}
