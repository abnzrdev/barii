import 'dart:convert';

import 'package:crypto/crypto.dart';

class SourceBlock {
  const SourceBlock.text(
    this.text, {
    this.kind = 'paragraph',
    this.marks = const [],
    this.anchor,
  }) : assetKey = null,
       altText = null,
       caption = null;

  const SourceBlock.figure({required this.assetKey, this.altText, this.caption})
    : text = null,
      kind = 'figure',
      marks = const [],
      anchor = null;

  final String? text;
  final String? assetKey;
  final String? altText;
  final String? caption;
  final String kind;
  final List<SourceMark> marks;
  final String? anchor;

  bool get isFigure => assetKey != null;
}

class SourceMark {
  const SourceMark({
    required this.start,
    required this.end,
    required this.kind,
    this.href,
  });

  final int start;
  final int end;
  final String kind;
  final String? href;
}

class SourceSection {
  const SourceSection({
    required this.index,
    this.heading,
    this.paragraphs = const [],
    this.blocks = const [],
  });

  final int index;
  final String? heading;
  final List<String> paragraphs;
  final List<SourceBlock> blocks;
}

class GeneratedBite {
  const GeneratedBite({
    required this.id,
    required this.sectionIndex,
    required this.position,
    required this.text,
    required this.sourceStart,
    required this.sourceEnd,
    this.kind = 'text',
    this.assetKey,
    this.altText,
    this.caption,
    this.markup,
  });

  final String id;
  final int sectionIndex;
  final int position;
  final String text;
  final int sourceStart;
  final int sourceEnd;
  final String kind;
  final String? assetKey;
  final String? altText;
  final String? caption;
  final String? markup;
}

class BiteGenerator {
  const BiteGenerator({this.targetWords = 140, this.maxWords = 180});

  final int targetWords;
  final int maxWords;

