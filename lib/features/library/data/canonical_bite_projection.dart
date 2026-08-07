import 'dart:convert';
import 'dart:typed_data';

import 'package:html/dom.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:path/path.dart' as path;

import '../../reader/domain/bite_generator.dart';
import '../domain/canonical_publication.dart';

class ParsedAsset {
  const ParsedAsset({required this.bytes, required this.extension});

  final Uint8List bytes;
  final String extension;
}

class CanonicalProjection {
  const CanonicalProjection({required this.sections, required this.assets});

  final List<SourceSection> sections;
  final Map<String, ParsedAsset> assets;
}

class CanonicalBiteProjection {
  const CanonicalBiteProjection();

  CanonicalProjection project(
    CanonicalPublication publication,
    Map<String, Uint8List> archiveFiles,
  ) {
    final sections = <SourceSection>[];
    final assets = <String, ParsedAsset>{};
    final projectedResources = <String>{};
    for (final occurrence in publication.readingOrder) {
      if (!projectedResources.add(occurrence.resourceHref)) continue;
      final source = publication.resources[occurrence.resourceHref]?.content;
      if (source == null) continue;
      final parsed = _parseHtml(source, occurrence.resourceHref, archiveFiles);
      if (parsed.blocks.isEmpty) continue;
      assets.addAll(parsed.assets);
      sections.add(
        SourceSection(
          index: sections.length,
          heading: parsed.heading ?? occurrence.title,
          paragraphs: parsed.blocks
              .where((block) => block.kind != 'heading')
              .map(
                (block) => block.kind == 'list'
                    ? block.text?.replaceFirst(RegExp(r'^\s*•\s*'), '')
                    : block.text,
              )
              .whereType<String>()
              .toList(),
          blocks: parsed.blocks,
        ),
      );
    }
    return CanonicalProjection(sections: sections, assets: assets);
  }

  static _ProjectedHtml _parseHtml(
    String source,
    String fileName,
    Map<String, Uint8List> archiveFiles,
  ) {
    final document = html_parser.parse(source);
    document
        .querySelectorAll('script, style, nav, noscript, iframe')
        .forEach((node) => node.remove());
    final heading = _clean(
      document.querySelector('h1, h2, h3, h4, h5, h6')?.text,
    );
    final blocks = <SourceBlock>[];
    final assets = <String, ParsedAsset>{};
    var inlineSvg = 0;
    for (final element
        in document.body?.querySelectorAll(
              'h1, h2, h3, h4, h5, h6, p, li, blockquote, aside, figure, img, svg',
            ) ??
            const <Element>[]) {
      if (_hasAncestor(element, 'figure') && element.localName != 'figure') {
        continue;
      }
      if (_isTextBlock(element)) {
        if (element.querySelector('p, li, blockquote, aside') != null) continue;
        final block = _richBlock(element, fileName);
        if (block != null) blocks.add(block);
        continue;
      }
      final imageElement = element.localName == 'figure'
          ? element.querySelector('img, svg')
          : element;
      if (imageElement == null) continue;
      final alt = _clean(
        imageElement.attributes['alt'] ?? imageElement.attributes['aria-label'],
      );
      final caption = _clean(element.querySelector('figcaption')?.text);
      String? assetKey;
      Uint8List? assetBytes;
      String? extension;
      if (imageElement.localName == 'svg') {
        assetKey = '$fileName.inline-${inlineSvg++}.svg';
        assetBytes = Uint8List.fromList(utf8.encode(imageElement.outerHtml));
        extension = '.svg';
      } else {
        assetKey = _resolveAssetPath(fileName, imageElement.attributes['src']);
        assetBytes = assetKey == null ? null : archiveFiles[assetKey];
        if (assetKey != null && assetBytes == null) {
          final matches = archiveFiles.keys
              .where((name) => name.endsWith('/$assetKey'))
              .toList();
          if (matches.length == 1) {
            assetKey = matches.single;
            assetBytes = archiveFiles[assetKey];
          }
        }
        extension = assetKey == null ? null : path.posix.extension(assetKey);
      }
      if (assetKey != null && assetBytes != null) {
        assets[assetKey] = ParsedAsset(
          bytes: assetBytes,
          extension: extension?.isEmpty ?? true ? '.bin' : extension!,
        );
        blocks.add(
          SourceBlock.figure(
            assetKey: assetKey,
            altText: alt,
            caption: caption,
          ),
        );
      } else {
        final fallback = [alt, caption].whereType<String>().join(' ');
        if (fallback.isNotEmpty) blocks.add(SourceBlock.text(fallback));
      }
    }
    if (blocks.isEmpty) {
      final text = _clean(document.body?.text);
      if (text != null && text != heading) blocks.add(SourceBlock.text(text));
    }
    return _ProjectedHtml(heading, blocks, assets);
  }

  static bool _isTextBlock(Element element) =>
      element.localName == 'p' ||
      element.localName == 'li' ||
      element.localName == 'blockquote' ||
      element.localName == 'aside' ||
      RegExp(r'^h[1-6]$').hasMatch(element.localName ?? '');

