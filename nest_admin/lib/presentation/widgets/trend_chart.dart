import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../l10n/admin_localizations.dart';

enum TrendKind {
  /// A level over time (load, response time): a 2 px line.
  line,

  /// A count per bucket (errors): thin bars from the baseline.
  bars,
}

/// One measure over time in a card: title, the latest (or hovered) value,
/// and a single-series chart with a crosshair on hover or touch.
///
/// Single series, so the title names it and there is no legend. The value
/// text is ink, never the series colour; the chart has a screen reader
/// summary.
class TrendChart extends StatefulWidget {
  const TrendChart({
    super.key,
    required this.title,
    required this.points,
    required this.from,
    required this.to,
    required this.bucketMinutes,
    required this.formatValue,
    required this.formatTime,
    this.formatEdge,
    this.kind = TrendKind.line,
    this.maxValue,
  });

  final String title;
  final List<AdminMetricPoint> points;
  final DateTime from;
  final DateTime to;
  final int bucketMinutes;
  final String Function(double value) formatValue;
  final String Function(DateTime at) formatTime;

  /// Formats the start and end of the range under the chart; defaults to
  /// [formatTime].
  final String Function(DateTime at)? formatEdge;
  final TrendKind kind;

  /// A fixed top of the scale, e.g. 1.0 for shares; otherwise the highest
  /// value plus some room.
  final double? maxValue;

  @override
  State<TrendChart> createState() => _TrendChartState();
}

class _TrendChartState extends State<TrendChart> {
  int? _hovered;

  static const _height = 120.0;

