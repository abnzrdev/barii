import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:epubx/epubx.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:image/image.dart' as image;

import '../domain/canonical_publication.dart';
import '../../reader/domain/bite_generator.dart';
import 'canonical_bite_projection.dart';

class ParsedPublication {
  const ParsedPublication({
    required this.title,
    required this.author,
    required this.sections,
    this.canonical,
    this.assets = const {},
    this.cover,
  });

  final String title;
  final String author;
  final List<SourceSection> sections;
  final CanonicalPublication? canonical;
  final Map<String, ParsedAsset> assets;
  final Uint8List? cover;
}

class EpubParser {
  const EpubParser();

  Future<ParsedPublication> parse(List<int> bytes) async {
    final parseTask = TimelineTask()..start('Epub.parse');
    try {
      final archive = Timeline.timeSync(
        'Epub.archiveDecode',
        () => ZipDecoder().decodeBytes(bytes, verify: true),
        arguments: {'bytes': bytes.length},
      );
      if (archive.files.any(
        (file) => file.name.toLowerCase() == 'meta-inf/encryption.xml',
      )) {
        throw const UnsupportedDrmException();
      }
      final archiveFiles = {
        for (final file in archive.files)
          if (file.isFile)
            _normalizePath(file.name): Uint8List.fromList(
              (file.content as List<int>),
            ),
      };
      final packageTask = TimelineTask()..start('Epub.packageParse');
      final book = await EpubReader.readBook(bytes);
      packageTask.finish();
      final titlesByFile = <String, String>{};
      void collectTitles(List<EpubChapter>? chapters) {
        for (final chapter in chapters ?? const <EpubChapter>[]) {
          final fileName = _normalizePath(chapter.ContentFileName);
          final title = chapter.Title?.trim();
          if (fileName.isNotEmpty && title != null && title.isNotEmpty) {
            titlesByFile.putIfAbsent(fileName, () => title);
          }
          collectTitles(chapter.SubChapters);
        }
      }

      collectTitles(book.Chapters);
      final htmlFiles =
          book.Content?.Html ?? const <String, EpubTextContentFile>{};
      final filesByName = <String, EpubTextContentFile>{};
      for (final entry in htmlFiles.entries) {
        filesByName[_normalizePath(entry.key)] = entry.value;
        filesByName[_normalizePath(entry.value.FileName)] = entry.value;
      }
      final canonical = _canonicalPublication(
        book,
        filesByName,
        titlesByFile,
        archiveFiles,
      );
      Timeline.startSync(
        'Epub.contentCanonicalization',
        arguments: {'spineItems': canonical.readingOrder.length},
      );
      late final CanonicalProjection projection;
      try {
        projection = const CanonicalBiteProjection().project(
          canonical,
          archiveFiles,
        );
      } finally {
        Timeline.finishSync();
      }
      if (projection.sections.isEmpty) {
        throw const BookParseException('Book is empty.');
      }
      final publication = ParsedPublication(
        title: _fallback(book.Title, 'Untitled book'),
        author: _fallback(book.Author, 'Unknown author'),
        sections: projection.sections,
        canonical: canonical,
        assets: projection.assets,
        cover: book.CoverImage == null
            ? null
            : Uint8List.fromList(image.encodePng(book.CoverImage!)),
      );
      parseTask.finish(
        arguments: {
          'sections': projection.sections.length,
          'assets': projection.assets.length,
        },
      );
      return publication;
    } on UnsupportedDrmException {
      parseTask.finish(arguments: {'error': 'unsupportedDrm'});
      rethrow;
    } on BookParseException {
      parseTask.finish(arguments: {'error': 'bookParse'});
      rethrow;
    } catch (_) {
      parseTask.finish(arguments: {'error': 'unexpected'});
      throw const BookParseException('This EPUB could not be read.');
    }
  }

