// Runs inside the same trusted, script-disabled EPUB document as navigation.
const originalWordLookupScript = r'''
  let lookupTimer = 0;
  let lookupWord = null;
  let lookupTouch = null;
  let lookupConsumed = false;
  let lookupText = null;
  const lookupOffsets = new WeakMap();
  const describeWord = word => {
    if (!word.node) return word;
    // EPUB scripts are disabled. Text stays fixed for this navigator generation;
    // build the context index once, after dwell, instead of on every mouse move.
    if (lookupText === null) {
      const parts = []; let total = 0;
      for (const node of textNodes()) {
        lookupOffsets.set(node, total); parts.push(node.data); total += node.data.length;
      }
      lookupText = parts.join('');
    }
    const offset = (lookupOffsets.get(word.node) ?? 0) + word.start;
    const end = offset + word.end - word.start, base = Math.max(0, offset - 200);
    return {word: word.word, startOffset: offset, endOffset: end, rect: word.rect,
      context: lookupText.slice(base, end + 200), contextOffset: offset - base,
      before: lookupText.slice(Math.max(0, offset - 32), offset), after: lookupText.slice(end, end + 32)};
  };
  const wordCharacter = c => !!c && /[A-Za-zÀ-ÖØ-öø-ÿ'’\-]/.test(c);
  const dismissWord = () => {
    clearTimeout(lookupTimer);
    lookupWord = null;
    post({type: 'word', generation, action: 'dismiss'});
  };
  const wordAt = (x, y) => {
    const caret = caretAt(x, y);
    if (!caret || caret[0].nodeType !== Node.TEXT_NODE) return null;
    const node = caret[0], text = node.data;
    let start = Math.min(caret[1], text.length - 1), end = start;
    if (!wordCharacter(text[start])) return null;
    while (start > 0 && wordCharacter(text[start - 1])) start--;
    while (end < text.length && wordCharacter(text[end])) end++;
    const range = document.createRange();
    range.setStart(node, start); range.setEnd(node, end);
    const rect = range.getBoundingClientRect();
    if (x < rect.left - 2 || x > rect.right + 2 || y < rect.top - 2 || y > rect.bottom + 2) return null;
    return {word: range.toString(), node, start, end,
      rect: {x: rect.x, y: rect.y, width: rect.width, height: rect.height}};
  };
  const sendWord = (word, action) => {
    if (word) post({...describeWord(word), type: 'word', generation, action});
  };
  const lookupMove = event => {
    if (event.pointerType !== 'mouse' || event.buttons || selectionActive()) return;
    const word = wordAt(event.clientX, event.clientY);
    if (lookupWord?.node === word?.node && lookupWord?.start === word?.start) return;
    dismissWord(); lookupWord = word;
    if (word) lookupTimer = setTimeout(() => sendWord(word, 'preview'), 250);
  };
  const lookupDown = event => {
    dismissWord(); lookupConsumed = false;
    if (event.pointerType === 'mouse' || !event.isPrimary) return;
    const word = wordAt(event.clientX, event.clientY);
    if (!word) return;
    lookupTouch = {id: event.pointerId, x: event.clientX, y: event.clientY, word, held: false};
    lookupTimer = setTimeout(() => {
      if (!lookupTouch) return;
      lookupTouch.held = true; lookupConsumed = true;
      sendWord(word, 'preview');
    }, 450);
  };
  const lookupDrag = event => {
    const touch = lookupTouch;
    if (!touch || touch.id !== event.pointerId) return;
    const dx = event.clientX - touch.x, dy = event.clientY - touch.y;
    if (!touch.held && Math.hypot(dx, dy) > 12) {
      clearTimeout(lookupTimer); lookupTouch = null; return;
    }
    if (touch.held && dy < -70 && -dy > Math.abs(dx) * 1.5) {
      event.preventDefault(); sendWord(touch.word, 'expand'); lookupTouch = null;
      window.getSelection()?.removeAllRanges();
    } else if (touch.held && (Math.abs(dx) > 18 || dy > 18)) {
      touch.held = false;
      dismissWord();
    }
  };
  const lookupUp = () => {
    clearTimeout(lookupTimer);
    if (lookupTouch?.held) { dismissWord(); window.getSelection()?.removeAllRanges(); }
    lookupTouch = null;
  };
  const lookupTouchMove = event => {
    if (lookupTouch?.held) event.preventDefault();
  };
  const lookupContextMenu = event => {
    if (lookupTouch?.held) event.preventDefault();
  };
  const lookupKey = event => {
    if (event.key.toLowerCase() !== 'd' || event.ctrlKey || event.metaKey || event.altKey ||
        event.target?.matches?.('input, textarea, [contenteditable]')) return;
    const selection = window.getSelection();
    if (!selection || selection.isCollapsed || selection.toString().length > 160) return;
    const range = selection.getRangeAt(0), rect = range.getBoundingClientRect();
    const all = textNodes().map(n => n.data).join('');
    const start = offsetOf(range.startContainer, range.startOffset);
    const end = offsetOf(range.endContainer, range.endOffset), base = Math.max(0, start - 200);
    event.preventDefault();
    sendWord({word: selection.toString(), startOffset: start, endOffset: end,
      context: all.slice(base, end + 200), contextOffset: start - base,
      before: all.slice(Math.max(0, start - 32), start), after: all.slice(end, end + 32),
      rect: {x: rect.x, y: rect.y, width: rect.width, height: rect.height}}, 'expand');
  };
  const lookupEvents = [
    ['pointermove', lookupMove], ['pointermove', lookupDrag], ['pointerdown', lookupDown],
    ['pointerup', lookupUp], ['pointercancel', lookupUp], ['pointerleave', dismissWord],
    ['scroll', dismissWord], ['keydown', lookupKey], ['contextmenu', lookupContextMenu],
  ];
  for (const [name, listener] of lookupEvents) document.addEventListener(name, listener, true);
  document.addEventListener('touchmove', lookupTouchMove, {capture: true, passive: false});
  const lookupCleanup = () => {
    clearTimeout(lookupTimer);
    document.removeEventListener('touchmove', lookupTouchMove, true);
    for (const [name, listener] of lookupEvents) document.removeEventListener(name, listener, true);
  };
''';
