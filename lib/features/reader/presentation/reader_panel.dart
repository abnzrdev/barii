import 'package:flutter/material.dart';

import '../../../core/database/app_database.dart';
import '../../notes/presentation/notes_panel.dart';

enum ReaderPanelTab { contents, search, bookmarks, notes }

class ReaderLocation {
  const ReaderLocation(this.biteId, this.sourceOffset);

  final String biteId;
  final int sourceOffset;
}

class ReaderPanel extends StatefulWidget {
  const ReaderPanel({
    super.key,
    required this.database,
    required this.book,
    required this.bites,
    required this.currentBite,
    required this.initialTab,
    required this.onNavigate,
    required this.onClose,
  });

  final AppDatabase database;
  final Book book;
  final List<Bite> bites;
  final Bite currentBite;
  final ReaderPanelTab initialTab;
  final ValueChanged<ReaderLocation> onNavigate;
  final VoidCallback onClose;

  @override
  State<ReaderPanel> createState() => _ReaderPanelState();
}

class _ReaderPanelState extends State<ReaderPanel> {
  var _query = '';
  late final Future<List<Section>> _sections;
  late final Future<List<Bookmark>> _bookmarkData;

  @override
  void initState() {
    super.initState();
    _sections = widget.database.sectionsForBook(widget.book.id);
    _bookmarkData = widget.database.bookmarksForBook(widget.book.id);
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
    key: ValueKey(widget.initialTab),
    length: ReaderPanelTab.values.length,
    initialIndex: widget.initialTab.index,
    child: Material(
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: TabBar(
                    isScrollable: true,
                    tabs: [
                      Tab(text: 'Contents'),
                      Tab(text: 'Search'),
                      Tab(text: 'Bookmarks'),
                      Tab(text: 'Notes'),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Close reader panel',
                  onPressed: widget.onClose,
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [_contents(), _search(), _bookmarks(), _notes()],
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _contents() => FutureBuilder<List<Section>>(
    future: _sections,
    builder: (context, snapshot) {
      final sections = snapshot.data ?? const [];
      if (sections.isEmpty) return const Center(child: Text('No contents'));
      return ListView(
        children: [
          for (final section in sections)
            Builder(
              builder: (context) {
                final first = widget.bites
                    .where((bite) => bite.sectionId == section.id)
                    .firstOrNull;
                return ListTile(
                  selected: widget.currentBite.sectionId == section.id,
                  title: Text(
                    section.heading ?? 'Section ${section.position + 1}',
                  ),
                  onTap: first == null
                      ? null
                      : () => widget.onNavigate(ReaderLocation(first.id, 0)),
                );
              },
            ),
        ],
      );
    },
  );

  Widget _search() {
    final normalized = _query.trim().toLowerCase();
    final matches = normalized.isEmpty
        ? const <({Bite bite, int offset})>[]
        : [
            for (final bite in widget.bites)
              for (
                var offset = bite.content.toLowerCase().indexOf(normalized);
                offset >= 0;
                offset = bite.content.toLowerCase().indexOf(
                  normalized,
                  offset + normalized.length,
                )
              )
                (bite: bite, offset: offset),
          ];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: SearchBar(
            hintText: 'Search this book',
            leading: const Icon(Icons.search),
            onChanged: (value) => setState(() => _query = value),
          ),
        ),
        Expanded(
          child: normalized.isEmpty
              ? const Center(child: Text('Enter a word or phrase'))
              : matches.isEmpty
              ? const Center(child: Text('No matches'))
              : ListView.builder(
                  itemCount: matches.length,
                  itemBuilder: (context, index) {
                    final match = matches[index];
                    final start = (match.offset - 36).clamp(
                      0,
                      match.bite.content.length,
                    );
                    final end = (match.offset + normalized.length + 52).clamp(
                      start,
                      match.bite.content.length,
                    );
                    return ListTile(
                      title: Text(match.bite.content.substring(start, end)),
                      onTap: () => widget.onNavigate(
                        ReaderLocation(match.bite.id, match.offset),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _bookmarks() => FutureBuilder<List<Bookmark>>(
    future: _bookmarkData,
    builder: (context, snapshot) {
      final bookmarks = snapshot.data ?? const [];
      if (bookmarks.isEmpty) {
        return const Center(child: Text('No bookmarks yet'));
      }
      return ListView(
        children: [
          for (final bookmark in bookmarks)
            ListTile(
              leading: const Icon(Icons.bookmark),
              title: Text(
                widget.bites
                        .where((bite) => bite.id == bookmark.biteId)
                        .firstOrNull
                        ?.content ??
                    'Saved location',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () => widget.onNavigate(
                ReaderLocation(bookmark.biteId, bookmark.sourceOffset),
              ),
            ),
        ],
      );
    },
  );

  Widget _notes() => NotesPanel(
    database: widget.database,
    book: widget.book,
    bite: widget.currentBite,
    onClose: widget.onClose,
  );
}