  static CanonicalPublication _canonicalPublication(
    EpubBook book,
    Map<String, EpubTextContentFile> filesByName,
    Map<String, String> titlesByFile,
    Map<String, Uint8List> archiveFiles,
  ) {
    final package = book.Schema?.Package;
    final metadata = package?.Metadata;
    final manifestItems =
        package?.Manifest?.Items ?? const <EpubManifestItem>[];
    final resources = <String, CanonicalResource>{};
    final resourcesById = <String, CanonicalResource>{};
    for (final item in manifestItems) {
      final href = _normalizePath(item.Href);
      if (href.isEmpty) continue;
      final resource = CanonicalResource(
        id: item.Id ?? href,
        href: href,
        mediaType: item.MediaType ?? 'application/octet-stream',
        content:
            filesByName[href]?.Content ??
            _textResource(href, item.MediaType, archiveFiles),
        properties: _tokens(item.Properties),
      );
      resources[href] = resource;
      if (item.Id != null) resourcesById[item.Id!] = resource;
    }

    final layout = metadata?.MetaItems
        ?.where((item) => item.Property == 'rendition:layout')
        .map((item) => item.Content?.trim())
        .whereType<String>()
        .where((value) => value.isNotEmpty)
        .firstOrNull;
    final rawItemRefs = _rawSpineItemRefs(archiveFiles);
    final nodeCache = <String, _CanonicalDocument>{};
    _CanonicalDocument documentFor(CanonicalResource resource) => nodeCache
        .putIfAbsent(resource.href, () => _canonicalDocument(resource.content));
    final readingOrder = <CanonicalSpineOccurrence>[];
    final spineItems = package?.Spine?.Items ?? const <EpubSpineItemRef>[];
    for (var index = 0; index < spineItems.length; index++) {
      final itemRef = spineItems[index];
      final resource = resourcesById[itemRef.IdRef];
      if (resource == null) continue;
      final raw = index < rawItemRefs.length ? rawItemRefs[index] : const {};
      final document = documentFor(resource);
      final properties = _tokens(raw['properties']);
      final occurrenceLayout =
          properties.contains('rendition:layout-pre-paginated')
          ? 'pre-paginated'
          : properties.contains('rendition:layout-reflowable')
          ? 'reflowable'
          : layout;
      readingOrder.add(
        CanonicalSpineOccurrence(
          occurrenceId: raw['id'] ?? 'spine-$index:${itemRef.IdRef}',
          resourceId: itemRef.IdRef ?? resource.id,
          position: index,
          resourceHref: resource.href,
          mediaType: resource.mediaType,
          linear: raw['linear']?.toLowerCase() != 'no',
          nodes: document.nodes,
          title: titlesByFile[resource.href],
          language: document.language ?? metadata?.Languages?.firstOrNull,
          textDirection: document.textDirection,
          layout: occurrenceLayout,
          properties: properties,
        ),
      );
    }
    if (readingOrder.isEmpty) {
      for (final resource in resources.values.where(
        (resource) => resource.content != null,
      )) {
        final index = readingOrder.length;
        final document = documentFor(resource);
        readingOrder.add(
          CanonicalSpineOccurrence(
            occurrenceId: 'fallback-$index:${resource.id}',
            resourceId: resource.id,
            position: index,
            resourceHref: resource.href,
            mediaType: resource.mediaType,
            linear: true,
            nodes: document.nodes,
            title: titlesByFile[resource.href],
            language: document.language ?? metadata?.Languages?.firstOrNull,
            textDirection: document.textDirection,
            layout: layout,
          ),
        );
      }
    }
    return CanonicalPublication(
      metadata: CanonicalMetadata(
        identifier: metadata?.Identifiers?.firstOrNull?.Identifier,
        title: _fallback(book.Title, 'Untitled book'),
        authors: [
          if (book.Author?.trim().isNotEmpty ?? false) book.Author!.trim(),
        ],
        languages: List.unmodifiable(metadata?.Languages ?? const []),
      ),
      rendition: CanonicalRendition(layout: layout ?? 'reflowable'),
      resources: Map.unmodifiable(resources),
      readingOrder: List.unmodifiable(readingOrder),
      pageProgressionDirection: package?.Spine?.ltr == false ? 'rtl' : 'ltr',
    );
  }

