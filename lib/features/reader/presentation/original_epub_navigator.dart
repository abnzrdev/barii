import 'dart:convert';
import 'original_word_lookup.dart';

enum OriginalEpubPresentation {
  scroll,
  pages;

  static OriginalEpubPresentation? fromReaderViewMode(String mode) =>
      switch (mode) {
        'original-scroll' => scroll,
        'original-pages' => pages,
        _ => null,
      };

  String get readerViewMode => 'original-$name';
}

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
    this.pageProgressionDirection = 'default',
    this.initialFragment,
    this.fontFamily = 'serif',
    this.fontSize = 20,
    this.lineHeight = 1.6,
    this.readingWidth = 680,
    this.pageMargin = 24,
    this.backgroundColor = '#f4f1ea',
    this.textColor = '#2d3321',
    this.returnLocator,
  });

  final OriginalEpubPresentation presentation;
  final int initialOffset;
  final int generation;
  final String pageProgressionDirection;
  final String? initialFragment;
  final String fontFamily;
  final double fontSize;
  final double lineHeight;
  final double readingWidth;
  final double pageMargin;
  final String backgroundColor;
  final String textColor;
  final Map<String, dynamic>? returnLocator;

  static const teardown = '''
(() => {
  const reader = window.__bariiOriginalReader;
  if (!reader) return;
  reader.lookupCleanup?.();
  document.removeEventListener('scroll', reader.report, true);
  document.removeEventListener('click', reader.link, true);
  document.removeEventListener('keydown', reader.keydown, true);
  document.removeEventListener('touchstart', reader.touchstart, true);
  document.removeEventListener('touchend', reader.touchend, true);
  document.removeEventListener('wheel', reader.wheel, true);
  window.removeEventListener('resize', reader.resize);
  reader.resizeObserver?.disconnect();
  reader.style?.remove();
  if (reader.viewportCreated) reader.viewport?.remove();
  else if (reader.viewport) reader.viewport.content = reader.viewportContent;
  document.documentElement.style.direction = reader.rootDirection;
  document.body.style.direction = reader.bodyDirection;
  delete window.__bariiOriginalReader;
})();
''';

  String get source {
    final mode = presentation.name;
    final fragment = jsonEncode(initialFragment);
    final returnAnchor = jsonEncode(returnLocator);
    final rtlProgression = pageProgressionDirection == 'rtl';
    final layoutCss = switch (presentation) {
      OriginalEpubPresentation.scroll =>
        '''
    body {
      margin: 0 auto !important;
      padding: clamp(12px, 4vw, ${pageMargin.clamp(12, 64)}px) !important;
      width: 100% !important;
      min-width: 0 !important;
      max-width: ${readingWidth.clamp(320, 1200) + pageMargin.clamp(12, 64) * 2}px !important;
      max-inline-size: ${readingWidth.clamp(320, 1200) + pageMargin.clamp(12, 64) * 2}px !important;
      min-block-size: 100vh;
    }''',
      OriginalEpubPresentation.pages =>
        '''
    html {
      overflow: hidden;
      padding-inline: max(1rem, calc((100vw - 92rem) / 2));
    }
    body {
      margin: 0 !important;
      padding: clamp(1rem, 3vw, 2.5rem) !important;
      max-inline-size: none;
      block-size: 100vh;
      column-count: var(--barii-columns, 1);
      column-gap: clamp(1.5rem, 5vw, 4rem);
      column-fill: auto;
      overflow: hidden;
    }''',
    };
    final pageSetup = presentation == OriginalEpubPresentation.pages
        ? '''
  const layoutPages = () => {
    document.documentElement.style.setProperty(
      '--barii-columns', innerWidth >= 1100 ? '2' : '1');
  };
  const rootDirection = document.documentElement.style.direction;
  const bodyDirection = document.body.style.direction;
  if (rtlProgression) {
    const contentDirection = getComputedStyle(document.body).direction;
    document.documentElement.style.direction = 'rtl';
    document.body.style.direction = contentDirection;
  }
  const turn = delta => {
    const root = document.scrollingElement;
    const direction = (delta < 0 ? -1 : 1) * (rtlProgression ? -1 : 1);
    const next = root.scrollLeft + direction * innerWidth;
    const max = Math.max(0, root.scrollWidth - innerWidth);
    if (Math.abs(next) > max + 1 ||
        (!rtlProgression && next < -1) ||
        (rtlProgression && next > 1)) {
      post({type: 'boundary', generation: generation, delta: delta});
      return;
    }
    const bounded = Math.max(-max, Math.min(max, next));
    root.scrollTo({left: bounded, behavior: 'auto'});
    requestAnimationFrame(report);
  };
  layoutPages();
'''
        : '''
  const layoutPages = () => {};
  const rootDirection = document.documentElement.style.direction;
  const bodyDirection = document.body.style.direction;
  const turn = delta => post({type: 'boundary', generation: generation, delta: delta});
''';
    return '''
(() => {
  const previousLocation = window.__bariiOriginalReader?.current?.();
  ${teardown.trim()}
  const generation = $generation;
  const rtlProgression = $rtlProgression;
  const post = value => {
    const message = JSON.stringify(value);
    if (window.BariiLocation?.postMessage) {
      window.BariiLocation.postMessage(message);
    } else {
      window.webkit?.messageHandlers?.BariiLocation?.postMessage(message);
    }
  };
  let viewport = document.querySelector('meta[name="viewport" i]');
  const viewportCreated = !viewport;
  if (!viewport) {
    viewport = document.createElementNS('http://www.w3.org/1999/xhtml', 'meta');
    viewport.name = 'viewport';
    document.head.append(viewport);
  }
  const viewportContent = viewport?.content ?? '';
  if (viewport) viewport.content = 'width=device-width, initial-scale=1';
  const style = document.createElementNS('http://www.w3.org/1999/xhtml', 'style');
  style.dataset.bariiOriginalReader = '$mode';
  style.textContent = `
    :root { color-scheme: light dark; overflow-wrap: break-word; }
    html { box-sizing: border-box; }
    *, *::before, *::after { box-sizing: inherit; }
$layoutCss
    html, body {
      min-width: 0 !important;
      background-color: $backgroundColor !important;
      color: $textColor !important;
    }
    html { width: 100% !important; max-width: 100% !important; overflow-x: hidden; }
    body, body * {
      font-family: $fontFamily !important;
      line-height: ${lineHeight.clamp(1.2, 2.0)} !important;
      color: $textColor !important;
    }
    body { font-size: ${fontSize.clamp(16, 32)}px !important; }
    p, li, blockquote, td, th, div, section, article, main {
      min-width: 0 !important; max-width: 100% !important;
      overflow-wrap: anywhere;
    }
    p, li, blockquote, td, th { font-size: 1em !important; }
    p span, li span { font-size: inherit !important; }
    p, div, section, article, main, table, td, th {
      background-color: transparent !important;
    }
    div, section, article, main, figure { width: auto !important; }
    figure { margin-inline: 0 !important; }
    pre, code, pre * { font-family: monospace !important; }
    a { text-decoration: underline; }
    img, svg, video, canvas, table {
      max-width: 100% !important;
      max-inline-size: 100% !important;
    }
    img, video, canvas { height: auto !important; }
    svg { max-block-size: 90vh; }
    pre { max-inline-size: 100%; overflow: auto; }
    table { display: block; overflow-x: auto; }
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
  const keydown = event => {
    if (event.defaultPrevented || event.ctrlKey || event.metaKey ||
        event.target?.matches?.('input, textarea, select, [contenteditable]')) return;
    let action = null;
    if (event.key === 'F11' && !event.repeat) action = 'fullscreen';
    else if (event.key === 'Escape') action = 'escape';
    else if (event.altKey && event.key === 'ArrowLeft') action = 'back';
    else if (event.key === 'PageDown') action = 'next';
    else if (event.key === 'PageUp') action = 'previous';
    else if (event.key === 'ArrowRight') action = rtlProgression ? 'previous' : 'next';
    else if (event.key === 'ArrowLeft') action = rtlProgression ? 'next' : 'previous';
    if (!action) return;
    event.preventDefault();
    post({type: 'key', generation: generation, action: action});
  };
  // Only a new gesture beginning at a chapter edge can change chapters.
  // Reaching the bottom during an ordinary scroll never turns it immediately.
  const edge = delta => {
    const root = document.scrollingElement ?? document.documentElement;
    return delta > 0
      ? root.scrollTop + innerHeight >= root.scrollHeight - 2
      : root.scrollTop <= 2;
  };
  const selectionActive = () => window.getSelection()?.isCollapsed === false;
  let touch = null;
  const touchstart = event => {
    touch = null;
    if (event.touches.length !== 1 || selectionActive()) return;
    const point = event.touches[0];
    touch = {x: point.clientX, y: point.clientY, top: edge(-1), bottom: edge(1)};
  };
  const touchend = event => {
    const start = touch;
    touch = null;
    const point = event.changedTouches[0];
    if (!start || !point || selectionActive() || lookupConsumed) return;
    const dy = start.y - point.clientY;
    if (Math.abs(dy) < 70 || Math.abs(dy) < Math.abs(start.x - point.clientX) * 1.5) return;
    if (dy > 0 && start.bottom || dy < 0 && start.top) {
      post({type: 'boundary', generation: generation, delta: Math.sign(dy)});
    }
  };
  let wheelDistance = 0;
  let lastWheel = 0;
  let boundaryAt = 0;
  let wheelArmed = false;
  let wheelDirection = 0;
  const wheel = event => {
    if (event.ctrlKey || event.deltaY === 0 || selectionActive()) return;
    const now = performance.now();
    const direction = Math.sign(event.deltaY);
    if (now - lastWheel > 250 || wheelDirection !== direction) {
      wheelArmed = edge(direction);
      wheelDistance = 0;
    }
    wheelDirection = direction;
    if (!edge(direction) || now - boundaryAt < 700) {
      wheelArmed = false;
      wheelDistance = 0;
      lastWheel = now;
      return;
    }
    lastWheel = now;
    if (!wheelArmed) return;
    wheelDistance += event.deltaY * (event.deltaMode === 1 ? 16 : event.deltaMode === 2 ? innerHeight : 1);
    if (Math.abs(wheelDistance) >= 120) {
      boundaryAt = now;
      wheelDistance = 0;
      post({type: 'boundary', generation: generation, delta: direction});
    }
  };
  const resize = () => {
    const location = current();
    layoutPages();
    requestAnimationFrame(() => restore(location.startOffset));
  };
$originalWordLookupScript
$pageSetup
  const resizeObserver = new ResizeObserver(resize);
  resizeObserver.observe(document.body);
  document.addEventListener('scroll', report, {passive: true, capture: true});
  document.addEventListener('click', link, true);
  document.addEventListener('keydown', keydown, true);
  document.addEventListener('touchstart', touchstart, {passive: true, capture: true});
  document.addEventListener('touchend', touchend, {passive: true, capture: true});
  document.addEventListener('wheel', wheel, {passive: true, capture: true});
  window.addEventListener('resize', resize);
  window.__bariiOriginalReader = {generation, report, current, link, keydown, touchstart, touchend, wheel, resize, resizeObserver, style, viewport, viewportCreated, viewportContent, rootDirection, bodyDirection, lookupCleanup, turn: turn};
  Promise.resolve(document.fonts?.ready).then(() => {
    if (window.__bariiOriginalReader?.generation !== generation) return;
    const target = $fragment == null ? null : document.getElementById($fragment);
    if (target && !previousLocation) target.scrollIntoView({block: 'start'});
    else restore(previousLocation?.startOffset ?? $initialOffset);
    const saved = $returnAnchor;
    if (saved && !previousLocation) {
      const nodes = textNodes(), all = nodes.map(n => n.data).join('');
      let start = saved.startOffset;
      if (all.slice(start, saved.endOffset) !== saved.quote) {
        const matches = [];
        let at = all.indexOf(saved.quote);
        while (at >= 0 && saved.quote) {
          if ((!saved.before || all.slice(0, at).endsWith(saved.before)) &&
              (!saved.after || all.slice(at + saved.quote.length).startsWith(saved.after))) matches.push(at);
          at = all.indexOf(saved.quote, at + 1);
        }
        start = matches.length === 1 ? matches[0] : -1;
      }
      if (start >= 0) {
        let total = 0, begin = null, end = null;
        for (const node of nodes) {
          if (!begin && start <= total + node.length) begin = [node, start - total];
          if (start + saved.quote.length <= total + node.length) { end = [node, start + saved.quote.length - total]; break; }
          total += node.length;
        }
        if (begin && end) {
          const range = document.createRange(); range.setStart(...begin); range.setEnd(...end);
          begin[0].parentElement?.scrollIntoView({block: 'center'});
          if (window.CSS?.highlights && window.Highlight) {
            const flashStyle = document.createElement('style');
            flashStyle.textContent = '::highlight(barii-return) { background: #c7d59a; color: #202719; }';
            document.head.appendChild(flashStyle);
            CSS.highlights.set('barii-return', new Highlight(range));
            setTimeout(() => { CSS.highlights.delete('barii-return'); flashStyle.remove(); }, 3000);
          }
        }
      }
    }
    requestAnimationFrame(report);
  });
})();
''';
  }
}