  static SourceBlock? _richBlock(Element element, String fileName) {
    var text = _clean(_textWithoutNestedLists(element));
    if (text == null) return null;
    var prefix = '';
    final listItem = element.localName == 'li'
        ? element
        : _ancestor(element, 'li');
    if (listItem != null) {
      var depth = 0;
      for (
        var parent = listItem.parent;
        parent != null;
        parent = parent.parent
      ) {
        if (parent.localName == 'ul' || parent.localName == 'ol') depth++;
      }
      final indentation = List.filled((depth - 1).clamp(0, 8), '  ').join();
      final parent = listItem.parent;
      if (parent?.localName == 'ol') {
        final number =
            parent!.children
                .where((child) => child.localName == 'li')
                .toList()
                .indexOf(listItem) +
            1;
        prefix = '$indentation$number. ';
      } else {
        prefix = '$indentation• ';
      }
      text = '$prefix$text';
    }
    final marks = <SourceMark>[];
    final nextMatch = <String, int>{};
    for (final child in element.querySelectorAll('strong, b, em, i, a')) {
      final fragment = _clean(child.text);
      if (fragment == null) continue;
      var start = text.indexOf(fragment, nextMatch[fragment] ?? prefix.length);
      if (start < 0) start = text.indexOf(fragment, prefix.length);
      if (start < 0) continue;
      nextMatch[fragment] = start + fragment.length;
      final name = child.localName;
      marks.add(
        SourceMark(
          start: start,
          end: start + fragment.length,
          kind: name == 'strong' || name == 'b'
              ? 'bold'
              : name == 'em' || name == 'i'
              ? 'italic'
              : 'link',
          href: name == 'a'
              ? _resolveHref(fileName, child.attributes['href'])
              : null,
        ),
      );
    }
    final id = element.id.isNotEmpty ? element.id : _nearestId(element);
    final kind = listItem != null
        ? 'list'
        : element.localName == 'blockquote'
        ? 'blockquote'
        : element.localName == 'aside'
        ? 'footnote'
        : RegExp(r'^h[1-6]$').hasMatch(element.localName ?? '')
        ? 'heading'
        : 'paragraph';
    return SourceBlock.text(
      text,
      kind: kind,
      marks: marks,
      anchor: id == null ? null : '$fileName#$id',
    );
  }

  static String _textWithoutNestedLists(Element element) {
    final parts = <String>[];
    void collect(Node node) {
      if (node is Text) {
        parts.add(node.data);
        return;
      }
      if (node is! Element) return;
      if (!identical(node, element) &&
          (node.localName == 'ol' || node.localName == 'ul')) {
        return;
      }
      for (final child in node.nodes) {
        collect(child);
      }
    }

    collect(element);
    return parts.join();
  }

  static Element? _ancestor(Element element, String name) {
    for (var parent = element.parent; parent != null; parent = parent.parent) {
      if (parent.localName == name) return parent;
    }
    return null;
  }

  static String? _nearestId(Element element) {
    for (
      var current = element.parent;
      current != null;
      current = current.parent
    ) {
      if (current.id.isNotEmpty) return current.id;
    }
    return null;
  }

  static String? _resolveHref(String fileName, String? href) {
    final value = href?.trim();
    if (value == null || value.isEmpty) return null;
    final uri = Uri.tryParse(value);
    if (uri == null) return null;
    if (uri.hasScheme) return value;
    final target = uri.path.isEmpty
        ? fileName
        : path.posix.normalize(
            path.posix.join(path.posix.dirname(fileName), uri.path),
          );
    return uri.fragment.isEmpty ? target : '$target#${uri.fragment}';
  }

  static bool _hasAncestor(Element element, String name) {
    for (var parent = element.parent; parent != null; parent = parent.parent) {
      if (parent.localName == name) return true;
    }
    return false;
  }

  static String? _clean(String? value) {
    final text = value?.replaceAll(RegExp(r'\s+'), ' ').trim();
    return text == null || text.isEmpty ? null : text;
  }

  static String? _resolveAssetPath(String htmlFile, String? source) {
    if (source == null || source.trim().isEmpty) return null;
    final uri = Uri.tryParse(source.trim());
    if (uri == null || uri.hasScheme || uri.path.startsWith('/')) return null;
    final resolved = path.posix.normalize(
      path.posix.join(path.posix.dirname(htmlFile), uri.path),
    );
    if (resolved == '..' || resolved.startsWith('../')) return null;
    return _normalizePath(resolved);
  }

  static String _normalizePath(String value) {
    final normalized = value.split('#').first.replaceAll('\\', '/').trim();
    return normalized.startsWith('./') ? normalized.substring(2) : normalized;
  }
}

class _ProjectedHtml {
  const _ProjectedHtml(this.heading, this.blocks, this.assets);

  final String? heading;
  final List<SourceBlock> blocks;
  final Map<String, ParsedAsset> assets;
}
