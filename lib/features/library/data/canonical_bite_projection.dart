import 'dart:convert';
import 'dart:typed_data';

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
      final state = _ProjectionState(
        fileName: occurrence.resourceHref,
        archiveFiles: archiveFiles,
        assets: assets,
      );
      final blocks = occurrence.mediaType == 'image/svg+xml'
          ? state.projectSvgResource(
              publication.resources[occurrence.resourceHref],
              occurrence.nodes,
            )
          : state.projectNodes(occurrence.nodes);
      if (blocks.isEmpty) continue;
      final heading = blocks
          .where((block) => block.kind == 'heading')
          .map((block) => block.text)
          .whereType<String>()
          .firstOrNull;
      sections.add(
        SourceSection(
          index: sections.length,
          heading: heading ?? occurrence.title,
          paragraphs: blocks
              .where((block) => !block.isFigure && block.kind != 'heading')
              .map(
                (block) => block.kind == 'list'
                    ? block.text?.replaceFirst(
                        RegExp(r'^\s*(?:•|\d+\.)\s*'),
                        '',
                      )
                    : block.text,
              )
              .whereType<String>()
              .toList(),
          blocks: blocks,
        ),
      );
    }
    return CanonicalProjection(sections: sections, assets: assets);
  }
}

class _ProjectionState {
  _ProjectionState({
    required this.fileName,
    required this.archiveFiles,
    required this.assets,
  });

  final String fileName;
  final Map<String, Uint8List> archiveFiles;
  final Map<String, ParsedAsset> assets;
  var _inlineSvg = 0;

  List<SourceBlock> projectNodes(List<CanonicalNode> nodes) {
    final blocks = <SourceBlock>[];
    _projectContainer(nodes, blocks, const []);
    return blocks;
  }

  List<SourceBlock> projectSvgResource(
    CanonicalResource? resource,
    List<CanonicalNode> nodes,
  ) {
    final bytes =
        _assetBytes(fileName) ??
        (resource?.content == null
            ? null
            : Uint8List.fromList(utf8.encode(resource!.content!)));
    if (bytes == null) return projectNodes(nodes);
    final title = _firstDescendant(nodes, 'title');
    final labels = _descendants(nodes)
        .where((node) => node.kind == 'text')
        .map((node) => _clean(node.logicalText))
        .whereType<String>()
        .where((text) => text != _clean(title?.logicalText))
        .toList();
    assets[fileName] = ParsedAsset(bytes: bytes, extension: '.svg');
    return [
      SourceBlock.figure(
        assetKey: fileName,
        altText: _clean(title?.logicalText),
        caption: labels.isEmpty ? null : labels.join(' '),
      ),
    ];
  }

  void _projectContainer(
    List<CanonicalNode> nodes,
    List<SourceBlock> blocks,
    List<_ListLevel> lists, {
    String? inheritedAnchor,
  }) {
    final inline = <CanonicalNode>[];
    void flushInline() {
      if (inline.isEmpty) return;
      _addInlineBlocks(
        inline,
        blocks,
        kind: lists.isEmpty ? 'paragraph' : 'list',
        prefix: _listPrefix(lists),
        anchor: inheritedAnchor,
      );
      inline.clear();
    }

    for (final node in nodes) {
      if (node.kind == '#text' || !_isBlock(node.kind)) {
        inline.add(node);
        continue;
      }
      flushInline();
      _projectBlock(node, blocks, lists, inheritedAnchor: inheritedAnchor);
    }
    flushInline();
  }

  void _projectBlock(
    CanonicalNode node,
    List<SourceBlock> blocks,
    List<_ListLevel> lists, {
    String? inheritedAnchor,
  }) {
    final anchorId = node.elementId ?? inheritedAnchor;
    final anchor = anchorId == null ? null : '$fileName#$anchorId';
    switch (node.kind) {
      case 'ol':
      case 'ul':
        var item = 0;
        for (final child in node.children) {
          if (child.kind == 'li') {
            item++;
            _projectBlock(child, blocks, [
              ...lists,
              _ListLevel(node.kind == 'ol', item),
            ], inheritedAnchor: anchorId);
          } else {
            _projectBlock(child, blocks, lists, inheritedAnchor: anchorId);
          }
        }
      case 'table':
        _projectTable(node, blocks, anchor);
      case 'figure':
      case 'img':
      case 'svg':
        final block = _figure(node);
        if (block != null) blocks.add(block);
      case 'hr':
        return;
      case 'pre':
        _addInlineBlocks(
          node.children,
          blocks,
          kind: 'pre',
          anchor: anchor,
          preserveWhitespace: true,
        );
      case 'li':
        if (_hasBlockChild(node)) {
          _projectContainer(
            node.children,
            blocks,
            lists,
            inheritedAnchor: anchorId,
          );
        } else {
          _addInlineBlocks(
            node.children,
            blocks,
            kind: 'list',
            prefix: _listPrefix(lists),
            anchor: anchor,
          );
        }
      case 'p':
      case 'blockquote':
      case 'aside':
      case 'h1':
      case 'h2':
      case 'h3':
      case 'h4':
      case 'h5':
      case 'h6':
        final kind = lists.isNotEmpty ? 'list' : _blockKind(node);
        _addInlineBlocks(
          node.children,
          blocks,
          kind: kind,
          prefix: lists.isEmpty ? '' : _listPrefix(lists),
          anchor: anchor,
        );
      default:
        _projectContainer(
          node.children,
          blocks,
          lists,
          inheritedAnchor: anchorId,
        );
    }
  }

