import 'package:archive/archive.dart';
import 'package:bookbites/features/library/data/epub_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const parser = EpubParser();

  test('extracts metadata and sanitized chapters in spine order', () async {
    final publication = await parser.parse(_epubBytes());

    expect(publication.title, 'Fixture Book');
    expect(publication.author, 'Fixture Author');
    expect(publication.sections.map((section) => section.heading), [
      'Chapter One',
      'Chapter Two',
    ]);
    expect(publication.sections.first.paragraphs, [
      'First safe sentence.',
      'Second safe sentence.',
    ]);
    expect(
      publication.sections.expand((section) => section.paragraphs).join(' '),
      isNot(contains('remove me')),
    );
  });

  test('reports invalid archives without leaking parser errors', () async {
    expect(() => parser.parse([1, 2, 3]), throwsA(isA<BookParseException>()));
  });

  test('rejects encrypted EPUB resources', () async {
    expect(
      () => parser.parse(_epubBytes(encrypted: true)),
      throwsA(isA<UnsupportedDrmException>()),
    );
  });

  test('extracts nested list paragraphs exactly once', () async {
    final publication = await parser.parse(_epubBytes(nestedList: true));
    const text = 'If you are a coach, build a reliable system.';

    expect(
      publication.sections.expand((section) => section.paragraphs),
      contains(text),
    );
    expect(
      publication.sections
          .expand((section) => section.paragraphs)
          .where((paragraph) => paragraph == text),
      hasLength(1),
    );
  });
}

List<int> _epubBytes({bool encrypted = false, bool nestedList = false}) {
  final archive = Archive()
    ..addFile(ArchiveFile.string('mimetype', 'application/epub+zip'))
    ..addFile(
      ArchiveFile.string('META-INF/container.xml', '''<?xml version="1.0"?>
<container xmlns="urn:oasis:names:tc:opendocument:xmlns:container">
<rootfiles><rootfile full-path="OEBPS/content.opf"
media-type="application/oebps-package+xml"/></rootfiles></container>'''),
    )
    ..addFile(
      ArchiveFile.string(
        'OEBPS/content.opf',
        '''<?xml version="1.0" encoding="UTF-8"?>
<package xmlns="http://www.idpf.org/2007/opf" version="3.0"
unique-identifier="id"><metadata xmlns:dc="http://purl.org/dc/elements/1.1/">
<dc:identifier id="id">fixture</dc:identifier>
<dc:title>Fixture Book</dc:title><dc:creator>Fixture Author</dc:creator>
<dc:language>en</dc:language></metadata><manifest>
<item id="nav" href="nav.xhtml" media-type="application/xhtml+xml"
properties="nav"/><item id="one" href="one.xhtml"
media-type="application/xhtml+xml"/><item id="two" href="two.xhtml"
media-type="application/xhtml+xml"/></manifest>
<spine><itemref idref="one"/><itemref idref="two"/></spine></package>''',
      ),
    )
    ..addFile(
      ArchiveFile.string(
        'OEBPS/nav.xhtml',
        '''<html xmlns="http://www.w3.org/1999/xhtml"><head><title>TOC</title></head><body><nav>
<ol><li><a href="one.xhtml">Chapter One</a></li>
<li><a href="two.xhtml">Chapter Two</a></li></ol></nav></body></html>''',
      ),
    )
    ..addFile(
      ArchiveFile.string(
        'OEBPS/one.xhtml',
        '''<html><body><h1>Chapter One</h1><script>remove me</script>
<p>First safe sentence.</p><p>Second safe sentence.</p>
${nestedList ? '<ul><li><p>If you are a coach, build a reliable system.</p></li></ul>' : ''}
</body></html>''',
      ),
    )
    ..addFile(
      ArchiveFile.string(
        'OEBPS/two.xhtml',
        '<html><body><h1>Chapter Two</h1><p>你好，世界。</p></body></html>',
      ),
    );
  if (encrypted) {
    archive.addFile(
      ArchiveFile.string(
        'META-INF/encryption.xml',
        '<encryption><EncryptedData/></encryption>',
      ),
    );
  }
  return ZipEncoder().encode(archive)!;
}
