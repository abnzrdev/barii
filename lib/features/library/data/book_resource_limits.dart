import 'dart:typed_data';

enum BookResourceLimitKind {
  sourceBytes,
  archiveEntries,
  expandedEntryBytes,
  expandedArchiveBytes,
  compressionRatio,
  invalidArchive,
}

class BookResourceLimitException implements Exception {
  const BookResourceLimitException(this.kind, this.message);

  final BookResourceLimitKind kind;
  final String message;

  @override
  String toString() => message;
}

/// Safety ceilings for dependencies that currently materialize complete EPUB
/// archives and publication models in memory.
///
/// These defaults are not a supported-book-size promise. They keep the eager
/// parser's several simultaneous representations inside a conservative mobile
/// envelope until broader device measurements justify changing them.
class BookResourceLimits {
  const BookResourceLimits({
    this.maxSourceBytes = 64 * 1024 * 1024,
    this.maxArchiveEntries = 10000,
    this.maxExpandedEntryBytes = 64 * 1024 * 1024,
    this.maxExpandedArchiveBytes = 256 * 1024 * 1024,
    this.maxCompressionRatio = 200,
  });

  final int maxSourceBytes;
  final int maxArchiveEntries;
  final int maxExpandedEntryBytes;
  final int maxExpandedArchiveBytes;
  final int maxCompressionRatio;

  void validateSourceLength(int length) {
    if (length > maxSourceBytes) {
      throw const BookResourceLimitException(
        BookResourceLimitKind.sourceBytes,
        'This book is too large to open safely on this device.',
      );
    }
  }

  void validateEpub(List<int> bytes) {
    validateSourceLength(bytes.length);
    final data = bytes is Uint8List ? bytes : Uint8List.fromList(bytes);
    final view = ByteData.sublistView(data);
    final end = _endOfCentralDirectory(view);
    if (end == null) {
      throw const BookResourceLimitException(
        BookResourceLimitKind.invalidArchive,
        'This EPUB archive is incomplete or invalid.',
      );
    }

    final disk = view.getUint16(end + 4, Endian.little);
    final centralDisk = view.getUint16(end + 6, Endian.little);
    final diskEntries = view.getUint16(end + 8, Endian.little);
    final entries = view.getUint16(end + 10, Endian.little);
    final centralSize = view.getUint32(end + 12, Endian.little);
    final centralOffset = view.getUint32(end + 16, Endian.little);
    if (disk != 0 ||
        centralDisk != 0 ||
        diskEntries != entries ||
        entries == 0xffff ||
        centralSize == 0xffffffff ||
        centralOffset == 0xffffffff) {
      throw const BookResourceLimitException(
        BookResourceLimitKind.invalidArchive,
        'This EPUB uses an unsupported archive structure.',
      );
    }
    if (entries > maxArchiveEntries) {
      throw const BookResourceLimitException(
        BookResourceLimitKind.archiveEntries,
        'This EPUB contains too many files to open safely.',
      );
    }
    final centralEnd = centralOffset + centralSize;
    if (centralOffset < 0 || centralEnd > end || centralEnd < centralOffset) {
      throw const BookResourceLimitException(
        BookResourceLimitKind.invalidArchive,
        'This EPUB archive is incomplete or invalid.',
      );
    }

    var offset = centralOffset;
    var expandedTotal = 0;
    for (var index = 0; index < entries; index++) {
      if (offset + 46 > centralEnd ||
          view.getUint32(offset, Endian.little) != 0x02014b50) {
        throw const BookResourceLimitException(
          BookResourceLimitKind.invalidArchive,
          'This EPUB archive is incomplete or invalid.',
        );
      }
      final compressed = view.getUint32(offset + 20, Endian.little);
      final expanded = view.getUint32(offset + 24, Endian.little);
      if (compressed == 0xffffffff || expanded == 0xffffffff) {
        throw const BookResourceLimitException(
          BookResourceLimitKind.invalidArchive,
          'This EPUB uses an unsupported archive structure.',
        );
      }
      if (expanded > maxExpandedEntryBytes) {
        throw const BookResourceLimitException(
          BookResourceLimitKind.expandedEntryBytes,
          'This EPUB contains a file that is too large to open safely.',
        );
      }
      expandedTotal += expanded;
      if (expandedTotal > maxExpandedArchiveBytes) {
        throw const BookResourceLimitException(
          BookResourceLimitKind.expandedArchiveBytes,
          'This EPUB expands to more data than can be opened safely.',
        );
      }
      if (expanded > 0 &&
          (compressed == 0 || expanded > compressed * maxCompressionRatio)) {
        throw const BookResourceLimitException(
          BookResourceLimitKind.compressionRatio,
          'This EPUB uses an unsafe compression ratio.',
        );
      }
      final nameLength = view.getUint16(offset + 28, Endian.little);
      final extraLength = view.getUint16(offset + 30, Endian.little);
      final commentLength = view.getUint16(offset + 32, Endian.little);
      offset += 46 + nameLength + extraLength + commentLength;
    }
  }

  int? _endOfCentralDirectory(ByteData bytes) {
    const recordLength = 22;
    if (bytes.lengthInBytes < recordLength) return null;
    final earliest = (bytes.lengthInBytes - recordLength - 0xffff)
        .clamp(0, bytes.lengthInBytes)
        .toInt();
    for (
      var offset = bytes.lengthInBytes - recordLength;
      offset >= earliest;
      offset--
    ) {
      if (bytes.getUint32(offset, Endian.little) == 0x06054b50) {
        final commentLength = bytes.getUint16(offset + 20, Endian.little);
        if (offset + recordLength + commentLength == bytes.lengthInBytes) {
          return offset;
        }
      }
    }
    return null;
  }
}
