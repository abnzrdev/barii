import 'dart:convert';

import 'package:crypto/crypto.dart';

class SourceSection {
  const SourceSection({
    required this.index,
    this.heading,
    required this.paragraphs,
  });

  final int index;
  final String? heading;
  final List<String> paragraphs;
}

class GeneratedBite {
  const GeneratedBite({
    required this.id,
    required this.sectionIndex,
    required this.position,
    required this.text,
    required this.sourceStart,
    required this.sourceEnd,
  });

  final String id;
  final int sectionIndex;
  final int position;
  final String text;
  final int sourceStart;
  final int sourceEnd;
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
      final paragraphs = section.paragraphs
          .map((text) => text.replaceAll(RegExp(r'\s+'), ' ').trim())
          .where((text) => text.isNotEmpty)
          .toList();
      final heading = section.heading?.trim();
      if (paragraphs.isEmpty) continue;

      final units = <_Unit>[];
      var sourceOffset = 0;
      for (final paragraph in paragraphs) {
        final sentences = _sentences(paragraph);
        var part = <String>[];
        var partWords = 0;
        var partStart = sourceOffset;
        for (final sentence in sentences) {
          final sentenceWords = _wordCount(sentence);
          if (part.isNotEmpty && partWords + sentenceWords > maxWords) {
            units.add(_Unit(part.join(' '), partStart, sourceOffset));
            part = [];
            partWords = 0;
            partStart = sourceOffset;
          }
          part.add(sentence);
          partWords += sentenceWords;
          sourceOffset += sentence.length + 1;
        }
        if (part.isNotEmpty) {
          units.add(_Unit(part.join(' '), partStart, sourceOffset));
        }
        sourceOffset++;
      }

      var current = <_Unit>[];
      var words = 0;
      var firstInSection = true;
      void flush() {
        if (current.isEmpty) return;
        final body = current.map((unit) => unit.text).join('\n\n');
        final text = firstInSection && heading != null && heading.isNotEmpty
            ? '$heading\n\n$body'
            : body;
        final start = current.first.start;
        final end = current.last.end;
        final id = sha256
            .convert(
              utf8.encode('$bookFingerprint:${section.index}:$start:$end'),
            )
            .toString();
        result.add(
          GeneratedBite(
            id: id,
            sectionIndex: section.index,
            position: globalPosition++,
            text: text,
            sourceStart: start,
            sourceEnd: end,
          ),
        );
        firstInSection = false;
        current = [];
        words = 0;
      }

      for (final unit in units) {
        final unitWords = _wordCount(unit.text);
        if (current.isNotEmpty && words + unitWords > maxWords) flush();
        current.add(unit);
        words += unitWords;
        if (words >= targetWords) flush();
      }
      flush();
    }
    return result;
  }

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
