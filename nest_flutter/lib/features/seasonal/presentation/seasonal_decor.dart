import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../../l10n/app_localizations.dart';
import '../domain/seasonal_logic.dart';

/// Colours of the holiday decorations. They are drawings, never text, so
/// they sit outside the design system's text colour pairs.
abstract final class SeasonalPalette {
  static const gold = Color(0xFFE2B13C);
  static const red = Color(0xFFC8463D);
  static const green = Color(0xFF2F7D5B);
  static const icyBlue = Color(0xFF9FB6D3);
  static const mistBlue = Color(0xFFC9D3E0);
  static const ribbon = Color(0xFFB8862B);
  static const ribbonKnot = Color(0xFF9A6F1F);
  static const blue = Color(0xFF2F6FDE);
  static const purple = Color(0xFF7C4DCC);
  static const leafGreen = Color(0xFF1B7F3E);
  static const wire = Color(0xFF586274);

  static const lights = [gold, red, green, icyBlue];
  static const confetti = [gold, blue, red, purple, leafGreen];
}

/// Whether the decorations may move (not when the device asks for less
/// motion).
bool seasonalMotionOn(BuildContext context) =>
    !MediaQuery.disableAnimationsOf(context);

/// The line under the greeting while [theme] shows.
String seasonalGreetingText(
  AppLocalizations l10n,
  SeasonalTheme theme,
  DateTime now,
) => switch (seasonalGreeting(theme, now)) {
  NightsUntilChristmas(:final nights) => l10n.seasonalNightsUntilChristmas(
    nights,
  ),
  MerryChristmas() => l10n.seasonalMerryChristmas,
  HappyHolidays() => l10n.seasonalHappyHolidays,
  HoursUntilNewYear(:final hours, :final year) =>
    l10n.seasonalHoursUntilNewYear(hours, '$year'),
  HappyNewYear() => l10n.seasonalHappyNewYear,
};

// ---------------------------------------------------------------------------
// Christmas lights

/// A string of lights that twinkle and slowly change colour. Tapping makes
/// them flash for a few seconds.
class ChristmasLights extends StatefulWidget {
  const ChristmasLights({super.key});

  @override
  State<ChristmasLights> createState() => _ChristmasLightsState();
}

class _ChristmasLightsState extends State<ChristmasLights>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 8),
  );
  DateTime? _partyUntil;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncMotion();
  }

  void _syncMotion() {
    if (seasonalMotionOn(context)) {
      if (!_controller.isAnimating) _controller.repeat();
    } else {
      _controller
        ..stop()
        ..value = 0.3;
    }
  }

  void _party() {
    setState(
      () => _partyUntil = DateTime.now().add(const Duration(seconds: 3)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Semantics(
      button: true,
      label: l10n.seasonalLightsLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _party,
        child: SizedBox(
          height: 48,
          width: double.infinity,
          child: CustomPaint(
            painter: _LightsPainter(
              _controller,
              partyUntil: _partyUntil,
              moving: seasonalMotionOn(context),
            ),
          ),
        ),
      ),
    );
  }
}

class _LightsPainter extends CustomPainter {
  _LightsPainter(this.time, {required this.partyUntil, required this.moving})
    : super(repaint: time);

  final Animation<double> time;
  final DateTime? partyUntil;
  final bool moving;

  static const _sag = 38.0;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final third = w / 3;
    final wire = Path()..moveTo(0, 6);
    final bulbs = <Offset>[];
    for (var i = 0; i < 3; i++) {
      final x0 = i * third;
      final start = Offset(x0, i == 0 ? 6 : 10);
      final control = Offset(x0 + third / 2, _sag + 6);
      final end = Offset(x0 + third, i == 2 ? 6 : 10);
      wire.quadraticBezierTo(control.dx, control.dy, end.dx, end.dy);
      for (final t in const [0.25, 0.5, 0.75]) {
        bulbs.add(_quad(start, control, end, t));
      }
    }
    canvas.drawPath(
      wire,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = SeasonalPalette.wire.withValues(alpha: 0.55),
    );

