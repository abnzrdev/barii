import 'dart:convert';

import 'package:crypto/crypto.dart';

class SourceBlock {
  const SourceBlock.text(this.text)
    : assetKey = null,
      altText = null,
      caption = null;

  const SourceBlock.figure({required this.assetKey, this.altText, this.caption})
    : text = null;

  final String? text;
  final String? assetKey;
  final String? altText;
  final String? caption;

  bool get isFigure => assetKey != null;
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
        var partWords = 0;
        var partStart = sourceOffset;
        for (final sentence in _sentences(paragraph)) {
          final sentenceWords = _wordCount(sentence);
          if (part.isNotEmpty && partWords + sentenceWords > maxWords) {
            paragraphUnits.add(_Unit(part.join(' '), partStart, sourceOffset));
            part = [];
            partWords = 0;
            partStart = sourceOffset;
          }
          part.add(sentence);
          partWords += sentenceWords;
          sourceOffset += sentence.length + 1;
        }
        if (part.isNotEmpty) {
          paragraphUnits.add(_Unit(part.join(' '), partStart, sourceOffset));
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

  static List<String> _sentences(String text) {
    final matches = RegExp(r'.+?(?:[.!?。！？]+(?=\s|$)|$)', dotAll: true)
        .allMatches(text)
        .map((match) => match.group(0)!.trim())
        .where((sentence) => sentence.isNotEmpty)
        .toList();
    return matches.isEmpty ? [text] : matches;
  }

  static int _wordCount(String text) => RegExp(r'\S+').allMatches(text).length;
}

class _Unit {
  const _Unit(this.text, this.start, this.end);

  final String text;
  final int start;
  final int end;
}
