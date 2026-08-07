class CanonicalPublication {
  static const modelVersion = 1;
  static const parserVersion = 1;
  static const projectionVersion = 1;

  const CanonicalPublication({
    required this.metadata,
    required this.rendition,
    required this.resources,
    required this.readingOrder,
    required this.pageProgressionDirection,
  });

  final CanonicalMetadata metadata;
  final CanonicalRendition rendition;
  final Map<String, CanonicalResource> resources;
  final List<CanonicalSpineOccurrence> readingOrder;
  final String pageProgressionDirection;

  Map<String, Object?> toJson() => {
    'metadata': metadata.toJson(),
    'rendition': rendition.toJson(),
    'resources': resources.map((key, value) => MapEntry(key, value.toJson())),
    'readingOrder': readingOrder.map((item) => item.toJson()).toList(),
    'pageProgressionDirection': pageProgressionDirection,
  };

  factory CanonicalPublication.fromJson(Map<String, Object?> json) =>
      CanonicalPublication(
        metadata: CanonicalMetadata.fromJson(_map(json['metadata'])),
        rendition: CanonicalRendition.fromJson(_map(json['rendition'])),
        resources: _map(json['resources']).map(
          (key, value) =>
              MapEntry(key, CanonicalResource.fromJson(_map(value))),
        ),
        readingOrder: _list(json['readingOrder'])
            .map((value) => CanonicalSpineOccurrence.fromJson(_map(value)))
            .toList(),
        pageProgressionDirection:
            json['pageProgressionDirection'] as String? ?? 'ltr',
      );
}

class CanonicalMetadata {
  const CanonicalMetadata({
    required this.title,
    required this.authors,
    required this.languages,
    this.identifier,
  });

  final String? identifier;
  final String title;
  final List<String> authors;
  final List<String> languages;

  Map<String, Object?> toJson() => {
    'identifier': identifier,
    'title': title,
    'authors': authors,
    'languages': languages,
  };

  factory CanonicalMetadata.fromJson(Map<String, Object?> json) =>
      CanonicalMetadata(
        identifier: json['identifier'] as String?,
        title: json['title'] as String? ?? '',
        authors: _strings(json['authors']),
        languages: _strings(json['languages']),
      );
}

class CanonicalRendition {
  const CanonicalRendition({this.layout = 'reflowable'});

  final String layout;

  Map<String, Object?> toJson() => {'layout': layout};

  factory CanonicalRendition.fromJson(Map<String, Object?> json) =>
      CanonicalRendition(layout: json['layout'] as String? ?? 'reflowable');
}

class CanonicalResource {
  const CanonicalResource({
    required this.id,
    required this.href,
    required this.mediaType,
    required this.content,
    this.properties = const [],
  });

  final String id;
  final String href;
  final String mediaType;
  final String? content;
  final List<String> properties;

  Map<String, Object?> toJson() => {
    'id': id,
    'href': href,
    'mediaType': mediaType,
    'content': content,
    'properties': properties,
  };

  factory CanonicalResource.fromJson(Map<String, Object?> json) =>
      CanonicalResource(
        id: json['id'] as String? ?? '',
        href: json['href'] as String? ?? '',
        mediaType: json['mediaType'] as String? ?? 'application/octet-stream',
        content: json['content'] as String?,
        properties: _strings(json['properties']),
      );
}

class CanonicalSpineOccurrence {
  const CanonicalSpineOccurrence({
    required this.occurrenceId,
    required this.resourceId,
    required this.position,
    required this.resourceHref,
    required this.mediaType,
    required this.linear,
    required this.nodes,
    this.title,
    this.language,
    this.textDirection,
    this.layout,
    this.properties = const [],
  });

  final String occurrenceId;
  final String resourceId;
  final int position;
  final String resourceHref;
  final String mediaType;
  final bool linear;
  final List<CanonicalNode> nodes;
  final String? title;
  final String? language;
  final String? textDirection;
  final String? layout;
  final List<String> properties;

