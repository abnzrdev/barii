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
  final DateTime createdAt;
  const VocabularyEntry({
    required this.id,
    required this.word,
    required this.normalizedWord,
    required this.definition,
    required this.sourceSentence,
    required this.bookId,
    required this.biteId,
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
    DateTime? createdAt,
  }) => VocabularyEntry(
    id: id ?? this.id,
    word: word ?? this.word,
    normalizedWord: normalizedWord ?? this.normalizedWord,
    definition: definition ?? this.definition,
    sourceSentence: sourceSentence ?? this.sourceSentence,
    bookId: bookId ?? this.bookId,
    biteId: biteId ?? this.biteId,
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
          ..write('createdAt: $createdAt, ')
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    theme,
    fontSize,
    lineHeight,
    alignment,
    readingWidth,
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
  const ReaderPreference({
    required this.id,
    required this.theme,
    required this.fontSize,
    required this.lineHeight,
    required this.alignment,
    required this.readingWidth,
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
    };
  }

  ReaderPreference copyWith({
    int? id,
    String? theme,
    double? fontSize,
    double? lineHeight,
    String? alignment,
    double? readingWidth,
  }) => ReaderPreference(
    id: id ?? this.id,
    theme: theme ?? this.theme,
    fontSize: fontSize ?? this.fontSize,
    lineHeight: lineHeight ?? this.lineHeight,
    alignment: alignment ?? this.alignment,
    readingWidth: readingWidth ?? this.readingWidth,
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
          ..write('readingWidth: $readingWidth')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, theme, fontSize, lineHeight, alignment, readingWidth);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReaderPreference &&
          other.id == this.id &&
          other.theme == this.theme &&
          other.fontSize == this.fontSize &&
          other.lineHeight == this.lineHeight &&
          other.alignment == this.alignment &&
          other.readingWidth == this.readingWidth);
}

class ReaderPreferencesCompanion extends UpdateCompanion<ReaderPreference> {
  final Value<int> id;
  final Value<String> theme;
  final Value<double> fontSize;
  final Value<double> lineHeight;
  final Value<String> alignment;
  final Value<double> readingWidth;
  const ReaderPreferencesCompanion({
    this.id = const Value.absent(),
    this.theme = const Value.absent(),
    this.fontSize = const Value.absent(),
    this.lineHeight = const Value.absent(),
    this.alignment = const Value.absent(),
    this.readingWidth = const Value.absent(),
  });
  ReaderPreferencesCompanion.insert({
    this.id = const Value.absent(),
    this.theme = const Value.absent(),
    this.fontSize = const Value.absent(),
    this.lineHeight = const Value.absent(),
    this.alignment = const Value.absent(),
    this.readingWidth = const Value.absent(),
  });
  static Insertable<ReaderPreference> custom({
    Expression<int>? id,
    Expression<String>? theme,
    Expression<double>? fontSize,
    Expression<double>? lineHeight,
    Expression<String>? alignment,
    Expression<double>? readingWidth,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (theme != null) 'theme': theme,
      if (fontSize != null) 'font_size': fontSize,
      if (lineHeight != null) 'line_height': lineHeight,
      if (alignment != null) 'alignment': alignment,
      if (readingWidth != null) 'reading_width': readingWidth,
    });
  }

  ReaderPreferencesCompanion copyWith({
    Value<int>? id,
    Value<String>? theme,
    Value<double>? fontSize,
    Value<double>? lineHeight,
    Value<String>? alignment,
    Value<double>? readingWidth,
  }) {
    return ReaderPreferencesCompanion(
      id: id ?? this.id,
      theme: theme ?? this.theme,
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
      alignment: alignment ?? this.alignment,
      readingWidth: readingWidth ?? this.readingWidth,
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
          ..write('readingWidth: $readingWidth')
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
  late final $VocabularyEntriesTable vocabularyEntries =
      $VocabularyEntriesTable(this);
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
    vocabularyEntries,
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
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (sectionsRefs) db.sections,
                    if (bitesRefs) db.bites,
                    if (readingProgressRefs) db.readingProgress,
                    if (readerNotesRefs) db.readerNotes,
                    if (vocabularyEntriesRefs) db.vocabularyEntries,
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
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (readingProgressRefs) db.readingProgress,
                    if (readerNotesRefs) db.readerNotes,
                    if (vocabularyEntriesRefs) db.vocabularyEntries,
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
typedef $$VocabularyEntriesTableCreateCompanionBuilder =
    VocabularyEntriesCompanion Function({
      required String id,
      required String word,
      required String normalizedWord,
      required String definition,
      required String sourceSentence,
      required String bookId,
      required String biteId,
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
          PrefetchHooks Function({bool bookId, bool biteId})
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
      PrefetchHooks Function({bool bookId, bool biteId})
    >;
typedef $$ReaderPreferencesTableCreateCompanionBuilder =
    ReaderPreferencesCompanion Function({
      Value<int> id,
      Value<String> theme,
      Value<double> fontSize,
      Value<double> lineHeight,
      Value<String> alignment,
      Value<double> readingWidth,
    });
typedef $$ReaderPreferencesTableUpdateCompanionBuilder =
    ReaderPreferencesCompanion Function({
      Value<int> id,
      Value<String> theme,
      Value<double> fontSize,
      Value<double> lineHeight,
      Value<String> alignment,
      Value<double> readingWidth,
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
              }) => ReaderPreferencesCompanion(
                id: id,
                theme: theme,
                fontSize: fontSize,
                lineHeight: lineHeight,
                alignment: alignment,
                readingWidth: readingWidth,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> theme = const Value.absent(),
                Value<double> fontSize = const Value.absent(),
                Value<double> lineHeight = const Value.absent(),
                Value<String> alignment = const Value.absent(),
                Value<double> readingWidth = const Value.absent(),
              }) => ReaderPreferencesCompanion.insert(
                id: id,
                theme: theme,
                fontSize: fontSize,
                lineHeight: lineHeight,
                alignment: alignment,
                readingWidth: readingWidth,
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
  $$VocabularyEntriesTableTableManager get vocabularyEntries =>
      $$VocabularyEntriesTableTableManager(_db, _db.vocabularyEntries);
  $$ReaderPreferencesTableTableManager get readerPreferences =>
      $$ReaderPreferencesTableTableManager(_db, _db.readerPreferences);
}