  void _projectTable(
    CanonicalNode table,
    List<SourceBlock> blocks,
    String? anchor,
  ) {
    final caption = _firstDescendant([table], 'caption');
    final captionText = _clean(caption?.logicalText);
    if (captionText != null) {
      blocks.add(
        SourceBlock.text(captionText, kind: 'caption', anchor: anchor),
      );
    }
    for (final row in _descendants([
      table,
    ]).where((node) => node.kind == 'tr')) {
      final cells = row.children
          .where((node) => node.kind == 'th' || node.kind == 'td')
          .map((node) => _clean(_inlineText(node.children)))
          .whereType<String>()
          .toList();
      if (cells.isNotEmpty) {
        blocks.add(SourceBlock.text(cells.join(' | '), kind: 'table'));
      }
    }
  }

  void _addInlineBlocks(
    List<CanonicalNode> nodes,
    List<SourceBlock> blocks, {
    required String kind,
    String prefix = '',
    String? anchor,
    bool preserveWhitespace = false,
  }) {
    final events = <_InlineEvent>[];
    _inlineEvents(nodes, events, []);
    var firstText = true;
    for (final event in events) {
      if (event.media != null) {
        final figure = _figure(event.media!);
        if (figure != null) blocks.add(figure);
        continue;
      }
      final raw = event.text!;
      final text = preserveWhitespace ? raw : _cleanInline(raw);
      if (text == null || text.isEmpty) continue;
      final appliedPrefix = firstText ? prefix : '';
      blocks.add(
        SourceBlock.text(
          '$appliedPrefix$text',
          kind: kind,
          marks: _marksFor(event, raw, text, appliedPrefix.length),
          anchor: firstText ? anchor : null,
        ),
      );
      firstText = false;
    }
  }

  void _inlineEvents(
    List<CanonicalNode> nodes,
    List<_InlineEvent> events,
    List<_MarkSpec> active,
  ) {
    var buffer = StringBuffer();
    final ranges = <_MarkSpec, _MutableRange>{};

    void flush() {
      if (buffer.isEmpty) return;
      events.add(_InlineEvent.text(buffer.toString(), Map.of(ranges)));
      buffer = StringBuffer();
      ranges.clear();
    }

    void append(String value) {
      if (value.isEmpty) return;
      final start = buffer.length;
      buffer.write(value);
      for (final mark in active) {
        final range = ranges.putIfAbsent(
          mark,
          () => _MutableRange(start, start),
        );
        range.end = buffer.length;
      }
    }

    void visit(CanonicalNode node) {
      if (node.kind == '#text') {
        append(node.logicalText);
        return;
      }
      if (node.kind == 'br') {
        append('\n');
        return;
      }
      if (node.kind == 'img' || node.kind == 'svg') {
        flush();
        events.add(_InlineEvent.media(node));
        return;
      }
      final mark = _markFor(node);
      if (mark != null) active.add(mark);
      for (final child in node.children) {
        visit(child);
      }
      if (mark != null) active.removeLast();
    }

    for (final node in nodes) {
      visit(node);
    }
    flush();
  }

  List<SourceMark> _marksFor(
    _InlineEvent event,
    String raw,
    String output,
    int prefixLength,
  ) {
    final marks = <SourceMark>[];
    final nextMatch = <String, int>{};
    for (final entry in event.ranges.entries) {
      final fragment = _cleanInline(
        raw.substring(entry.value.start, entry.value.end),
      );
      if (fragment == null) continue;
      var start = output.indexOf(fragment, nextMatch[fragment] ?? 0);
      if (start < 0) start = output.indexOf(fragment);
      if (start < 0) continue;
      nextMatch[fragment] = start + fragment.length;
      marks.add(
        SourceMark(
          start: prefixLength + start,
          end: prefixLength + start + fragment.length,
          kind: entry.key.kind,
          href: entry.key.href,
        ),
      );
    }
    return marks;
  }

  _MarkSpec? _markFor(CanonicalNode node) {
    final kind = switch (node.kind) {
      'strong' || 'b' => 'bold',
      'em' || 'i' => 'italic',
      'a' => 'link',
      'sup' => 'superscript',
      'sub' => 'subscript',
      'code' => 'code',
      'rt' => 'ruby-annotation',
      _ => null,
    };
    return kind == null
        ? null
        : _MarkSpec(
            kind,
            node.kind == 'a' ? _resolveHref(fileName, node.href) : null,
          );
  }

