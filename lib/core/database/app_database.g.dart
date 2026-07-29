// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $BooksTable extends Books with TableInfo<$BooksTable, Book> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BooksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fingerprintMeta = const VerificationMeta(
    'fingerprint',
  );
  @override
  late final GeneratedColumn<String> fingerprint = GeneratedColumn<String>(
    'fingerprint',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
    'author',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileTypeMeta = const VerificationMeta(
    'fileType',
  );
  @override
  late final GeneratedColumn<String> fileType = GeneratedColumn<String>(
    'file_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _coverMeta = const VerificationMeta('cover');
  @override
  late final GeneratedColumn<Uint8List> cover = GeneratedColumn<Uint8List>(
    'cover',
    aliasedName,
    true,
    type: DriftSqlType.blob,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fingerprint,
    title,
    author,
    filePath,
    fileType,
    cover,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'books';
  @override
  VerificationContext validateIntegrity(
    Insertable<Book> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('fingerprint')) {
      context.handle(
        _fingerprintMeta,
        fingerprint.isAcceptableOrUnknown(
          data['fingerprint']!,
          _fingerprintMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fingerprintMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('author')) {
      context.handle(
        _authorMeta,
        author.isAcceptableOrUnknown(data['author']!, _authorMeta),
      );
    } else if (isInserting) {
      context.missing(_authorMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('file_type')) {
      context.handle(
        _fileTypeMeta,
        fileType.isAcceptableOrUnknown(data['file_type']!, _fileTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_fileTypeMeta);
    }
    if (data.containsKey('cover')) {
      context.handle(
        _coverMeta,
        cover.isAcceptableOrUnknown(data['cover']!, _coverMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Book map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Book(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      fingerprint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fingerprint'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      author: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      fileType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_type'],
      )!,
      cover: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}cover'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BooksTable createAlias(String alias) {
    return $BooksTable(attachedDatabase, alias);
  }
}

class Book extends DataClass implements Insertable<Book> {
  final String id;
  final String fingerprint;
  final String title;
  final String author;
  final String filePath;
  final String fileType;
  final Uint8List? cover;
  final DateTime createdAt;
  const Book({
    required this.id,
    required this.fingerprint,
    required this.title,
    required this.author,
    required this.filePath,
    required this.fileType,
    this.cover,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['fingerprint'] = Variable<String>(fingerprint);
    map['title'] = Variable<String>(title);
    map['author'] = Variable<String>(author);
    map['file_path'] = Variable<String>(filePath);
    map['file_type'] = Variable<String>(fileType);
    if (!nullToAbsent || cover != null) {
      map['cover'] = Variable<Uint8List>(cover);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BooksCompanion toCompanion(bool nullToAbsent) {
    return BooksCompanion(
      id: Value(id),
      fingerprint: Value(fingerprint),
      title: Value(title),
      author: Value(author),
      filePath: Value(filePath),
      fileType: Value(fileType),
      cover: cover == null && nullToAbsent
          ? const Value.absent()
          : Value(cover),
      createdAt: Value(createdAt),
    );
  }

  factory Book.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Book(
      id: serializer.fromJson<String>(json['id']),
      fingerprint: serializer.fromJson<String>(json['fingerprint']),
      title: serializer.fromJson<String>(json['title']),
      author: serializer.fromJson<String>(json['author']),
      filePath: serializer.fromJson<String>(json['filePath']),
      fileType: serializer.fromJson<String>(json['fileType']),
      cover: serializer.fromJson<Uint8List?>(json['cover']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fingerprint': serializer.toJson<String>(fingerprint),
      'title': serializer.toJson<String>(title),
      'author': serializer.toJson<String>(author),
      'filePath': serializer.toJson<String>(filePath),
      'fileType': serializer.toJson<String>(fileType),
      'cover': serializer.toJson<Uint8List?>(cover),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Book copyWith({
    String? id,
    String? fingerprint,
    String? title,
    String? author,
    String? filePath,
    String? fileType,
    Value<Uint8List?> cover = const Value.absent(),
    DateTime? createdAt,
  }) => Book(
    id: id ?? this.id,
    fingerprint: fingerprint ?? this.fingerprint,
    title: title ?? this.title,
    author: author ?? this.author,
    filePath: filePath ?? this.filePath,
    fileType: fileType ?? this.fileType,
    cover: cover.present ? cover.value : this.cover,
    createdAt: createdAt ?? this.createdAt,
  );
  Book copyWithCompanion(BooksCompanion data) {
    return Book(
      id: data.id.present ? data.id.value : this.id,
      fingerprint: data.fingerprint.present
          ? data.fingerprint.value
          : this.fingerprint,
      title: data.title.present ? data.title.value : this.title,
      author: data.author.present ? data.author.value : this.author,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      fileType: data.fileType.present ? data.fileType.value : this.fileType,
      cover: data.cover.present ? data.cover.value : this.cover,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Book(')
          ..write('id: $id, ')
          ..write('fingerprint: $fingerprint, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('filePath: $filePath, ')
          ..write('fileType: $fileType, ')
          ..write('cover: $cover, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    fingerprint,
    title,
    author,
    filePath,
    fileType,
    $driftBlobEquality.hash(cover),
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Book &&
          other.id == this.id &&
          other.fingerprint == this.fingerprint &&
          other.title == this.title &&
          other.author == this.author &&
          other.filePath == this.filePath &&
          other.fileType == this.fileType &&
          $driftBlobEquality.equals(other.cover, this.cover) &&
          other.createdAt == this.createdAt);
}

class BooksCompanion extends UpdateCompanion<Book> {
  final Value<String> id;
  final Value<String> fingerprint;
  final Value<String> title;
  final Value<String> author;
  final Value<String> filePath;
  final Value<String> fileType;
  final Value<Uint8List?> cover;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const BooksCompanion({
    this.id = const Value.absent(),
    this.fingerprint = const Value.absent(),
    this.title = const Value.absent(),
    this.author = const Value.absent(),
    this.filePath = const Value.absent(),
    this.fileType = const Value.absent(),
    this.cover = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BooksCompanion.insert({
    required String id,
    required String fingerprint,
    required String title,
    required String author,
    required String filePath,
    required String fileType,
    this.cover = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       fingerprint = Value(fingerprint),
       title = Value(title),
       author = Value(author),
       filePath = Value(filePath),
       fileType = Value(fileType);
  static Insertable<Book> custom({
    Expression<String>? id,
    Expression<String>? fingerprint,
    Expression<String>? title,
    Expression<String>? author,
    Expression<String>? filePath,
    Expression<String>? fileType,
    Expression<Uint8List>? cover,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fingerprint != null) 'fingerprint': fingerprint,
      if (title != null) 'title': title,
      if (author != null) 'author': author,
      if (filePath != null) 'file_path': filePath,
      if (fileType != null) 'file_type': fileType,
      if (cover != null) 'cover': cover,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BooksCompanion copyWith({
    Value<String>? id,
    Value<String>? fingerprint,
    Value<String>? title,
    Value<String>? author,
    Value<String>? filePath,
    Value<String>? fileType,
    Value<Uint8List?>? cover,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return BooksCompanion(
      id: id ?? this.id,
      fingerprint: fingerprint ?? this.fingerprint,
      title: title ?? this.title,
      author: author ?? this.author,
      filePath: filePath ?? this.filePath,
      fileType: fileType ?? this.fileType,
      cover: cover ?? this.cover,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fingerprint.present) {
      map['fingerprint'] = Variable<String>(fingerprint.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (fileType.present) {
      map['file_type'] = Variable<String>(fileType.value);
    }
    if (cover.present) {
      map['cover'] = Variable<Uint8List>(cover.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BooksCompanion(')
          ..write('id: $id, ')
          ..write('fingerprint: $fingerprint, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('filePath: $filePath, ')
          ..write('fileType: $fileType, ')
          ..write('cover: $cover, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SectionsTable extends Sections with TableInfo<$SectionsTable, Section> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<String> bookId = GeneratedColumn<String>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES books (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _headingMeta = const VerificationMeta(
    'heading',
  );
  @override
  late final GeneratedColumn<String> heading = GeneratedColumn<String>(
    'heading',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, bookId, position, heading];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sections';
  @override
  VerificationContext validateIntegrity(
    Insertable<Section> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('heading')) {
      context.handle(
        _headingMeta,
        heading.isAcceptableOrUnknown(data['heading']!, _headingMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {bookId, position},
  ];
  @override
  Section map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Section(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}book_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      heading: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}heading'],
      ),
    );
  }

  @override
  $SectionsTable createAlias(String alias) {
    return $SectionsTable(attachedDatabase, alias);
  }
}

class Section extends DataClass implements Insertable<Section> {
  final String id;
  final String bookId;
  final int position;
  final String? heading;
  const Section({
    required this.id,
    required this.bookId,
    required this.position,
    this.heading,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['book_id'] = Variable<String>(bookId);
    map['position'] = Variable<int>(position);
    if (!nullToAbsent || heading != null) {
      map['heading'] = Variable<String>(heading);
    }
    return map;
  }

  SectionsCompanion toCompanion(bool nullToAbsent) {
    return SectionsCompanion(
      id: Value(id),
      bookId: Value(bookId),
      position: Value(position),
      heading: heading == null && nullToAbsent
          ? const Value.absent()
          : Value(heading),
    );
  }

  factory Section.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Section(
      id: serializer.fromJson<String>(json['id']),
      bookId: serializer.fromJson<String>(json['bookId']),
      position: serializer.fromJson<int>(json['position']),
      heading: serializer.fromJson<String?>(json['heading']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'bookId': serializer.toJson<String>(bookId),
      'position': serializer.toJson<int>(position),
      'heading': serializer.toJson<String?>(heading),
    };
  }

  Section copyWith({
    String? id,
    String? bookId,
    int? position,
    Value<String?> heading = const Value.absent(),
  }) => Section(
    id: id ?? this.id,
    bookId: bookId ?? this.bookId,
    position: position ?? this.position,
    heading: heading.present ? heading.value : this.heading,
  );
  Section copyWithCompanion(SectionsCompanion data) {
    return Section(
      id: data.id.present ? data.id.value : this.id,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      position: data.position.present ? data.position.value : this.position,
      heading: data.heading.present ? data.heading.value : this.heading,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Section(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('position: $position, ')
          ..write('heading: $heading')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, bookId, position, heading);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Section &&
          other.id == this.id &&
          other.bookId == this.bookId &&
          other.position == this.position &&
          other.heading == this.heading);
}

class SectionsCompanion extends UpdateCompanion<Section> {
  final Value<String> id;
  final Value<String> bookId;
  final Value<int> position;
  final Value<String?> heading;
  final Value<int> rowid;
  const SectionsCompanion({
    this.id = const Value.absent(),
    this.bookId = const Value.absent(),
    this.position = const Value.absent(),
    this.heading = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SectionsCompanion.insert({
    required String id,
    required String bookId,
    required int position,
    this.heading = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       bookId = Value(bookId),
       position = Value(position);
  static Insertable<Section> custom({
    Expression<String>? id,
    Expression<String>? bookId,
    Expression<int>? position,
    Expression<String>? heading,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookId != null) 'book_id': bookId,
      if (position != null) 'position': position,
      if (heading != null) 'heading': heading,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SectionsCompanion copyWith({
    Value<String>? id,
    Value<String>? bookId,
    Value<int>? position,
    Value<String?>? heading,
    Value<int>? rowid,
  }) {
    return SectionsCompanion(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      position: position ?? this.position,
      heading: heading ?? this.heading,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<String>(bookId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (heading.present) {
      map['heading'] = Variable<String>(heading.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SectionsCompanion(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('position: $position, ')
          ..write('heading: $heading, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BitesTable extends Bites with TableInfo<$BitesTable, Bite> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BitesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<String> bookId = GeneratedColumn<String>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES books (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _sectionIdMeta = const VerificationMeta(
    'sectionId',
  );
  @override
  late final GeneratedColumn<String> sectionId = GeneratedColumn<String>(
    'section_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sections (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceStartMeta = const VerificationMeta(
    'sourceStart',
  );
  @override
  late final GeneratedColumn<int> sourceStart = GeneratedColumn<int>(
    'source_start',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceEndMeta = const VerificationMeta(
    'sourceEnd',
  );
  @override
  late final GeneratedColumn<int> sourceEnd = GeneratedColumn<int>(
    'source_end',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    bookId,
    sectionId,
    position,
    content,
    sourceStart,
    sourceEnd,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bites';
  @override
  VerificationContext validateIntegrity(
    Insertable<Bite> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('section_id')) {
      context.handle(
        _sectionIdMeta,
        sectionId.isAcceptableOrUnknown(data['section_id']!, _sectionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sectionIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('source_start')) {
      context.handle(
        _sourceStartMeta,
        sourceStart.isAcceptableOrUnknown(
          data['source_start']!,
          _sourceStartMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceStartMeta);
    }
    if (data.containsKey('source_end')) {
      context.handle(
        _sourceEndMeta,
        sourceEnd.isAcceptableOrUnknown(data['source_end']!, _sourceEndMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceEndMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {bookId, position},
  ];
  @override
  Bite map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Bite(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}book_id'],
      )!,
      sectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}section_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      sourceStart: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}source_start'],
      )!,
      sourceEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}source_end'],
      )!,
    );
  }

  @override
  $BitesTable createAlias(String alias) {
    return $BitesTable(attachedDatabase, alias);
  }
}

class Bite extends DataClass implements Insertable<Bite> {
  final String id;
  final String bookId;
  final String sectionId;
  final int position;
  final String content;
  final int sourceStart;
  final int sourceEnd;
  const Bite({
    required this.id,
    required this.bookId,
    required this.sectionId,
    required this.position,
    required this.content,
    required this.sourceStart,
    required this.sourceEnd,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['book_id'] = Variable<String>(bookId);
    map['section_id'] = Variable<String>(sectionId);
    map['position'] = Variable<int>(position);
    map['content'] = Variable<String>(content);
    map['source_start'] = Variable<int>(sourceStart);
    map['source_end'] = Variable<int>(sourceEnd);
    return map;
  }

  BitesCompanion toCompanion(bool nullToAbsent) {
    return BitesCompanion(
      id: Value(id),
      bookId: Value(bookId),
      sectionId: Value(sectionId),
      position: Value(position),
      content: Value(content),
      sourceStart: Value(sourceStart),
      sourceEnd: Value(sourceEnd),
    );
  }

  factory Bite.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Bite(
      id: serializer.fromJson<String>(json['id']),
      bookId: serializer.fromJson<String>(json['bookId']),
      sectionId: serializer.fromJson<String>(json['sectionId']),
      position: serializer.fromJson<int>(json['position']),
      content: serializer.fromJson<String>(json['content']),
      sourceStart: serializer.fromJson<int>(json['sourceStart']),
      sourceEnd: serializer.fromJson<int>(json['sourceEnd']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'bookId': serializer.toJson<String>(bookId),
      'sectionId': serializer.toJson<String>(sectionId),
      'position': serializer.toJson<int>(position),
      'content': serializer.toJson<String>(content),
      'sourceStart': serializer.toJson<int>(sourceStart),
      'sourceEnd': serializer.toJson<int>(sourceEnd),
    };
  }

  Bite copyWith({
    String? id,
    String? bookId,
    String? sectionId,
    int? position,
    String? content,
    int? sourceStart,
    int? sourceEnd,
  }) => Bite(
    id: id ?? this.id,
    bookId: bookId ?? this.bookId,
    sectionId: sectionId ?? this.sectionId,
    position: position ?? this.position,
    content: content ?? this.content,
    sourceStart: sourceStart ?? this.sourceStart,
    sourceEnd: sourceEnd ?? this.sourceEnd,
  );
  Bite copyWithCompanion(BitesCompanion data) {
    return Bite(
      id: data.id.present ? data.id.value : this.id,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      sectionId: data.sectionId.present ? data.sectionId.value : this.sectionId,
      position: data.position.present ? data.position.value : this.position,
      content: data.content.present ? data.content.value : this.content,
      sourceStart: data.sourceStart.present
          ? data.sourceStart.value
          : this.sourceStart,
      sourceEnd: data.sourceEnd.present ? data.sourceEnd.value : this.sourceEnd,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Bite(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('sectionId: $sectionId, ')
          ..write('position: $position, ')
          ..write('content: $content, ')
          ..write('sourceStart: $sourceStart, ')
          ..write('sourceEnd: $sourceEnd')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    bookId,
    sectionId,
    position,
    content,
    sourceStart,
    sourceEnd,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Bite &&
          other.id == this.id &&
          other.bookId == this.bookId &&
          other.sectionId == this.sectionId &&
          other.position == this.position &&
          other.content == this.content &&
          other.sourceStart == this.sourceStart &&
          other.sourceEnd == this.sourceEnd);
}

class BitesCompanion extends UpdateCompanion<Bite> {
  final Value<String> id;
  final Value<String> bookId;
  final Value<String> sectionId;
  final Value<int> position;
  final Value<String> content;
  final Value<int> sourceStart;
  final Value<int> sourceEnd;
  final Value<int> rowid;
  const BitesCompanion({
    this.id = const Value.absent(),
    this.bookId = const Value.absent(),
    this.sectionId = const Value.absent(),
    this.position = const Value.absent(),
    this.content = const Value.absent(),
    this.sourceStart = const Value.absent(),
    this.sourceEnd = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BitesCompanion.insert({
    required String id,
    required String bookId,
    required String sectionId,
    required int position,
    required String content,
    required int sourceStart,
    required int sourceEnd,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       bookId = Value(bookId),
       sectionId = Value(sectionId),
       position = Value(position),
       content = Value(content),
       sourceStart = Value(sourceStart),
       sourceEnd = Value(sourceEnd);
  static Insertable<Bite> custom({
    Expression<String>? id,
    Expression<String>? bookId,
    Expression<String>? sectionId,
    Expression<int>? position,
    Expression<String>? content,
    Expression<int>? sourceStart,
    Expression<int>? sourceEnd,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookId != null) 'book_id': bookId,
      if (sectionId != null) 'section_id': sectionId,
      if (position != null) 'position': position,
      if (content != null) 'content': content,
      if (sourceStart != null) 'source_start': sourceStart,
      if (sourceEnd != null) 'source_end': sourceEnd,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BitesCompanion copyWith({
    Value<String>? id,
    Value<String>? bookId,
    Value<String>? sectionId,
    Value<int>? position,
    Value<String>? content,
    Value<int>? sourceStart,
    Value<int>? sourceEnd,
    Value<int>? rowid,
  }) {
    return BitesCompanion(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      sectionId: sectionId ?? this.sectionId,
      position: position ?? this.position,
      content: content ?? this.content,
      sourceStart: sourceStart ?? this.sourceStart,
      sourceEnd: sourceEnd ?? this.sourceEnd,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<String>(bookId.value);
    }
    if (sectionId.present) {
      map['section_id'] = Variable<String>(sectionId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (sourceStart.present) {
      map['source_start'] = Variable<int>(sourceStart.value);
    }
    if (sourceEnd.present) {
      map['source_end'] = Variable<int>(sourceEnd.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BitesCompanion(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('sectionId: $sectionId, ')
          ..write('position: $position, ')
          ..write('content: $content, ')
          ..write('sourceStart: $sourceStart, ')
          ..write('sourceEnd: $sourceEnd, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReadingProgressTable extends ReadingProgress
    with TableInfo<$ReadingProgressTable, ReadingProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadingProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<String> bookId = GeneratedColumn<String>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES books (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _biteIdMeta = const VerificationMeta('biteId');
  @override
  late final GeneratedColumn<String> biteId = GeneratedColumn<String>(
    'bite_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES bites (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _bitePositionMeta = const VerificationMeta(
    'bitePosition',
  );
  @override
  late final GeneratedColumn<int> bitePosition = GeneratedColumn<int>(
    'bite_position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    bookId,
    biteId,
    bitePosition,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reading_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReadingProgressData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('bite_id')) {
      context.handle(
        _biteIdMeta,
        biteId.isAcceptableOrUnknown(data['bite_id']!, _biteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_biteIdMeta);
    }
    if (data.containsKey('bite_position')) {
      context.handle(
        _bitePositionMeta,
        bitePosition.isAcceptableOrUnknown(
          data['bite_position']!,
          _bitePositionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_bitePositionMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {bookId};
  @override
  ReadingProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReadingProgressData(
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}book_id'],
      )!,
      biteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bite_id'],
      )!,
      bitePosition: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bite_position'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ReadingProgressTable createAlias(String alias) {
    return $ReadingProgressTable(attachedDatabase, alias);
  }
}

class ReadingProgressData extends DataClass
    implements Insertable<ReadingProgressData> {
  final String bookId;
  final String biteId;
  final int bitePosition;
  final DateTime updatedAt;
  const ReadingProgressData({
    required this.bookId,
    required this.biteId,
    required this.bitePosition,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['book_id'] = Variable<String>(bookId);
    map['bite_id'] = Variable<String>(biteId);
    map['bite_position'] = Variable<int>(bitePosition);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ReadingProgressCompanion toCompanion(bool nullToAbsent) {
    return ReadingProgressCompanion(
      bookId: Value(bookId),
      biteId: Value(biteId),
      bitePosition: Value(bitePosition),
      updatedAt: Value(updatedAt),
    );
  }

  factory ReadingProgressData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReadingProgressData(
      bookId: serializer.fromJson<String>(json['bookId']),
      biteId: serializer.fromJson<String>(json['biteId']),
      bitePosition: serializer.fromJson<int>(json['bitePosition']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'bookId': serializer.toJson<String>(bookId),
      'biteId': serializer.toJson<String>(biteId),
      'bitePosition': serializer.toJson<int>(bitePosition),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ReadingProgressData copyWith({
    String? bookId,
    String? biteId,
    int? bitePosition,
    DateTime? updatedAt,
  }) => ReadingProgressData(
    bookId: bookId ?? this.bookId,
    biteId: biteId ?? this.biteId,
    bitePosition: bitePosition ?? this.bitePosition,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ReadingProgressData copyWithCompanion(ReadingProgressCompanion data) {
    return ReadingProgressData(
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      biteId: data.biteId.present ? data.biteId.value : this.biteId,
      bitePosition: data.bitePosition.present
          ? data.bitePosition.value
          : this.bitePosition,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReadingProgressData(')
          ..write('bookId: $bookId, ')
          ..write('biteId: $biteId, ')
          ..write('bitePosition: $bitePosition, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(bookId, biteId, bitePosition, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReadingProgressData &&
          other.bookId == this.bookId &&
          other.biteId == this.biteId &&
          other.bitePosition == this.bitePosition &&
          other.updatedAt == this.updatedAt);
}

class ReadingProgressCompanion extends UpdateCompanion<ReadingProgressData> {
  final Value<String> bookId;
  final Value<String> biteId;
  final Value<int> bitePosition;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ReadingProgressCompanion({
    this.bookId = const Value.absent(),
    this.biteId = const Value.absent(),
    this.bitePosition = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReadingProgressCompanion.insert({
    required String bookId,
    required String biteId,
    required int bitePosition,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : bookId = Value(bookId),
       biteId = Value(biteId),
       bitePosition = Value(bitePosition),
       updatedAt = Value(updatedAt);
  static Insertable<ReadingProgressData> custom({
    Expression<String>? bookId,
    Expression<String>? biteId,
    Expression<int>? bitePosition,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (bookId != null) 'book_id': bookId,
      if (biteId != null) 'bite_id': biteId,
      if (bitePosition != null) 'bite_position': bitePosition,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReadingProgressCompanion copyWith({
    Value<String>? bookId,
    Value<String>? biteId,
    Value<int>? bitePosition,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ReadingProgressCompanion(
      bookId: bookId ?? this.bookId,
      biteId: biteId ?? this.biteId,
      bitePosition: bitePosition ?? this.bitePosition,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (bookId.present) {
      map['book_id'] = Variable<String>(bookId.value);
    }
    if (biteId.present) {
      map['bite_id'] = Variable<String>(biteId.value);
    }
    if (bitePosition.present) {
      map['bite_position'] = Variable<int>(bitePosition.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadingProgressCompanion(')
          ..write('bookId: $bookId, ')
          ..write('biteId: $biteId, ')
          ..write('bitePosition: $bitePosition, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReaderNotesTable extends ReaderNotes
    with TableInfo<$ReaderNotesTable, ReaderNote> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReaderNotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<String> bookId = GeneratedColumn<String>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES books (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _biteIdMeta = const VerificationMeta('biteId');
  @override
  late final GeneratedColumn<String> biteId = GeneratedColumn<String>(
    'bite_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES bites (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _noteTextMeta = const VerificationMeta(
    'noteText',
  );
  @override
  late final GeneratedColumn<String> noteText = GeneratedColumn<String>(
    'note_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    bookId,
    biteId,
    noteText,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reader_notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReaderNote> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('bite_id')) {
      context.handle(
        _biteIdMeta,
        biteId.isAcceptableOrUnknown(data['bite_id']!, _biteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_biteIdMeta);
    }
    if (data.containsKey('note_text')) {
      context.handle(
        _noteTextMeta,
        noteText.isAcceptableOrUnknown(data['note_text']!, _noteTextMeta),
      );
    } else if (isInserting) {
      context.missing(_noteTextMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReaderNote map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReaderNote(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}book_id'],
      )!,
      biteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bite_id'],
      )!,
      noteText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note_text'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ReaderNotesTable createAlias(String alias) {
    return $ReaderNotesTable(attachedDatabase, alias);
  }
}

class ReaderNote extends DataClass implements Insertable<ReaderNote> {
  final String id;
  final String bookId;
  final String biteId;
  final String noteText;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ReaderNote({
    required this.id,
    required this.bookId,
    required this.biteId,
    required this.noteText,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['book_id'] = Variable<String>(bookId);
    map['bite_id'] = Variable<String>(biteId);
    map['note_text'] = Variable<String>(noteText);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ReaderNotesCompanion toCompanion(bool nullToAbsent) {
    return ReaderNotesCompanion(
      id: Value(id),
      bookId: Value(bookId),
      biteId: Value(biteId),
      noteText: Value(noteText),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ReaderNote.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReaderNote(
      id: serializer.fromJson<String>(json['id']),
      bookId: serializer.fromJson<String>(json['bookId']),
      biteId: serializer.fromJson<String>(json['biteId']),
      noteText: serializer.fromJson<String>(json['noteText']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'bookId': serializer.toJson<String>(bookId),
      'biteId': serializer.toJson<String>(biteId),
      'noteText': serializer.toJson<String>(noteText),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ReaderNote copyWith({
    String? id,
    String? bookId,
    String? biteId,
    String? noteText,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ReaderNote(
    id: id ?? this.id,
    bookId: bookId ?? this.bookId,
    biteId: biteId ?? this.biteId,
    noteText: noteText ?? this.noteText,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ReaderNote copyWithCompanion(ReaderNotesCompanion data) {
    return ReaderNote(
      id: data.id.present ? data.id.value : this.id,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      biteId: data.biteId.present ? data.biteId.value : this.biteId,
      noteText: data.noteText.present ? data.noteText.value : this.noteText,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReaderNote(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('biteId: $biteId, ')
          ..write('noteText: $noteText, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, bookId, biteId, noteText, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReaderNote &&
          other.id == this.id &&
          other.bookId == this.bookId &&
          other.biteId == this.biteId &&
          other.noteText == this.noteText &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ReaderNotesCompanion extends UpdateCompanion<ReaderNote> {
  final Value<String> id;
  final Value<String> bookId;
  final Value<String> biteId;
  final Value<String> noteText;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ReaderNotesCompanion({
    this.id = const Value.absent(),
    this.bookId = const Value.absent(),
    this.biteId = const Value.absent(),
    this.noteText = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReaderNotesCompanion.insert({
    required String id,
    required String bookId,
    required String biteId,
    required String noteText,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       bookId = Value(bookId),
       biteId = Value(biteId),
       noteText = Value(noteText),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ReaderNote> custom({
    Expression<String>? id,
    Expression<String>? bookId,
    Expression<String>? biteId,
    Expression<String>? noteText,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookId != null) 'book_id': bookId,
      if (biteId != null) 'bite_id': biteId,
      if (noteText != null) 'note_text': noteText,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReaderNotesCompanion copyWith({
    Value<String>? id,
    Value<String>? bookId,
    Value<String>? biteId,
    Value<String>? noteText,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ReaderNotesCompanion(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      biteId: biteId ?? this.biteId,
      noteText: noteText ?? this.noteText,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<String>(bookId.value);
    }
    if (biteId.present) {
      map['bite_id'] = Variable<String>(biteId.value);
    }
    if (noteText.present) {
      map['note_text'] = Variable<String>(noteText.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReaderNotesCompanion(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('biteId: $biteId, ')
          ..write('noteText: $noteText, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DictionarySourcesTable extends DictionarySources
    with TableInfo<$DictionarySourcesTable, DictionarySource> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DictionarySourcesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _formatMeta = const VerificationMeta('format');
  @override
  late final GeneratedColumn<String> format = GeneratedColumn<String>(
    'format',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sizeBytesMeta = const VerificationMeta(
    'sizeBytes',
  );
  @override
  late final GeneratedColumn<int> sizeBytes = GeneratedColumn<int>(
    'size_bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentHashMeta = const VerificationMeta(
    'contentHash',
  );
  @override
  late final GeneratedColumn<String> contentHash = GeneratedColumn<String>(
    'content_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _licenseNameMeta = const VerificationMeta(
    'licenseName',
  );
  @override
  late final GeneratedColumn<String> licenseName = GeneratedColumn<String>(
    'license_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attributionMeta = const VerificationMeta(
    'attribution',
  );
  @override
  late final GeneratedColumn<String> attribution = GeneratedColumn<String>(
    'attribution',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _installedAtMeta = const VerificationMeta(
    'installedAt',
  );
  @override
  late final GeneratedColumn<DateTime> installedAt = GeneratedColumn<DateTime>(
    'installed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    language,
    format,
    sizeBytes,
    filePath,
    contentHash,
    source,
    licenseName,
    attribution,
    enabled,
    priority,
    installedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dictionary_sources';
  @override
  VerificationContext validateIntegrity(
    Insertable<DictionarySource> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    if (data.containsKey('format')) {
      context.handle(
        _formatMeta,
        format.isAcceptableOrUnknown(data['format']!, _formatMeta),
      );
    } else if (isInserting) {
      context.missing(_formatMeta);
    }
    if (data.containsKey('size_bytes')) {
      context.handle(
        _sizeBytesMeta,
        sizeBytes.isAcceptableOrUnknown(data['size_bytes']!, _sizeBytesMeta),
      );
    } else if (isInserting) {
      context.missing(_sizeBytesMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('content_hash')) {
      context.handle(
        _contentHashMeta,
        contentHash.isAcceptableOrUnknown(
          data['content_hash']!,
          _contentHashMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentHashMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('license_name')) {
      context.handle(
        _licenseNameMeta,
        licenseName.isAcceptableOrUnknown(
          data['license_name']!,
          _licenseNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_licenseNameMeta);
    }
    if (data.containsKey('attribution')) {
      context.handle(
        _attributionMeta,
        attribution.isAcceptableOrUnknown(
          data['attribution']!,
          _attributionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_attributionMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    } else if (isInserting) {
      context.missing(_priorityMeta);
    }
    if (data.containsKey('installed_at')) {
      context.handle(
        _installedAtMeta,
        installedAt.isAcceptableOrUnknown(
          data['installed_at']!,
          _installedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_installedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DictionarySource map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DictionarySource(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      format: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}format'],
      )!,
      sizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size_bytes'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      contentHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_hash'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      licenseName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}license_name'],
      )!,
      attribution: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attribution'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      )!,
      installedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}installed_at'],
      )!,
    );
  }

  @override
  $DictionarySourcesTable createAlias(String alias) {
    return $DictionarySourcesTable(attachedDatabase, alias);
  }
}

class DictionarySource extends DataClass
    implements Insertable<DictionarySource> {
  final String id;
  final String name;
  final String language;
  final String format;
  final int sizeBytes;
  final String filePath;
  final String contentHash;
  final String source;
  final String licenseName;
  final String attribution;
  final bool enabled;
  final int priority;
  final DateTime installedAt;
  const DictionarySource({
    required this.id,
    required this.name,
    required this.language,
    required this.format,
    required this.sizeBytes,
    required this.filePath,
    required this.contentHash,
    required this.source,
    required this.licenseName,
    required this.attribution,
    required this.enabled,
    required this.priority,
    required this.installedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['language'] = Variable<String>(language);
    map['format'] = Variable<String>(format);
    map['size_bytes'] = Variable<int>(sizeBytes);
    map['file_path'] = Variable<String>(filePath);
    map['content_hash'] = Variable<String>(contentHash);
    map['source'] = Variable<String>(source);
    map['license_name'] = Variable<String>(licenseName);
    map['attribution'] = Variable<String>(attribution);
    map['enabled'] = Variable<bool>(enabled);
    map['priority'] = Variable<int>(priority);
    map['installed_at'] = Variable<DateTime>(installedAt);
    return map;
  }

  DictionarySourcesCompanion toCompanion(bool nullToAbsent) {
    return DictionarySourcesCompanion(
      id: Value(id),
      name: Value(name),
      language: Value(language),
      format: Value(format),
      sizeBytes: Value(sizeBytes),
      filePath: Value(filePath),
      contentHash: Value(contentHash),
      source: Value(source),
      licenseName: Value(licenseName),
      attribution: Value(attribution),
      enabled: Value(enabled),
      priority: Value(priority),
      installedAt: Value(installedAt),
    );
  }

  factory DictionarySource.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DictionarySource(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      language: serializer.fromJson<String>(json['language']),
      format: serializer.fromJson<String>(json['format']),
      sizeBytes: serializer.fromJson<int>(json['sizeBytes']),
      filePath: serializer.fromJson<String>(json['filePath']),
      contentHash: serializer.fromJson<String>(json['contentHash']),
      source: serializer.fromJson<String>(json['source']),
      licenseName: serializer.fromJson<String>(json['licenseName']),
      attribution: serializer.fromJson<String>(json['attribution']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      priority: serializer.fromJson<int>(json['priority']),
      installedAt: serializer.fromJson<DateTime>(json['installedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'language': serializer.toJson<String>(language),
      'format': serializer.toJson<String>(format),
      'sizeBytes': serializer.toJson<int>(sizeBytes),
      'filePath': serializer.toJson<String>(filePath),
      'contentHash': serializer.toJson<String>(contentHash),
      'source': serializer.toJson<String>(source),
      'licenseName': serializer.toJson<String>(licenseName),
      'attribution': serializer.toJson<String>(attribution),
      'enabled': serializer.toJson<bool>(enabled),
      'priority': serializer.toJson<int>(priority),
      'installedAt': serializer.toJson<DateTime>(installedAt),
    };
  }

  DictionarySource copyWith({
    String? id,
    String? name,
    String? language,
    String? format,
    int? sizeBytes,
    String? filePath,
    String? contentHash,
    String? source,
    String? licenseName,
    String? attribution,
    bool? enabled,
    int? priority,
    DateTime? installedAt,
  }) => DictionarySource(
    id: id ?? this.id,
    name: name ?? this.name,
    language: language ?? this.language,
    format: format ?? this.format,
    sizeBytes: sizeBytes ?? this.sizeBytes,
    filePath: filePath ?? this.filePath,
    contentHash: contentHash ?? this.contentHash,
    source: source ?? this.source,
    licenseName: licenseName ?? this.licenseName,
    attribution: attribution ?? this.attribution,
    enabled: enabled ?? this.enabled,
    priority: priority ?? this.priority,
    installedAt: installedAt ?? this.installedAt,
  );
  DictionarySource copyWithCompanion(DictionarySourcesCompanion data) {
    return DictionarySource(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      language: data.language.present ? data.language.value : this.language,
      format: data.format.present ? data.format.value : this.format,
      sizeBytes: data.sizeBytes.present ? data.sizeBytes.value : this.sizeBytes,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      contentHash: data.contentHash.present
          ? data.contentHash.value
          : this.contentHash,
      source: data.source.present ? data.source.value : this.source,
      licenseName: data.licenseName.present
          ? data.licenseName.value
          : this.licenseName,
      attribution: data.attribution.present
          ? data.attribution.value
          : this.attribution,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      priority: data.priority.present ? data.priority.value : this.priority,
      installedAt: data.installedAt.present
          ? data.installedAt.value
          : this.installedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DictionarySource(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('language: $language, ')
          ..write('format: $format, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('filePath: $filePath, ')
          ..write('contentHash: $contentHash, ')
          ..write('source: $source, ')
          ..write('licenseName: $licenseName, ')
          ..write('attribution: $attribution, ')
          ..write('enabled: $enabled, ')
          ..write('priority: $priority, ')
          ..write('installedAt: $installedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    language,
    format,
    sizeBytes,
    filePath,
    contentHash,
    source,
    licenseName,
    attribution,
    enabled,
    priority,
    installedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DictionarySource &&
          other.id == this.id &&
          other.name == this.name &&
          other.language == this.language &&
          other.format == this.format &&
          other.sizeBytes == this.sizeBytes &&
          other.filePath == this.filePath &&
          other.contentHash == this.contentHash &&
          other.source == this.source &&
          other.licenseName == this.licenseName &&
          other.attribution == this.attribution &&
          other.enabled == this.enabled &&
          other.priority == this.priority &&
          other.installedAt == this.installedAt);
}

class DictionarySourcesCompanion extends UpdateCompanion<DictionarySource> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> language;
  final Value<String> format;
  final Value<int> sizeBytes;
  final Value<String> filePath;
  final Value<String> contentHash;
  final Value<String> source;
  final Value<String> licenseName;
  final Value<String> attribution;
  final Value<bool> enabled;
  final Value<int> priority;
  final Value<DateTime> installedAt;
  final Value<int> rowid;
  const DictionarySourcesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.language = const Value.absent(),
    this.format = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.filePath = const Value.absent(),
    this.contentHash = const Value.absent(),
    this.source = const Value.absent(),
    this.licenseName = const Value.absent(),
    this.attribution = const Value.absent(),
    this.enabled = const Value.absent(),
    this.priority = const Value.absent(),
    this.installedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DictionarySourcesCompanion.insert({
    required String id,
    required String name,
    required String language,
    required String format,
    required int sizeBytes,
    required String filePath,
    required String contentHash,
    required String source,
    required String licenseName,
    required String attribution,
    this.enabled = const Value.absent(),
    required int priority,
    required DateTime installedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       language = Value(language),
       format = Value(format),
       sizeBytes = Value(sizeBytes),
       filePath = Value(filePath),
       contentHash = Value(contentHash),
       source = Value(source),
       licenseName = Value(licenseName),
       attribution = Value(attribution),
       priority = Value(priority),
       installedAt = Value(installedAt);
  static Insertable<DictionarySource> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? language,
    Expression<String>? format,
    Expression<int>? sizeBytes,
    Expression<String>? filePath,
    Expression<String>? contentHash,
    Expression<String>? source,
    Expression<String>? licenseName,
    Expression<String>? attribution,
    Expression<bool>? enabled,
    Expression<int>? priority,
    Expression<DateTime>? installedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (language != null) 'language': language,
      if (format != null) 'format': format,
      if (sizeBytes != null) 'size_bytes': sizeBytes,
      if (filePath != null) 'file_path': filePath,
      if (contentHash != null) 'content_hash': contentHash,
      if (source != null) 'source': source,
      if (licenseName != null) 'license_name': licenseName,
      if (attribution != null) 'attribution': attribution,
      if (enabled != null) 'enabled': enabled,
      if (priority != null) 'priority': priority,
      if (installedAt != null) 'installed_at': installedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DictionarySourcesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? language,
    Value<String>? format,
    Value<int>? sizeBytes,
    Value<String>? filePath,
    Value<String>? contentHash,
    Value<String>? source,
    Value<String>? licenseName,
    Value<String>? attribution,
    Value<bool>? enabled,
    Value<int>? priority,
    Value<DateTime>? installedAt,
    Value<int>? rowid,
  }) {
    return DictionarySourcesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      language: language ?? this.language,
      format: format ?? this.format,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      filePath: filePath ?? this.filePath,
      contentHash: contentHash ?? this.contentHash,
      source: source ?? this.source,
      licenseName: licenseName ?? this.licenseName,
      attribution: attribution ?? this.attribution,
      enabled: enabled ?? this.enabled,
      priority: priority ?? this.priority,
      installedAt: installedAt ?? this.installedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (format.present) {
      map['format'] = Variable<String>(format.value);
    }
    if (sizeBytes.present) {
      map['size_bytes'] = Variable<int>(sizeBytes.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (contentHash.present) {
      map['content_hash'] = Variable<String>(contentHash.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (licenseName.present) {
      map['license_name'] = Variable<String>(licenseName.value);
    }
    if (attribution.present) {
      map['attribution'] = Variable<String>(attribution.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (installedAt.present) {
      map['installed_at'] = Variable<DateTime>(installedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DictionarySourcesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('language: $language, ')
          ..write('format: $format, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('filePath: $filePath, ')
          ..write('contentHash: $contentHash, ')
          ..write('source: $source, ')
          ..write('licenseName: $licenseName, ')
          ..write('attribution: $attribution, ')
          ..write('enabled: $enabled, ')
          ..write('priority: $priority, ')
          ..write('installedAt: $installedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VocabularyEntriesTable extends VocabularyEntries
    with TableInfo<$VocabularyEntriesTable, VocabularyEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VocabularyEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wordMeta = const VerificationMeta('word');
  @override
  late final GeneratedColumn<String> word = GeneratedColumn<String>(
    'word',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _normalizedWordMeta = const VerificationMeta(
    'normalizedWord',
  );
  @override
  late final GeneratedColumn<String> normalizedWord = GeneratedColumn<String>(
    'normalized_word',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _definitionMeta = const VerificationMeta(
    'definition',
  );
  @override
  late final GeneratedColumn<String> definition = GeneratedColumn<String>(
    'definition',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceSentenceMeta = const VerificationMeta(
    'sourceSentence',
  );
  @override
  late final GeneratedColumn<String> sourceSentence = GeneratedColumn<String>(
    'source_sentence',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<String> bookId = GeneratedColumn<String>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES books (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _biteIdMeta = const VerificationMeta('biteId');
  @override
  late final GeneratedColumn<String> biteId = GeneratedColumn<String>(
    'bite_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES bites (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _dictionarySourceIdMeta =
      const VerificationMeta('dictionarySourceId');
  @override
  late final GeneratedColumn<String> dictionarySourceId =
      GeneratedColumn<String>(
        'dictionary_source_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES dictionary_sources (id) ON DELETE SET NULL',
        ),
      );
  static const VerificationMeta _dictionarySourceNameMeta =
      const VerificationMeta('dictionarySourceName');
  @override
  late final GeneratedColumn<String> dictionarySourceName =
      GeneratedColumn<String>(
        'dictionary_source_name',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('Bundled dictionary'),
      );
  static const VerificationMeta _partOfSpeechMeta = const VerificationMeta(
    'partOfSpeech',
  );
  @override
  late final GeneratedColumn<String> partOfSpeech = GeneratedColumn<String>(
    'part_of_speech',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pronunciationMeta = const VerificationMeta(
    'pronunciation',
  );
  @override
  late final GeneratedColumn<String> pronunciation = GeneratedColumn<String>(
    'pronunciation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    word,
    normalizedWord,
    definition,
    sourceSentence,
    bookId,
    biteId,
    dictionarySourceId,
    dictionarySourceName,
    partOfSpeech,
    pronunciation,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vocabulary_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<VocabularyEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('word')) {
      context.handle(
        _wordMeta,
        word.isAcceptableOrUnknown(data['word']!, _wordMeta),
      );
    } else if (isInserting) {
      context.missing(_wordMeta);
    }
    if (data.containsKey('normalized_word')) {
      context.handle(
        _normalizedWordMeta,
        normalizedWord.isAcceptableOrUnknown(
          data['normalized_word']!,
          _normalizedWordMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_normalizedWordMeta);
    }
    if (data.containsKey('definition')) {
      context.handle(
        _definitionMeta,
        definition.isAcceptableOrUnknown(data['definition']!, _definitionMeta),
      );
    } else if (isInserting) {
      context.missing(_definitionMeta);
    }
    if (data.containsKey('source_sentence')) {
      context.handle(
        _sourceSentenceMeta,
        sourceSentence.isAcceptableOrUnknown(
          data['source_sentence']!,
          _sourceSentenceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceSentenceMeta);
    }
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('bite_id')) {
      context.handle(
        _biteIdMeta,
        biteId.isAcceptableOrUnknown(data['bite_id']!, _biteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_biteIdMeta);
    }
    if (data.containsKey('dictionary_source_id')) {
      context.handle(
        _dictionarySourceIdMeta,
        dictionarySourceId.isAcceptableOrUnknown(
          data['dictionary_source_id']!,
          _dictionarySourceIdMeta,
        ),
      );
    }
    if (data.containsKey('dictionary_source_name')) {
      context.handle(
        _dictionarySourceNameMeta,
        dictionarySourceName.isAcceptableOrUnknown(
          data['dictionary_source_name']!,
          _dictionarySourceNameMeta,
        ),
      );
    }
    if (data.containsKey('part_of_speech')) {
      context.handle(
        _partOfSpeechMeta,
        partOfSpeech.isAcceptableOrUnknown(
          data['part_of_speech']!,
          _partOfSpeechMeta,
        ),
      );
    }
    if (data.containsKey('pronunciation')) {
      context.handle(
        _pronunciationMeta,
        pronunciation.isAcceptableOrUnknown(
          data['pronunciation']!,
          _pronunciationMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VocabularyEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VocabularyEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      word: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}word'],
      )!,
      normalizedWord: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}normalized_word'],
      )!,
      definition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}definition'],
      )!,
      sourceSentence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_sentence'],
      )!,
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}book_id'],
      )!,
      biteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bite_id'],
      )!,
      dictionarySourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dictionary_source_id'],
      ),
      dictionarySourceName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dictionary_source_name'],
      )!,
      partOfSpeech: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}part_of_speech'],
      ),
      pronunciation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pronunciation'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $VocabularyEntriesTable createAlias(String alias) {
    return $VocabularyEntriesTable(attachedDatabase, alias);
  }
}

class VocabularyEntry extends DataClass implements Insertable<VocabularyEntry> {
  final String id;
  final String word;
  final String normalizedWord;
  final String definition;
  final String sourceSentence;
  final String bookId;
  final String biteId;
  final String? dictionarySourceId;
  final String dictionarySourceName;
  final String? partOfSpeech;
  final String? pronunciation;
  final DateTime createdAt;
  const VocabularyEntry({
    required this.id,
    required this.word,
    required this.normalizedWord,
    required this.definition,
    required this.sourceSentence,
    required this.bookId,
    required this.biteId,
    this.dictionarySourceId,
    required this.dictionarySourceName,
    this.partOfSpeech,
    this.pronunciation,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['word'] = Variable<String>(word);
    map['normalized_word'] = Variable<String>(normalizedWord);
    map['definition'] = Variable<String>(definition);
    map['source_sentence'] = Variable<String>(sourceSentence);
    map['book_id'] = Variable<String>(bookId);
    map['bite_id'] = Variable<String>(biteId);
    if (!nullToAbsent || dictionarySourceId != null) {
      map['dictionary_source_id'] = Variable<String>(dictionarySourceId);
    }
    map['dictionary_source_name'] = Variable<String>(dictionarySourceName);
    if (!nullToAbsent || partOfSpeech != null) {
      map['part_of_speech'] = Variable<String>(partOfSpeech);
    }
    if (!nullToAbsent || pronunciation != null) {
      map['pronunciation'] = Variable<String>(pronunciation);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  VocabularyEntriesCompanion toCompanion(bool nullToAbsent) {
    return VocabularyEntriesCompanion(
      id: Value(id),
      word: Value(word),
      normalizedWord: Value(normalizedWord),
      definition: Value(definition),
      sourceSentence: Value(sourceSentence),
      bookId: Value(bookId),
      biteId: Value(biteId),
      dictionarySourceId: dictionarySourceId == null && nullToAbsent
          ? const Value.absent()
          : Value(dictionarySourceId),
      dictionarySourceName: Value(dictionarySourceName),
      partOfSpeech: partOfSpeech == null && nullToAbsent
          ? const Value.absent()
          : Value(partOfSpeech),
      pronunciation: pronunciation == null && nullToAbsent
          ? const Value.absent()
          : Value(pronunciation),
      createdAt: Value(createdAt),
    );
  }

  factory VocabularyEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VocabularyEntry(
      id: serializer.fromJson<String>(json['id']),
      word: serializer.fromJson<String>(json['word']),
      normalizedWord: serializer.fromJson<String>(json['normalizedWord']),
      definition: serializer.fromJson<String>(json['definition']),
      sourceSentence: serializer.fromJson<String>(json['sourceSentence']),
      bookId: serializer.fromJson<String>(json['bookId']),
      biteId: serializer.fromJson<String>(json['biteId']),
      dictionarySourceId: serializer.fromJson<String?>(
        json['dictionarySourceId'],
      ),
      dictionarySourceName: serializer.fromJson<String>(
        json['dictionarySourceName'],
      ),
      partOfSpeech: serializer.fromJson<String?>(json['partOfSpeech']),
      pronunciation: serializer.fromJson<String?>(json['pronunciation']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'word': serializer.toJson<String>(word),
      'normalizedWord': serializer.toJson<String>(normalizedWord),
      'definition': serializer.toJson<String>(definition),
      'sourceSentence': serializer.toJson<String>(sourceSentence),
      'bookId': serializer.toJson<String>(bookId),
      'biteId': serializer.toJson<String>(biteId),
      'dictionarySourceId': serializer.toJson<String?>(dictionarySourceId),
      'dictionarySourceName': serializer.toJson<String>(dictionarySourceName),
      'partOfSpeech': serializer.toJson<String?>(partOfSpeech),
      'pronunciation': serializer.toJson<String?>(pronunciation),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  VocabularyEntry copyWith({
    String? id,
    String? word,
    String? normalizedWord,
    String? definition,
    String? sourceSentence,
    String? bookId,
    String? biteId,
    Value<String?> dictionarySourceId = const Value.absent(),
    String? dictionarySourceName,
    Value<String?> partOfSpeech = const Value.absent(),
    Value<String?> pronunciation = const Value.absent(),
    DateTime? createdAt,
  }) => VocabularyEntry(
    id: id ?? this.id,
    word: word ?? this.word,
    normalizedWord: normalizedWord ?? this.normalizedWord,
    definition: definition ?? this.definition,
    sourceSentence: sourceSentence ?? this.sourceSentence,
    bookId: bookId ?? this.bookId,
    biteId: biteId ?? this.biteId,
    dictionarySourceId: dictionarySourceId.present
        ? dictionarySourceId.value
        : this.dictionarySourceId,
    dictionarySourceName: dictionarySourceName ?? this.dictionarySourceName,
    partOfSpeech: partOfSpeech.present ? partOfSpeech.value : this.partOfSpeech,
    pronunciation: pronunciation.present
        ? pronunciation.value
        : this.pronunciation,
    createdAt: createdAt ?? this.createdAt,
  );
  VocabularyEntry copyWithCompanion(VocabularyEntriesCompanion data) {
    return VocabularyEntry(
      id: data.id.present ? data.id.value : this.id,
      word: data.word.present ? data.word.value : this.word,
      normalizedWord: data.normalizedWord.present
          ? data.normalizedWord.value
          : this.normalizedWord,
      definition: data.definition.present
          ? data.definition.value
          : this.definition,
      sourceSentence: data.sourceSentence.present
          ? data.sourceSentence.value
          : this.sourceSentence,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      biteId: data.biteId.present ? data.biteId.value : this.biteId,
      dictionarySourceId: data.dictionarySourceId.present
          ? data.dictionarySourceId.value
          : this.dictionarySourceId,
      dictionarySourceName: data.dictionarySourceName.present
          ? data.dictionarySourceName.value
          : this.dictionarySourceName,
      partOfSpeech: data.partOfSpeech.present
          ? data.partOfSpeech.value
          : this.partOfSpeech,
      pronunciation: data.pronunciation.present
          ? data.pronunciation.value
          : this.pronunciation,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VocabularyEntry(')
          ..write('id: $id, ')
          ..write('word: $word, ')
          ..write('normalizedWord: $normalizedWord, ')
          ..write('definition: $definition, ')
          ..write('sourceSentence: $sourceSentence, ')
          ..write('bookId: $bookId, ')
          ..write('biteId: $biteId, ')
          ..write('dictionarySourceId: $dictionarySourceId, ')
          ..write('dictionarySourceName: $dictionarySourceName, ')
          ..write('partOfSpeech: $partOfSpeech, ')
          ..write('pronunciation: $pronunciation, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    word,
    normalizedWord,
    definition,
    sourceSentence,
    bookId,
    biteId,
    dictionarySourceId,
    dictionarySourceName,
    partOfSpeech,
    pronunciation,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VocabularyEntry &&
          other.id == this.id &&
          other.word == this.word &&
          other.normalizedWord == this.normalizedWord &&
          other.definition == this.definition &&
          other.sourceSentence == this.sourceSentence &&
          other.bookId == this.bookId &&
          other.biteId == this.biteId &&
          other.dictionarySourceId == this.dictionarySourceId &&
          other.dictionarySourceName == this.dictionarySourceName &&
          other.partOfSpeech == this.partOfSpeech &&
          other.pronunciation == this.pronunciation &&
          other.createdAt == this.createdAt);
}

class VocabularyEntriesCompanion extends UpdateCompanion<VocabularyEntry> {
  final Value<String> id;
  final Value<String> word;
  final Value<String> normalizedWord;
  final Value<String> definition;
  final Value<String> sourceSentence;
  final Value<String> bookId;
  final Value<String> biteId;
  final Value<String?> dictionarySourceId;
  final Value<String> dictionarySourceName;
  final Value<String?> partOfSpeech;
  final Value<String?> pronunciation;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const VocabularyEntriesCompanion({
    this.id = const Value.absent(),
    this.word = const Value.absent(),
    this.normalizedWord = const Value.absent(),
    this.definition = const Value.absent(),
    this.sourceSentence = const Value.absent(),
    this.bookId = const Value.absent(),
    this.biteId = const Value.absent(),
    this.dictionarySourceId = const Value.absent(),
    this.dictionarySourceName = const Value.absent(),
    this.partOfSpeech = const Value.absent(),
    this.pronunciation = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VocabularyEntriesCompanion.insert({
    required String id,
    required String word,
    required String normalizedWord,
    required String definition,
    required String sourceSentence,
    required String bookId,
    required String biteId,
    this.dictionarySourceId = const Value.absent(),
    this.dictionarySourceName = const Value.absent(),
    this.partOfSpeech = const Value.absent(),
    this.pronunciation = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       word = Value(word),
       normalizedWord = Value(normalizedWord),
       definition = Value(definition),
       sourceSentence = Value(sourceSentence),
       bookId = Value(bookId),
       biteId = Value(biteId),
       createdAt = Value(createdAt);
  static Insertable<VocabularyEntry> custom({
    Expression<String>? id,
    Expression<String>? word,
    Expression<String>? normalizedWord,
    Expression<String>? definition,
    Expression<String>? sourceSentence,
    Expression<String>? bookId,
    Expression<String>? biteId,
    Expression<String>? dictionarySourceId,
    Expression<String>? dictionarySourceName,
    Expression<String>? partOfSpeech,
    Expression<String>? pronunciation,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (word != null) 'word': word,
      if (normalizedWord != null) 'normalized_word': normalizedWord,
      if (definition != null) 'definition': definition,
      if (sourceSentence != null) 'source_sentence': sourceSentence,
      if (bookId != null) 'book_id': bookId,
      if (biteId != null) 'bite_id': biteId,
      if (dictionarySourceId != null)
        'dictionary_source_id': dictionarySourceId,
      if (dictionarySourceName != null)
        'dictionary_source_name': dictionarySourceName,
      if (partOfSpeech != null) 'part_of_speech': partOfSpeech,
      if (pronunciation != null) 'pronunciation': pronunciation,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VocabularyEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? word,
    Value<String>? normalizedWord,
    Value<String>? definition,
    Value<String>? sourceSentence,
    Value<String>? bookId,
    Value<String>? biteId,
    Value<String?>? dictionarySourceId,
    Value<String>? dictionarySourceName,
    Value<String?>? partOfSpeech,
    Value<String?>? pronunciation,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return VocabularyEntriesCompanion(
      id: id ?? this.id,
      word: word ?? this.word,
      normalizedWord: normalizedWord ?? this.normalizedWord,
      definition: definition ?? this.definition,
      sourceSentence: sourceSentence ?? this.sourceSentence,
      bookId: bookId ?? this.bookId,
      biteId: biteId ?? this.biteId,
      dictionarySourceId: dictionarySourceId ?? this.dictionarySourceId,
      dictionarySourceName: dictionarySourceName ?? this.dictionarySourceName,
      partOfSpeech: partOfSpeech ?? this.partOfSpeech,
      pronunciation: pronunciation ?? this.pronunciation,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (word.present) {
      map['word'] = Variable<String>(word.value);
    }
    if (normalizedWord.present) {
      map['normalized_word'] = Variable<String>(normalizedWord.value);
    }
    if (definition.present) {
      map['definition'] = Variable<String>(definition.value);
    }
    if (sourceSentence.present) {
      map['source_sentence'] = Variable<String>(sourceSentence.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<String>(bookId.value);
    }
    if (biteId.present) {
      map['bite_id'] = Variable<String>(biteId.value);
    }
    if (dictionarySourceId.present) {
      map['dictionary_source_id'] = Variable<String>(dictionarySourceId.value);
    }
    if (dictionarySourceName.present) {
      map['dictionary_source_name'] = Variable<String>(
        dictionarySourceName.value,
      );
    }
    if (partOfSpeech.present) {
      map['part_of_speech'] = Variable<String>(partOfSpeech.value);
    }
    if (pronunciation.present) {
      map['pronunciation'] = Variable<String>(pronunciation.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VocabularyEntriesCompanion(')
          ..write('id: $id, ')
          ..write('word: $word, ')
          ..write('normalizedWord: $normalizedWord, ')
          ..write('definition: $definition, ')
          ..write('sourceSentence: $sourceSentence, ')
          ..write('bookId: $bookId, ')
          ..write('biteId: $biteId, ')
          ..write('dictionarySourceId: $dictionarySourceId, ')
          ..write('dictionarySourceName: $dictionarySourceName, ')
          ..write('partOfSpeech: $partOfSpeech, ')
          ..write('pronunciation: $pronunciation, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DictionaryImportStatesTable extends DictionaryImportStates
    with TableInfo<$DictionaryImportStatesTable, DictionaryImportState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DictionaryImportStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES dictionary_sources (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _stageMeta = const VerificationMeta('stage');
  @override
  late final GeneratedColumn<String> stage = GeneratedColumn<String>(
    'stage',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<int> completed = GeneratedColumn<int>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<int> total = GeneratedColumn<int>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _errorMeta = const VerificationMeta('error');
  @override
  late final GeneratedColumn<String> error = GeneratedColumn<String>(
    'error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    sourceId,
    stage,
    completed,
    total,
    error,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dictionary_import_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<DictionaryImportState> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('stage')) {
      context.handle(
        _stageMeta,
        stage.isAcceptableOrUnknown(data['stage']!, _stageMeta),
      );
    } else if (isInserting) {
      context.missing(_stageMeta);
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    }
    if (data.containsKey('error')) {
      context.handle(
        _errorMeta,
        error.isAcceptableOrUnknown(data['error']!, _errorMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sourceId};
  @override
  DictionaryImportState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DictionaryImportState(
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      )!,
      stage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stage'],
      )!,
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total'],
      )!,
      error: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DictionaryImportStatesTable createAlias(String alias) {
    return $DictionaryImportStatesTable(attachedDatabase, alias);
  }
}

class DictionaryImportState extends DataClass
    implements Insertable<DictionaryImportState> {
  final String sourceId;
  final String stage;
  final int completed;
  final int total;
  final String? error;
  final DateTime updatedAt;
  const DictionaryImportState({
    required this.sourceId,
    required this.stage,
    required this.completed,
    required this.total,
    this.error,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['source_id'] = Variable<String>(sourceId);
    map['stage'] = Variable<String>(stage);
    map['completed'] = Variable<int>(completed);
    map['total'] = Variable<int>(total);
    if (!nullToAbsent || error != null) {
      map['error'] = Variable<String>(error);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DictionaryImportStatesCompanion toCompanion(bool nullToAbsent) {
    return DictionaryImportStatesCompanion(
      sourceId: Value(sourceId),
      stage: Value(stage),
      completed: Value(completed),
      total: Value(total),
      error: error == null && nullToAbsent
          ? const Value.absent()
          : Value(error),
      updatedAt: Value(updatedAt),
    );
  }

  factory DictionaryImportState.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DictionaryImportState(
      sourceId: serializer.fromJson<String>(json['sourceId']),
      stage: serializer.fromJson<String>(json['stage']),
      completed: serializer.fromJson<int>(json['completed']),
      total: serializer.fromJson<int>(json['total']),
      error: serializer.fromJson<String?>(json['error']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sourceId': serializer.toJson<String>(sourceId),
      'stage': serializer.toJson<String>(stage),
      'completed': serializer.toJson<int>(completed),
      'total': serializer.toJson<int>(total),
      'error': serializer.toJson<String?>(error),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DictionaryImportState copyWith({
    String? sourceId,
    String? stage,
    int? completed,
    int? total,
    Value<String?> error = const Value.absent(),
    DateTime? updatedAt,
  }) => DictionaryImportState(
    sourceId: sourceId ?? this.sourceId,
    stage: stage ?? this.stage,
    completed: completed ?? this.completed,
    total: total ?? this.total,
    error: error.present ? error.value : this.error,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DictionaryImportState copyWithCompanion(
    DictionaryImportStatesCompanion data,
  ) {
    return DictionaryImportState(
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      stage: data.stage.present ? data.stage.value : this.stage,
      completed: data.completed.present ? data.completed.value : this.completed,
      total: data.total.present ? data.total.value : this.total,
      error: data.error.present ? data.error.value : this.error,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DictionaryImportState(')
          ..write('sourceId: $sourceId, ')
          ..write('stage: $stage, ')
          ..write('completed: $completed, ')
          ..write('total: $total, ')
          ..write('error: $error, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(sourceId, stage, completed, total, error, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DictionaryImportState &&
          other.sourceId == this.sourceId &&
          other.stage == this.stage &&
          other.completed == this.completed &&
          other.total == this.total &&
          other.error == this.error &&
          other.updatedAt == this.updatedAt);
}

class DictionaryImportStatesCompanion
    extends UpdateCompanion<DictionaryImportState> {
  final Value<String> sourceId;
  final Value<String> stage;
  final Value<int> completed;
  final Value<int> total;
  final Value<String?> error;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DictionaryImportStatesCompanion({
    this.sourceId = const Value.absent(),
    this.stage = const Value.absent(),
    this.completed = const Value.absent(),
    this.total = const Value.absent(),
    this.error = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DictionaryImportStatesCompanion.insert({
    required String sourceId,
    required String stage,
    this.completed = const Value.absent(),
    this.total = const Value.absent(),
    this.error = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : sourceId = Value(sourceId),
       stage = Value(stage),
       updatedAt = Value(updatedAt);
  static Insertable<DictionaryImportState> custom({
    Expression<String>? sourceId,
    Expression<String>? stage,
    Expression<int>? completed,
    Expression<int>? total,
    Expression<String>? error,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sourceId != null) 'source_id': sourceId,
      if (stage != null) 'stage': stage,
      if (completed != null) 'completed': completed,
      if (total != null) 'total': total,
      if (error != null) 'error': error,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DictionaryImportStatesCompanion copyWith({
    Value<String>? sourceId,
    Value<String>? stage,
    Value<int>? completed,
    Value<int>? total,
    Value<String?>? error,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return DictionaryImportStatesCompanion(
      sourceId: sourceId ?? this.sourceId,
      stage: stage ?? this.stage,
      completed: completed ?? this.completed,
      total: total ?? this.total,
      error: error ?? this.error,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (stage.present) {
      map['stage'] = Variable<String>(stage.value);
    }
    if (completed.present) {
      map['completed'] = Variable<int>(completed.value);
    }
    if (total.present) {
      map['total'] = Variable<int>(total.value);
    }
    if (error.present) {
      map['error'] = Variable<String>(error.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DictionaryImportStatesCompanion(')
          ..write('sourceId: $sourceId, ')
          ..write('stage: $stage, ')
          ..write('completed: $completed, ')
          ..write('total: $total, ')
          ..write('error: $error, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HighlightNotesTable extends HighlightNotes
    with TableInfo<$HighlightNotesTable, HighlightNote> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HighlightNotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<String> bookId = GeneratedColumn<String>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES books (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _biteIdMeta = const VerificationMeta('biteId');
  @override
  late final GeneratedColumn<String> biteId = GeneratedColumn<String>(
    'bite_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES bites (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _noteTextMeta = const VerificationMeta(
    'noteText',
  );
  @override
  late final GeneratedColumn<String> noteText = GeneratedColumn<String>(
    'note_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    bookId,
    biteId,
    noteText,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'highlight_notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<HighlightNote> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('bite_id')) {
      context.handle(
        _biteIdMeta,
        biteId.isAcceptableOrUnknown(data['bite_id']!, _biteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_biteIdMeta);
    }
    if (data.containsKey('note_text')) {
      context.handle(
        _noteTextMeta,
        noteText.isAcceptableOrUnknown(data['note_text']!, _noteTextMeta),
      );
    } else if (isInserting) {
      context.missing(_noteTextMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HighlightNote map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HighlightNote(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}book_id'],
      )!,
      biteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bite_id'],
      )!,
      noteText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note_text'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $HighlightNotesTable createAlias(String alias) {
    return $HighlightNotesTable(attachedDatabase, alias);
  }
}

class HighlightNote extends DataClass implements Insertable<HighlightNote> {
  final String id;
  final String bookId;
  final String biteId;
  final String noteText;
  final DateTime createdAt;
  final DateTime updatedAt;
  const HighlightNote({
    required this.id,
    required this.bookId,
    required this.biteId,
    required this.noteText,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['book_id'] = Variable<String>(bookId);
    map['bite_id'] = Variable<String>(biteId);
    map['note_text'] = Variable<String>(noteText);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  HighlightNotesCompanion toCompanion(bool nullToAbsent) {
    return HighlightNotesCompanion(
      id: Value(id),
      bookId: Value(bookId),
      biteId: Value(biteId),
      noteText: Value(noteText),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory HighlightNote.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HighlightNote(
      id: serializer.fromJson<String>(json['id']),
      bookId: serializer.fromJson<String>(json['bookId']),
      biteId: serializer.fromJson<String>(json['biteId']),
      noteText: serializer.fromJson<String>(json['noteText']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'bookId': serializer.toJson<String>(bookId),
      'biteId': serializer.toJson<String>(biteId),
      'noteText': serializer.toJson<String>(noteText),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  HighlightNote copyWith({
    String? id,
    String? bookId,
    String? biteId,
    String? noteText,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => HighlightNote(
    id: id ?? this.id,
    bookId: bookId ?? this.bookId,
    biteId: biteId ?? this.biteId,
    noteText: noteText ?? this.noteText,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  HighlightNote copyWithCompanion(HighlightNotesCompanion data) {
    return HighlightNote(
      id: data.id.present ? data.id.value : this.id,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      biteId: data.biteId.present ? data.biteId.value : this.biteId,
      noteText: data.noteText.present ? data.noteText.value : this.noteText,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HighlightNote(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('biteId: $biteId, ')
          ..write('noteText: $noteText, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, bookId, biteId, noteText, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HighlightNote &&
          other.id == this.id &&
          other.bookId == this.bookId &&
          other.biteId == this.biteId &&
          other.noteText == this.noteText &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class HighlightNotesCompanion extends UpdateCompanion<HighlightNote> {
  final Value<String> id;
  final Value<String> bookId;
  final Value<String> biteId;
  final Value<String> noteText;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const HighlightNotesCompanion({
    this.id = const Value.absent(),
    this.bookId = const Value.absent(),
    this.biteId = const Value.absent(),
    this.noteText = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HighlightNotesCompanion.insert({
    required String id,
    required String bookId,
    required String biteId,
    required String noteText,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       bookId = Value(bookId),
       biteId = Value(biteId),
       noteText = Value(noteText),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<HighlightNote> custom({
    Expression<String>? id,
    Expression<String>? bookId,
    Expression<String>? biteId,
    Expression<String>? noteText,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookId != null) 'book_id': bookId,
      if (biteId != null) 'bite_id': biteId,
      if (noteText != null) 'note_text': noteText,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HighlightNotesCompanion copyWith({
    Value<String>? id,
    Value<String>? bookId,
    Value<String>? biteId,
    Value<String>? noteText,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return HighlightNotesCompanion(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      biteId: biteId ?? this.biteId,
      noteText: noteText ?? this.noteText,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<String>(bookId.value);
    }
    if (biteId.present) {
      map['bite_id'] = Variable<String>(biteId.value);
    }
    if (noteText.present) {
      map['note_text'] = Variable<String>(noteText.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HighlightNotesCompanion(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('biteId: $biteId, ')
          ..write('noteText: $noteText, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HighlightsTable extends Highlights
    with TableInfo<$HighlightsTable, Highlight> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HighlightsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<String> bookId = GeneratedColumn<String>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES books (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _biteIdMeta = const VerificationMeta('biteId');
  @override
  late final GeneratedColumn<String> biteId = GeneratedColumn<String>(
    'bite_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES bites (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _startOffsetMeta = const VerificationMeta(
    'startOffset',
  );
  @override
  late final GeneratedColumn<int> startOffset = GeneratedColumn<int>(
    'start_offset',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endOffsetMeta = const VerificationMeta(
    'endOffset',
  );
  @override
  late final GeneratedColumn<int> endOffset = GeneratedColumn<int>(
    'end_offset',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _selectedTextMeta = const VerificationMeta(
    'selectedText',
  );
  @override
  late final GeneratedColumn<String> selectedText = GeneratedColumn<String>(
    'selected_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _prefixContextMeta = const VerificationMeta(
    'prefixContext',
  );
  @override
  late final GeneratedColumn<String> prefixContext = GeneratedColumn<String>(
    'prefix_context',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _suffixContextMeta = const VerificationMeta(
    'suffixContext',
  );
  @override
  late final GeneratedColumn<String> suffixContext = GeneratedColumn<String>(
    'suffix_context',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentChecksumMeta = const VerificationMeta(
    'contentChecksum',
  );
  @override
  late final GeneratedColumn<String> contentChecksum = GeneratedColumn<String>(
    'content_checksum',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _styleMeta = const VerificationMeta('style');
  @override
  late final GeneratedColumn<String> style = GeneratedColumn<String>(
    'style',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteIdMeta = const VerificationMeta('noteId');
  @override
  late final GeneratedColumn<String> noteId = GeneratedColumn<String>(
    'note_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES highlight_notes (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _resolvedMeta = const VerificationMeta(
    'resolved',
  );
  @override
  late final GeneratedColumn<bool> resolved = GeneratedColumn<bool>(
    'resolved',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("resolved" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    bookId,
    biteId,
    startOffset,
    endOffset,
    selectedText,
    prefixContext,
    suffixContext,
    contentChecksum,
    style,
    color,
    noteId,
    resolved,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'highlights';
  @override
  VerificationContext validateIntegrity(
    Insertable<Highlight> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('bite_id')) {
      context.handle(
        _biteIdMeta,
        biteId.isAcceptableOrUnknown(data['bite_id']!, _biteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_biteIdMeta);
    }
    if (data.containsKey('start_offset')) {
      context.handle(
        _startOffsetMeta,
        startOffset.isAcceptableOrUnknown(
          data['start_offset']!,
          _startOffsetMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startOffsetMeta);
    }
    if (data.containsKey('end_offset')) {
      context.handle(
        _endOffsetMeta,
        endOffset.isAcceptableOrUnknown(data['end_offset']!, _endOffsetMeta),
      );
    } else if (isInserting) {
      context.missing(_endOffsetMeta);
    }
    if (data.containsKey('selected_text')) {
      context.handle(
        _selectedTextMeta,
        selectedText.isAcceptableOrUnknown(
          data['selected_text']!,
          _selectedTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_selectedTextMeta);
    }
    if (data.containsKey('prefix_context')) {
      context.handle(
        _prefixContextMeta,
        prefixContext.isAcceptableOrUnknown(
          data['prefix_context']!,
          _prefixContextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_prefixContextMeta);
    }
    if (data.containsKey('suffix_context')) {
      context.handle(
        _suffixContextMeta,
        suffixContext.isAcceptableOrUnknown(
          data['suffix_context']!,
          _suffixContextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_suffixContextMeta);
    }
    if (data.containsKey('content_checksum')) {
      context.handle(
        _contentChecksumMeta,
        contentChecksum.isAcceptableOrUnknown(
          data['content_checksum']!,
          _contentChecksumMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentChecksumMeta);
    }
    if (data.containsKey('style')) {
      context.handle(
        _styleMeta,
        style.isAcceptableOrUnknown(data['style']!, _styleMeta),
      );
    } else if (isInserting) {
      context.missing(_styleMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('note_id')) {
      context.handle(
        _noteIdMeta,
        noteId.isAcceptableOrUnknown(data['note_id']!, _noteIdMeta),
      );
    }
    if (data.containsKey('resolved')) {
      context.handle(
        _resolvedMeta,
        resolved.isAcceptableOrUnknown(data['resolved']!, _resolvedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {biteId, startOffset, endOffset},
  ];
  @override
  Highlight map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Highlight(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}book_id'],
      )!,
      biteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bite_id'],
      )!,
      startOffset: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_offset'],
      )!,
      endOffset: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_offset'],
      )!,
      selectedText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selected_text'],
      )!,
      prefixContext: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prefix_context'],
      )!,
      suffixContext: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}suffix_context'],
      )!,
      contentChecksum: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_checksum'],
      )!,
      style: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}style'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      )!,
      noteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note_id'],
      ),
      resolved: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}resolved'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $HighlightsTable createAlias(String alias) {
    return $HighlightsTable(attachedDatabase, alias);
  }
}

class Highlight extends DataClass implements Insertable<Highlight> {
  final String id;
  final String bookId;
  final String biteId;
  final int startOffset;
  final int endOffset;
  final String selectedText;
  final String prefixContext;
  final String suffixContext;
  final String contentChecksum;
  final String style;
  final String color;
  final String? noteId;
  final bool resolved;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Highlight({
    required this.id,
    required this.bookId,
    required this.biteId,
    required this.startOffset,
    required this.endOffset,
    required this.selectedText,
    required this.prefixContext,
    required this.suffixContext,
    required this.contentChecksum,
    required this.style,
    required this.color,
    this.noteId,
    required this.resolved,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['book_id'] = Variable<String>(bookId);
    map['bite_id'] = Variable<String>(biteId);
    map['start_offset'] = Variable<int>(startOffset);
    map['end_offset'] = Variable<int>(endOffset);
    map['selected_text'] = Variable<String>(selectedText);
    map['prefix_context'] = Variable<String>(prefixContext);
    map['suffix_context'] = Variable<String>(suffixContext);
    map['content_checksum'] = Variable<String>(contentChecksum);
    map['style'] = Variable<String>(style);
    map['color'] = Variable<String>(color);
    if (!nullToAbsent || noteId != null) {
      map['note_id'] = Variable<String>(noteId);
    }
    map['resolved'] = Variable<bool>(resolved);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  HighlightsCompanion toCompanion(bool nullToAbsent) {
    return HighlightsCompanion(
      id: Value(id),
      bookId: Value(bookId),
      biteId: Value(biteId),
      startOffset: Value(startOffset),
      endOffset: Value(endOffset),
      selectedText: Value(selectedText),
      prefixContext: Value(prefixContext),
      suffixContext: Value(suffixContext),
      contentChecksum: Value(contentChecksum),
      style: Value(style),
      color: Value(color),
      noteId: noteId == null && nullToAbsent
          ? const Value.absent()
          : Value(noteId),
      resolved: Value(resolved),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Highlight.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Highlight(
      id: serializer.fromJson<String>(json['id']),
      bookId: serializer.fromJson<String>(json['bookId']),
      biteId: serializer.fromJson<String>(json['biteId']),
      startOffset: serializer.fromJson<int>(json['startOffset']),
      endOffset: serializer.fromJson<int>(json['endOffset']),
      selectedText: serializer.fromJson<String>(json['selectedText']),
      prefixContext: serializer.fromJson<String>(json['prefixContext']),
      suffixContext: serializer.fromJson<String>(json['suffixContext']),
      contentChecksum: serializer.fromJson<String>(json['contentChecksum']),
      style: serializer.fromJson<String>(json['style']),
      color: serializer.fromJson<String>(json['color']),
      noteId: serializer.fromJson<String?>(json['noteId']),
      resolved: serializer.fromJson<bool>(json['resolved']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'bookId': serializer.toJson<String>(bookId),
      'biteId': serializer.toJson<String>(biteId),
      'startOffset': serializer.toJson<int>(startOffset),
      'endOffset': serializer.toJson<int>(endOffset),
      'selectedText': serializer.toJson<String>(selectedText),
      'prefixContext': serializer.toJson<String>(prefixContext),
      'suffixContext': serializer.toJson<String>(suffixContext),
      'contentChecksum': serializer.toJson<String>(contentChecksum),
      'style': serializer.toJson<String>(style),
      'color': serializer.toJson<String>(color),
      'noteId': serializer.toJson<String?>(noteId),
      'resolved': serializer.toJson<bool>(resolved),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Highlight copyWith({
    String? id,
    String? bookId,
    String? biteId,
    int? startOffset,
    int? endOffset,
    String? selectedText,
    String? prefixContext,
    String? suffixContext,
    String? contentChecksum,
    String? style,
    String? color,
    Value<String?> noteId = const Value.absent(),
    bool? resolved,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Highlight(
    id: id ?? this.id,
    bookId: bookId ?? this.bookId,
    biteId: biteId ?? this.biteId,
    startOffset: startOffset ?? this.startOffset,
    endOffset: endOffset ?? this.endOffset,
    selectedText: selectedText ?? this.selectedText,
    prefixContext: prefixContext ?? this.prefixContext,
    suffixContext: suffixContext ?? this.suffixContext,
    contentChecksum: contentChecksum ?? this.contentChecksum,
    style: style ?? this.style,
    color: color ?? this.color,
    noteId: noteId.present ? noteId.value : this.noteId,
    resolved: resolved ?? this.resolved,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Highlight copyWithCompanion(HighlightsCompanion data) {
    return Highlight(
      id: data.id.present ? data.id.value : this.id,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      biteId: data.biteId.present ? data.biteId.value : this.biteId,
      startOffset: data.startOffset.present
          ? data.startOffset.value
          : this.startOffset,
      endOffset: data.endOffset.present ? data.endOffset.value : this.endOffset,
      selectedText: data.selectedText.present
          ? data.selectedText.value
          : this.selectedText,
      prefixContext: data.prefixContext.present
          ? data.prefixContext.value
          : this.prefixContext,
      suffixContext: data.suffixContext.present
          ? data.suffixContext.value
          : this.suffixContext,
      contentChecksum: data.contentChecksum.present
          ? data.contentChecksum.value
          : this.contentChecksum,
      style: data.style.present ? data.style.value : this.style,
      color: data.color.present ? data.color.value : this.color,
      noteId: data.noteId.present ? data.noteId.value : this.noteId,
      resolved: data.resolved.present ? data.resolved.value : this.resolved,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Highlight(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('biteId: $biteId, ')
          ..write('startOffset: $startOffset, ')
          ..write('endOffset: $endOffset, ')
          ..write('selectedText: $selectedText, ')
          ..write('prefixContext: $prefixContext, ')
          ..write('suffixContext: $suffixContext, ')
          ..write('contentChecksum: $contentChecksum, ')
          ..write('style: $style, ')
          ..write('color: $color, ')
          ..write('noteId: $noteId, ')
          ..write('resolved: $resolved, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    bookId,
    biteId,
    startOffset,
    endOffset,
    selectedText,
    prefixContext,
    suffixContext,
    contentChecksum,
    style,
    color,
    noteId,
    resolved,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Highlight &&
          other.id == this.id &&
          other.bookId == this.bookId &&
          other.biteId == this.biteId &&
          other.startOffset == this.startOffset &&
          other.endOffset == this.endOffset &&
          other.selectedText == this.selectedText &&
          other.prefixContext == this.prefixContext &&
          other.suffixContext == this.suffixContext &&
          other.contentChecksum == this.contentChecksum &&
          other.style == this.style &&
          other.color == this.color &&
          other.noteId == this.noteId &&
          other.resolved == this.resolved &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class HighlightsCompanion extends UpdateCompanion<Highlight> {
  final Value<String> id;
  final Value<String> bookId;
  final Value<String> biteId;
  final Value<int> startOffset;
  final Value<int> endOffset;
  final Value<String> selectedText;
  final Value<String> prefixContext;
  final Value<String> suffixContext;
  final Value<String> contentChecksum;
  final Value<String> style;
  final Value<String> color;
  final Value<String?> noteId;
  final Value<bool> resolved;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const HighlightsCompanion({
    this.id = const Value.absent(),
    this.bookId = const Value.absent(),
    this.biteId = const Value.absent(),
    this.startOffset = const Value.absent(),
    this.endOffset = const Value.absent(),
    this.selectedText = const Value.absent(),
    this.prefixContext = const Value.absent(),
    this.suffixContext = const Value.absent(),
    this.contentChecksum = const Value.absent(),
    this.style = const Value.absent(),
    this.color = const Value.absent(),
    this.noteId = const Value.absent(),
    this.resolved = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HighlightsCompanion.insert({
    required String id,
    required String bookId,
    required String biteId,
    required int startOffset,
    required int endOffset,
    required String selectedText,
    required String prefixContext,
    required String suffixContext,
    required String contentChecksum,
    required String style,
    required String color,
    this.noteId = const Value.absent(),
    this.resolved = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       bookId = Value(bookId),
       biteId = Value(biteId),
       startOffset = Value(startOffset),
       endOffset = Value(endOffset),
       selectedText = Value(selectedText),
       prefixContext = Value(prefixContext),
       suffixContext = Value(suffixContext),
       contentChecksum = Value(contentChecksum),
       style = Value(style),
       color = Value(color),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Highlight> custom({
    Expression<String>? id,
    Expression<String>? bookId,
    Expression<String>? biteId,
    Expression<int>? startOffset,
    Expression<int>? endOffset,
    Expression<String>? selectedText,
    Expression<String>? prefixContext,
    Expression<String>? suffixContext,
    Expression<String>? contentChecksum,
    Expression<String>? style,
    Expression<String>? color,
    Expression<String>? noteId,
    Expression<bool>? resolved,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookId != null) 'book_id': bookId,
      if (biteId != null) 'bite_id': biteId,
      if (startOffset != null) 'start_offset': startOffset,
      if (endOffset != null) 'end_offset': endOffset,
      if (selectedText != null) 'selected_text': selectedText,
      if (prefixContext != null) 'prefix_context': prefixContext,
      if (suffixContext != null) 'suffix_context': suffixContext,
      if (contentChecksum != null) 'content_checksum': contentChecksum,
      if (style != null) 'style': style,
      if (color != null) 'color': color,
      if (noteId != null) 'note_id': noteId,
      if (resolved != null) 'resolved': resolved,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HighlightsCompanion copyWith({
    Value<String>? id,
    Value<String>? bookId,
    Value<String>? biteId,
    Value<int>? startOffset,
    Value<int>? endOffset,
    Value<String>? selectedText,
    Value<String>? prefixContext,
    Value<String>? suffixContext,
    Value<String>? contentChecksum,
    Value<String>? style,
    Value<String>? color,
    Value<String?>? noteId,
    Value<bool>? resolved,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return HighlightsCompanion(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      biteId: biteId ?? this.biteId,
      startOffset: startOffset ?? this.startOffset,
      endOffset: endOffset ?? this.endOffset,
      selectedText: selectedText ?? this.selectedText,
      prefixContext: prefixContext ?? this.prefixContext,
      suffixContext: suffixContext ?? this.suffixContext,
      contentChecksum: contentChecksum ?? this.contentChecksum,
      style: style ?? this.style,
      color: color ?? this.color,
      noteId: noteId ?? this.noteId,
      resolved: resolved ?? this.resolved,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<String>(bookId.value);
    }
    if (biteId.present) {
      map['bite_id'] = Variable<String>(biteId.value);
    }
    if (startOffset.present) {
      map['start_offset'] = Variable<int>(startOffset.value);
    }
    if (endOffset.present) {
      map['end_offset'] = Variable<int>(endOffset.value);
    }
    if (selectedText.present) {
      map['selected_text'] = Variable<String>(selectedText.value);
    }
    if (prefixContext.present) {
      map['prefix_context'] = Variable<String>(prefixContext.value);
    }
    if (suffixContext.present) {
      map['suffix_context'] = Variable<String>(suffixContext.value);
    }
    if (contentChecksum.present) {
      map['content_checksum'] = Variable<String>(contentChecksum.value);
    }
    if (style.present) {
      map['style'] = Variable<String>(style.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (noteId.present) {
      map['note_id'] = Variable<String>(noteId.value);
    }
    if (resolved.present) {
      map['resolved'] = Variable<bool>(resolved.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HighlightsCompanion(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('biteId: $biteId, ')
          ..write('startOffset: $startOffset, ')
          ..write('endOffset: $endOffset, ')
          ..write('selectedText: $selectedText, ')
          ..write('prefixContext: $prefixContext, ')
          ..write('suffixContext: $suffixContext, ')
          ..write('contentChecksum: $contentChecksum, ')
          ..write('style: $style, ')
          ..write('color: $color, ')
          ..write('noteId: $noteId, ')
          ..write('resolved: $resolved, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReaderPreferencesTable extends ReaderPreferences
    with TableInfo<$ReaderPreferencesTable, ReaderPreference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReaderPreferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _themeMeta = const VerificationMeta('theme');
  @override
  late final GeneratedColumn<String> theme = GeneratedColumn<String>(
    'theme',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('system'),
  );
  static const VerificationMeta _fontSizeMeta = const VerificationMeta(
    'fontSize',
  );
  @override
  late final GeneratedColumn<double> fontSize = GeneratedColumn<double>(
    'font_size',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(20),
  );
  static const VerificationMeta _lineHeightMeta = const VerificationMeta(
    'lineHeight',
  );
  @override
  late final GeneratedColumn<double> lineHeight = GeneratedColumn<double>(
    'line_height',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.6),
  );
  static const VerificationMeta _alignmentMeta = const VerificationMeta(
    'alignment',
  );
  @override
  late final GeneratedColumn<String> alignment = GeneratedColumn<String>(
    'alignment',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('start'),
  );
  static const VerificationMeta _readingWidthMeta = const VerificationMeta(
    'readingWidth',
  );
  @override
  late final GeneratedColumn<double> readingWidth = GeneratedColumn<double>(
    'reading_width',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(680),
  );
  static const VerificationMeta _pageMarginMeta = const VerificationMeta(
    'pageMargin',
  );
  @override
  late final GeneratedColumn<double> pageMargin = GeneratedColumn<double>(
    'page_margin',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(24),
  );
  static const VerificationMeta _autoHideControlsMeta = const VerificationMeta(
    'autoHideControls',
  );
  @override
  late final GeneratedColumn<bool> autoHideControls = GeneratedColumn<bool>(
    'auto_hide_controls',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_hide_controls" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _hapticsEnabledMeta = const VerificationMeta(
    'hapticsEnabled',
  );
  @override
  late final GeneratedColumn<bool> hapticsEnabled = GeneratedColumn<bool>(
    'haptics_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("haptics_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    theme,
    fontSize,
    lineHeight,
    alignment,
    readingWidth,
    pageMargin,
    autoHideControls,
    hapticsEnabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reader_preferences';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReaderPreference> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('theme')) {
      context.handle(
        _themeMeta,
        theme.isAcceptableOrUnknown(data['theme']!, _themeMeta),
      );
    }
    if (data.containsKey('font_size')) {
      context.handle(
        _fontSizeMeta,
        fontSize.isAcceptableOrUnknown(data['font_size']!, _fontSizeMeta),
      );
    }
    if (data.containsKey('line_height')) {
      context.handle(
        _lineHeightMeta,
        lineHeight.isAcceptableOrUnknown(data['line_height']!, _lineHeightMeta),
      );
    }
    if (data.containsKey('alignment')) {
      context.handle(
        _alignmentMeta,
        alignment.isAcceptableOrUnknown(data['alignment']!, _alignmentMeta),
      );
    }
    if (data.containsKey('reading_width')) {
      context.handle(
        _readingWidthMeta,
        readingWidth.isAcceptableOrUnknown(
          data['reading_width']!,
          _readingWidthMeta,
        ),
      );
    }
    if (data.containsKey('page_margin')) {
      context.handle(
        _pageMarginMeta,
        pageMargin.isAcceptableOrUnknown(data['page_margin']!, _pageMarginMeta),
      );
    }
    if (data.containsKey('auto_hide_controls')) {
      context.handle(
        _autoHideControlsMeta,
        autoHideControls.isAcceptableOrUnknown(
          data['auto_hide_controls']!,
          _autoHideControlsMeta,
        ),
      );
    }
    if (data.containsKey('haptics_enabled')) {
      context.handle(
        _hapticsEnabledMeta,
        hapticsEnabled.isAcceptableOrUnknown(
          data['haptics_enabled']!,
          _hapticsEnabledMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReaderPreference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReaderPreference(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      theme: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme'],
      )!,
      fontSize: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}font_size'],
      )!,
      lineHeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}line_height'],
      )!,
      alignment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alignment'],
      )!,
      readingWidth: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}reading_width'],
      )!,
      pageMargin: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}page_margin'],
      )!,
      autoHideControls: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_hide_controls'],
      )!,
      hapticsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}haptics_enabled'],
      )!,
    );
  }

  @override
  $ReaderPreferencesTable createAlias(String alias) {
    return $ReaderPreferencesTable(attachedDatabase, alias);
  }
}

class ReaderPreference extends DataClass
    implements Insertable<ReaderPreference> {
  final int id;
  final String theme;
  final double fontSize;
  final double lineHeight;
  final String alignment;
  final double readingWidth;
  final double pageMargin;
  final bool autoHideControls;
  final bool hapticsEnabled;
  const ReaderPreference({
    required this.id,
    required this.theme,
    required this.fontSize,
    required this.lineHeight,
    required this.alignment,
    required this.readingWidth,
    required this.pageMargin,
    required this.autoHideControls,
    required this.hapticsEnabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['theme'] = Variable<String>(theme);
    map['font_size'] = Variable<double>(fontSize);
    map['line_height'] = Variable<double>(lineHeight);
    map['alignment'] = Variable<String>(alignment);
    map['reading_width'] = Variable<double>(readingWidth);
    map['page_margin'] = Variable<double>(pageMargin);
    map['auto_hide_controls'] = Variable<bool>(autoHideControls);
    map['haptics_enabled'] = Variable<bool>(hapticsEnabled);
    return map;
  }

  ReaderPreferencesCompanion toCompanion(bool nullToAbsent) {
    return ReaderPreferencesCompanion(
      id: Value(id),
      theme: Value(theme),
      fontSize: Value(fontSize),
      lineHeight: Value(lineHeight),
      alignment: Value(alignment),
      readingWidth: Value(readingWidth),
      pageMargin: Value(pageMargin),
      autoHideControls: Value(autoHideControls),
      hapticsEnabled: Value(hapticsEnabled),
    );
  }

  factory ReaderPreference.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReaderPreference(
      id: serializer.fromJson<int>(json['id']),
      theme: serializer.fromJson<String>(json['theme']),
      fontSize: serializer.fromJson<double>(json['fontSize']),
      lineHeight: serializer.fromJson<double>(json['lineHeight']),
      alignment: serializer.fromJson<String>(json['alignment']),
      readingWidth: serializer.fromJson<double>(json['readingWidth']),
      pageMargin: serializer.fromJson<double>(json['pageMargin']),
      autoHideControls: serializer.fromJson<bool>(json['autoHideControls']),
      hapticsEnabled: serializer.fromJson<bool>(json['hapticsEnabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'theme': serializer.toJson<String>(theme),
      'fontSize': serializer.toJson<double>(fontSize),
      'lineHeight': serializer.toJson<double>(lineHeight),
      'alignment': serializer.toJson<String>(alignment),
      'readingWidth': serializer.toJson<double>(readingWidth),
      'pageMargin': serializer.toJson<double>(pageMargin),
      'autoHideControls': serializer.toJson<bool>(autoHideControls),
      'hapticsEnabled': serializer.toJson<bool>(hapticsEnabled),
    };
  }

  ReaderPreference copyWith({
    int? id,
    String? theme,
    double? fontSize,
    double? lineHeight,
    String? alignment,
    double? readingWidth,
    double? pageMargin,
    bool? autoHideControls,
    bool? hapticsEnabled,
  }) => ReaderPreference(
    id: id ?? this.id,
    theme: theme ?? this.theme,
    fontSize: fontSize ?? this.fontSize,
    lineHeight: lineHeight ?? this.lineHeight,
    alignment: alignment ?? this.alignment,
    readingWidth: readingWidth ?? this.readingWidth,
    pageMargin: pageMargin ?? this.pageMargin,
    autoHideControls: autoHideControls ?? this.autoHideControls,
    hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
  );
  ReaderPreference copyWithCompanion(ReaderPreferencesCompanion data) {
    return ReaderPreference(
      id: data.id.present ? data.id.value : this.id,
      theme: data.theme.present ? data.theme.value : this.theme,
      fontSize: data.fontSize.present ? data.fontSize.value : this.fontSize,
      lineHeight: data.lineHeight.present
          ? data.lineHeight.value
          : this.lineHeight,
      alignment: data.alignment.present ? data.alignment.value : this.alignment,
      readingWidth: data.readingWidth.present
          ? data.readingWidth.value
          : this.readingWidth,
      pageMargin: data.pageMargin.present
          ? data.pageMargin.value
          : this.pageMargin,
      autoHideControls: data.autoHideControls.present
          ? data.autoHideControls.value
          : this.autoHideControls,
      hapticsEnabled: data.hapticsEnabled.present
          ? data.hapticsEnabled.value
          : this.hapticsEnabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReaderPreference(')
          ..write('id: $id, ')
          ..write('theme: $theme, ')
          ..write('fontSize: $fontSize, ')
          ..write('lineHeight: $lineHeight, ')
          ..write('alignment: $alignment, ')
          ..write('readingWidth: $readingWidth, ')
          ..write('pageMargin: $pageMargin, ')
          ..write('autoHideControls: $autoHideControls, ')
          ..write('hapticsEnabled: $hapticsEnabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    theme,
    fontSize,
    lineHeight,
    alignment,
    readingWidth,
    pageMargin,
    autoHideControls,
    hapticsEnabled,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReaderPreference &&
          other.id == this.id &&
          other.theme == this.theme &&
          other.fontSize == this.fontSize &&
          other.lineHeight == this.lineHeight &&
          other.alignment == this.alignment &&
          other.readingWidth == this.readingWidth &&
          other.pageMargin == this.pageMargin &&
          other.autoHideControls == this.autoHideControls &&
          other.hapticsEnabled == this.hapticsEnabled);
}

class ReaderPreferencesCompanion extends UpdateCompanion<ReaderPreference> {
  final Value<int> id;
  final Value<String> theme;
  final Value<double> fontSize;
  final Value<double> lineHeight;
  final Value<String> alignment;
  final Value<double> readingWidth;
  final Value<double> pageMargin;
  final Value<bool> autoHideControls;
  final Value<bool> hapticsEnabled;
  const ReaderPreferencesCompanion({
    this.id = const Value.absent(),
    this.theme = const Value.absent(),
    this.fontSize = const Value.absent(),
    this.lineHeight = const Value.absent(),
    this.alignment = const Value.absent(),
    this.readingWidth = const Value.absent(),
    this.pageMargin = const Value.absent(),
    this.autoHideControls = const Value.absent(),
    this.hapticsEnabled = const Value.absent(),
  });
  ReaderPreferencesCompanion.insert({
    this.id = const Value.absent(),
    this.theme = const Value.absent(),
    this.fontSize = const Value.absent(),
    this.lineHeight = const Value.absent(),
    this.alignment = const Value.absent(),
    this.readingWidth = const Value.absent(),
    this.pageMargin = const Value.absent(),
    this.autoHideControls = const Value.absent(),
    this.hapticsEnabled = const Value.absent(),
  });
  static Insertable<ReaderPreference> custom({
    Expression<int>? id,
    Expression<String>? theme,
    Expression<double>? fontSize,
    Expression<double>? lineHeight,
    Expression<String>? alignment,
    Expression<double>? readingWidth,
    Expression<double>? pageMargin,
    Expression<bool>? autoHideControls,
    Expression<bool>? hapticsEnabled,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (theme != null) 'theme': theme,
      if (fontSize != null) 'font_size': fontSize,
      if (lineHeight != null) 'line_height': lineHeight,
      if (alignment != null) 'alignment': alignment,
      if (readingWidth != null) 'reading_width': readingWidth,
      if (pageMargin != null) 'page_margin': pageMargin,
      if (autoHideControls != null) 'auto_hide_controls': autoHideControls,
      if (hapticsEnabled != null) 'haptics_enabled': hapticsEnabled,
    });
  }

  ReaderPreferencesCompanion copyWith({
    Value<int>? id,
    Value<String>? theme,
    Value<double>? fontSize,
    Value<double>? lineHeight,
    Value<String>? alignment,
    Value<double>? readingWidth,
    Value<double>? pageMargin,
    Value<bool>? autoHideControls,
    Value<bool>? hapticsEnabled,
  }) {
    return ReaderPreferencesCompanion(
      id: id ?? this.id,
      theme: theme ?? this.theme,
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
      alignment: alignment ?? this.alignment,
      readingWidth: readingWidth ?? this.readingWidth,
      pageMargin: pageMargin ?? this.pageMargin,
      autoHideControls: autoHideControls ?? this.autoHideControls,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (theme.present) {
      map['theme'] = Variable<String>(theme.value);
    }
    if (fontSize.present) {
      map['font_size'] = Variable<double>(fontSize.value);
    }
    if (lineHeight.present) {
      map['line_height'] = Variable<double>(lineHeight.value);
    }
    if (alignment.present) {
      map['alignment'] = Variable<String>(alignment.value);
    }
    if (readingWidth.present) {
      map['reading_width'] = Variable<double>(readingWidth.value);
    }
    if (pageMargin.present) {
      map['page_margin'] = Variable<double>(pageMargin.value);
    }
    if (autoHideControls.present) {
      map['auto_hide_controls'] = Variable<bool>(autoHideControls.value);
    }
    if (hapticsEnabled.present) {
      map['haptics_enabled'] = Variable<bool>(hapticsEnabled.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReaderPreferencesCompanion(')
          ..write('id: $id, ')
          ..write('theme: $theme, ')
          ..write('fontSize: $fontSize, ')
          ..write('lineHeight: $lineHeight, ')
          ..write('alignment: $alignment, ')
          ..write('readingWidth: $readingWidth, ')
          ..write('pageMargin: $pageMargin, ')
          ..write('autoHideControls: $autoHideControls, ')
          ..write('hapticsEnabled: $hapticsEnabled')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BooksTable books = $BooksTable(this);
  late final $SectionsTable sections = $SectionsTable(this);
  late final $BitesTable bites = $BitesTable(this);
  late final $ReadingProgressTable readingProgress = $ReadingProgressTable(
    this,
  );
  late final $ReaderNotesTable readerNotes = $ReaderNotesTable(this);
  late final $DictionarySourcesTable dictionarySources =
      $DictionarySourcesTable(this);
  late final $VocabularyEntriesTable vocabularyEntries =
      $VocabularyEntriesTable(this);
  late final $DictionaryImportStatesTable dictionaryImportStates =
      $DictionaryImportStatesTable(this);
  late final $HighlightNotesTable highlightNotes = $HighlightNotesTable(this);
  late final $HighlightsTable highlights = $HighlightsTable(this);
  late final $ReaderPreferencesTable readerPreferences =
      $ReaderPreferencesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    books,
    sections,
    bites,
    readingProgress,
    readerNotes,
    dictionarySources,
    vocabularyEntries,
    dictionaryImportStates,
    highlightNotes,
    highlights,
    readerPreferences,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'books',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('sections', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'books',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('bites', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'sections',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('bites', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'books',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('reading_progress', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'bites',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('reading_progress', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'books',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('reader_notes', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'bites',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('reader_notes', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'books',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('vocabulary_entries', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'bites',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('vocabulary_entries', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'dictionary_sources',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('vocabulary_entries', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'dictionary_sources',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('dictionary_import_states', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'books',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('highlight_notes', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'bites',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('highlight_notes', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'books',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('highlights', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'bites',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('highlights', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'highlight_notes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('highlights', kind: UpdateKind.update)],
    ),
  ]);
}

typedef $$BooksTableCreateCompanionBuilder =
    BooksCompanion Function({
      required String id,
      required String fingerprint,
      required String title,
      required String author,
      required String filePath,
      required String fileType,
      Value<Uint8List?> cover,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$BooksTableUpdateCompanionBuilder =
    BooksCompanion Function({
      Value<String> id,
      Value<String> fingerprint,
      Value<String> title,
      Value<String> author,
      Value<String> filePath,
      Value<String> fileType,
      Value<Uint8List?> cover,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$BooksTableReferences
    extends BaseReferences<_$AppDatabase, $BooksTable, Book> {
  $$BooksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SectionsTable, List<Section>> _sectionsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.sections,
    aliasName: 'books__id__sections__book_id',
  );

  $$SectionsTableProcessedTableManager get sectionsRefs {
    final manager = $$SectionsTableTableManager(
      $_db,
      $_db.sections,
    ).filter((f) => f.bookId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_sectionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BitesTable, List<Bite>> _bitesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.bites,
    aliasName: 'books__id__bites__book_id',
  );

  $$BitesTableProcessedTableManager get bitesRefs {
    final manager = $$BitesTableTableManager(
      $_db,
      $_db.bites,
    ).filter((f) => f.bookId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_bitesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ReadingProgressTable, List<ReadingProgressData>>
  _readingProgressRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.readingProgress,
    aliasName: 'books__id__reading_progress__book_id',
  );

  $$ReadingProgressTableProcessedTableManager get readingProgressRefs {
    final manager = $$ReadingProgressTableTableManager(
      $_db,
      $_db.readingProgress,
    ).filter((f) => f.bookId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _readingProgressRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ReaderNotesTable, List<ReaderNote>>
  _readerNotesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.readerNotes,
    aliasName: 'books__id__reader_notes__book_id',
  );

  $$ReaderNotesTableProcessedTableManager get readerNotesRefs {
    final manager = $$ReaderNotesTableTableManager(
      $_db,
      $_db.readerNotes,
    ).filter((f) => f.bookId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_readerNotesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$VocabularyEntriesTable, List<VocabularyEntry>>
  _vocabularyEntriesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.vocabularyEntries,
        aliasName: 'books__id__vocabulary_entries__book_id',
      );

  $$VocabularyEntriesTableProcessedTableManager get vocabularyEntriesRefs {
    final manager = $$VocabularyEntriesTableTableManager(
      $_db,
      $_db.vocabularyEntries,
    ).filter((f) => f.bookId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _vocabularyEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$HighlightNotesTable, List<HighlightNote>>
  _highlightNotesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.highlightNotes,
    aliasName: 'books__id__highlight_notes__book_id',
  );

  $$HighlightNotesTableProcessedTableManager get highlightNotesRefs {
    final manager = $$HighlightNotesTableTableManager(
      $_db,
      $_db.highlightNotes,
    ).filter((f) => f.bookId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_highlightNotesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$HighlightsTable, List<Highlight>>
  _highlightsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.highlights,
    aliasName: 'books__id__highlights__book_id',
  );

  $$HighlightsTableProcessedTableManager get highlightsRefs {
    final manager = $$HighlightsTableTableManager(
      $_db,
      $_db.highlights,
    ).filter((f) => f.bookId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_highlightsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BooksTableFilterComposer extends Composer<_$AppDatabase, $BooksTable> {
  $$BooksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileType => $composableBuilder(
    column: $table.fileType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get cover => $composableBuilder(
    column: $table.cover,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> sectionsRefs(
    Expression<bool> Function($$SectionsTableFilterComposer f) f,
  ) {
    final $$SectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sections,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SectionsTableFilterComposer(
            $db: $db,
            $table: $db.sections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> bitesRefs(
    Expression<bool> Function($$BitesTableFilterComposer f) f,
  ) {
    final $$BitesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bites,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BitesTableFilterComposer(
            $db: $db,
            $table: $db.bites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> readingProgressRefs(
    Expression<bool> Function($$ReadingProgressTableFilterComposer f) f,
  ) {
    final $$ReadingProgressTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readingProgress,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingProgressTableFilterComposer(
            $db: $db,
            $table: $db.readingProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> readerNotesRefs(
    Expression<bool> Function($$ReaderNotesTableFilterComposer f) f,
  ) {
    final $$ReaderNotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readerNotes,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReaderNotesTableFilterComposer(
            $db: $db,
            $table: $db.readerNotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> vocabularyEntriesRefs(
    Expression<bool> Function($$VocabularyEntriesTableFilterComposer f) f,
  ) {
    final $$VocabularyEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vocabularyEntries,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VocabularyEntriesTableFilterComposer(
            $db: $db,
            $table: $db.vocabularyEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> highlightNotesRefs(
    Expression<bool> Function($$HighlightNotesTableFilterComposer f) f,
  ) {
    final $$HighlightNotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.highlightNotes,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HighlightNotesTableFilterComposer(
            $db: $db,
            $table: $db.highlightNotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> highlightsRefs(
    Expression<bool> Function($$HighlightsTableFilterComposer f) f,
  ) {
    final $$HighlightsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.highlights,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HighlightsTableFilterComposer(
            $db: $db,
            $table: $db.highlights,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BooksTableOrderingComposer
    extends Composer<_$AppDatabase, $BooksTable> {
  $$BooksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileType => $composableBuilder(
    column: $table.fileType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get cover => $composableBuilder(
    column: $table.cover,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BooksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BooksTable> {
  $$BooksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get fileType =>
      $composableBuilder(column: $table.fileType, builder: (column) => column);

  GeneratedColumn<Uint8List> get cover =>
      $composableBuilder(column: $table.cover, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> sectionsRefs<T extends Object>(
    Expression<T> Function($$SectionsTableAnnotationComposer a) f,
  ) {
    final $$SectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sections,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> bitesRefs<T extends Object>(
    Expression<T> Function($$BitesTableAnnotationComposer a) f,
  ) {
    final $$BitesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bites,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BitesTableAnnotationComposer(
            $db: $db,
            $table: $db.bites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> readingProgressRefs<T extends Object>(
    Expression<T> Function($$ReadingProgressTableAnnotationComposer a) f,
  ) {
    final $$ReadingProgressTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readingProgress,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingProgressTableAnnotationComposer(
            $db: $db,
            $table: $db.readingProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> readerNotesRefs<T extends Object>(
    Expression<T> Function($$ReaderNotesTableAnnotationComposer a) f,
  ) {
    final $$ReaderNotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readerNotes,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReaderNotesTableAnnotationComposer(
            $db: $db,
            $table: $db.readerNotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> vocabularyEntriesRefs<T extends Object>(
    Expression<T> Function($$VocabularyEntriesTableAnnotationComposer a) f,
  ) {
    final $$VocabularyEntriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.vocabularyEntries,
          getReferencedColumn: (t) => t.bookId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$VocabularyEntriesTableAnnotationComposer(
                $db: $db,
                $table: $db.vocabularyEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> highlightNotesRefs<T extends Object>(
    Expression<T> Function($$HighlightNotesTableAnnotationComposer a) f,
  ) {
    final $$HighlightNotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.highlightNotes,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HighlightNotesTableAnnotationComposer(
            $db: $db,
            $table: $db.highlightNotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> highlightsRefs<T extends Object>(
    Expression<T> Function($$HighlightsTableAnnotationComposer a) f,
  ) {
    final $$HighlightsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.highlights,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HighlightsTableAnnotationComposer(
            $db: $db,
            $table: $db.highlights,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BooksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BooksTable,
          Book,
          $$BooksTableFilterComposer,
          $$BooksTableOrderingComposer,
          $$BooksTableAnnotationComposer,
          $$BooksTableCreateCompanionBuilder,
          $$BooksTableUpdateCompanionBuilder,
          (Book, $$BooksTableReferences),
          Book,
          PrefetchHooks Function({
            bool sectionsRefs,
            bool bitesRefs,
            bool readingProgressRefs,
            bool readerNotesRefs,
            bool vocabularyEntriesRefs,
            bool highlightNotesRefs,
            bool highlightsRefs,
          })
        > {
  $$BooksTableTableManager(_$AppDatabase db, $BooksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BooksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BooksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BooksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> fingerprint = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> author = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<String> fileType = const Value.absent(),
                Value<Uint8List?> cover = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BooksCompanion(
                id: id,
                fingerprint: fingerprint,
                title: title,
                author: author,
                filePath: filePath,
                fileType: fileType,
                cover: cover,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String fingerprint,
                required String title,
                required String author,
                required String filePath,
                required String fileType,
                Value<Uint8List?> cover = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BooksCompanion.insert(
                id: id,
                fingerprint: fingerprint,
                title: title,
                author: author,
                filePath: filePath,
                fileType: fileType,
                cover: cover,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$BooksTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                sectionsRefs = false,
                bitesRefs = false,
                readingProgressRefs = false,
                readerNotesRefs = false,
                vocabularyEntriesRefs = false,
                highlightNotesRefs = false,
                highlightsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (sectionsRefs) db.sections,
                    if (bitesRefs) db.bites,
                    if (readingProgressRefs) db.readingProgress,
                    if (readerNotesRefs) db.readerNotes,
                    if (vocabularyEntriesRefs) db.vocabularyEntries,
                    if (highlightNotesRefs) db.highlightNotes,
                    if (highlightsRefs) db.highlights,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (sectionsRefs)
                        await $_getPrefetchedData<Book, $BooksTable, Section>(
                          currentTable: table,
                          referencedTable: $$BooksTableReferences
                              ._sectionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BooksTableReferences(
                                db,
                                table,
                                p0,
                              ).sectionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.bookId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (bitesRefs)
                        await $_getPrefetchedData<Book, $BooksTable, Bite>(
                          currentTable: table,
                          referencedTable: $$BooksTableReferences
                              ._bitesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BooksTableReferences(db, table, p0).bitesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.bookId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (readingProgressRefs)
                        await $_getPrefetchedData<
                          Book,
                          $BooksTable,
                          ReadingProgressData
                        >(
                          currentTable: table,
                          referencedTable: $$BooksTableReferences
                              ._readingProgressRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BooksTableReferences(
                                db,
                                table,
                                p0,
                              ).readingProgressRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.bookId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (readerNotesRefs)
                        await $_getPrefetchedData<
                          Book,
                          $BooksTable,
                          ReaderNote
                        >(
                          currentTable: table,
                          referencedTable: $$BooksTableReferences
                              ._readerNotesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BooksTableReferences(
                                db,
                                table,
                                p0,
                              ).readerNotesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.bookId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (vocabularyEntriesRefs)
                        await $_getPrefetchedData<
                          Book,
                          $BooksTable,
                          VocabularyEntry
                        >(
                          currentTable: table,
                          referencedTable: $$BooksTableReferences
                              ._vocabularyEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BooksTableReferences(
                                db,
                                table,
                                p0,
                              ).vocabularyEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.bookId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (highlightNotesRefs)
                        await $_getPrefetchedData<
                          Book,
                          $BooksTable,
                          HighlightNote
                        >(
                          currentTable: table,
                          referencedTable: $$BooksTableReferences
                              ._highlightNotesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BooksTableReferences(
                                db,
                                table,
                                p0,
                              ).highlightNotesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.bookId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (highlightsRefs)
                        await $_getPrefetchedData<Book, $BooksTable, Highlight>(
                          currentTable: table,
                          referencedTable: $$BooksTableReferences
                              ._highlightsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BooksTableReferences(
                                db,
                                table,
                                p0,
                              ).highlightsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.bookId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$BooksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BooksTable,
      Book,
      $$BooksTableFilterComposer,
      $$BooksTableOrderingComposer,
      $$BooksTableAnnotationComposer,
      $$BooksTableCreateCompanionBuilder,
      $$BooksTableUpdateCompanionBuilder,
      (Book, $$BooksTableReferences),
      Book,
      PrefetchHooks Function({
        bool sectionsRefs,
        bool bitesRefs,
        bool readingProgressRefs,
        bool readerNotesRefs,
        bool vocabularyEntriesRefs,
        bool highlightNotesRefs,
        bool highlightsRefs,
      })
    >;
typedef $$SectionsTableCreateCompanionBuilder =
    SectionsCompanion Function({
      required String id,
      required String bookId,
      required int position,
      Value<String?> heading,
      Value<int> rowid,
    });
typedef $$SectionsTableUpdateCompanionBuilder =
    SectionsCompanion Function({
      Value<String> id,
      Value<String> bookId,
      Value<int> position,
      Value<String?> heading,
      Value<int> rowid,
    });

final class $$SectionsTableReferences
    extends BaseReferences<_$AppDatabase, $SectionsTable, Section> {
  $$SectionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BooksTable _bookIdTable(_$AppDatabase db) =>
      db.books.createAlias('sections__book_id__books__id');

  $$BooksTableProcessedTableManager get bookId {
    final $_column = $_itemColumn<String>('book_id')!;

    final manager = $$BooksTableTableManager(
      $_db,
      $_db.books,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$BitesTable, List<Bite>> _bitesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.bites,
    aliasName: 'sections__id__bites__section_id',
  );

  $$BitesTableProcessedTableManager get bitesRefs {
    final manager = $$BitesTableTableManager(
      $_db,
      $_db.bites,
    ).filter((f) => f.sectionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_bitesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SectionsTableFilterComposer
    extends Composer<_$AppDatabase, $SectionsTable> {
  $$SectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get heading => $composableBuilder(
    column: $table.heading,
    builder: (column) => ColumnFilters(column),
  );

  $$BooksTableFilterComposer get bookId {
    final $$BooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableFilterComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> bitesRefs(
    Expression<bool> Function($$BitesTableFilterComposer f) f,
  ) {
    final $$BitesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bites,
      getReferencedColumn: (t) => t.sectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BitesTableFilterComposer(
            $db: $db,
            $table: $db.bites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SectionsTable> {
  $$SectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get heading => $composableBuilder(
    column: $table.heading,
    builder: (column) => ColumnOrderings(column),
  );

  $$BooksTableOrderingComposer get bookId {
    final $$BooksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableOrderingComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SectionsTable> {
  $$SectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get heading =>
      $composableBuilder(column: $table.heading, builder: (column) => column);

  $$BooksTableAnnotationComposer get bookId {
    final $$BooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableAnnotationComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> bitesRefs<T extends Object>(
    Expression<T> Function($$BitesTableAnnotationComposer a) f,
  ) {
    final $$BitesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bites,
      getReferencedColumn: (t) => t.sectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BitesTableAnnotationComposer(
            $db: $db,
            $table: $db.bites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SectionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SectionsTable,
          Section,
          $$SectionsTableFilterComposer,
          $$SectionsTableOrderingComposer,
          $$SectionsTableAnnotationComposer,
          $$SectionsTableCreateCompanionBuilder,
          $$SectionsTableUpdateCompanionBuilder,
          (Section, $$SectionsTableReferences),
          Section,
          PrefetchHooks Function({bool bookId, bool bitesRefs})
        > {
  $$SectionsTableTableManager(_$AppDatabase db, $SectionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> bookId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String?> heading = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SectionsCompanion(
                id: id,
                bookId: bookId,
                position: position,
                heading: heading,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String bookId,
                required int position,
                Value<String?> heading = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SectionsCompanion.insert(
                id: id,
                bookId: bookId,
                position: position,
                heading: heading,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SectionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bookId = false, bitesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (bitesRefs) db.bites],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (bookId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.bookId,
                                referencedTable: $$SectionsTableReferences
                                    ._bookIdTable(db),
                                referencedColumn: $$SectionsTableReferences
                                    ._bookIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (bitesRefs)
                    await $_getPrefetchedData<Section, $SectionsTable, Bite>(
                      currentTable: table,
                      referencedTable: $$SectionsTableReferences
                          ._bitesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SectionsTableReferences(db, table, p0).bitesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.sectionId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SectionsTable,
      Section,
      $$SectionsTableFilterComposer,
      $$SectionsTableOrderingComposer,
      $$SectionsTableAnnotationComposer,
      $$SectionsTableCreateCompanionBuilder,
      $$SectionsTableUpdateCompanionBuilder,
      (Section, $$SectionsTableReferences),
      Section,
      PrefetchHooks Function({bool bookId, bool bitesRefs})
    >;
typedef $$BitesTableCreateCompanionBuilder =
    BitesCompanion Function({
      required String id,
      required String bookId,
      required String sectionId,
      required int position,
      required String content,
      required int sourceStart,
      required int sourceEnd,
      Value<int> rowid,
    });
typedef $$BitesTableUpdateCompanionBuilder =
    BitesCompanion Function({
      Value<String> id,
      Value<String> bookId,
      Value<String> sectionId,
      Value<int> position,
      Value<String> content,
      Value<int> sourceStart,
      Value<int> sourceEnd,
      Value<int> rowid,
    });

final class $$BitesTableReferences
    extends BaseReferences<_$AppDatabase, $BitesTable, Bite> {
  $$BitesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BooksTable _bookIdTable(_$AppDatabase db) =>
      db.books.createAlias('bites__book_id__books__id');

  $$BooksTableProcessedTableManager get bookId {
    final $_column = $_itemColumn<String>('book_id')!;

    final manager = $$BooksTableTableManager(
      $_db,
      $_db.books,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SectionsTable _sectionIdTable(_$AppDatabase db) =>
      db.sections.createAlias('bites__section_id__sections__id');

  $$SectionsTableProcessedTableManager get sectionId {
    final $_column = $_itemColumn<String>('section_id')!;

    final manager = $$SectionsTableTableManager(
      $_db,
      $_db.sections,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sectionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ReadingProgressTable, List<ReadingProgressData>>
  _readingProgressRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.readingProgress,
    aliasName: 'bites__id__reading_progress__bite_id',
  );

  $$ReadingProgressTableProcessedTableManager get readingProgressRefs {
    final manager = $$ReadingProgressTableTableManager(
      $_db,
      $_db.readingProgress,
    ).filter((f) => f.biteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _readingProgressRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ReaderNotesTable, List<ReaderNote>>
  _readerNotesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.readerNotes,
    aliasName: 'bites__id__reader_notes__bite_id',
  );

  $$ReaderNotesTableProcessedTableManager get readerNotesRefs {
    final manager = $$ReaderNotesTableTableManager(
      $_db,
      $_db.readerNotes,
    ).filter((f) => f.biteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_readerNotesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$VocabularyEntriesTable, List<VocabularyEntry>>
  _vocabularyEntriesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.vocabularyEntries,
        aliasName: 'bites__id__vocabulary_entries__bite_id',
      );

  $$VocabularyEntriesTableProcessedTableManager get vocabularyEntriesRefs {
    final manager = $$VocabularyEntriesTableTableManager(
      $_db,
      $_db.vocabularyEntries,
    ).filter((f) => f.biteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _vocabularyEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$HighlightNotesTable, List<HighlightNote>>
  _highlightNotesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.highlightNotes,
    aliasName: 'bites__id__highlight_notes__bite_id',
  );

  $$HighlightNotesTableProcessedTableManager get highlightNotesRefs {
    final manager = $$HighlightNotesTableTableManager(
      $_db,
      $_db.highlightNotes,
    ).filter((f) => f.biteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_highlightNotesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$HighlightsTable, List<Highlight>>
  _highlightsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.highlights,
    aliasName: 'bites__id__highlights__bite_id',
  );

  $$HighlightsTableProcessedTableManager get highlightsRefs {
    final manager = $$HighlightsTableTableManager(
      $_db,
      $_db.highlights,
    ).filter((f) => f.biteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_highlightsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BitesTableFilterComposer extends Composer<_$AppDatabase, $BitesTable> {
  $$BitesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sourceStart => $composableBuilder(
    column: $table.sourceStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sourceEnd => $composableBuilder(
    column: $table.sourceEnd,
    builder: (column) => ColumnFilters(column),
  );

  $$BooksTableFilterComposer get bookId {
    final $$BooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableFilterComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SectionsTableFilterComposer get sectionId {
    final $$SectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sectionId,
      referencedTable: $db.sections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SectionsTableFilterComposer(
            $db: $db,
            $table: $db.sections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> readingProgressRefs(
    Expression<bool> Function($$ReadingProgressTableFilterComposer f) f,
  ) {
    final $$ReadingProgressTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readingProgress,
      getReferencedColumn: (t) => t.biteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingProgressTableFilterComposer(
            $db: $db,
            $table: $db.readingProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> readerNotesRefs(
    Expression<bool> Function($$ReaderNotesTableFilterComposer f) f,
  ) {
    final $$ReaderNotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readerNotes,
      getReferencedColumn: (t) => t.biteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReaderNotesTableFilterComposer(
            $db: $db,
            $table: $db.readerNotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> vocabularyEntriesRefs(
    Expression<bool> Function($$VocabularyEntriesTableFilterComposer f) f,
  ) {
    final $$VocabularyEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vocabularyEntries,
      getReferencedColumn: (t) => t.biteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VocabularyEntriesTableFilterComposer(
            $db: $db,
            $table: $db.vocabularyEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> highlightNotesRefs(
    Expression<bool> Function($$HighlightNotesTableFilterComposer f) f,
  ) {
    final $$HighlightNotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.highlightNotes,
      getReferencedColumn: (t) => t.biteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HighlightNotesTableFilterComposer(
            $db: $db,
            $table: $db.highlightNotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> highlightsRefs(
    Expression<bool> Function($$HighlightsTableFilterComposer f) f,
  ) {
    final $$HighlightsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.highlights,
      getReferencedColumn: (t) => t.biteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HighlightsTableFilterComposer(
            $db: $db,
            $table: $db.highlights,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BitesTableOrderingComposer
    extends Composer<_$AppDatabase, $BitesTable> {
  $$BitesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sourceStart => $composableBuilder(
    column: $table.sourceStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sourceEnd => $composableBuilder(
    column: $table.sourceEnd,
    builder: (column) => ColumnOrderings(column),
  );

  $$BooksTableOrderingComposer get bookId {
    final $$BooksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableOrderingComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SectionsTableOrderingComposer get sectionId {
    final $$SectionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sectionId,
      referencedTable: $db.sections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SectionsTableOrderingComposer(
            $db: $db,
            $table: $db.sections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BitesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BitesTable> {
  $$BitesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<int> get sourceStart => $composableBuilder(
    column: $table.sourceStart,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sourceEnd =>
      $composableBuilder(column: $table.sourceEnd, builder: (column) => column);

  $$BooksTableAnnotationComposer get bookId {
    final $$BooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableAnnotationComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SectionsTableAnnotationComposer get sectionId {
    final $$SectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sectionId,
      referencedTable: $db.sections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> readingProgressRefs<T extends Object>(
    Expression<T> Function($$ReadingProgressTableAnnotationComposer a) f,
  ) {
    final $$ReadingProgressTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readingProgress,
      getReferencedColumn: (t) => t.biteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingProgressTableAnnotationComposer(
            $db: $db,
            $table: $db.readingProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> readerNotesRefs<T extends Object>(
    Expression<T> Function($$ReaderNotesTableAnnotationComposer a) f,
  ) {
    final $$ReaderNotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readerNotes,
      getReferencedColumn: (t) => t.biteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReaderNotesTableAnnotationComposer(
            $db: $db,
            $table: $db.readerNotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> vocabularyEntriesRefs<T extends Object>(
    Expression<T> Function($$VocabularyEntriesTableAnnotationComposer a) f,
  ) {
    final $$VocabularyEntriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.vocabularyEntries,
          getReferencedColumn: (t) => t.biteId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$VocabularyEntriesTableAnnotationComposer(
                $db: $db,
                $table: $db.vocabularyEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> highlightNotesRefs<T extends Object>(
    Expression<T> Function($$HighlightNotesTableAnnotationComposer a) f,
  ) {
    final $$HighlightNotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.highlightNotes,
      getReferencedColumn: (t) => t.biteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HighlightNotesTableAnnotationComposer(
            $db: $db,
            $table: $db.highlightNotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> highlightsRefs<T extends Object>(
    Expression<T> Function($$HighlightsTableAnnotationComposer a) f,
  ) {
    final $$HighlightsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.highlights,
      getReferencedColumn: (t) => t.biteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HighlightsTableAnnotationComposer(
            $db: $db,
            $table: $db.highlights,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BitesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BitesTable,
          Bite,
          $$BitesTableFilterComposer,
          $$BitesTableOrderingComposer,
          $$BitesTableAnnotationComposer,
          $$BitesTableCreateCompanionBuilder,
          $$BitesTableUpdateCompanionBuilder,
          (Bite, $$BitesTableReferences),
          Bite,
          PrefetchHooks Function({
            bool bookId,
            bool sectionId,
            bool readingProgressRefs,
            bool readerNotesRefs,
            bool vocabularyEntriesRefs,
            bool highlightNotesRefs,
            bool highlightsRefs,
          })
        > {
  $$BitesTableTableManager(_$AppDatabase db, $BitesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BitesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BitesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BitesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> bookId = const Value.absent(),
                Value<String> sectionId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<int> sourceStart = const Value.absent(),
                Value<int> sourceEnd = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BitesCompanion(
                id: id,
                bookId: bookId,
                sectionId: sectionId,
                position: position,
                content: content,
                sourceStart: sourceStart,
                sourceEnd: sourceEnd,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String bookId,
                required String sectionId,
                required int position,
                required String content,
                required int sourceStart,
                required int sourceEnd,
                Value<int> rowid = const Value.absent(),
              }) => BitesCompanion.insert(
                id: id,
                bookId: bookId,
                sectionId: sectionId,
                position: position,
                content: content,
                sourceStart: sourceStart,
                sourceEnd: sourceEnd,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$BitesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                bookId = false,
                sectionId = false,
                readingProgressRefs = false,
                readerNotesRefs = false,
                vocabularyEntriesRefs = false,
                highlightNotesRefs = false,
                highlightsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (readingProgressRefs) db.readingProgress,
                    if (readerNotesRefs) db.readerNotes,
                    if (vocabularyEntriesRefs) db.vocabularyEntries,
                    if (highlightNotesRefs) db.highlightNotes,
                    if (highlightsRefs) db.highlights,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (bookId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.bookId,
                                    referencedTable: $$BitesTableReferences
                                        ._bookIdTable(db),
                                    referencedColumn: $$BitesTableReferences
                                        ._bookIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (sectionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.sectionId,
                                    referencedTable: $$BitesTableReferences
                                        ._sectionIdTable(db),
                                    referencedColumn: $$BitesTableReferences
                                        ._sectionIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (readingProgressRefs)
                        await $_getPrefetchedData<
                          Bite,
                          $BitesTable,
                          ReadingProgressData
                        >(
                          currentTable: table,
                          referencedTable: $$BitesTableReferences
                              ._readingProgressRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BitesTableReferences(
                                db,
                                table,
                                p0,
                              ).readingProgressRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.biteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (readerNotesRefs)
                        await $_getPrefetchedData<
                          Bite,
                          $BitesTable,
                          ReaderNote
                        >(
                          currentTable: table,
                          referencedTable: $$BitesTableReferences
                              ._readerNotesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BitesTableReferences(
                                db,
                                table,
                                p0,
                              ).readerNotesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.biteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (vocabularyEntriesRefs)
                        await $_getPrefetchedData<
                          Bite,
                          $BitesTable,
                          VocabularyEntry
                        >(
                          currentTable: table,
                          referencedTable: $$BitesTableReferences
                              ._vocabularyEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BitesTableReferences(
                                db,
                                table,
                                p0,
                              ).vocabularyEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.biteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (highlightNotesRefs)
                        await $_getPrefetchedData<
                          Bite,
                          $BitesTable,
                          HighlightNote
                        >(
                          currentTable: table,
                          referencedTable: $$BitesTableReferences
                              ._highlightNotesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BitesTableReferences(
                                db,
                                table,
                                p0,
                              ).highlightNotesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.biteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (highlightsRefs)
                        await $_getPrefetchedData<Bite, $BitesTable, Highlight>(
                          currentTable: table,
                          referencedTable: $$BitesTableReferences
                              ._highlightsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BitesTableReferences(
                                db,
                                table,
                                p0,
                              ).highlightsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.biteId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$BitesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BitesTable,
      Bite,
      $$BitesTableFilterComposer,
      $$BitesTableOrderingComposer,
      $$BitesTableAnnotationComposer,
      $$BitesTableCreateCompanionBuilder,
      $$BitesTableUpdateCompanionBuilder,
      (Bite, $$BitesTableReferences),
      Bite,
      PrefetchHooks Function({
        bool bookId,
        bool sectionId,
        bool readingProgressRefs,
        bool readerNotesRefs,
        bool vocabularyEntriesRefs,
        bool highlightNotesRefs,
        bool highlightsRefs,
      })
    >;
typedef $$ReadingProgressTableCreateCompanionBuilder =
    ReadingProgressCompanion Function({
      required String bookId,
      required String biteId,
      required int bitePosition,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ReadingProgressTableUpdateCompanionBuilder =
    ReadingProgressCompanion Function({
      Value<String> bookId,
      Value<String> biteId,
      Value<int> bitePosition,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$ReadingProgressTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ReadingProgressTable,
          ReadingProgressData
        > {
  $$ReadingProgressTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BooksTable _bookIdTable(_$AppDatabase db) =>
      db.books.createAlias('reading_progress__book_id__books__id');

  $$BooksTableProcessedTableManager get bookId {
    final $_column = $_itemColumn<String>('book_id')!;

    final manager = $$BooksTableTableManager(
      $_db,
      $_db.books,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $BitesTable _biteIdTable(_$AppDatabase db) =>
      db.bites.createAlias('reading_progress__bite_id__bites__id');

  $$BitesTableProcessedTableManager get biteId {
    final $_column = $_itemColumn<String>('bite_id')!;

    final manager = $$BitesTableTableManager(
      $_db,
      $_db.bites,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_biteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReadingProgressTableFilterComposer
    extends Composer<_$AppDatabase, $ReadingProgressTable> {
  $$ReadingProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get bitePosition => $composableBuilder(
    column: $table.bitePosition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$BooksTableFilterComposer get bookId {
    final $$BooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableFilterComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BitesTableFilterComposer get biteId {
    final $$BitesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.biteId,
      referencedTable: $db.bites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BitesTableFilterComposer(
            $db: $db,
            $table: $db.bites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $ReadingProgressTable> {
  $$ReadingProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get bitePosition => $composableBuilder(
    column: $table.bitePosition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$BooksTableOrderingComposer get bookId {
    final $$BooksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableOrderingComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BitesTableOrderingComposer get biteId {
    final $$BitesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.biteId,
      referencedTable: $db.bites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BitesTableOrderingComposer(
            $db: $db,
            $table: $db.bites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReadingProgressTable> {
  $$ReadingProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get bitePosition => $composableBuilder(
    column: $table.bitePosition,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$BooksTableAnnotationComposer get bookId {
    final $$BooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableAnnotationComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BitesTableAnnotationComposer get biteId {
    final $$BitesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.biteId,
      referencedTable: $db.bites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BitesTableAnnotationComposer(
            $db: $db,
            $table: $db.bites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReadingProgressTable,
          ReadingProgressData,
          $$ReadingProgressTableFilterComposer,
          $$ReadingProgressTableOrderingComposer,
          $$ReadingProgressTableAnnotationComposer,
          $$ReadingProgressTableCreateCompanionBuilder,
          $$ReadingProgressTableUpdateCompanionBuilder,
          (ReadingProgressData, $$ReadingProgressTableReferences),
          ReadingProgressData,
          PrefetchHooks Function({bool bookId, bool biteId})
        > {
  $$ReadingProgressTableTableManager(
    _$AppDatabase db,
    $ReadingProgressTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReadingProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReadingProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReadingProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> bookId = const Value.absent(),
                Value<String> biteId = const Value.absent(),
                Value<int> bitePosition = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReadingProgressCompanion(
                bookId: bookId,
                biteId: biteId,
                bitePosition: bitePosition,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String bookId,
                required String biteId,
                required int bitePosition,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ReadingProgressCompanion.insert(
                bookId: bookId,
                biteId: biteId,
                bitePosition: bitePosition,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ReadingProgressTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bookId = false, biteId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (bookId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.bookId,
                                referencedTable:
                                    $$ReadingProgressTableReferences
                                        ._bookIdTable(db),
                                referencedColumn:
                                    $$ReadingProgressTableReferences
                                        ._bookIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (biteId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.biteId,
                                referencedTable:
                                    $$ReadingProgressTableReferences
                                        ._biteIdTable(db),
                                referencedColumn:
                                    $$ReadingProgressTableReferences
                                        ._biteIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReadingProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReadingProgressTable,
      ReadingProgressData,
      $$ReadingProgressTableFilterComposer,
      $$ReadingProgressTableOrderingComposer,
      $$ReadingProgressTableAnnotationComposer,
      $$ReadingProgressTableCreateCompanionBuilder,
      $$ReadingProgressTableUpdateCompanionBuilder,
      (ReadingProgressData, $$ReadingProgressTableReferences),
      ReadingProgressData,
      PrefetchHooks Function({bool bookId, bool biteId})
    >;
typedef $$ReaderNotesTableCreateCompanionBuilder =
    ReaderNotesCompanion Function({
      required String id,
      required String bookId,
      required String biteId,
      required String noteText,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ReaderNotesTableUpdateCompanionBuilder =
    ReaderNotesCompanion Function({
      Value<String> id,
      Value<String> bookId,
      Value<String> biteId,
      Value<String> noteText,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$ReaderNotesTableReferences
    extends BaseReferences<_$AppDatabase, $ReaderNotesTable, ReaderNote> {
  $$ReaderNotesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BooksTable _bookIdTable(_$AppDatabase db) =>
      db.books.createAlias('reader_notes__book_id__books__id');

  $$BooksTableProcessedTableManager get bookId {
    final $_column = $_itemColumn<String>('book_id')!;

    final manager = $$BooksTableTableManager(
      $_db,
      $_db.books,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $BitesTable _biteIdTable(_$AppDatabase db) =>
      db.bites.createAlias('reader_notes__bite_id__bites__id');

  $$BitesTableProcessedTableManager get biteId {
    final $_column = $_itemColumn<String>('bite_id')!;

    final manager = $$BitesTableTableManager(
      $_db,
      $_db.bites,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_biteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReaderNotesTableFilterComposer
    extends Composer<_$AppDatabase, $ReaderNotesTable> {
  $$ReaderNotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get noteText => $composableBuilder(
    column: $table.noteText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$BooksTableFilterComposer get bookId {
    final $$BooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableFilterComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BitesTableFilterComposer get biteId {
    final $$BitesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.biteId,
      referencedTable: $db.bites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BitesTableFilterComposer(
            $db: $db,
            $table: $db.bites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReaderNotesTableOrderingComposer
    extends Composer<_$AppDatabase, $ReaderNotesTable> {
  $$ReaderNotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get noteText => $composableBuilder(
    column: $table.noteText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$BooksTableOrderingComposer get bookId {
    final $$BooksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableOrderingComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BitesTableOrderingComposer get biteId {
    final $$BitesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.biteId,
      referencedTable: $db.bites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BitesTableOrderingComposer(
            $db: $db,
            $table: $db.bites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReaderNotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReaderNotesTable> {
  $$ReaderNotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get noteText =>
      $composableBuilder(column: $table.noteText, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$BooksTableAnnotationComposer get bookId {
    final $$BooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableAnnotationComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BitesTableAnnotationComposer get biteId {
    final $$BitesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.biteId,
      referencedTable: $db.bites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BitesTableAnnotationComposer(
            $db: $db,
            $table: $db.bites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReaderNotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReaderNotesTable,
          ReaderNote,
          $$ReaderNotesTableFilterComposer,
          $$ReaderNotesTableOrderingComposer,
          $$ReaderNotesTableAnnotationComposer,
          $$ReaderNotesTableCreateCompanionBuilder,
          $$ReaderNotesTableUpdateCompanionBuilder,
          (ReaderNote, $$ReaderNotesTableReferences),
          ReaderNote,
          PrefetchHooks Function({bool bookId, bool biteId})
        > {
  $$ReaderNotesTableTableManager(_$AppDatabase db, $ReaderNotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReaderNotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReaderNotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReaderNotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> bookId = const Value.absent(),
                Value<String> biteId = const Value.absent(),
                Value<String> noteText = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReaderNotesCompanion(
                id: id,
                bookId: bookId,
                biteId: biteId,
                noteText: noteText,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String bookId,
                required String biteId,
                required String noteText,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ReaderNotesCompanion.insert(
                id: id,
                bookId: bookId,
                biteId: biteId,
                noteText: noteText,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ReaderNotesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bookId = false, biteId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (bookId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.bookId,
                                referencedTable: $$ReaderNotesTableReferences
                                    ._bookIdTable(db),
                                referencedColumn: $$ReaderNotesTableReferences
                                    ._bookIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (biteId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.biteId,
                                referencedTable: $$ReaderNotesTableReferences
                                    ._biteIdTable(db),
                                referencedColumn: $$ReaderNotesTableReferences
                                    ._biteIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReaderNotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReaderNotesTable,
      ReaderNote,
      $$ReaderNotesTableFilterComposer,
      $$ReaderNotesTableOrderingComposer,
      $$ReaderNotesTableAnnotationComposer,
      $$ReaderNotesTableCreateCompanionBuilder,
      $$ReaderNotesTableUpdateCompanionBuilder,
      (ReaderNote, $$ReaderNotesTableReferences),
      ReaderNote,
      PrefetchHooks Function({bool bookId, bool biteId})
    >;
typedef $$DictionarySourcesTableCreateCompanionBuilder =
    DictionarySourcesCompanion Function({
      required String id,
      required String name,
      required String language,
      required String format,
      required int sizeBytes,
      required String filePath,
      required String contentHash,
      required String source,
      required String licenseName,
      required String attribution,
      Value<bool> enabled,
      required int priority,
      required DateTime installedAt,
      Value<int> rowid,
    });
typedef $$DictionarySourcesTableUpdateCompanionBuilder =
    DictionarySourcesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> language,
      Value<String> format,
      Value<int> sizeBytes,
      Value<String> filePath,
      Value<String> contentHash,
      Value<String> source,
      Value<String> licenseName,
      Value<String> attribution,
      Value<bool> enabled,
      Value<int> priority,
      Value<DateTime> installedAt,
      Value<int> rowid,
    });

final class $$DictionarySourcesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $DictionarySourcesTable,
          DictionarySource
        > {
  $$DictionarySourcesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$VocabularyEntriesTable, List<VocabularyEntry>>
  _vocabularyEntriesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.vocabularyEntries,
        aliasName:
            'dictionary_sources__id__vocabulary_entries__dictionary_source_id',
      );

  $$VocabularyEntriesTableProcessedTableManager get vocabularyEntriesRefs {
    final manager =
        $$VocabularyEntriesTableTableManager(
          $_db,
          $_db.vocabularyEntries,
        ).filter(
          (f) => f.dictionarySourceId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _vocabularyEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $DictionaryImportStatesTable,
    List<DictionaryImportState>
  >
  _dictionaryImportStatesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.dictionaryImportStates,
        aliasName:
            'dictionary_sources__id__dictionary_import_states__source_id',
      );

  $$DictionaryImportStatesTableProcessedTableManager
  get dictionaryImportStatesRefs {
    final manager = $$DictionaryImportStatesTableTableManager(
      $_db,
      $_db.dictionaryImportStates,
    ).filter((f) => f.sourceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _dictionaryImportStatesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DictionarySourcesTableFilterComposer
    extends Composer<_$AppDatabase, $DictionarySourcesTable> {
  $$DictionarySourcesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get format => $composableBuilder(
    column: $table.format,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentHash => $composableBuilder(
    column: $table.contentHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get licenseName => $composableBuilder(
    column: $table.licenseName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get attribution => $composableBuilder(
    column: $table.attribution,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get installedAt => $composableBuilder(
    column: $table.installedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> vocabularyEntriesRefs(
    Expression<bool> Function($$VocabularyEntriesTableFilterComposer f) f,
  ) {
    final $$VocabularyEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vocabularyEntries,
      getReferencedColumn: (t) => t.dictionarySourceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VocabularyEntriesTableFilterComposer(
            $db: $db,
            $table: $db.vocabularyEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> dictionaryImportStatesRefs(
    Expression<bool> Function($$DictionaryImportStatesTableFilterComposer f) f,
  ) {
    final $$DictionaryImportStatesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.dictionaryImportStates,
          getReferencedColumn: (t) => t.sourceId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DictionaryImportStatesTableFilterComposer(
                $db: $db,
                $table: $db.dictionaryImportStates,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$DictionarySourcesTableOrderingComposer
    extends Composer<_$AppDatabase, $DictionarySourcesTable> {
  $$DictionarySourcesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get format => $composableBuilder(
    column: $table.format,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentHash => $composableBuilder(
    column: $table.contentHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get licenseName => $composableBuilder(
    column: $table.licenseName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get attribution => $composableBuilder(
    column: $table.attribution,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get installedAt => $composableBuilder(
    column: $table.installedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DictionarySourcesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DictionarySourcesTable> {
  $$DictionarySourcesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get format =>
      $composableBuilder(column: $table.format, builder: (column) => column);

  GeneratedColumn<int> get sizeBytes =>
      $composableBuilder(column: $table.sizeBytes, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get contentHash => $composableBuilder(
    column: $table.contentHash,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get licenseName => $composableBuilder(
    column: $table.licenseName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get attribution => $composableBuilder(
    column: $table.attribution,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<DateTime> get installedAt => $composableBuilder(
    column: $table.installedAt,
    builder: (column) => column,
  );

  Expression<T> vocabularyEntriesRefs<T extends Object>(
    Expression<T> Function($$VocabularyEntriesTableAnnotationComposer a) f,
  ) {
    final $$VocabularyEntriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.vocabularyEntries,
          getReferencedColumn: (t) => t.dictionarySourceId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$VocabularyEntriesTableAnnotationComposer(
                $db: $db,
                $table: $db.vocabularyEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> dictionaryImportStatesRefs<T extends Object>(
    Expression<T> Function($$DictionaryImportStatesTableAnnotationComposer a) f,
  ) {
    final $$DictionaryImportStatesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.dictionaryImportStates,
          getReferencedColumn: (t) => t.sourceId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DictionaryImportStatesTableAnnotationComposer(
                $db: $db,
                $table: $db.dictionaryImportStates,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$DictionarySourcesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DictionarySourcesTable,
          DictionarySource,
          $$DictionarySourcesTableFilterComposer,
          $$DictionarySourcesTableOrderingComposer,
          $$DictionarySourcesTableAnnotationComposer,
          $$DictionarySourcesTableCreateCompanionBuilder,
          $$DictionarySourcesTableUpdateCompanionBuilder,
          (DictionarySource, $$DictionarySourcesTableReferences),
          DictionarySource,
          PrefetchHooks Function({
            bool vocabularyEntriesRefs,
            bool dictionaryImportStatesRefs,
          })
        > {
  $$DictionarySourcesTableTableManager(
    _$AppDatabase db,
    $DictionarySourcesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DictionarySourcesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DictionarySourcesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DictionarySourcesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<String> format = const Value.absent(),
                Value<int> sizeBytes = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<String> contentHash = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String> licenseName = const Value.absent(),
                Value<String> attribution = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<DateTime> installedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DictionarySourcesCompanion(
                id: id,
                name: name,
                language: language,
                format: format,
                sizeBytes: sizeBytes,
                filePath: filePath,
                contentHash: contentHash,
                source: source,
                licenseName: licenseName,
                attribution: attribution,
                enabled: enabled,
                priority: priority,
                installedAt: installedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String language,
                required String format,
                required int sizeBytes,
                required String filePath,
                required String contentHash,
                required String source,
                required String licenseName,
                required String attribution,
                Value<bool> enabled = const Value.absent(),
                required int priority,
                required DateTime installedAt,
                Value<int> rowid = const Value.absent(),
              }) => DictionarySourcesCompanion.insert(
                id: id,
                name: name,
                language: language,
                format: format,
                sizeBytes: sizeBytes,
                filePath: filePath,
                contentHash: contentHash,
                source: source,
                licenseName: licenseName,
                attribution: attribution,
                enabled: enabled,
                priority: priority,
                installedAt: installedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DictionarySourcesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                vocabularyEntriesRefs = false,
                dictionaryImportStatesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (vocabularyEntriesRefs) db.vocabularyEntries,
                    if (dictionaryImportStatesRefs) db.dictionaryImportStates,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (vocabularyEntriesRefs)
                        await $_getPrefetchedData<
                          DictionarySource,
                          $DictionarySourcesTable,
                          VocabularyEntry
                        >(
                          currentTable: table,
                          referencedTable: $$DictionarySourcesTableReferences
                              ._vocabularyEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DictionarySourcesTableReferences(
                                db,
                                table,
                                p0,
                              ).vocabularyEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.dictionarySourceId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (dictionaryImportStatesRefs)
                        await $_getPrefetchedData<
                          DictionarySource,
                          $DictionarySourcesTable,
                          DictionaryImportState
                        >(
                          currentTable: table,
                          referencedTable: $$DictionarySourcesTableReferences
                              ._dictionaryImportStatesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DictionarySourcesTableReferences(
                                db,
                                table,
                                p0,
                              ).dictionaryImportStatesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sourceId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$DictionarySourcesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DictionarySourcesTable,
      DictionarySource,
      $$DictionarySourcesTableFilterComposer,
      $$DictionarySourcesTableOrderingComposer,
      $$DictionarySourcesTableAnnotationComposer,
      $$DictionarySourcesTableCreateCompanionBuilder,
      $$DictionarySourcesTableUpdateCompanionBuilder,
      (DictionarySource, $$DictionarySourcesTableReferences),
      DictionarySource,
      PrefetchHooks Function({
        bool vocabularyEntriesRefs,
        bool dictionaryImportStatesRefs,
      })
    >;
typedef $$VocabularyEntriesTableCreateCompanionBuilder =
    VocabularyEntriesCompanion Function({
      required String id,
      required String word,
      required String normalizedWord,
      required String definition,
      required String sourceSentence,
      required String bookId,
      required String biteId,
      Value<String?> dictionarySourceId,
      Value<String> dictionarySourceName,
      Value<String?> partOfSpeech,
      Value<String?> pronunciation,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$VocabularyEntriesTableUpdateCompanionBuilder =
    VocabularyEntriesCompanion Function({
      Value<String> id,
      Value<String> word,
      Value<String> normalizedWord,
      Value<String> definition,
      Value<String> sourceSentence,
      Value<String> bookId,
      Value<String> biteId,
      Value<String?> dictionarySourceId,
      Value<String> dictionarySourceName,
      Value<String?> partOfSpeech,
      Value<String?> pronunciation,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$VocabularyEntriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $VocabularyEntriesTable,
          VocabularyEntry
        > {
  $$VocabularyEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BooksTable _bookIdTable(_$AppDatabase db) =>
      db.books.createAlias('vocabulary_entries__book_id__books__id');

  $$BooksTableProcessedTableManager get bookId {
    final $_column = $_itemColumn<String>('book_id')!;

    final manager = $$BooksTableTableManager(
      $_db,
      $_db.books,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $BitesTable _biteIdTable(_$AppDatabase db) =>
      db.bites.createAlias('vocabulary_entries__bite_id__bites__id');

  $$BitesTableProcessedTableManager get biteId {
    final $_column = $_itemColumn<String>('bite_id')!;

    final manager = $$BitesTableTableManager(
      $_db,
      $_db.bites,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_biteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $DictionarySourcesTable _dictionarySourceIdTable(_$AppDatabase db) =>
      db.dictionarySources.createAlias(
        'vocabulary_entries__dictionary_source_id__dictionary_sources__id',
      );

  $$DictionarySourcesTableProcessedTableManager? get dictionarySourceId {
    final $_column = $_itemColumn<String>('dictionary_source_id');
    if ($_column == null) return null;
    final manager = $$DictionarySourcesTableTableManager(
      $_db,
      $_db.dictionarySources,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_dictionarySourceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$VocabularyEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $VocabularyEntriesTable> {
  $$VocabularyEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get word => $composableBuilder(
    column: $table.word,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get normalizedWord => $composableBuilder(
    column: $table.normalizedWord,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get definition => $composableBuilder(
    column: $table.definition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceSentence => $composableBuilder(
    column: $table.sourceSentence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dictionarySourceName => $composableBuilder(
    column: $table.dictionarySourceName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get partOfSpeech => $composableBuilder(
    column: $table.partOfSpeech,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pronunciation => $composableBuilder(
    column: $table.pronunciation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$BooksTableFilterComposer get bookId {
    final $$BooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableFilterComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BitesTableFilterComposer get biteId {
    final $$BitesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.biteId,
      referencedTable: $db.bites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BitesTableFilterComposer(
            $db: $db,
            $table: $db.bites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DictionarySourcesTableFilterComposer get dictionarySourceId {
    final $$DictionarySourcesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dictionarySourceId,
      referencedTable: $db.dictionarySources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DictionarySourcesTableFilterComposer(
            $db: $db,
            $table: $db.dictionarySources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VocabularyEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $VocabularyEntriesTable> {
  $$VocabularyEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get word => $composableBuilder(
    column: $table.word,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get normalizedWord => $composableBuilder(
    column: $table.normalizedWord,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get definition => $composableBuilder(
    column: $table.definition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceSentence => $composableBuilder(
    column: $table.sourceSentence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dictionarySourceName => $composableBuilder(
    column: $table.dictionarySourceName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get partOfSpeech => $composableBuilder(
    column: $table.partOfSpeech,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pronunciation => $composableBuilder(
    column: $table.pronunciation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$BooksTableOrderingComposer get bookId {
    final $$BooksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableOrderingComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BitesTableOrderingComposer get biteId {
    final $$BitesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.biteId,
      referencedTable: $db.bites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BitesTableOrderingComposer(
            $db: $db,
            $table: $db.bites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DictionarySourcesTableOrderingComposer get dictionarySourceId {
    final $$DictionarySourcesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dictionarySourceId,
      referencedTable: $db.dictionarySources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DictionarySourcesTableOrderingComposer(
            $db: $db,
            $table: $db.dictionarySources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VocabularyEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VocabularyEntriesTable> {
  $$VocabularyEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get word =>
      $composableBuilder(column: $table.word, builder: (column) => column);

  GeneratedColumn<String> get normalizedWord => $composableBuilder(
    column: $table.normalizedWord,
    builder: (column) => column,
  );

  GeneratedColumn<String> get definition => $composableBuilder(
    column: $table.definition,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceSentence => $composableBuilder(
    column: $table.sourceSentence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dictionarySourceName => $composableBuilder(
    column: $table.dictionarySourceName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get partOfSpeech => $composableBuilder(
    column: $table.partOfSpeech,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pronunciation => $composableBuilder(
    column: $table.pronunciation,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$BooksTableAnnotationComposer get bookId {
    final $$BooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableAnnotationComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BitesTableAnnotationComposer get biteId {
    final $$BitesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.biteId,
      referencedTable: $db.bites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BitesTableAnnotationComposer(
            $db: $db,
            $table: $db.bites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DictionarySourcesTableAnnotationComposer get dictionarySourceId {
    final $$DictionarySourcesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.dictionarySourceId,
          referencedTable: $db.dictionarySources,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DictionarySourcesTableAnnotationComposer(
                $db: $db,
                $table: $db.dictionarySources,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$VocabularyEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VocabularyEntriesTable,
          VocabularyEntry,
          $$VocabularyEntriesTableFilterComposer,
          $$VocabularyEntriesTableOrderingComposer,
          $$VocabularyEntriesTableAnnotationComposer,
          $$VocabularyEntriesTableCreateCompanionBuilder,
          $$VocabularyEntriesTableUpdateCompanionBuilder,
          (VocabularyEntry, $$VocabularyEntriesTableReferences),
          VocabularyEntry,
          PrefetchHooks Function({
            bool bookId,
            bool biteId,
            bool dictionarySourceId,
          })
        > {
  $$VocabularyEntriesTableTableManager(
    _$AppDatabase db,
    $VocabularyEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VocabularyEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VocabularyEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VocabularyEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> word = const Value.absent(),
                Value<String> normalizedWord = const Value.absent(),
                Value<String> definition = const Value.absent(),
                Value<String> sourceSentence = const Value.absent(),
                Value<String> bookId = const Value.absent(),
                Value<String> biteId = const Value.absent(),
                Value<String?> dictionarySourceId = const Value.absent(),
                Value<String> dictionarySourceName = const Value.absent(),
                Value<String?> partOfSpeech = const Value.absent(),
                Value<String?> pronunciation = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VocabularyEntriesCompanion(
                id: id,
                word: word,
                normalizedWord: normalizedWord,
                definition: definition,
                sourceSentence: sourceSentence,
                bookId: bookId,
                biteId: biteId,
                dictionarySourceId: dictionarySourceId,
                dictionarySourceName: dictionarySourceName,
                partOfSpeech: partOfSpeech,
                pronunciation: pronunciation,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String word,
                required String normalizedWord,
                required String definition,
                required String sourceSentence,
                required String bookId,
                required String biteId,
                Value<String?> dictionarySourceId = const Value.absent(),
                Value<String> dictionarySourceName = const Value.absent(),
                Value<String?> partOfSpeech = const Value.absent(),
                Value<String?> pronunciation = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => VocabularyEntriesCompanion.insert(
                id: id,
                word: word,
                normalizedWord: normalizedWord,
                definition: definition,
                sourceSentence: sourceSentence,
                bookId: bookId,
                biteId: biteId,
                dictionarySourceId: dictionarySourceId,
                dictionarySourceName: dictionarySourceName,
                partOfSpeech: partOfSpeech,
                pronunciation: pronunciation,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$VocabularyEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({bookId = false, biteId = false, dictionarySourceId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (bookId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.bookId,
                                    referencedTable:
                                        $$VocabularyEntriesTableReferences
                                            ._bookIdTable(db),
                                    referencedColumn:
                                        $$VocabularyEntriesTableReferences
                                            ._bookIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (biteId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.biteId,
                                    referencedTable:
                                        $$VocabularyEntriesTableReferences
                                            ._biteIdTable(db),
                                    referencedColumn:
                                        $$VocabularyEntriesTableReferences
                                            ._biteIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (dictionarySourceId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.dictionarySourceId,
                                    referencedTable:
                                        $$VocabularyEntriesTableReferences
                                            ._dictionarySourceIdTable(db),
                                    referencedColumn:
                                        $$VocabularyEntriesTableReferences
                                            ._dictionarySourceIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$VocabularyEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VocabularyEntriesTable,
      VocabularyEntry,
      $$VocabularyEntriesTableFilterComposer,
      $$VocabularyEntriesTableOrderingComposer,
      $$VocabularyEntriesTableAnnotationComposer,
      $$VocabularyEntriesTableCreateCompanionBuilder,
      $$VocabularyEntriesTableUpdateCompanionBuilder,
      (VocabularyEntry, $$VocabularyEntriesTableReferences),
      VocabularyEntry,
      PrefetchHooks Function({
        bool bookId,
        bool biteId,
        bool dictionarySourceId,
      })
    >;
typedef $$DictionaryImportStatesTableCreateCompanionBuilder =
    DictionaryImportStatesCompanion Function({
      required String sourceId,
      required String stage,
      Value<int> completed,
      Value<int> total,
      Value<String?> error,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$DictionaryImportStatesTableUpdateCompanionBuilder =
    DictionaryImportStatesCompanion Function({
      Value<String> sourceId,
      Value<String> stage,
      Value<int> completed,
      Value<int> total,
      Value<String?> error,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$DictionaryImportStatesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $DictionaryImportStatesTable,
          DictionaryImportState
        > {
  $$DictionaryImportStatesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DictionarySourcesTable _sourceIdTable(_$AppDatabase db) =>
      db.dictionarySources.createAlias(
        'dictionary_import_states__source_id__dictionary_sources__id',
      );

  $$DictionarySourcesTableProcessedTableManager get sourceId {
    final $_column = $_itemColumn<String>('source_id')!;

    final manager = $$DictionarySourcesTableTableManager(
      $_db,
      $_db.dictionarySources,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DictionaryImportStatesTableFilterComposer
    extends Composer<_$AppDatabase, $DictionaryImportStatesTable> {
  $$DictionaryImportStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get stage => $composableBuilder(
    column: $table.stage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$DictionarySourcesTableFilterComposer get sourceId {
    final $$DictionarySourcesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.dictionarySources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DictionarySourcesTableFilterComposer(
            $db: $db,
            $table: $db.dictionarySources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DictionaryImportStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $DictionaryImportStatesTable> {
  $$DictionaryImportStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get stage => $composableBuilder(
    column: $table.stage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$DictionarySourcesTableOrderingComposer get sourceId {
    final $$DictionarySourcesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.dictionarySources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DictionarySourcesTableOrderingComposer(
            $db: $db,
            $table: $db.dictionarySources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DictionaryImportStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DictionaryImportStatesTable> {
  $$DictionaryImportStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get stage =>
      $composableBuilder(column: $table.stage, builder: (column) => column);

  GeneratedColumn<int> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<int> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<String> get error =>
      $composableBuilder(column: $table.error, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$DictionarySourcesTableAnnotationComposer get sourceId {
    final $$DictionarySourcesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sourceId,
          referencedTable: $db.dictionarySources,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DictionarySourcesTableAnnotationComposer(
                $db: $db,
                $table: $db.dictionarySources,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$DictionaryImportStatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DictionaryImportStatesTable,
          DictionaryImportState,
          $$DictionaryImportStatesTableFilterComposer,
          $$DictionaryImportStatesTableOrderingComposer,
          $$DictionaryImportStatesTableAnnotationComposer,
          $$DictionaryImportStatesTableCreateCompanionBuilder,
          $$DictionaryImportStatesTableUpdateCompanionBuilder,
          (DictionaryImportState, $$DictionaryImportStatesTableReferences),
          DictionaryImportState,
          PrefetchHooks Function({bool sourceId})
        > {
  $$DictionaryImportStatesTableTableManager(
    _$AppDatabase db,
    $DictionaryImportStatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DictionaryImportStatesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$DictionaryImportStatesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DictionaryImportStatesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> sourceId = const Value.absent(),
                Value<String> stage = const Value.absent(),
                Value<int> completed = const Value.absent(),
                Value<int> total = const Value.absent(),
                Value<String?> error = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DictionaryImportStatesCompanion(
                sourceId: sourceId,
                stage: stage,
                completed: completed,
                total: total,
                error: error,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String sourceId,
                required String stage,
                Value<int> completed = const Value.absent(),
                Value<int> total = const Value.absent(),
                Value<String?> error = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => DictionaryImportStatesCompanion.insert(
                sourceId: sourceId,
                stage: stage,
                completed: completed,
                total: total,
                error: error,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DictionaryImportStatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sourceId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sourceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sourceId,
                                referencedTable:
                                    $$DictionaryImportStatesTableReferences
                                        ._sourceIdTable(db),
                                referencedColumn:
                                    $$DictionaryImportStatesTableReferences
                                        ._sourceIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DictionaryImportStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DictionaryImportStatesTable,
      DictionaryImportState,
      $$DictionaryImportStatesTableFilterComposer,
      $$DictionaryImportStatesTableOrderingComposer,
      $$DictionaryImportStatesTableAnnotationComposer,
      $$DictionaryImportStatesTableCreateCompanionBuilder,
      $$DictionaryImportStatesTableUpdateCompanionBuilder,
      (DictionaryImportState, $$DictionaryImportStatesTableReferences),
      DictionaryImportState,
      PrefetchHooks Function({bool sourceId})
    >;
typedef $$HighlightNotesTableCreateCompanionBuilder =
    HighlightNotesCompanion Function({
      required String id,
      required String bookId,
      required String biteId,
      required String noteText,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$HighlightNotesTableUpdateCompanionBuilder =
    HighlightNotesCompanion Function({
      Value<String> id,
      Value<String> bookId,
      Value<String> biteId,
      Value<String> noteText,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$HighlightNotesTableReferences
    extends BaseReferences<_$AppDatabase, $HighlightNotesTable, HighlightNote> {
  $$HighlightNotesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BooksTable _bookIdTable(_$AppDatabase db) =>
      db.books.createAlias('highlight_notes__book_id__books__id');

  $$BooksTableProcessedTableManager get bookId {
    final $_column = $_itemColumn<String>('book_id')!;

    final manager = $$BooksTableTableManager(
      $_db,
      $_db.books,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $BitesTable _biteIdTable(_$AppDatabase db) =>
      db.bites.createAlias('highlight_notes__bite_id__bites__id');

  $$BitesTableProcessedTableManager get biteId {
    final $_column = $_itemColumn<String>('bite_id')!;

    final manager = $$BitesTableTableManager(
      $_db,
      $_db.bites,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_biteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$HighlightsTable, List<Highlight>>
  _highlightsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.highlights,
    aliasName: 'highlight_notes__id__highlights__note_id',
  );

  $$HighlightsTableProcessedTableManager get highlightsRefs {
    final manager = $$HighlightsTableTableManager(
      $_db,
      $_db.highlights,
    ).filter((f) => f.noteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_highlightsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$HighlightNotesTableFilterComposer
    extends Composer<_$AppDatabase, $HighlightNotesTable> {
  $$HighlightNotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get noteText => $composableBuilder(
    column: $table.noteText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$BooksTableFilterComposer get bookId {
    final $$BooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableFilterComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BitesTableFilterComposer get biteId {
    final $$BitesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.biteId,
      referencedTable: $db.bites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BitesTableFilterComposer(
            $db: $db,
            $table: $db.bites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> highlightsRefs(
    Expression<bool> Function($$HighlightsTableFilterComposer f) f,
  ) {
    final $$HighlightsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.highlights,
      getReferencedColumn: (t) => t.noteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HighlightsTableFilterComposer(
            $db: $db,
            $table: $db.highlights,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HighlightNotesTableOrderingComposer
    extends Composer<_$AppDatabase, $HighlightNotesTable> {
  $$HighlightNotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get noteText => $composableBuilder(
    column: $table.noteText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$BooksTableOrderingComposer get bookId {
    final $$BooksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableOrderingComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BitesTableOrderingComposer get biteId {
    final $$BitesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.biteId,
      referencedTable: $db.bites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BitesTableOrderingComposer(
            $db: $db,
            $table: $db.bites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HighlightNotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $HighlightNotesTable> {
  $$HighlightNotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get noteText =>
      $composableBuilder(column: $table.noteText, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$BooksTableAnnotationComposer get bookId {
    final $$BooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableAnnotationComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BitesTableAnnotationComposer get biteId {
    final $$BitesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.biteId,
      referencedTable: $db.bites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BitesTableAnnotationComposer(
            $db: $db,
            $table: $db.bites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> highlightsRefs<T extends Object>(
    Expression<T> Function($$HighlightsTableAnnotationComposer a) f,
  ) {
    final $$HighlightsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.highlights,
      getReferencedColumn: (t) => t.noteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HighlightsTableAnnotationComposer(
            $db: $db,
            $table: $db.highlights,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HighlightNotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HighlightNotesTable,
          HighlightNote,
          $$HighlightNotesTableFilterComposer,
          $$HighlightNotesTableOrderingComposer,
          $$HighlightNotesTableAnnotationComposer,
          $$HighlightNotesTableCreateCompanionBuilder,
          $$HighlightNotesTableUpdateCompanionBuilder,
          (HighlightNote, $$HighlightNotesTableReferences),
          HighlightNote,
          PrefetchHooks Function({
            bool bookId,
            bool biteId,
            bool highlightsRefs,
          })
        > {
  $$HighlightNotesTableTableManager(
    _$AppDatabase db,
    $HighlightNotesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HighlightNotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HighlightNotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HighlightNotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> bookId = const Value.absent(),
                Value<String> biteId = const Value.absent(),
                Value<String> noteText = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HighlightNotesCompanion(
                id: id,
                bookId: bookId,
                biteId: biteId,
                noteText: noteText,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String bookId,
                required String biteId,
                required String noteText,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => HighlightNotesCompanion.insert(
                id: id,
                bookId: bookId,
                biteId: biteId,
                noteText: noteText,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$HighlightNotesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({bookId = false, biteId = false, highlightsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (highlightsRefs) db.highlights],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (bookId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.bookId,
                                    referencedTable:
                                        $$HighlightNotesTableReferences
                                            ._bookIdTable(db),
                                    referencedColumn:
                                        $$HighlightNotesTableReferences
                                            ._bookIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (biteId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.biteId,
                                    referencedTable:
                                        $$HighlightNotesTableReferences
                                            ._biteIdTable(db),
                                    referencedColumn:
                                        $$HighlightNotesTableReferences
                                            ._biteIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (highlightsRefs)
                        await $_getPrefetchedData<
                          HighlightNote,
                          $HighlightNotesTable,
                          Highlight
                        >(
                          currentTable: table,
                          referencedTable: $$HighlightNotesTableReferences
                              ._highlightsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$HighlightNotesTableReferences(
                                db,
                                table,
                                p0,
                              ).highlightsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.noteId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$HighlightNotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HighlightNotesTable,
      HighlightNote,
      $$HighlightNotesTableFilterComposer,
      $$HighlightNotesTableOrderingComposer,
      $$HighlightNotesTableAnnotationComposer,
      $$HighlightNotesTableCreateCompanionBuilder,
      $$HighlightNotesTableUpdateCompanionBuilder,
      (HighlightNote, $$HighlightNotesTableReferences),
      HighlightNote,
      PrefetchHooks Function({bool bookId, bool biteId, bool highlightsRefs})
    >;
typedef $$HighlightsTableCreateCompanionBuilder =
    HighlightsCompanion Function({
      required String id,
      required String bookId,
      required String biteId,
      required int startOffset,
      required int endOffset,
      required String selectedText,
      required String prefixContext,
      required String suffixContext,
      required String contentChecksum,
      required String style,
      required String color,
      Value<String?> noteId,
      Value<bool> resolved,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$HighlightsTableUpdateCompanionBuilder =
    HighlightsCompanion Function({
      Value<String> id,
      Value<String> bookId,
      Value<String> biteId,
      Value<int> startOffset,
      Value<int> endOffset,
      Value<String> selectedText,
      Value<String> prefixContext,
      Value<String> suffixContext,
      Value<String> contentChecksum,
      Value<String> style,
      Value<String> color,
      Value<String?> noteId,
      Value<bool> resolved,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$HighlightsTableReferences
    extends BaseReferences<_$AppDatabase, $HighlightsTable, Highlight> {
  $$HighlightsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BooksTable _bookIdTable(_$AppDatabase db) =>
      db.books.createAlias('highlights__book_id__books__id');

  $$BooksTableProcessedTableManager get bookId {
    final $_column = $_itemColumn<String>('book_id')!;

    final manager = $$BooksTableTableManager(
      $_db,
      $_db.books,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $BitesTable _biteIdTable(_$AppDatabase db) =>
      db.bites.createAlias('highlights__bite_id__bites__id');

  $$BitesTableProcessedTableManager get biteId {
    final $_column = $_itemColumn<String>('bite_id')!;

    final manager = $$BitesTableTableManager(
      $_db,
      $_db.bites,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_biteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $HighlightNotesTable _noteIdTable(_$AppDatabase db) =>
      db.highlightNotes.createAlias('highlights__note_id__highlight_notes__id');

  $$HighlightNotesTableProcessedTableManager? get noteId {
    final $_column = $_itemColumn<String>('note_id');
    if ($_column == null) return null;
    final manager = $$HighlightNotesTableTableManager(
      $_db,
      $_db.highlightNotes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_noteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$HighlightsTableFilterComposer
    extends Composer<_$AppDatabase, $HighlightsTable> {
  $$HighlightsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startOffset => $composableBuilder(
    column: $table.startOffset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endOffset => $composableBuilder(
    column: $table.endOffset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get selectedText => $composableBuilder(
    column: $table.selectedText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prefixContext => $composableBuilder(
    column: $table.prefixContext,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get suffixContext => $composableBuilder(
    column: $table.suffixContext,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentChecksum => $composableBuilder(
    column: $table.contentChecksum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get style => $composableBuilder(
    column: $table.style,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get resolved => $composableBuilder(
    column: $table.resolved,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$BooksTableFilterComposer get bookId {
    final $$BooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableFilterComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BitesTableFilterComposer get biteId {
    final $$BitesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.biteId,
      referencedTable: $db.bites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BitesTableFilterComposer(
            $db: $db,
            $table: $db.bites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$HighlightNotesTableFilterComposer get noteId {
    final $$HighlightNotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.noteId,
      referencedTable: $db.highlightNotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HighlightNotesTableFilterComposer(
            $db: $db,
            $table: $db.highlightNotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HighlightsTableOrderingComposer
    extends Composer<_$AppDatabase, $HighlightsTable> {
  $$HighlightsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startOffset => $composableBuilder(
    column: $table.startOffset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endOffset => $composableBuilder(
    column: $table.endOffset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get selectedText => $composableBuilder(
    column: $table.selectedText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prefixContext => $composableBuilder(
    column: $table.prefixContext,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get suffixContext => $composableBuilder(
    column: $table.suffixContext,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentChecksum => $composableBuilder(
    column: $table.contentChecksum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get style => $composableBuilder(
    column: $table.style,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get resolved => $composableBuilder(
    column: $table.resolved,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$BooksTableOrderingComposer get bookId {
    final $$BooksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableOrderingComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BitesTableOrderingComposer get biteId {
    final $$BitesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.biteId,
      referencedTable: $db.bites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BitesTableOrderingComposer(
            $db: $db,
            $table: $db.bites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$HighlightNotesTableOrderingComposer get noteId {
    final $$HighlightNotesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.noteId,
      referencedTable: $db.highlightNotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HighlightNotesTableOrderingComposer(
            $db: $db,
            $table: $db.highlightNotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HighlightsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HighlightsTable> {
  $$HighlightsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get startOffset => $composableBuilder(
    column: $table.startOffset,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endOffset =>
      $composableBuilder(column: $table.endOffset, builder: (column) => column);

  GeneratedColumn<String> get selectedText => $composableBuilder(
    column: $table.selectedText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get prefixContext => $composableBuilder(
    column: $table.prefixContext,
    builder: (column) => column,
  );

  GeneratedColumn<String> get suffixContext => $composableBuilder(
    column: $table.suffixContext,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contentChecksum => $composableBuilder(
    column: $table.contentChecksum,
    builder: (column) => column,
  );

  GeneratedColumn<String> get style =>
      $composableBuilder(column: $table.style, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<bool> get resolved =>
      $composableBuilder(column: $table.resolved, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$BooksTableAnnotationComposer get bookId {
    final $$BooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableAnnotationComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BitesTableAnnotationComposer get biteId {
    final $$BitesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.biteId,
      referencedTable: $db.bites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BitesTableAnnotationComposer(
            $db: $db,
            $table: $db.bites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$HighlightNotesTableAnnotationComposer get noteId {
    final $$HighlightNotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.noteId,
      referencedTable: $db.highlightNotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HighlightNotesTableAnnotationComposer(
            $db: $db,
            $table: $db.highlightNotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HighlightsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HighlightsTable,
          Highlight,
          $$HighlightsTableFilterComposer,
          $$HighlightsTableOrderingComposer,
          $$HighlightsTableAnnotationComposer,
          $$HighlightsTableCreateCompanionBuilder,
          $$HighlightsTableUpdateCompanionBuilder,
          (Highlight, $$HighlightsTableReferences),
          Highlight,
          PrefetchHooks Function({bool bookId, bool biteId, bool noteId})
        > {
  $$HighlightsTableTableManager(_$AppDatabase db, $HighlightsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HighlightsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HighlightsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HighlightsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> bookId = const Value.absent(),
                Value<String> biteId = const Value.absent(),
                Value<int> startOffset = const Value.absent(),
                Value<int> endOffset = const Value.absent(),
                Value<String> selectedText = const Value.absent(),
                Value<String> prefixContext = const Value.absent(),
                Value<String> suffixContext = const Value.absent(),
                Value<String> contentChecksum = const Value.absent(),
                Value<String> style = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<String?> noteId = const Value.absent(),
                Value<bool> resolved = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HighlightsCompanion(
                id: id,
                bookId: bookId,
                biteId: biteId,
                startOffset: startOffset,
                endOffset: endOffset,
                selectedText: selectedText,
                prefixContext: prefixContext,
                suffixContext: suffixContext,
                contentChecksum: contentChecksum,
                style: style,
                color: color,
                noteId: noteId,
                resolved: resolved,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String bookId,
                required String biteId,
                required int startOffset,
                required int endOffset,
                required String selectedText,
                required String prefixContext,
                required String suffixContext,
                required String contentChecksum,
                required String style,
                required String color,
                Value<String?> noteId = const Value.absent(),
                Value<bool> resolved = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => HighlightsCompanion.insert(
                id: id,
                bookId: bookId,
                biteId: biteId,
                startOffset: startOffset,
                endOffset: endOffset,
                selectedText: selectedText,
                prefixContext: prefixContext,
                suffixContext: suffixContext,
                contentChecksum: contentChecksum,
                style: style,
                color: color,
                noteId: noteId,
                resolved: resolved,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$HighlightsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({bookId = false, biteId = false, noteId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (bookId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.bookId,
                                    referencedTable: $$HighlightsTableReferences
                                        ._bookIdTable(db),
                                    referencedColumn:
                                        $$HighlightsTableReferences
                                            ._bookIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (biteId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.biteId,
                                    referencedTable: $$HighlightsTableReferences
                                        ._biteIdTable(db),
                                    referencedColumn:
                                        $$HighlightsTableReferences
                                            ._biteIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (noteId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.noteId,
                                    referencedTable: $$HighlightsTableReferences
                                        ._noteIdTable(db),
                                    referencedColumn:
                                        $$HighlightsTableReferences
                                            ._noteIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$HighlightsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HighlightsTable,
      Highlight,
      $$HighlightsTableFilterComposer,
      $$HighlightsTableOrderingComposer,
      $$HighlightsTableAnnotationComposer,
      $$HighlightsTableCreateCompanionBuilder,
      $$HighlightsTableUpdateCompanionBuilder,
      (Highlight, $$HighlightsTableReferences),
      Highlight,
      PrefetchHooks Function({bool bookId, bool biteId, bool noteId})
    >;
typedef $$ReaderPreferencesTableCreateCompanionBuilder =
    ReaderPreferencesCompanion Function({
      Value<int> id,
      Value<String> theme,
      Value<double> fontSize,
      Value<double> lineHeight,
      Value<String> alignment,
      Value<double> readingWidth,
      Value<double> pageMargin,
      Value<bool> autoHideControls,
      Value<bool> hapticsEnabled,
    });
typedef $$ReaderPreferencesTableUpdateCompanionBuilder =
    ReaderPreferencesCompanion Function({
      Value<int> id,
      Value<String> theme,
      Value<double> fontSize,
      Value<double> lineHeight,
      Value<String> alignment,
      Value<double> readingWidth,
      Value<double> pageMargin,
      Value<bool> autoHideControls,
      Value<bool> hapticsEnabled,
    });

class $$ReaderPreferencesTableFilterComposer
    extends Composer<_$AppDatabase, $ReaderPreferencesTable> {
  $$ReaderPreferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get theme => $composableBuilder(
    column: $table.theme,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fontSize => $composableBuilder(
    column: $table.fontSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lineHeight => $composableBuilder(
    column: $table.lineHeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get alignment => $composableBuilder(
    column: $table.alignment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get readingWidth => $composableBuilder(
    column: $table.readingWidth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pageMargin => $composableBuilder(
    column: $table.pageMargin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoHideControls => $composableBuilder(
    column: $table.autoHideControls,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hapticsEnabled => $composableBuilder(
    column: $table.hapticsEnabled,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReaderPreferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $ReaderPreferencesTable> {
  $$ReaderPreferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get theme => $composableBuilder(
    column: $table.theme,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fontSize => $composableBuilder(
    column: $table.fontSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lineHeight => $composableBuilder(
    column: $table.lineHeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get alignment => $composableBuilder(
    column: $table.alignment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get readingWidth => $composableBuilder(
    column: $table.readingWidth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pageMargin => $composableBuilder(
    column: $table.pageMargin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoHideControls => $composableBuilder(
    column: $table.autoHideControls,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hapticsEnabled => $composableBuilder(
    column: $table.hapticsEnabled,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReaderPreferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReaderPreferencesTable> {
  $$ReaderPreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get theme =>
      $composableBuilder(column: $table.theme, builder: (column) => column);

  GeneratedColumn<double> get fontSize =>
      $composableBuilder(column: $table.fontSize, builder: (column) => column);

  GeneratedColumn<double> get lineHeight => $composableBuilder(
    column: $table.lineHeight,
    builder: (column) => column,
  );

  GeneratedColumn<String> get alignment =>
      $composableBuilder(column: $table.alignment, builder: (column) => column);

  GeneratedColumn<double> get readingWidth => $composableBuilder(
    column: $table.readingWidth,
    builder: (column) => column,
  );

  GeneratedColumn<double> get pageMargin => $composableBuilder(
    column: $table.pageMargin,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autoHideControls => $composableBuilder(
    column: $table.autoHideControls,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hapticsEnabled => $composableBuilder(
    column: $table.hapticsEnabled,
    builder: (column) => column,
  );
}

class $$ReaderPreferencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReaderPreferencesTable,
          ReaderPreference,
          $$ReaderPreferencesTableFilterComposer,
          $$ReaderPreferencesTableOrderingComposer,
          $$ReaderPreferencesTableAnnotationComposer,
          $$ReaderPreferencesTableCreateCompanionBuilder,
          $$ReaderPreferencesTableUpdateCompanionBuilder,
          (
            ReaderPreference,
            BaseReferences<
              _$AppDatabase,
              $ReaderPreferencesTable,
              ReaderPreference
            >,
          ),
          ReaderPreference,
          PrefetchHooks Function()
        > {
  $$ReaderPreferencesTableTableManager(
    _$AppDatabase db,
    $ReaderPreferencesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReaderPreferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReaderPreferencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReaderPreferencesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> theme = const Value.absent(),
                Value<double> fontSize = const Value.absent(),
                Value<double> lineHeight = const Value.absent(),
                Value<String> alignment = const Value.absent(),
                Value<double> readingWidth = const Value.absent(),
                Value<double> pageMargin = const Value.absent(),
                Value<bool> autoHideControls = const Value.absent(),
                Value<bool> hapticsEnabled = const Value.absent(),
              }) => ReaderPreferencesCompanion(
                id: id,
                theme: theme,
                fontSize: fontSize,
                lineHeight: lineHeight,
                alignment: alignment,
                readingWidth: readingWidth,
                pageMargin: pageMargin,
                autoHideControls: autoHideControls,
                hapticsEnabled: hapticsEnabled,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> theme = const Value.absent(),
                Value<double> fontSize = const Value.absent(),
                Value<double> lineHeight = const Value.absent(),
                Value<String> alignment = const Value.absent(),
                Value<double> readingWidth = const Value.absent(),
                Value<double> pageMargin = const Value.absent(),
                Value<bool> autoHideControls = const Value.absent(),
                Value<bool> hapticsEnabled = const Value.absent(),
              }) => ReaderPreferencesCompanion.insert(
                id: id,
                theme: theme,
                fontSize: fontSize,
                lineHeight: lineHeight,
                alignment: alignment,
                readingWidth: readingWidth,
                pageMargin: pageMargin,
                autoHideControls: autoHideControls,
                hapticsEnabled: hapticsEnabled,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReaderPreferencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReaderPreferencesTable,
      ReaderPreference,
      $$ReaderPreferencesTableFilterComposer,
      $$ReaderPreferencesTableOrderingComposer,
      $$ReaderPreferencesTableAnnotationComposer,
      $$ReaderPreferencesTableCreateCompanionBuilder,
      $$ReaderPreferencesTableUpdateCompanionBuilder,
      (
        ReaderPreference,
        BaseReferences<
          _$AppDatabase,
          $ReaderPreferencesTable,
          ReaderPreference
        >,
      ),
      ReaderPreference,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BooksTableTableManager get books =>
      $$BooksTableTableManager(_db, _db.books);
  $$SectionsTableTableManager get sections =>
      $$SectionsTableTableManager(_db, _db.sections);
  $$BitesTableTableManager get bites =>
      $$BitesTableTableManager(_db, _db.bites);
  $$ReadingProgressTableTableManager get readingProgress =>
      $$ReadingProgressTableTableManager(_db, _db.readingProgress);
  $$ReaderNotesTableTableManager get readerNotes =>
      $$ReaderNotesTableTableManager(_db, _db.readerNotes);
  $$DictionarySourcesTableTableManager get dictionarySources =>
      $$DictionarySourcesTableTableManager(_db, _db.dictionarySources);
  $$VocabularyEntriesTableTableManager get vocabularyEntries =>
      $$VocabularyEntriesTableTableManager(_db, _db.vocabularyEntries);
  $$DictionaryImportStatesTableTableManager get dictionaryImportStates =>
      $$DictionaryImportStatesTableTableManager(
        _db,
        _db.dictionaryImportStates,
      );
  $$HighlightNotesTableTableManager get highlightNotes =>
      $$HighlightNotesTableTableManager(_db, _db.highlightNotes);
  $$HighlightsTableTableManager get highlights =>
      $$HighlightsTableTableManager(_db, _db.highlights);
  $$ReaderPreferencesTableTableManager get readerPreferences =>
      $$ReaderPreferencesTableTableManager(_db, _db.readerPreferences);
}
