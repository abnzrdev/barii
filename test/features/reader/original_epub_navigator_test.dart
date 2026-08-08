import 'dart:convert';

import 'package:bookbites/features/reader/presentation/original_epub_navigator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('scroll script adds bounded reader styles and precise relocation', () {
    final script = OriginalEpubNavigatorScript(
      presentation: OriginalEpubPresentation.scroll,
      initialOffset: 42,
      generation: 7,
    ).source;

    expect(script, contains('max-inline-size: 46rem'));
    expect(script, contains('ResizeObserver'));
    expect(script, contains('document.fonts?.ready'));
    expect(script, contains('caretRangeFromPoint'));
    expect(script, contains('const generation = 7'));
    expect(script, contains('style.dataset.bookbitesOriginalReader'));
    expect(script, contains('max-width: 100%'));
  });

  test('relocation messages preserve a visible canonical range', () {
    final location = OriginalEpubLocation.fromMessage(
      jsonEncode({
        'generation': 3,
        'startOffset': 12,
        'endOffset': 34,
        'fragment': 'part-2',
      }),
      spineIndex: 1,
      href: 'OEBPS/two.xhtml',
    );

    expect(location.generation, 3);
    expect(location.spineIndex, 1);
    expect(location.href, 'OEBPS/two.xhtml');
    expect(location.offset, 12);
    expect(location.endOffset, 34);
    expect(location.fragment, 'part-2');
  });

  test('teardown script removes installed observers and listeners', () {
    expect(
      OriginalEpubNavigatorScript.teardown,
      allOf(contains('removeEventListener'), contains('disconnect')),
    );
  });

  test('fragment restoration wins over a zero text offset', () {
    final script = OriginalEpubNavigatorScript(
      presentation: OriginalEpubPresentation.scroll,
      initialOffset: 0,
      initialFragment: 'note-1',
      generation: 2,
    ).source;

    expect(script, contains('getElementById("note-1")'));
    expect(script, contains("scrollIntoView({block: 'start'})"));
  });
}
