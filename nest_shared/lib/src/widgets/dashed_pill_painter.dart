import 'package:flutter/widgets.dart';

/// Dashed pill outline for "add" buttons (use the `checkboxIdle` colour).
class DashedPillPainter extends CustomPainter {
  DashedPillPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final rect = Offset.zero & size;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          rect.deflate(0.75),
          Radius.circular(size.height / 2),
        ),
      );
    for (final metric in path.computeMetrics()) {
      for (var d = 0.0; d < metric.length; d += 9) {
        canvas.drawPath(metric.extractPath(d, d + 5), paint);
      }
    }
  }

  @override
  bool shouldRepaint(DashedPillPainter old) => old.color != color;
}