  void _hover(Offset position, double width) {
    final points = widget.points;
    if (points.isEmpty || width <= 0) return;
    final span = widget.to.difference(widget.from).inMilliseconds;
    final at = widget.from.add(
      Duration(milliseconds: (position.dx / width * span).round()),
    );
    var best = 0;
    for (var i = 1; i < points.length; i++) {
      if ((points[i].at.difference(at)).abs() <
          (points[best].at.difference(at)).abs()) {
        best = i;
      }
    }
    if (best != _hovered) setState(() => _hovered = best);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AdminLocalizations.of(context);
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final points = widget.points;
    final highest = points.isEmpty
        ? 0.0
        : points.map((p) => p.value).reduce(math.max);
    final top =
        widget.maxValue ?? (highest <= 0 ? 1.0 : _niceCeiling(highest * 1.1));
    final shown = _hovered != null && _hovered! < points.length
        ? points[_hovered!]
        : points.lastOrNull;

    final muted = nunito(size: 12, weight: 600, color: colors.inkMuted);

    return NestCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(widget.title, style: textTheme.titleMedium),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                shown == null ? '–' : widget.formatValue(shown.value),
                style: nunito(size: 22, weight: 800, color: colors.ink),
              ),
              const SizedBox(width: 8),
              if (shown != null)
                Flexible(
                  child: Text(
                    widget.formatTime(shown.at),
                    style: muted,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          // The top grid line's value; the baseline is zero.
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Text(widget.formatValue(top), style: muted),
          ),
          const SizedBox(height: 2),
          if (points.isEmpty)
            SizedBox(
              height: _height,
              child: Center(child: Text(l10n.chartNoData, style: muted)),
            )
          else
            Semantics(
              container: true,
              label: l10n.chartSummary(
                widget.title,
                widget.formatValue(points.last.value),
                widget.formatValue(highest),
              ),
              child: ExcludeSemantics(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    return MouseRegion(
                      onHover: (e) => _hover(e.localPosition, width),
                      onExit: (_) => setState(() => _hovered = null),
                      child: GestureDetector(
                        onTapDown: (e) => _hover(e.localPosition, width),
                        onHorizontalDragUpdate: (e) =>
                            _hover(e.localPosition, width),
                        child: CustomPaint(
                          size: Size(width, _height),
                          painter: _TrendPainter(
                            points: points,
                            from: widget.from,
                            to: widget.to,
                            bucket: Duration(minutes: widget.bucketMinutes),
                            top: top,
                            kind: widget.kind,
                            hovered: _hovered,
                            series: colors.accent,
                            grid: colors.divider,
                            crosshair: colors.inkMuted,
                            surface: colors.surface,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  (widget.formatEdge ?? widget.formatTime)(widget.from),
                  style: muted,
                ),
              ),
              Text(
                (widget.formatEdge ?? widget.formatTime)(widget.to),
                style: muted,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Rounds up to 1, 2 or 5 times a power of ten, for a calm scale.
  static double _niceCeiling(double value) {
    final power = math
        .pow(10, (math.log(value) / math.ln10).floor())
        .toDouble();
    for (final step in [1, 2, 5, 10]) {
      if (step * power >= value) return step * power;
    }
    return 10 * power;
  }
}

class _TrendPainter extends CustomPainter {
  _TrendPainter({
    required this.points,
    required this.from,
    required this.to,
    required this.bucket,
    required this.top,
    required this.kind,
    required this.hovered,
    required this.series,
    required this.grid,
    required this.crosshair,
    required this.surface,
  });

  final List<AdminMetricPoint> points;
  final DateTime from;
  final DateTime to;
  final Duration bucket;
  final double top;
  final TrendKind kind;
  final int? hovered;
  final Color series;
  final Color grid;
  final Color crosshair;
  final Color surface;

  @override
  void paint(Canvas canvas, Size size) {
    final span = to.difference(from).inMilliseconds.toDouble();
    double x(DateTime at) =>
        (at.difference(from).inMilliseconds / span * size.width).clamp(
          0.0,
          size.width,
        );
    double y(double value) =>
        size.height - (value / top).clamp(0.0, 1.0) * size.height;

    // Recessive grid: baseline, middle and top.
    final gridPaint = Paint()
      ..color = grid
      ..strokeWidth = 1;
    for (final f in [0.0, 0.5, 1.0]) {
      final gy = (size.height * f).roundToDouble() + 0.5;
      canvas.drawLine(Offset(0, gy), Offset(size.width, gy), gridPaint);
    }

    final seriesPaint = Paint()..color = series;
    final bucketWidth = bucket.inMilliseconds / span * size.width;

    if (kind == TrendKind.bars) {
      // Thin bars with a 2 px gap and rounded tops anchored to the baseline.
      final width = math.max(1.0, bucketWidth - 2);
      final radius = Radius.circular(math.min(4, width / 2));
      for (final p in points) {
        if (p.value <= 0) continue;
        final left = x(p.at) + 1;
        canvas.drawRRect(
          RRect.fromRectAndCorners(
            Rect.fromLTRB(left, y(p.value), left + width, size.height),
            topLeft: radius,
            topRight: radius,
          ),
          seriesPaint,
        );
      }
    } else {
      // A 2 px line, broken where buckets are missing.
      final linePaint = Paint()
        ..color = series
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round;
      final path = Path();
      for (var i = 0; i < points.length; i++) {
        final p = Offset(x(points[i].at), y(points[i].value));
        final gap =
            i > 0 && points[i].at.difference(points[i - 1].at) > bucket * 1.5;
        if (i == 0 || gap) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      canvas.drawPath(path, linePaint);
      if (points.length == 1) {
        canvas.drawCircle(
          Offset(x(points.single.at), y(points.single.value)),
          3,
          seriesPaint,
        );
      }
    }

    final index = hovered;
    if (index != null && index < points.length) {
      final p = points[index];
      final cx = kind == TrendKind.bars ? x(p.at) + bucketWidth / 2 : x(p.at);
      canvas.drawLine(
        Offset(cx, 0),
        Offset(cx, size.height),
        Paint()
          ..color = crosshair
          ..strokeWidth = 1,
      );
      final center = Offset(cx, y(p.value));
      canvas
        ..drawCircle(center, 6, Paint()..color = surface)
        ..drawCircle(center, 4, seriesPaint);
    }
  }

  @override
  bool shouldRepaint(_TrendPainter old) =>
      old.points != points ||
      old.hovered != hovered ||
      old.top != top ||
      old.series != series;
}
