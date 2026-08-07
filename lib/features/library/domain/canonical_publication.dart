class CanonicalPublication {
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
}

class CanonicalRendition {
  const CanonicalRendition({this.layout = 'reflowable'});

  final String layout;
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
