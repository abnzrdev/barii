import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../domain/dictionary_repository.dart';

class QuickDefinition extends StatelessWidget {
  const QuickDefinition({
    super.key,
    required this.word,
    required this.bounds,
    required this.entry,
    required this.busy,
    required this.onExpand,
    required this.onEnter,
    required this.onExit,
  });
  final String word;
  final Rect bounds;
  final DictionaryEntry? entry;
  final bool busy;
  final VoidCallback onExpand;
  final VoidCallback onEnter;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    final viewport = MediaQuery.sizeOf(context);
    final padding = MediaQuery.paddingOf(context);
    final scheme = Theme.of(context).colorScheme;
    if (entry == null) {
      return Positioned(
        left: bounds.right.clamp(12, math.max(12, viewport.width - 20)),
        top: bounds.bottom.clamp(
          padding.top + 8,
          math.max(padding.top + 8, viewport.height - 20),
        ),
        child: Semantics(
          label: busy ? 'Looking up $word' : 'No offline definition for $word',
          child: Icon(
            Icons.circle,
            size: 7,
            color: busy ? scheme.outline : scheme.error,
          ),
        ),
      );
    }
    final width = math.min(340.0, viewport.width - 24);
    final height = math.min(220.0, viewport.height * .4);
    return Positioned.fill(
      child: CustomSingleChildLayout(
        delegate: _DefinitionPlacement(
          bounds: bounds,
          padding: padding,
          width: width,
          maxHeight: height,
        ),
        child: MouseRegion(
          onEnter: (_) => onEnter(),
          onExit: (_) => onExit(),
          child: Material(
            elevation: 5,
            color: scheme.surfaceContainer,
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.antiAlias,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: height),
              child: InkWell(
                onTap: onExpand,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              entry!.word,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Tooltip(
                            message: 'More meanings',
                            child: Icon(
                              Icons.open_in_full,
                              size: 17,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 7),
                      Flexible(
                        child: Text(
                          entry!.definition,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 16, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Places the measured card, including text scaling, rather than a guessed
/// maximum-height box. The full-size layout itself does not absorb pointer hits.
class _DefinitionPlacement extends SingleChildLayoutDelegate {
  const _DefinitionPlacement({
    required this.bounds,
    required this.padding,
    required this.width,
    required this.maxHeight,
  });
  final Rect bounds;
  final EdgeInsets padding;
  final double width;
  final double maxHeight;
  static const gap = 8.0;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final above = bounds.top - padding.top - gap * 2;
    final below =
        constraints.maxHeight - padding.bottom - bounds.bottom - gap * 2;
    return BoxConstraints.tightFor(width: width).copyWith(
      minHeight: 0,
      maxHeight: math.min(
        maxHeight,
        math.max(above, below).clamp(0, maxHeight),
      ),
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final topEdge = padding.top + gap;
    final bottomEdge = size.height - padding.bottom - gap;
    final above = bounds.top - gap - childSize.height;
    final top = (above >= topEdge ? above : bounds.bottom + gap).clamp(
      topEdge,
      math.max(topEdge, bottomEdge - childSize.height),
    );
    final left = (bounds.center.dx - childSize.width / 2).clamp(
      12.0,
      math.max(12.0, size.width - childSize.width - 12),
    );
    return Offset(left.toDouble(), top.toDouble());
  }

  @override
  bool shouldRelayout(_DefinitionPlacement oldDelegate) =>
      oldDelegate.bounds != bounds ||
      oldDelegate.padding != padding ||
      oldDelegate.width != width ||
      oldDelegate.maxHeight != maxHeight;
}