  static _CanonicalDocument _canonicalDocument(String? source) {
    if (source == null) return const _CanonicalDocument([]);
    final document = html_parser.parse(source);
    final root = document.documentElement;
    var offset = 0;
    CanonicalNode? build(Node node, String? language, String? direction) {
      final start = offset;
      if (node is Text) {
        offset += node.data.length;
        return CanonicalNode(
          kind: '#text',
          startOffset: start,
          endOffset: offset,
          logicalText: node.data,
        );
      }
      final element = node as Element;
      if (element.localName == 'script' || element.localName == 'style') {
        return null;
      }
      final effectiveLanguage =
          element.attributes['lang'] ??
          element.attributes['xml:lang'] ??
          language;
      final effectiveDirection = element.attributes['dir'] ?? direction;
      final children = element.nodes
          .map((node) => build(node, effectiveLanguage, effectiveDirection))
          .whereType<CanonicalNode>()
          .toList(growable: false);
      return CanonicalNode(
        kind: element.localName ?? 'element',
        startOffset: start,
        endOffset: offset,
        logicalText: children.map((child) => child.logicalText).join(),
        children: children,
        elementId: element.id.isEmpty ? null : element.id,
        language: effectiveLanguage,
        textDirection: effectiveDirection,
        href: element.attributes['href'],
        epubTypes: _tokens(element.attributes['epub:type']),
        role: element.attributes['role'],
        attributes: Map.unmodifiable(_semanticAttributes(element)),
        sourceMarkup: element.localName == 'svg' ? element.outerHtml : null,
      );
    }

    final rootLanguage =
        root?.attributes['lang'] ?? root?.attributes['xml:lang'];
    final rootDirection = root?.attributes['dir'];
    final nodes =
        (document.body ?? root)?.nodes
            .map((node) => build(node, rootLanguage, rootDirection))
            .whereType<CanonicalNode>()
            .toList() ??
        const [];
    return _CanonicalDocument(
      nodes,
      language: root?.attributes['lang'] ?? root?.attributes['xml:lang'],
      textDirection: root?.attributes['dir'],
    );
  }

  static Map<String, String> _semanticAttributes(Element element) => {
    for (final entry in element.attributes.entries)
      if (entry.key.toString() != 'style' &&
          !entry.key.toString().toLowerCase().startsWith('on'))
        entry.key.toString(): entry.value,
  };

  static String? _textResource(
    String href,
    String? mediaType,
    Map<String, Uint8List> archiveFiles,
  ) {
    if (mediaType != 'application/xhtml+xml' && mediaType != 'image/svg+xml') {
      return null;
    }
    final bytes =
        archiveFiles[href] ??
        archiveFiles.entries
            .where((entry) => entry.key.endsWith('/$href'))
            .map((entry) => entry.value)
            .firstOrNull;
    return bytes == null ? null : utf8.decode(bytes, allowMalformed: true);
  }

  static List<Map<String, String>> _rawSpineItemRefs(
    Map<String, Uint8List> archiveFiles,
  ) {
    final package = archiveFiles.entries
        .where((entry) => entry.key.toLowerCase().endsWith('.opf'))
        .firstOrNull;
    if (package == null) return const [];
    final document = html_parser.parse(utf8.decode(package.value));
    return document.querySelectorAll('spine itemref').map((element) {
      return {
        for (final entry in element.attributes.entries)
          entry.key.toString(): entry.value,
      };
    }).toList();
  }

  static List<String> _tokens(String? value) =>
      value
          ?.split(RegExp(r'\s+'))
          .where((token) => token.isNotEmpty)
          .toList() ??
      const [];

  static String? _clean(String? value) {
    final text = value?.replaceAll(RegExp(r'\s+'), ' ').trim();
    return text == null || text.isEmpty ? null : text;
  }

  static String _fallback(String? value, String fallback) =>
      _clean(value) ?? fallback;

  static String _normalizePath(String? value) {
    final normalized = (value ?? '')
        .split('#')
        .first
        .replaceAll('\\', '/')
        .trim();
    return normalized.startsWith('./') ? normalized.substring(2) : normalized;
  }
}

class _CanonicalDocument {
  const _CanonicalDocument(this.nodes, {this.language, this.textDirection});

  final List<CanonicalNode> nodes;
  final String? language;
  final String? textDirection;
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