    final party =
        moving && partyUntil != null && DateTime.now().isBefore(partyUntil!);
    final seconds = time.value * 8;
    final capPaint = Paint()..color = SeasonalPalette.wire;
    for (var i = 0; i < bulbs.length; i++) {
      final at = bulbs[i];
      // Each bulb runs through the colours on its own phase.
      final speed = party ? 5.0 : 1.0;
      final colourPhase = (seconds * speed / 8 + i * 0.27) % 1;
      final colour = _cycle(SeasonalPalette.lights, colourPhase);
      final twinkleSpeed = party ? 6.0 : 1.0;
      final twinkle =
          0.725 +
          0.275 *
              math.cos((seconds * twinkleSpeed / 2.6 + i * 0.37) * 2 * math.pi);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: at, width: 4, height: 4),
          const Radius.circular(1),
        ),
        capPaint,
      );
      final bulb = Rect.fromCenter(
        center: at + const Offset(0, 6),
        width: 8,
        height: 11,
      );
      canvas.drawOval(
        bulb.inflate(3),
        Paint()
          ..color = colour.withValues(alpha: 0.25 * twinkle)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );
      canvas.drawOval(bulb, Paint()..color = colour.withValues(alpha: twinkle));
    }
  }

  @override
  bool shouldRepaint(_LightsPainter old) =>
      old.partyUntil != partyUntil || old.moving != moving;
}

Offset _quad(Offset a, Offset c, Offset b, double t) {
  final u = 1 - t;
  return a * (u * u) + c * (2 * u * t) + b * (t * t);
}

/// Smoothly through [colours] for a [phase] from 0 to 1.
Color _cycle(List<Color> colours, double phase) {
  final scaled = phase * colours.length;
  final i = scaled.floor() % colours.length;
  final next = (i + 1) % colours.length;
  return Color.lerp(colours[i], colours[next], scaled - scaled.floor())!;
}

// ---------------------------------------------------------------------------
// Background: snow (Christmas) and fireworks (New Year)

/// Snow or fireworks behind the dashboard cards. Call
/// [SeasonalBackdropState.surprise] for a snow flurry or a big firework.
class SeasonalBackdrop extends StatefulWidget {
  const SeasonalBackdrop({super.key, required this.theme});

  final SeasonalTheme theme;

  @override
  State<SeasonalBackdrop> createState() => SeasonalBackdropState();
}

class SeasonalBackdropState extends State<SeasonalBackdrop>
    with TickerProviderStateMixin {
  // Long enough that every flake's and firework's own period fits a whole
  // number of times, so the loop is seamless.
  late final _loop = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 252),
  );
  late final _surprise = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (seasonalMotionOn(context)) {
      if (!_loop.isAnimating) _loop.repeat();
    } else {
      _loop
        ..stop()
        ..value = 0.013;
    }
  }

  /// A snow flurry or a big firework for a moment.
  void surprise() {
    if (!seasonalMotionOn(context)) return;
    _surprise.forward(from: 0);
  }

  @override
  void dispose() {
    _loop.dispose();
    _surprise.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final listenable = Listenable.merge([_loop, _surprise]);
    return IgnorePointer(
      child: ExcludeSemantics(
        child: CustomPaint(
          size: Size.infinite,
          painter: switch (widget.theme) {
            SeasonalTheme.christmas => _SnowPainter(
              listenable,
              loop: _loop,
              surprise: _surprise,
            ),
            SeasonalTheme.newYear => _FireworksPainter(
              listenable,
              loop: _loop,
              surprise: _surprise,
            ),
          },
        ),
      ),
    );
  }
}

class _Flake {
  const _Flake(
    this.x,
    this.size,
    this.period,
    this.offset, {
    this.star = false,
  });
  final double x;
  final double size;
  final double period;
  final double offset;
  final bool star;
}

const _flakes = [
  _Flake(0.05, 3, 18, 0.1),
  _Flake(0.12, 2, 21, 0.55),
  _Flake(0.22, 6, 14, 0.3, star: true),
  _Flake(0.31, 2.5, 18, 0.8),
  _Flake(0.41, 2, 12, 0.45),
  _Flake(0.50, 7, 21, 0.05, star: true),
  _Flake(0.59, 3, 14, 0.65),
  _Flake(0.69, 2, 18, 0.25),
  _Flake(0.78, 5.5, 12, 0.9, star: true),
  _Flake(0.86, 2.5, 21, 0.4),
  _Flake(0.94, 2, 14, 0.7),
];