  SourceBlock? _figure(CanonicalNode node) {
    final image = node.kind == 'figure'
        ? _descendants([node])
              .where((child) => child.kind == 'img' || child.kind == 'svg')
              .firstOrNull
        : node;
    if (image == null) return null;
    final caption = node.kind == 'figure'
        ? _clean(_firstDescendant([node], 'figcaption')?.logicalText)
        : null;
    final alt = _clean(
      image.attributes['alt'] ?? image.attributes['aria-label'],
    );
    String? assetKey;
    Uint8List? bytes;
    String extension = '.bin';
    if (image.kind == 'svg') {
      assetKey = '$fileName.inline-${_inlineSvg++}.svg';
      bytes = Uint8List.fromList(
        utf8.encode(image.sourceMarkup ?? '<svg></svg>'),
      );
      extension = '.svg';
    } else {
      assetKey = _resolveAssetPath(fileName, image.attributes['src']);
      bytes = assetKey == null ? null : _assetBytes(assetKey);
      extension = assetKey == null ? '.bin' : path.posix.extension(assetKey);
    }
    if (assetKey != null && bytes != null) {
      assets[assetKey] = ParsedAsset(
        bytes: bytes,
        extension: extension.isEmpty ? '.bin' : extension,
      );
      return SourceBlock.figure(
        assetKey: assetKey,
        altText: alt,
        caption: caption,
      );
    }
    final fallback = [alt, caption].whereType<String>().join(' ');
    return fallback.isEmpty ? null : SourceBlock.text(fallback);
  }

  Uint8List? _assetBytes(String key) {
    final direct = archiveFiles[key];
    if (direct != null) return direct;
    final matches = archiveFiles.entries
        .where((entry) => entry.key.endsWith('/$key'))
        .toList();
    return matches.length == 1 ? matches.single.value : null;
  }

  static String _blockKind(CanonicalNode node) {
    if (node.epubTypes.contains('footnote') ||
        node.role == 'doc-footnote' ||
        node.kind == 'aside') {
      return 'footnote';
    }
    if (node.kind == 'blockquote') return 'blockquote';
    if (RegExp(r'^h[1-6]$').hasMatch(node.kind)) return 'heading';
    return 'paragraph';
  }

  static bool _hasBlockChild(CanonicalNode node) =>
      node.children.any((child) => _isBlock(child.kind));

  static bool _isBlock(String kind) => const {
    'address',
    'article',
    'aside',
    'blockquote',
    'div',
    'figure',
    'footer',
    'h1',
    'h2',
    'h3',
    'h4',
    'h5',
    'h6',
    'header',
    'hr',
    'img',
    'li',
    'main',
    'nav',
    'ol',
    'p',
    'pre',
    'section',
    'svg',
    'table',
    'ul',
  }.contains(kind);

  static String _listPrefix(List<_ListLevel> levels) {
    if (levels.isEmpty) return '';
    final indentation = List.filled(
      (levels.length - 1).clamp(0, 8),
      '  ',
    ).join();
    final current = levels.last;
    return current.ordered
        ? '$indentation${current.number}. '
        : '$indentation• ';
  }

  static String _inlineText(List<CanonicalNode> nodes) {
    final buffer = StringBuffer();
    void visit(CanonicalNode node) {
      if (node.kind == '#text') {
        buffer.write(node.logicalText);
      } else if (node.kind == 'br') {
        buffer.write('\n');
      } else if (node.kind != 'img' && node.kind != 'svg') {
        for (final child in node.children) {
          visit(child);
        }
      }
    }

    for (final node in nodes) {
      visit(node);
    }
    return buffer.toString();
  }

  static Iterable<CanonicalNode> _descendants(List<CanonicalNode> nodes) sync* {
    for (final node in nodes) {
      yield node;
      yield* _descendants(node.children);
    }
  }

  static CanonicalNode? _firstDescendant(
    List<CanonicalNode> nodes,
    String kind,
  ) => _descendants(nodes).where((node) => node.kind == kind).firstOrNull;

  static String? _clean(String? value) {
    final text = value?.replaceAll(RegExp(r'\s+'), ' ').trim();
    return text == null || text.isEmpty ? null : text;
  }

  static String? _cleanInline(String value) {
    final lines = value
        .split('\n')
        .map((line) => line.replaceAll(RegExp(r'[\t\r ]+'), ' ').trim())
        .where((line) => line.isNotEmpty)
        .toList();
    return lines.isEmpty ? null : lines.join('\n');
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

class _InlineEvent {
  const _InlineEvent.text(this.text, this.ranges) : media = null;
  const _InlineEvent.media(this.media) : text = null, ranges = const {};

  final String? text;
  final CanonicalNode? media;
  final Map<_MarkSpec, _MutableRange> ranges;
}

class _MarkSpec {
  const _MarkSpec(this.kind, this.href);

  final String kind;
  final String? href;
}

class _MutableRange {
  _MutableRange(this.start, this.end);

  final int start;
  int end;
}

class _ListLevel {
  const _ListLevel(this.ordered, this.number);

  final bool ordered;
  final int number;
}
