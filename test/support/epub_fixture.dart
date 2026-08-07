import 'package:archive/archive.dart';
import 'dart:convert';

List<int> epubFixtureBytes({
  bool encrypted = false,
  bool nestedList = false,
  bool anchoredNavigation = false,
  bool emptyContent = false,
  bool figures = false,
  bool richText = false,
  bool canonicalSemantics = false,
}) {
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
<dc:language>${canonicalSemantics ? 'ar' : 'en'}</dc:language>
${canonicalSemantics ? '<meta property="rendition:layout">pre-paginated</meta>' : ''}</metadata><manifest>
<item id="nav" href="nav.xhtml" media-type="application/xhtml+xml"
properties="nav"/><item id="one" href="one.xhtml"
media-type="application/xhtml+xml"/><item id="two" href="two.xhtml"
media-type="application/xhtml+xml"/>
${figures ? '<item id="png" href="images/dot.png" media-type="image/png"/><item id="jpg" href="images/photo.jpg" media-type="image/jpeg"/><item id="svg" href="images/shape.svg" media-type="image/svg+xml"/>' : ''}</manifest>
<spine page-progression-direction="${canonicalSemantics ? 'rtl' : 'ltr'}"><itemref idref="one"/>${canonicalSemantics ? '<itemref idref="one" linear="no"/>' : ''}<itemref idref="two"/></spine></package>''',
      ),
    )
    ..addFile(
      ArchiveFile.string(
        'OEBPS/nav.xhtml',
        anchoredNavigation
            ? '''<html xmlns="http://www.w3.org/1999/xhtml"><head><title>TOC</title></head><body><nav><ol>
<li><a href="one.xhtml#start">Chapter One</a><ol>
<li><a href="one.xhtml#part-one">Part One</a></li>
<li><a href="one.xhtml#part-two">Part Two</a></li>
</ol></li><li><a href="two.xhtml">Chapter Two</a></li>
</ol></nav></body></html>'''
            : '''<html xmlns="http://www.w3.org/1999/xhtml"><head><title>TOC</title></head><body><nav>
<ol><li><a href="one.xhtml">Chapter One</a></li>
<li><a href="two.xhtml">Chapter Two</a></li></ol></nav></body></html>''',
      ),
    )
    ..addFile(
      ArchiveFile.string(
        'OEBPS/one.xhtml',
        emptyContent
            ? '<html><body><script>remove me</script></body></html>'
            : '''<html${canonicalSemantics ? ' lang="ar" dir="rtl"' : ''}><body><h1>Chapter One</h1><script>remove me</script>
<p>First safe sentence.</p><p>Second safe sentence.</p>
${canonicalSemantics ? '<p id="semantic-start">Alpha <strong>bold <em id="inner-mark">inner</em></strong> omega.</p>' : ''}
${figures ? '<figure><img src="images/dot.png" alt="Green dot"/><figcaption>PNG caption</figcaption></figure><img src="./images/photo.jpg" alt="JPEG portrait"/><img src="images/shape.svg" alt="External SVG"/><svg aria-label="Inline SVG" viewBox="0 0 10 10"><circle cx="5" cy="5" r="4"/></svg>' : ''}
${nestedList ? '<ul><li><p>If you are a coach, build a reliable system.</p></li></ul>' : ''}
${anchoredNavigation ? '<h2 id="start">Start</h2><p>Intentional refrain.</p><h2 id="part-one">Part One</h2><ul><li><p>Previously duplicated sentence.</p></li></ul><h2 id="part-two">Part Two</h2><p>Intentional refrain.</p><p>Unicode punctuation: “calm”—always.</p>' : ''}
${richText ? '<h2 id="details">Details</h2><p><strong>Bold words</strong> and <em>italic words</em> with <a href="#footnote">a footnote</a> and <a href="https://example.com">an external source</a>.</p><p><strong>Echo</strong> then <strong>Echo</strong>.</p><blockquote>Quoted wisdom.</blockquote><ol><li><p>Outer item</p><ul><li><p>Nested item</p></li></ul></li></ol><aside id="footnote" epub:type="footnote">Footnote text.</aside>' : ''}
</body></html>''',
      ),
    )
    ..addFile(
      ArchiveFile.string(
        'OEBPS/two.xhtml',
        emptyContent
            ? '<html><body></body></html>'
            : '<html><body><h1>Chapter Two</h1><p>你好，世界。</p></body></html>',
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
  if (figures) {
    final png = base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=',
    );
    archive
      ..addFile(ArchiveFile('OEBPS/images/dot.png', png.length, png))
      ..addFile(
        ArchiveFile('OEBPS/images/photo.jpg', 4, [0xFF, 0xD8, 0xFF, 0xD9]),
      )
      ..addFile(
        ArchiveFile.string(
          'OEBPS/images/shape.svg',
          '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 10 10"><rect width="10" height="10"/></svg>',
        ),
      );
  }
  return ZipEncoder().encode(archive)!;
}