class _SnowPainter extends CustomPainter {
  _SnowPainter(
    Listenable repaint, {
    required this.loop,
    required this.surprise,
  }) : super(repaint: repaint);

  final Animation<double> loop;
  final Animation<double> surprise;

  @override
  void paint(Canvas canvas, Size size) {
    final seconds = loop.value * 252;
    // A flurry moves every flake a whole number of extra rounds, so the
    // snow ends where it would have been and nothing jumps.
    final flurry = Curves.easeInOut.transform(surprise.value);
    final dot = Paint();
    final star = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.6;
    for (final (i, f) in _flakes.indexed) {
      // A flurry speeds the snow up for a moment.
      final progress =
          (seconds / f.period + f.offset + flurry * (1 + i % 3)) % 1;
      final y = -10 + progress * (size.height + 20);
      final x = f.x * size.width + math.sin(progress * 2 * math.pi + i) * 12;
      final fade = progress < 0.06
          ? progress / 0.06
          : progress > 0.92
          ? (1 - progress) / 0.08
          : 1.0;
      final colour =
          (i.isEven ? SeasonalPalette.mistBlue : SeasonalPalette.icyBlue)
              .withValues(alpha: fade);
      if (f.star) {
        star.color = colour;
        final r = f.size;
        for (var k = 0; k < 3; k++) {
          final a = k * math.pi / 3 + progress * math.pi;
          final d = Offset(math.cos(a) * r, math.sin(a) * r);
          canvas.drawLine(Offset(x, y) - d, Offset(x, y) + d, star);
        }
      } else {
        dot.color = colour;
        canvas.drawCircle(Offset(x, y), f.size, dot);
      }
    }
  }

  @override
  bool shouldRepaint(_SnowPainter old) => false;
}

class _Firework {
  const _Firework(
    this.x,
    this.y,
    this.radius,
    this.offset,
    this.rays,
    this.dots,
  );
  final double x;
  final double y;
  final double radius;
  final double offset;
  final Color? rays;
  final Color dots;
}

const _fireworks = [
  _Firework(0.18, 0.06, 38, 0, SeasonalPalette.gold, SeasonalPalette.gold),
  _Firework(0.80, 0.05, 34, 0.33, SeasonalPalette.blue, SeasonalPalette.red),
  _Firework(0.50, 0.03, 30, 0.66, null, SeasonalPalette.purple),
  _Firework(0.90, 0.47, 28, 0.5, SeasonalPalette.gold, SeasonalPalette.gold),
  _Firework(
    0.10,
    0.65,
    30,
    0.83,
    SeasonalPalette.gold,
    SeasonalPalette.leafGreen,
  ),
];

class _FireworksPainter extends CustomPainter {
  _FireworksPainter(
    Listenable repaint, {
    required this.loop,
    required this.surprise,
  }) : super(repaint: repaint);

  final Animation<double> loop;
  final Animation<double> surprise;

  static const _period = 6.0;

  @override
  void paint(Canvas canvas, Size size) {
    final seconds = loop.value * 252;
    for (final f in _fireworks) {
      final phase = (seconds / _period + f.offset) % 1;
      final centre = Offset(f.x * size.width, f.y * size.height + 40);
      if (phase < 0.2) {
        // The rocket rises.
        final rise = phase / 0.18;
        if (rise > 1) continue;
        final y = centre.dy + (1 - rise) * 220;
        canvas.drawLine(
          Offset(centre.dx, y),
          Offset(centre.dx, y + 18),
          Paint()
            ..color = (f.rays ?? f.dots).withValues(alpha: 0.8)
            ..strokeWidth = 2
            ..strokeCap = StrokeCap.round,
        );
      } else if (phase < 0.6) {
        final burst = (phase - 0.2) / 0.4;
        _burst(canvas, centre, f.radius, burst, f.rays, f.dots, 12);
      }
    }
    if (surprise.value > 0 && surprise.value < 1) {
      final t = surprise.value;
      final centre = Offset(size.width / 2, 130);
      _burst(
        canvas,
        centre,
        100,
        t,
        SeasonalPalette.gold,
        SeasonalPalette.blue,
        16,
      );
      if (t > 0.15) {
        _burst(
          canvas,
          Offset(size.width * 0.2, 240),
          54,
          (t - 0.15) / 0.85,
          null,
          SeasonalPalette.purple,
          10,
        );
      }
      if (t > 0.3) {
        _burst(
          canvas,
          Offset(size.width * 0.82, 260),
          54,
          (t - 0.3) / 0.7,
          SeasonalPalette.leafGreen,
          SeasonalPalette.red,
          10,
        );
      }
    }
  }

