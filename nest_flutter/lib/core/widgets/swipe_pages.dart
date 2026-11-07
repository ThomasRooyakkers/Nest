import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Lets a horizontal swipe over [child] move to the next or previous of
/// [pages], the views a screen picks with chips (task filters, stores,
/// watchlist statuses). The chips follow, since they show [current].
///
/// The part of the screen inside a [SwipeContent] follows the finger,
/// slides out and the next page slides in from the other side; at the
/// first and last page it gives a little and springs back. Picking a chip
/// slides the content the same way. With reduced motion switched on the
/// page simply changes.
///
/// A fast swipe or one past a quarter of the width switches the page.
/// Widgets inside that handle horizontal drags themselves (a scrolling
/// chip row) keep them. In right-to-left languages the directions flip.
class SwipePages<T> extends StatefulWidget {
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

  /// Share of the width a slow drag must pass to switch the page.
  static const minDistance = 0.25;

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
  State<SwipePages<T>> createState() => _SwipePagesState<T>();
}

class _SwipePagesState<T> extends State<SwipePages<T>>
    with SingleTickerProviderStateMixin {
  /// Horizontal offset of the [SwipeContent], in logical pixels.
  late final _offset = AnimationController.unbounded(vsync: this);
  var _width = 360.0;

  /// The page changed because of a swipe here (already animated).
  var _changedHere = false;

  bool get _reduceMotion => MediaQuery.disableAnimationsOf(context);

  /// How far a page slides before it is swapped for the next one.
  double get _travel => _width * 0.35;

  @override
  void didUpdateWidget(SwipePages<T> old) {
    super.didUpdateWidget(old);
    if (old.current == widget.current) return;
    if (_changedHere) {
      _changedHere = false;
      return;
    }
    // Picked with a chip: slide in from the side of the new page.
    final from = widget.pages.indexOf(old.current);
    final to = widget.pages.indexOf(widget.current);
    if (from < 0 || to < 0 || _reduceMotion) return;
    final ltr = Directionality.of(context) == TextDirection.ltr;
    _slideIn(((to > from) == ltr) ? _travel : -_travel);
  }

  @override
  void dispose() {
    _offset.dispose();
    super.dispose();
  }

  void _slideIn(double from) {
    _offset.value = from;
    _offset.animateTo(
      0,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  void _onUpdate(DragUpdateDetails details) {
    final delta = details.primaryDelta ?? 0;
    final next = _offset.value + delta;
    // No page that way: follow with resistance, up to a small stretch.
    final hasPage =
        SwipePages.target(
          widget.pages,
          widget.current,
          next < 0 ? -double.maxFinite : double.maxFinite,
          direction: Directionality.of(context),
        ) !=
        null;
    _offset.value = hasPage
        ? next
        : (_offset.value + delta * 0.3).clamp(-_width * 0.12, _width * 0.12);
  }

  Future<void> _onEnd(DragEndDetails details) async {
    final velocity = details.primaryVelocity ?? 0;
    final dragged = _offset.value;
    // A fast swipe counts by its direction; a slow one by how far it went.
    final intent = velocity.abs() >= SwipePages.minVelocity
        ? velocity
        : dragged.abs() > _width * SwipePages.minDistance
        ? dragged.sign * SwipePages.minVelocity
        : 0.0;
    final next = SwipePages.target(
      widget.pages,
      widget.current,
      intent,
      direction: Directionality.of(context),
    );
    if (next == null) {
      await _offset.animateTo(
        0,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
      );
      return;
    }
    HapticFeedback.selectionClick();
    final out = intent.sign * _travel;
    if (!_reduceMotion) {
      await _offset.animateTo(
        out,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeIn,
      );
    }
    if (!mounted) return;
    _changedHere = true;
    widget.onChanged(widget.pages[next]);
    if (_reduceMotion) {
      _offset.value = 0;
    } else {
      _slideIn(-out);
    }
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.enabled && widget.pages.length > 1;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth.isFinite) _width = constraints.maxWidth;
        return _SwipeScope(
          offset: _offset,
          width: _width,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragStart: enabled ? (_) => _offset.stop() : null,
            onHorizontalDragUpdate: enabled ? _onUpdate : null,
            onHorizontalDragEnd: enabled ? _onEnd : null,
            onHorizontalDragCancel: enabled
                ? () => _offset.animateTo(
                    0,
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                  )
                : null,
            child: widget.child,
          ),
        );
      },
    );
  }
}

class _SwipeScope extends InheritedWidget {
  const _SwipeScope({
    required this.offset,
    required this.width,
    required super.child,
  });

  final Animation<double> offset;
  final double width;

  @override
  bool updateShouldNotify(_SwipeScope old) =>
      offset != old.offset || width != old.width;
}

/// The part of a [SwipePages] screen that moves with the swipe: the page
/// content, not the title or the chips.
class SwipeContent extends StatelessWidget {
  const SwipeContent({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_SwipeScope>();
    if (scope == null) return child;
    return AnimatedBuilder(
      animation: scope.offset,
      child: child,
      builder: (context, child) {
        final dx = scope.offset.value;
        if (dx == 0) return child!;
        // Fades out over the slide distance, never quite to nothing.
        final fade = (dx.abs() / (scope.width * 0.35)).clamp(0.0, 1.0);
        return Opacity(
          opacity: 1 - fade * 0.85,
          child: Transform.translate(offset: Offset(dx, 0), child: child),
        );
      },
    );
  }
}

/// Scrolls a chip into view in its horizontal row when it becomes
/// selected, so a swipe to a store far down the row shows its chip.
class KeepVisibleWhenSelected extends StatefulWidget {
  const KeepVisibleWhenSelected({
    super.key,
    required this.selected,
    required this.child,
  });

  final bool selected;
  final Widget child;

  @override
  State<KeepVisibleWhenSelected> createState() =>
      _KeepVisibleWhenSelectedState();
}

class _KeepVisibleWhenSelectedState extends State<KeepVisibleWhenSelected> {
  @override
  void didUpdateWidget(KeepVisibleWhenSelected old) {
    super.didUpdateWidget(old);
    if (widget.selected && !old.selected) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        // Only the chip row scrolls, not the page around it.
        final row = Scrollable.maybeOf(context, axis: Axis.horizontal);
        final chip = context.findRenderObject();
        if (row == null || chip == null) return;
        row.position.ensureVisible(
          chip,
          alignment: 0.5,
          duration: MediaQuery.disableAnimationsOf(context)
              ? Duration.zero
              : const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
