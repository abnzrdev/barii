import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as path;

import '../../reader/domain/bite_generator.dart';
import 'book_resource_limits.dart';
import 'epub_parser.dart';

class ProcessedBook {
  const ProcessedBook({required this.publication, required this.bites});

  final ParsedPublication publication;
  final List<GeneratedBite> bites;
}

class BookProcessingWorker {
  const BookProcessingWorker({this.limits = const BookResourceLimits()});

  final BookResourceLimits limits;

  Future<String> fingerprint(String sourcePath) {
    final policy = limits;
    return Isolate.run(
      () => _fingerprint((sourcePath: sourcePath, limits: policy)),
      debugName: 'Barii book fingerprint',
    );
  }

  Future<ProcessedBook> process({
    required String sourcePath,
    required String extension,
    required String fingerprint,
  }) {
    final policy = limits;
    return Isolate.run(
      () => _process((
        sourcePath: sourcePath,
        extension: extension,
        fingerprint: fingerprint,
        limits: policy,
      )),
      debugName: 'Barii book processing',
    );
  }
}

Future<String> _fingerprint(
  ({BookResourceLimits limits, String sourcePath}) request,
) async {
  final bytes = await File(request.sourcePath).readAsBytes();
  request.limits.validateSourceLength(bytes.length);
  return sha256.convert(bytes).toString();
}

Future<ProcessedBook> _process(
  ({
    String sourcePath,
    String extension,
    String fingerprint,
    BookResourceLimits limits,
  })
  request,
) async {
  final bytes = await File(request.sourcePath).readAsBytes();
  request.limits.validateSourceLength(bytes.length);
  final ParsedPublication publication;
  if (request.extension == '.epub') {
    publication = await EpubParser(limits: request.limits).parse(bytes);
  } else {
    final text = utf8.decode(bytes);
    final paragraphs = text
        .split(RegExp(r'\n\s*\n'))
        .map((part) => part.replaceAll(RegExp(r'\s+'), ' ').trim())
        .where((part) => part.isNotEmpty)
        .toList();
    if (paragraphs.isEmpty) throw const EmptyProcessedBookException();
    publication = ParsedPublication(
      title: path.basenameWithoutExtension(request.sourcePath),
      author: 'Unknown author',
      sections: [SourceSection(index: 0, paragraphs: paragraphs)],
    );
  }
  final bites = const BiteGenerator().generate(
    bookFingerprint: request.fingerprint,
    sections: publication.sections,
  );
  if (bites.isEmpty) throw const EmptyProcessedBookException();
  return ProcessedBook(publication: publication, bites: bites);
}

class EmptyProcessedBookException implements Exception {
  const EmptyProcessedBookException();
}