  List<GeneratedBite> generate({
    required String bookFingerprint,
    required List<SourceSection> sections,
  }) {
    final result = <GeneratedBite>[];
    var globalPosition = 0;
    for (final section in sections) {
      final blocks = section.blocks.isEmpty
          ? section.paragraphs.map(SourceBlock.text).toList()
          : section.blocks;
      final heading = section.heading?.trim();
      final units = <_Unit>[];
      var sourceOffset = 0;
      var firstInSection = true;

      void flush() {
        if (units.isEmpty) return;
        final body = units.map((unit) => unit.text).join('\n\n');
        final text = firstInSection && heading != null && heading.isNotEmpty
            ? '$heading\n\n$body'
            : body;
        final marks = <SourceMark>[];
        final anchors = <String, int>{};
        var outputOffset = 0;
        if (firstInSection && heading != null && heading.isNotEmpty) {
          marks.add(SourceMark(start: 0, end: heading.length, kind: 'heading'));
          outputOffset = heading.length + 2;
        }
        for (final unit in units) {
          marks.addAll(
            unit.marks.map(
              (mark) => SourceMark(
                start: outputOffset + mark.start,
                end: outputOffset + mark.end,
                kind: mark.kind,
                href: mark.href,
              ),
            ),
          );
          for (final anchor in unit.anchors.entries) {
            anchors[anchor.key] = outputOffset + anchor.value;
          }
          outputOffset += unit.text.length + 2;
        }
        final start = units.first.start;
        final end = units.last.end;
        result.add(
          GeneratedBite(
            id: _id(bookFingerprint, section.index, start, end),
            sectionIndex: section.index,
            position: globalPosition++,
            text: text,
            sourceStart: start,
            sourceEnd: end,
            markup: _markup(marks, anchors),
          ),
        );
        firstInSection = false;
        units.clear();
      }

      for (final block in blocks) {
        if (block.isFigure) {
          flush();
          final semanticText = [
            block.altText?.trim(),
            block.caption?.trim(),
          ].whereType<String>().where((text) => text.isNotEmpty).join('\n');
          final end = sourceOffset + semanticText.length;
          result.add(
            GeneratedBite(
              id: _id(
                bookFingerprint,
                section.index,
                sourceOffset,
                end,
                block.assetKey,
              ),
              sectionIndex: section.index,
              position: globalPosition++,
              text: semanticText,
              sourceStart: sourceOffset,
              sourceEnd: end,
              kind: 'figure',
              assetKey: block.assetKey,
              altText: block.altText,
              caption: block.caption,
            ),
          );
          firstInSection = false;
          sourceOffset = end + 1;
          continue;
        }

        final paragraph = block.text?.replaceAll(RegExp(r'\s+'), ' ').trim();
        if (paragraph == null || paragraph.isEmpty) continue;
        final paragraphUnits = <_Unit>[];
        var part = <String>[];
        var partMarks = <SourceMark>[];
        var partAnchors = <String, int>{};
        var partWords = 0;
        var partStart = sourceOffset;
        for (final match in _sentenceMatches(paragraph)) {
          final sentence = match.group(0)!.trim();
          final sentenceWords = _wordCount(sentence);
          if (part.isNotEmpty && partWords + sentenceWords > maxWords) {
            final value = part.join(' ');
            if (block.kind != 'paragraph') {
              partMarks.add(
                SourceMark(start: 0, end: value.length, kind: block.kind),
              );
            }
            paragraphUnits.add(
              _Unit(value, partStart, sourceOffset, partMarks, partAnchors),
            );
            part = [];
            partMarks = [];
            partAnchors = {};
            partWords = 0;
            partStart = sourceOffset;
          }
          final sentenceStart =
              match.start + match.group(0)!.indexOf(RegExp(r'\S'));
          final sentenceEnd = sentenceStart + sentence.length;
          final outputStart = part.isEmpty ? 0 : part.join(' ').length + 1;
          for (final mark in block.marks) {
            final start = mark.start.clamp(sentenceStart, sentenceEnd);
            final end = mark.end.clamp(sentenceStart, sentenceEnd);
            if (start < end) {
              partMarks.add(
                SourceMark(
                  start: outputStart + start - sentenceStart,
                  end: outputStart + end - sentenceStart,
                  kind: mark.kind,
                  href: mark.href,
                ),
              );
            }
          }
          if (part.isEmpty && block.anchor != null) {
            partAnchors[block.anchor!] = 0;
          }
          part.add(sentence);
          partWords += sentenceWords;
          sourceOffset += sentence.length + 1;
        }
        if (part.isNotEmpty) {
          final value = part.join(' ');
          if (block.kind != 'paragraph') {
            partMarks.add(
              SourceMark(start: 0, end: value.length, kind: block.kind),
            );
          }
          paragraphUnits.add(
            _Unit(value, partStart, sourceOffset, partMarks, partAnchors),
          );
        }
        for (final unit in paragraphUnits) {
          final words = units.fold<int>(
            0,
            (total, current) => total + _wordCount(current.text),
          );
          final unitWords = _wordCount(unit.text);
          if (units.isNotEmpty && words + unitWords > maxWords) flush();
          units.add(unit);
          if (words + unitWords >= targetWords) flush();
        }
        sourceOffset++;
      }
      flush();
    }
    return result;
  }

  static String _id(
    String fingerprint,
    int section,
    int start,
    int end, [
    String? asset,
  ]) => sha256
      .convert(
        utf8.encode(
          asset == null
              ? '$fingerprint:$section:$start:$end'
              : '$fingerprint:$section:$start:$end:$asset',
        ),
      )
      .toString();

  static Iterable<RegExpMatch> _sentenceMatches(String text) => RegExp(
    r'.+?(?:[.!?。！？]+(?=\s|$)|$)',
    dotAll: true,
  ).allMatches(text).where((match) => match.group(0)!.trim().isNotEmpty);

  static String? _markup(List<SourceMark> marks, Map<String, int> anchors) =>
      marks.isEmpty && anchors.isEmpty
      ? null
      : jsonEncode({
          'marks': [
            for (final mark in marks)
              {
                'start': mark.start,
                'end': mark.end,
                'kind': mark.kind,
                if (mark.href != null) 'href': mark.href,
              },
          ],
          'anchors': anchors,
        });

  static int _wordCount(String text) => RegExp(r'\S+').allMatches(text).length;
}

class _Unit {
  const _Unit(
    this.text,
    this.start,
    this.end, [
    this.marks = const [],
    this.anchors = const {},
  ]);

  final String text;
  final int start;
  final int end;
  final List<SourceMark> marks;
  final Map<String, int> anchors;
}
