import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Lets a horizontal swipe over [child] move to the next or previous of
/// [pages], the views a screen picks with chips (task filters, stores,
/// watchlist statuses). The chips follow, since they show [current].
///
/// Only a quick swipe counts, so vertical scrolling stays as it is, and
/// widgets inside that handle horizontal drags themselves (a scrolling
/// chip row) keep them. In right-to-left languages the directions flip.
class SwipePages<T> extends StatelessWidget {
  const SwipePages({
    super.key,
    required this.pages,
    required this.current,
    required this.onChanged,
    required this.child,
    this.enabled = true,
  });

  /// Swipe speed, in logical pixels per second, that switches the page.
  static const minVelocity = 300.0;

  final List<T> pages;
  final T current;
  final ValueChanged<T> onChanged;
  final Widget child;
  final bool enabled;

  /// The index of the page a swipe at [velocity] (negative: to the left)
  /// moves to from [current], or null at either end or for a slow swipe.
  /// (An index, since a page itself may be null: "All stores".)
  static int? target<T>(
    List<T> pages,
    T current,
    double velocity, {
    TextDirection direction = TextDirection.ltr,
  }) {
    if (velocity.abs() < minVelocity) return null;
    final index = pages.indexOf(current);
    if (index < 0) return null;
    // Swiping left shows what is to the right: the next page.
    final forward = (velocity < 0) == (direction == TextDirection.ltr);
    final next = index + (forward ? 1 : -1);
    return next < 0 || next >= pages.length ? null : next;
  }

  @override
  Widget build(BuildContext context) {
    if (!enabled || pages.length < 2) return child;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragEnd: (details) {
        final next = target(
          pages,
          current,
          details.primaryVelocity ?? 0,
          direction: Directionality.of(context),
        );
        if (next == null) return;
        HapticFeedback.selectionClick();
        onChanged(pages[next]);
      },
      child: child,
    );
  }
}