  Map<String, Object?> toJson() => {
    'occurrenceId': occurrenceId,
    'resourceId': resourceId,
    'position': position,
    'resourceHref': resourceHref,
    'mediaType': mediaType,
    'linear': linear,
    'nodes': nodes.map((node) => node.toJson()).toList(),
    'title': title,
    'language': language,
    'textDirection': textDirection,
    'layout': layout,
    'properties': properties,
  };

  factory CanonicalSpineOccurrence.fromJson(Map<String, Object?> json) =>
      CanonicalSpineOccurrence(
        occurrenceId: json['occurrenceId'] as String? ?? '',
        resourceId: json['resourceId'] as String? ?? '',
        position: json['position'] as int? ?? 0,
        resourceHref: json['resourceHref'] as String? ?? '',
        mediaType: json['mediaType'] as String? ?? 'application/xhtml+xml',
        linear: json['linear'] as bool? ?? true,
        nodes: _list(
          json['nodes'],
        ).map((value) => CanonicalNode.fromJson(_map(value))).toList(),
        title: json['title'] as String?,
        language: json['language'] as String?,
        textDirection: json['textDirection'] as String?,
        layout: json['layout'] as String?,
        properties: _strings(json['properties']),
      );
}

class CanonicalNode {
  const CanonicalNode({
    required this.kind,
    required this.startOffset,
    required this.endOffset,
    required this.logicalText,
    this.children = const [],
    this.elementId,
    this.language,
    this.textDirection,
    this.href,
    this.epubTypes = const [],
    this.role,
    this.attributes = const {},
    this.sourceMarkup,
  });

  final String kind;
  final int startOffset;
  final int endOffset;
  final String logicalText;
  final List<CanonicalNode> children;
  final String? elementId;
  final String? language;
  final String? textDirection;
  final String? href;
  final List<String> epubTypes;
  final String? role;
  final Map<String, String> attributes;
  final String? sourceMarkup;

  Map<String, Object?> toJson() => {
    'kind': kind,
    'startOffset': startOffset,
    'endOffset': endOffset,
    'logicalText': logicalText,
    'children': children.map((child) => child.toJson()).toList(),
    'elementId': elementId,
    'language': language,
    'textDirection': textDirection,
    'href': href,
    'epubTypes': epubTypes,
    'role': role,
    'attributes': attributes,
    'sourceMarkup': sourceMarkup,
  };

  factory CanonicalNode.fromJson(Map<String, Object?> json) => CanonicalNode(
    kind: json['kind'] as String? ?? '',
    startOffset: json['startOffset'] as int? ?? 0,
    endOffset: json['endOffset'] as int? ?? 0,
    logicalText: json['logicalText'] as String? ?? '',
    children: _list(
      json['children'],
    ).map((value) => CanonicalNode.fromJson(_map(value))).toList(),
    elementId: json['elementId'] as String?,
    language: json['language'] as String?,
    textDirection: json['textDirection'] as String?,
    href: json['href'] as String?,
    epubTypes: _strings(json['epubTypes']),
    role: json['role'] as String?,
    attributes: _map(
      json['attributes'],
    ).map((key, value) => MapEntry(key, value.toString())),
    sourceMarkup: json['sourceMarkup'] as String?,
  );
}

class CanonicalLocator {
  const CanonicalLocator({
    required this.href,
    required this.mediaType,
    this.fragment,
    this.startOffset,
    this.endOffset,
    this.before,
    this.highlight,
    this.after,
  });

  final String href;
  final String mediaType;
  final String? fragment;
  final int? startOffset;
  final int? endOffset;
  final String? before;
  final String? highlight;
  final String? after;
}

Map<String, Object?> _map(Object? value) => value is Map
    ? value.map((key, value) => MapEntry(key.toString(), value))
    : {};

List<Object?> _list(Object? value) => value is List ? value : const [];

List<String> _strings(Object? value) =>
    _list(value).whereType<String>().toList();