  /// One burst at [t] from 0 (start) to 1 (gone).
  static void _burst(
    Canvas canvas,
    Offset centre,
    double radius,
    double t,
    Color? rays,
    Color dots,
    int count,
  ) {
    final grow = Curves.easeOut.transform(math.min(1, t / 0.55));
    final alpha = t < 0.55 ? 1.0 : (1 - (t - 0.55) / 0.45).clamp(0.0, 1.0);
    final r = radius * (0.15 + 0.85 * grow);
    final drop = t > 0.55 ? (t - 0.55) * 16 : 0.0;
    final rayPaint = Paint()
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = (rays ?? dots).withValues(alpha: alpha);
    final dotPaint = Paint()..color = dots.withValues(alpha: alpha);
    for (var k = 0; k < count; k++) {
      final a = k * 2 * math.pi / count;
      final dir = Offset(math.cos(a), math.sin(a));
      final at = centre + Offset(0, drop);
      if (rays != null) {
        canvas.drawLine(at + dir * (r * 0.4), at + dir * (r * 0.9), rayPaint);
      }
      canvas.drawCircle(at + dir * r, 2.2, dotPaint);
    }
  }

  @override
  bool shouldRepaint(_FireworksPainter old) => false;
}

// ---------------------------------------------------------------------------
// Card and tab bar decorations

/// Decorations on tonight's card: snow on top and a gift ribbon with a bow
/// (Christmas), or a party popper (New Year).
class SeasonalCardDecor extends StatelessWidget {
  const SeasonalCardDecor({
    super.key,
    required this.theme,
    required this.child,
  });

  final SeasonalTheme theme;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = NestColors.of(context);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (theme == SeasonalTheme.christmas) ...[
          // The ribbon runs down the card, inside its rounded corners.
          Positioned.fill(
            child: IgnorePointer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(NestRadii.card),
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(end: 44),
                    child: Container(
                      width: 9,
                      color: SeasonalPalette.ribbon.withValues(alpha: 0.85),
                    ),
                  ),
                ),
              ),
            ),
          ),
          PositionedDirectional(
            top: -9,
            start: 0,
            end: 84,
            height: 22,
            child: IgnorePointer(
              child: CustomPaint(painter: _SnowCapPainter(colors.surface)),
            ),
          ),
          const PositionedDirectional(
            top: -13,
            end: 28,
            child: IgnorePointer(
              child: CustomPaint(size: Size(40, 28), painter: _BowPainter()),
            ),
          ),
        ],
        if (theme == SeasonalTheme.newYear)
          const PositionedDirectional(
            top: -16,
            end: 14,
            child: IgnorePointer(
              child: CustomPaint(size: Size(52, 46), painter: _PopperPainter()),
            ),
          ),
      ],
    );
  }
}

/// Snow (Christmas) or confetti (New Year) lying on top of the tab bar.
class SeasonalTabBarTop extends StatelessWidget {
  const SeasonalTabBarTop({super.key, required this.theme});

  final SeasonalTheme theme;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: ExcludeSemantics(
      child: CustomPaint(
        size: const Size(double.infinity, 14),
        painter: switch (theme) {
          SeasonalTheme.christmas => _SnowCapPainter(Colors.white),
          SeasonalTheme.newYear => const _ConfettiRestPainter(),
        },
      ),
    ),
  );
}

/// A soft, uneven layer of snow filling the given box.
class _SnowCapPainter extends CustomPainter {
  _SnowCapPainter(this.colour);

