import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:epubx/epubx.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:image/image.dart' as image;

import '../../reader/domain/bite_generator.dart';

class ParsedPublication {
  const ParsedPublication({
    required this.title,
    required this.author,
    required this.sections,
    this.cover,
  });

  final String title;
  final String author;
  final List<SourceSection> sections;
  final Uint8List? cover;
}

class EpubParser {
  const EpubParser();

  Future<ParsedPublication> parse(List<int> bytes) async {
    try {
      final archive = ZipDecoder().decodeBytes(bytes, verify: true);
      if (archive.files.any(
        (file) => file.name.toLowerCase() == 'meta-inf/encryption.xml',
      )) {
        throw const UnsupportedDrmException();
      }
      final book = await EpubReader.readBook(bytes);
      final sections = <SourceSection>[];
      void addChapters(List<EpubChapter>? chapters) {
        for (final chapter in chapters ?? const <EpubChapter>[]) {
          final content = chapter.HtmlContent?.trim() ?? '';
          if (content.isNotEmpty) {
            final parsed = _parseHtml(content);
            if (parsed.paragraphs.isNotEmpty) {
              sections.add(
                SourceSection(
                  index: sections.length,
                  heading: parsed.heading ?? chapter.Title?.trim(),
                  paragraphs: parsed.paragraphs,
                ),
              );
            }
          }
          addChapters(chapter.SubChapters);
        }
      }

      addChapters(book.Chapters);
      if (sections.isEmpty) {
        final htmlFiles = book.Content?.Html;
        if (htmlFiles != null) {
          for (final file in htmlFiles.values) {
            final parsed = _parseHtml(file.Content ?? '');
            if (parsed.paragraphs.isNotEmpty) {
              sections.add(
                SourceSection(
                  index: sections.length,
                  heading: parsed.heading,
                  paragraphs: parsed.paragraphs,
                ),
              );
            }
          }
        }
      }
      if (sections.isEmpty) throw const BookParseException('Book is empty.');
      return ParsedPublication(
        title: _fallback(book.Title, 'Untitled book'),
        author: _fallback(book.Author, 'Unknown author'),
        sections: sections,
        cover: book.CoverImage == null
            ? null
            : Uint8List.fromList(image.encodePng(book.CoverImage!)),
      );
    } on UnsupportedDrmException {
      rethrow;
    } on BookParseException {
      rethrow;
    } catch (_) {
      throw const BookParseException('This EPUB could not be read.');
    }
  }

  static _ParsedHtml _parseHtml(String source) {
    final document = html_parser.parse(source);
    document
        .querySelectorAll('script, style, nav, noscript, iframe, svg')
        .forEach((node) => node.remove());
    final heading = document
        .querySelector('h1, h2, h3, h4, h5, h6')
        ?.text
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    final paragraphs = document
        .querySelectorAll('p, li, blockquote')
        .where((node) => node.querySelector('p, li, blockquote') == null)
        .map((node) => node.text.replaceAll(RegExp(r'\s+'), ' ').trim())
        .where((text) => text.isNotEmpty)
        .toList();
    if (paragraphs.isEmpty) {
      final text = document.body?.text.replaceAll(RegExp(r'\s+'), ' ').trim();
      if (text != null && text.isNotEmpty && text != heading) {
        paragraphs.add(text);
      }
    }
    return _ParsedHtml(heading, paragraphs);
  }

  static String _fallback(String? value, String fallback) {
    final text = value?.trim();
    return text == null || text.isEmpty ? fallback : text;
  }
}

class _ParsedHtml {
  const _ParsedHtml(this.heading, this.paragraphs);
  final String? heading;
  final List<String> paragraphs;
}

class BookParseException implements Exception {
  const BookParseException(this.message);
  final String message;

  @override
  String toString() => message;
}

class UnsupportedDrmException extends BookParseException {
  const UnsupportedDrmException()
    : super('DRM-protected EPUB files are not supported.');
}
