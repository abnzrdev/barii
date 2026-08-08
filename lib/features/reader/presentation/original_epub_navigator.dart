import 'dart:convert';

enum OriginalEpubPresentation { scroll, pages }

class OriginalEpubLocation {
  const OriginalEpubLocation({
    required this.spineIndex,
    required this.href,
    required this.offset,
    required this.endOffset,
    required this.generation,
    this.fragment,
  });

  factory OriginalEpubLocation.fromMessage(
    String message, {
    required int spineIndex,
    required String href,
  }) {
    final value = jsonDecode(message);
    if (value is! Map<String, dynamic>) {
      throw const FormatException('Invalid Original EPUB location.');
    }
    return OriginalEpubLocation(
      spineIndex: spineIndex,
      href: href,
      offset: value['startOffset'] as int? ?? 0,
      endOffset:
          value['endOffset'] as int? ?? value['startOffset'] as int? ?? 0,
      generation: value['generation'] as int? ?? 0,
      fragment: value['fragment'] as String?,
    );
  }

  final int spineIndex;
  final String href;
  final int offset;
  final int endOffset;
  final int generation;
  final String? fragment;
}

class OriginalEpubNavigatorScript {
  const OriginalEpubNavigatorScript({
    required this.presentation,
    required this.initialOffset,
    required this.generation,
    this.initialFragment,
  });

  final OriginalEpubPresentation presentation;
  final int initialOffset;
  final int generation;
  final String? initialFragment;

  static const teardown = '''
(() => {
  const reader = window.__bookBitesOriginalReader;
  if (!reader) return;
  document.removeEventListener('scroll', reader.report, true);
  document.removeEventListener('click', reader.link, true);
  window.removeEventListener('resize', reader.resize);
  reader.resizeObserver?.disconnect();
  reader.style?.remove();
  if (reader.viewport) reader.viewport.content = reader.viewportContent;
  delete window.__bookBitesOriginalReader;
})();
''';

  String get source {
    final mode = presentation.name;
    final fragment = jsonEncode(initialFragment);
    return '''
(() => {
  ${teardown.trim()}
  const generation = $generation;
  const post = value => {
    const message = JSON.stringify(value);
    if (window.BookBitesLocation?.postMessage) {
      window.BookBitesLocation.postMessage(message);
    } else {
      window.webkit?.messageHandlers?.BookBitesLocation?.postMessage(message);
    }
  };
  const viewport = document.querySelector('meta[name="viewport" i]');
  const viewportContent = viewport?.content ?? '';
  if (viewport) viewport.content = 'width=device-width, initial-scale=1';
  const style = document.createElement('style');
  style.dataset.bookbitesOriginalReader = '$mode';
  style.textContent = `
    :root { color-scheme: light dark; overflow-wrap: break-word; }
    html { box-sizing: border-box; }
    *, *::before, *::after { box-sizing: inherit; }
    body {
      margin: 0 auto !important;
      padding: clamp(1rem, 4vw, 3rem) !important;
      max-inline-size: 46rem;
      min-block-size: 100vh;
    }
    img, svg, video, canvas, table {
      max-width: 100% !important;
      max-inline-size: 100% !important;
    }
    img, video, canvas { height: auto !important; }
    svg { max-block-size: 90vh; }
    pre { max-inline-size: 100%; overflow: auto; }
  `;
  document.head.append(style);

  const textNodes = () => {
    const walker = document.createTreeWalker(document.body, NodeFilter.SHOW_TEXT);
    const nodes = [];
    while (walker.nextNode()) nodes.push(walker.currentNode);
    return nodes;
  };
  const offsetOf = (node, offset) => {
    const range = document.createRange();
    range.selectNodeContents(document.body);
    try { range.setEnd(node, offset); } catch (_) { return 0; }
    return range.toString().length;
  };
  const caretAt = (x, y) => {
    if (document.caretPositionFromPoint) {
      const caret = document.caretPositionFromPoint(x, y);
      if (caret) return [caret.offsetNode, caret.offset];
    }
    if (document.caretRangeFromPoint) {
      const range = document.caretRangeFromPoint(x, y);
      if (range) return [range.startContainer, range.startOffset];
    }
    return null;
  };
  const visibleCaret = (fromStart) => {
    const xs = fromStart ? [16, innerWidth / 2, innerWidth - 16] : [innerWidth - 16, innerWidth / 2, 16];
    const ys = fromStart ? [16, 40, 80] : [innerHeight - 16, innerHeight - 40, innerHeight - 80];
    for (const y of ys) for (const x of xs) {
      const caret = caretAt(x, y);
      if (caret && document.body.contains(caret[0])) return caret;
    }
    return null;
  };
  const current = () => {
    const start = visibleCaret(true);
    const end = visibleCaret(false) ?? start;
    return {
      type: 'relocate',
      generation: generation,
      startOffset: start ? offsetOf(start[0], start[1]) : 0,
      endOffset: end ? offsetOf(end[0], end[1]) : 0,
      fragment: document.elementFromPoint(16, 16)?.closest('[id]')?.id ?? null,
    };
  };
  let frame = 0;
  const report = () => {
    if (frame) return;
    frame = requestAnimationFrame(() => { frame = 0; post(current()); });
  };
  const restore = offset => {
    let remaining = Math.max(0, offset);
    for (const node of textNodes()) {
      const length = node.data.length;
      if (remaining <= length) {
        const range = document.createRange();
        range.setStart(node, remaining);
        range.collapse(true);
        range.startContainer.parentElement?.scrollIntoView({block: 'start'});
        return;
      }
      remaining -= length;
    }
  };
  const link = event => {
    const anchor = event.target?.closest?.('a[href]');
    if (!anchor) return;
    const target = new URL(anchor.href, document.baseURI);
    if (target.origin !== location.origin) return;
    event.preventDefault();
    post({type: 'link', generation: generation, href: target.href});
  };
  const resize = () => {
    const location = current();
    requestAnimationFrame(() => restore(location.startOffset));
  };
  const resizeObserver = new ResizeObserver(resize);
  resizeObserver.observe(document.body);
  document.addEventListener('scroll', report, {passive: true, capture: true});
  document.addEventListener('click', link, true);
  window.addEventListener('resize', resize);
  window.__bookBitesOriginalReader = {report, link, resize, resizeObserver, style, viewport, viewportContent};
  Promise.resolve(document.fonts?.ready).then(() => {
    const target = $fragment == null ? null : document.getElementById($fragment);
    if (target) target.scrollIntoView({block: 'start'});
    else restore($initialOffset);
    requestAnimationFrame(report);
  });
})();
''';
  }
}