  final Color colour;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final bumps = math.max(3, (w / 50).round());
    final path = Path()..moveTo(8, h * 0.6);
    for (var i = 0; i < bumps; i++) {
      final x0 = 8 + (w - 16) * i / bumps;
      final x1 = 8 + (w - 16) * (i + 1) / bumps;
      final top = i.isEven ? h * 0.05 : h * 0.18;
      path.cubicTo(
        x0 + (x1 - x0) * 0.2,
        top,
        x0 + (x1 - x0) * 0.8,
        top,
        x1,
        h * 0.35,
      );
    }
    path
      ..cubicTo(w, h * 0.7, w - 10, h * 0.9, w - 20, h * 0.75)
      ..lineTo(28, h * 0.8)
      ..cubicTo(14, h * 0.95, 4, h * 0.85, 8, h * 0.6)
      ..close();
    canvas.drawShadow(path, Colors.black, 1, false);
    canvas.drawPath(path, Paint()..color = colour);
  }

  @override
  bool shouldRepaint(_SnowCapPainter old) => old.colour != colour;
}

class _BowPainter extends CustomPainter {
  const _BowPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = SeasonalPalette.ribbon;
    canvas
      ..drawPath(
        Path()
          ..moveTo(19, 15)
          ..cubicTo(9, 3, 1, 9, 7, 16)
          ..cubicTo(11, 20, 17, 18, 19, 15)
          ..close(),
        paint,
      )
      ..drawPath(
        Path()
          ..moveTo(21, 15)
          ..cubicTo(31, 3, 39, 9, 33, 16)
          ..cubicTo(29, 20, 23, 18, 21, 15)
          ..close(),
        paint,
      )
      ..drawLine(
        const Offset(18, 17),
        const Offset(13, 27),
        paint
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round,
      )
      ..drawLine(const Offset(22, 17), const Offset(27, 27), paint)
      ..drawCircle(
        const Offset(20, 15.5),
        4,
        Paint()..color = SeasonalPalette.ribbonKnot,
      );
  }

  @override
  bool shouldRepaint(_BowPainter old) => false;
}

class _PopperPainter extends CustomPainter {
  const _PopperPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..drawPath(
        Path()
          ..moveTo(10, 44)
          ..lineTo(22, 14)
          ..lineTo(36, 30)
          ..close(),
        Paint()..color = const Color(0xFF1F3A5F),
      )
      ..drawPath(
        Path()
          ..moveTo(14, 34)
          ..lineTo(19, 22)
          ..lineTo(25, 28)
          ..close(),
        Paint()..color = SeasonalPalette.gold,
      );
    const bits = [
      (Offset(33, 7), SeasonalPalette.red, 0.5),
      (Offset(43, 15), SeasonalPalette.gold, -0.35),
      (Offset(26, 3), SeasonalPalette.blue, 1.0),
    ];
    for (final (at, colour, angle) in bits) {
      canvas
        ..save()
        ..translate(at.dx, at.dy)
        ..rotate(angle)
        ..drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset.zero, width: 6, height: 3),
            const Radius.circular(1),
          ),
          Paint()..color = colour,
        )
        ..restore();
    }
    canvas
      ..drawCircle(
        const Offset(44, 4),
        2,
        Paint()..color = SeasonalPalette.purple,
      )
      ..drawCircle(
        const Offset(46, 24),
        1.8,
        Paint()..color = SeasonalPalette.gold,
      );
  }

  @override
  bool shouldRepaint(_PopperPainter old) => false;
}

class _ConfettiRestPainter extends CustomPainter {
  const _ConfettiRestPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const pieces = 9;
    for (var i = 0; i < pieces; i++) {
      final x = 24 + (size.width - 48) * i / (pieces - 1);
      final colour =
          SeasonalPalette.confetti[i % SeasonalPalette.confetti.length];
      canvas
        ..save()
        ..translate(x, size.height - 5)
        ..rotate((i * 0.7) % 1.2 - 0.6);
      if (i % 3 == 1) {
        canvas.drawCircle(Offset.zero, 2, Paint()..color = colour);
      } else {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset.zero, width: 7, height: 3),
            const Radius.circular(1),
          ),
          Paint()..color = colour,
        );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiRestPainter old) => false;
}
