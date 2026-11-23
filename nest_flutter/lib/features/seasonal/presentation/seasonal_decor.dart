import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../../l10n/app_localizations.dart';
import '../domain/seasonal_logic.dart';

/// Colours of the holiday decorations. They are drawings, never text, so
/// they sit outside the design system's text colour pairs.
abstract final class SeasonalPalette {
  static const gold = Color(0xFFE8B23A);
  static const red = Color(0xFFD9443A);
  static const green = Color(0xFF2E9A62);
  static const blue = Color(0xFF3F7FE0);
  static const icyBlue = Color(0xFF9FB6D3);
  static const frost = Color(0xFFB7C7DC);
  static const snowShade = Color(0xFFE6ECF4);
  static const wire = Color(0xFF2F4A3A);
  static const socket = Color(0xFF6F7682);
  static const ribbonLight = Color(0xFFF2D07A);
  static const ribbon = Color(0xFFC9962F);
  static const ribbonDark = Color(0xFF8E6516);
  static const purple = Color(0xFF8A5BDB);
  static const leafGreen = Color(0xFF26A65B);
  static const navy = Color(0xFF1F3A5F);

  /// The light string's colours, as in the agreed design.
  static const lights = [
    Color(0xFFE2B13C),
    Color(0xFFC8463D),
    Color(0xFF2F7D5B),
    Color(0xFF9FB6D3),
  ];
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

Color _lighter(Color c, double t) => Color.lerp(c, Colors.white, t)!;
Color _darker(Color c, double t) => Color.lerp(c, Colors.black, t)!;

/// A soft round glow: [colour] in the middle, fading out at [radius].
void _glow(Canvas canvas, Offset at, double radius, Color colour) {
  canvas.drawCircle(
    at,
    radius,
    Paint()
      ..shader = RadialGradient(
        colors: [colour, colour.withValues(alpha: 0)],
      ).createShader(Rect.fromCircle(center: at, radius: radius)),
  );
}

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
              wireColor: NestColors.of(context).inkMuted,
            ),
          ),
        ),
      ),
    );
  }
}

class _LightsPainter extends CustomPainter {
  _LightsPainter(
    this.time, {
    required this.partyUntil,
    required this.moving,
    required this.wireColor,
  }) : super(repaint: time);

  final Animation<double> time;
  final DateTime? partyUntil;
  final bool moving;

  /// The wire and bulb caps: the theme's muted ink, so they show on ivory
  /// and on navy.
  final Color wireColor;

  /// How low each of the three arcs of wire hangs.
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
        ..color = wireColor.withValues(alpha: 0.55),
    );

    final party =
        moving && partyUntil != null && DateTime.now().isBefore(partyUntil!);
    final seconds = time.value * 8;
    final capPaint = Paint()..color = wireColor;
    for (var i = 0; i < bulbs.length; i++) {
      final at = bulbs[i];
      final speed = party ? 5.0 : 1.0;
      final colour = _cycle(
        SeasonalPalette.lights,
        (seconds * speed / 8 + i * 0.27) % 1,
      );
      final twinkleSpeed = party ? 6.0 : 1.0;
      // Twinkles between 45 % and full brightness.
      final twinkle =
          0.725 +
          0.275 *
              math.cos(
                (seconds * twinkleSpeed / 2.6 + i * 0.37) * 2 * math.pi,
              );
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
      canvas
        ..drawOval(
          bulb.inflate(3),
          Paint()
            ..color = colour.withValues(alpha: 0.4 * twinkle)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
        )
        ..drawOval(bulb, Paint()..color = colour.withValues(alpha: twinkle));
    }
  }

  @override
  bool shouldRepaint(_LightsPainter old) =>
      old.partyUntil != partyUntil ||
      old.moving != moving ||
      old.wireColor != wireColor;
}

Offset _quad(Offset a, Offset c, Offset b, double t) {
  final u = 1 - t;
  return a * (u * u) + c * (2 * u * t) + b * (t * t);
}

/// Through [colours] for a [phase] from 0 to 1: each colour holds for a
/// while, then turns into the next around the colour wheel, so a bulb is
/// never a muddy mix.
Color _cycle(List<Color> colours, double phase) {
  final scaled = phase * colours.length;
  final i = scaled.floor() % colours.length;
  final next = (i + 1) % colours.length;
  final t = ((scaled - scaled.floor() - 0.7) / 0.3).clamp(0.0, 1.0);
  return HSVColor.lerp(
    HSVColor.fromColor(colours[i]),
    HSVColor.fromColor(colours[next]),
    Curves.easeInOut.transform(t),
  )!.toColor();
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
    duration: const Duration(milliseconds: 2400),
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

/// A flake: where it falls ([x] as a fraction of the width), how big, how
/// long one fall takes (a divisor of 252 s) and where it starts.
class _Flake {
  const _Flake(
    this.x,
    this.size,
    this.period,
    this.offset, {
    this.crystal = false,
  });
  final double x;
  final double size;
  final double period;
  final double offset;
  final bool crystal;
}

const _flakes = [
  _Flake(0.04, 2.5, 21, 0.10),
  _Flake(0.10, 9, 14, 0.62, crystal: true),
  _Flake(0.17, 3.5, 18, 0.33),
  _Flake(0.25, 2, 28, 0.85),
  _Flake(0.31, 6, 21, 0.15, crystal: true),
  _Flake(0.38, 4, 12, 0.48),
  _Flake(0.45, 2.5, 18, 0.72),
  _Flake(0.52, 11, 14, 0.04, crystal: true),
  _Flake(0.58, 3, 21, 0.55),
  _Flake(0.65, 2, 28, 0.27),
  _Flake(0.71, 7, 18, 0.90, crystal: true),
  _Flake(0.78, 4, 12, 0.40),
  _Flake(0.84, 2.5, 21, 0.68),
  _Flake(0.90, 8, 14, 0.20, crystal: true),
  _Flake(0.96, 3, 18, 0.05),
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
    for (final (i, f) in _flakes.indexed) {
      final progress =
          (seconds / f.period + f.offset + flurry * (1 + i % 3)) % 1;
      final y = -14 + progress * (size.height + 28);
      final x =
          f.x * size.width + math.sin(progress * 2 * math.pi * 1.5 + i) * 14;
      final fade = progress < 0.05
          ? progress / 0.05
          : progress > 0.93
          ? (1 - progress) / 0.07
          : 1.0;
      final at = Offset(x, y);
      if (f.crystal) {
        _crystal(canvas, at, f.size, progress * math.pi * 1.2 + i, fade);
      } else {
        // A soft, round flake further away.
        _glow(
          canvas,
          at,
          f.size * 1.6,
          SeasonalPalette.frost.withValues(alpha: 0.75 * fade),
        );
        canvas.drawCircle(
          at,
          f.size * 0.6,
          Paint()
            ..color = _lighter(
              SeasonalPalette.frost,
              0.3,
            ).withValues(alpha: fade),
        );
      }
    }
  }

  /// A six-armed snow crystal with side branches.
  static void _crystal(
    Canvas canvas,
    Offset at,
    double r,
    double angle,
    double alpha,
  ) {
    final outer = Paint()
      ..color = SeasonalPalette.icyBlue.withValues(alpha: 0.9 * alpha)
      ..strokeWidth = math.max(1.2, r * 0.17)
      ..strokeCap = StrokeCap.round;
    final inner = Paint()
      ..color = Colors.white.withValues(alpha: 0.9 * alpha)
      ..strokeWidth = math.max(0.5, r * 0.06)
      ..strokeCap = StrokeCap.round;
    canvas
      ..save()
      ..translate(at.dx, at.dy)
      ..rotate(angle);
    for (final paint in [outer, inner]) {
      for (var k = 0; k < 6; k++) {
        canvas
          ..save()
          ..rotate(k * math.pi / 3)
          ..drawLine(Offset.zero, Offset(0, -r), paint)
          ..drawLine(Offset(0, -r * 0.55), Offset(-r * 0.28, -r * 0.78), paint)
          ..drawLine(Offset(0, -r * 0.55), Offset(r * 0.28, -r * 0.78), paint)
          ..drawLine(Offset(0, -r * 0.3), Offset(-r * 0.17, -r * 0.44), paint)
          ..drawLine(Offset(0, -r * 0.3), Offset(r * 0.17, -r * 0.44), paint)
          ..restore();
      }
    }
    canvas
      ..drawCircle(
        Offset.zero,
        r * 0.14,
        Paint()..color = Colors.white.withValues(alpha: alpha),
      )
      ..restore();
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
    this.colour,
    this.accent,
  );
  final double x;
  final double y;
  final double radius;
  final double offset;
  final Color colour;
  final Color accent;
}

const _fireworks = [
  _Firework(0.20, 0.05, 44, 0, SeasonalPalette.gold, SeasonalPalette.red),
  _Firework(0.80, 0.04, 40, 0.33, SeasonalPalette.blue, SeasonalPalette.gold),
  _Firework(0.52, 0.02, 34, 0.66, SeasonalPalette.purple, SeasonalPalette.blue),
  _Firework(0.88, 0.46, 32, 0.5, SeasonalPalette.red, SeasonalPalette.gold),
  _Firework(
    0.12,
    0.64,
    34,
    0.83,
    SeasonalPalette.leafGreen,
    SeasonalPalette.gold,
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
    for (final (i, f) in _fireworks.indexed) {
      final phase = (seconds / _period + f.offset) % 1;
      final centre = Offset(f.x * size.width, f.y * size.height + 44);
      if (phase < 0.2) {
        _rocket(canvas, centre, phase / 0.2, f.colour, 200);
      } else if (phase < 0.62) {
        _burst(
          canvas,
          centre,
          f.radius,
          (phase - 0.2) / 0.42,
          f.colour,
          f.accent,
          18,
          i,
        );
      }
    }
    final t = surprise.value;
    if (t > 0 && t < 1) {
      final top = Offset(size.width / 2, 140);
      _burst(
        canvas,
        top,
        110,
        t,
        SeasonalPalette.gold,
        SeasonalPalette.red,
        28,
        7,
      );
      if (t > 0.12) {
        _burst(
          canvas,
          Offset(size.width * 0.18, 250),
          60,
          (t - 0.12) / 0.88,
          SeasonalPalette.purple,
          SeasonalPalette.blue,
          18,
          3,
        );
      }
      if (t > 0.25) {
        _burst(
          canvas,
          Offset(size.width * 0.84, 270),
          64,
          (t - 0.25) / 0.75,
          SeasonalPalette.leafGreen,
          SeasonalPalette.gold,
          18,
          5,
        );
      }
    }
  }

  /// A rising rocket with a fading trail of sparks; [t] 0 → 1.
  static void _rocket(
    Canvas canvas,
    Offset target,
    double t,
    Color colour,
    double height,
  ) {
    final rise = Curves.easeOut.transform(math.min(1, t / 0.9));
    final head = target + Offset(0, (1 - rise) * height);
    final tail = head + const Offset(0, 34);
    canvas.drawLine(
      head,
      tail,
      Paint()
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_lighter(colour, 0.6), colour.withValues(alpha: 0)],
        ).createShader(Rect.fromPoints(head, tail)),
    );
    for (var k = 0; k < 5; k++) {
      final spark = head + Offset(math.sin(k * 2.3 + t * 20) * 3, 8.0 + k * 6);
      canvas.drawCircle(
        spark,
        1.1,
        Paint()
          ..color = _lighter(colour, 0.5).withValues(alpha: 0.7 - k * 0.12),
      );
    }
    _glow(canvas, head, 6, _lighter(colour, 0.7).withValues(alpha: 0.9));
  }

  /// One burst at [t] from 0 (start) to 1 (gone): a white flash, streaks
  /// with glowing heads that droop a little, and sparkles along them.
  static void _burst(
    Canvas canvas,
    Offset centre,
    double radius,
    double t,
    Color colour,
    Color accent,
    int count,
    int seed,
  ) {
    final grow = Curves.easeOutCubic.transform(math.min(1, t / 0.5));
    final alpha = t < 0.5 ? 1.0 : (1 - (t - 0.5) / 0.5).clamp(0.0, 1.0);
    if (t < 0.25) {
      _glow(
        canvas,
        centre,
        radius * 0.45,
        Colors.white.withValues(alpha: (1 - t / 0.25) * 0.8),
      );
    }
    final r = radius * (0.1 + 0.9 * grow);
    final gravity = t * t * radius * 0.35;
    for (var k = 0; k < count; k++) {
      final jitter = ((k * 37 + seed * 11) % 10) / 10;
      final a = k * 2 * math.pi / count + jitter * 0.15;
      final dir = Offset(math.cos(a), math.sin(a));
      final length = r * (0.85 + jitter * 0.3);
      final head = centre + dir * length + Offset(0, gravity);
      final tail = centre + dir * (length * 0.35) + Offset(0, gravity * 0.4);
      final c = k.isEven ? colour : accent;
      canvas.drawLine(
        tail,
        head,
        Paint()
          ..strokeWidth = 1.8
          ..strokeCap = StrokeCap.round
          ..shader = LinearGradient(
            colors: [
              c.withValues(alpha: 0),
              c.withValues(alpha: alpha),
            ],
          ).createShader(Rect.fromPoints(tail, head)),
      );
      _glow(canvas, head, 5, c.withValues(alpha: 0.55 * alpha));
      canvas.drawCircle(
        head,
        1.6,
        Paint()..color = _lighter(c, 0.7).withValues(alpha: alpha),
      );
      // Sparkles left behind.
      if (k % 3 == 0 && t > 0.3) {
        final sparkle =
            centre + dir * (length * 0.7) + Offset(0, gravity * 1.2);
        canvas.drawCircle(
          sparkle,
          1,
          Paint()..color = _lighter(accent, 0.6).withValues(alpha: alpha * 0.8),
        );
      }
    }
  }

  @override
  bool shouldRepaint(_FireworksPainter old) => false;
}

// ---------------------------------------------------------------------------
// Card and tab bar decorations

/// Decorations on tonight's card: snow with icicles on top and a satin
/// ribbon with a bow (Christmas), or a party popper (New Year).
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
    final dark = NestColors.of(context).brightness == Brightness.dark;
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
                child: CustomPaint(
                  painter: _RibbonPainter(end: 40, dark: dark),
                ),
              ),
            ),
          ),
          const PositionedDirectional(
            top: -11,
            start: 2,
            end: 82,
            height: 26,
            child: IgnorePointer(
              child: CustomPaint(painter: _SnowCapPainter(icicles: true)),
            ),
          ),
          const PositionedDirectional(
            top: -22,
            end: 16,
            child: IgnorePointer(
              child: CustomPaint(size: Size(64, 46), painter: _BowPainter()),
            ),
          ),
        ],
        if (theme == SeasonalTheme.newYear)
          PositionedDirectional(
            top: -26,
            end: 8,
            child: IgnorePointer(
              child: CustomPaint(
                size: const Size(72, 60),
                painter: _PopperPainter(dark: dark),
              ),
            ),
          ),
      ],
    );
  }
}

/// Snow (Christmas) or confetti and streamers (New Year) lying on top of
/// the tab bar.
class SeasonalTabBarTop extends StatelessWidget {
  const SeasonalTabBarTop({super.key, required this.theme});

  final SeasonalTheme theme;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: ExcludeSemantics(
      child: CustomPaint(
        size: const Size(double.infinity, 16),
        painter: switch (theme) {
          SeasonalTheme.christmas => const _SnowCapPainter(icicles: false),
          SeasonalTheme.newYear => const _ConfettiRestPainter(),
        },
      ),
    ),
  );
}

/// A satin ribbon running down a card, [end] pixels from its end edge.
class _RibbonPainter extends CustomPainter {
  const _RibbonPainter({required this.end, this.dark = false});

  final double end;

  /// On dark cards the drop shadow needs more strength to show.
  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    const width = 13.0;
    final left = size.width - end - width;
    final rect = Rect.fromLTWH(left, 0, width, size.height);
    canvas
      ..drawRect(
        rect.translate(1.5, 0),
        Paint()..color = Colors.black.withValues(alpha: dark ? 0.35 : 0.08),
      )
      ..drawRect(
        rect,
        Paint()
          ..shader = const LinearGradient(
            colors: [
              SeasonalPalette.ribbonDark,
              SeasonalPalette.ribbon,
              SeasonalPalette.ribbonLight,
              SeasonalPalette.ribbon,
              SeasonalPalette.ribbonDark,
            ],
            stops: [0, 0.2, 0.45, 0.75, 1],
          ).createShader(rect),
      );
    // A fine stitched edge on both sides.
    final stitch = Paint()
      ..color = SeasonalPalette.ribbonLight.withValues(alpha: 0.7)
      ..strokeWidth = 0.6;
    for (var y = 2.0; y < size.height; y += 5) {
      canvas
        ..drawLine(Offset(left + 2, y), Offset(left + 2, y + 2.5), stitch)
        ..drawLine(
          Offset(left + width - 2, y),
          Offset(left + width - 2, y + 2.5),
          stitch,
        );
    }
  }

  @override
  bool shouldRepaint(_RibbonPainter old) => old.end != end || old.dark != dark;
}

/// A soft, uneven layer of snow with shading, glints and (on cards)
/// small icicles along its lower edge.
class _SnowCapPainter extends CustomPainter {
  const _SnowCapPainter({required this.icicles});

  final bool icicles;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final base = h * 0.72;
    final bumps = math.max(3, (w / 46).round());
    final path = Path()..moveTo(4, base);
    for (var i = 0; i < bumps; i++) {
      final x0 = 4 + (w - 8) * i / bumps;
      final x1 = 4 + (w - 8) * (i + 1) / bumps;
      final top = h * (i.isEven ? 0.02 : 0.16) + (i % 3) * 1.2;
      path.cubicTo(
        x0 + (x1 - x0) * 0.15,
        top,
        x0 + (x1 - x0) * 0.85,
        top,
        x1,
        h * 0.3,
      );
    }
    path
      ..cubicTo(w + 2, h * 0.55, w, base + 3, w - 8, base + 2)
      ..lineTo(12, base + 3)
      ..cubicTo(2, base + 4, 0, base - 2, 4, base)
      ..close();

    canvas.drawShadow(path, const Color(0xFF6B7F99), 2, false);
    canvas.drawPath(
      path,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.white, SeasonalPalette.snowShade],
          stops: [0, 0.45, 1],
        ).createShader(Offset.zero & size),
    );

    if (icicles) {
      final ice = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Color(0xFFD5E2F0)],
        ).createShader(Rect.fromLTWH(0, base, w, 14));
      for (var x = 18.0; x < w - 14; x += 23 + (x % 7)) {
        final length = 5 + (x * 7 % 9);
        canvas.drawPath(
          Path()
            ..moveTo(x - 2.4, base + 1)
            ..quadraticBezierTo(x - 0.6, base + length * 0.6, x, base + length)
            ..quadraticBezierTo(x + 0.6, base + length * 0.6, x + 2.4, base + 1)
            ..close(),
          ice,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_SnowCapPainter old) => old.icicles != icicles;
}

/// A satin bow with two loops, a knot and notched tails.
class _BowPainter extends CustomPainter {
  const _BowPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    const cy = 20.0;
    Shader satin(Rect r, Alignment centre) => RadialGradient(
      center: centre,
      radius: 0.9,
      colors: const [
        SeasonalPalette.ribbonLight,
        SeasonalPalette.ribbon,
        SeasonalPalette.ribbonDark,
      ],
      stops: const [0, 0.55, 1],
    ).createShader(r);

    // Tails with a V notch.
    for (final side in const [-1.0, 1.0]) {
      final tail = Path()
        ..moveTo(cx + side * 2, cy + 2)
        ..lineTo(cx + side * 14, cy + 24)
        ..lineTo(cx + side * 9, cy + 21)
        ..lineTo(cx + side * 7, cy + 26)
        ..lineTo(cx - side * 3, cy + 4)
        ..close();
      canvas.drawPath(
        tail,
        Paint()..shader = satin(tail.getBounds(), Alignment(side * -0.4, -0.6)),
      );
    }
    // The loops, each with a darker fold inside.
    for (final side in const [-1.0, 1.0]) {
      final loop = Path()
        ..moveTo(cx, cy)
        ..cubicTo(
          cx + side * 10,
          cy - 20,
          cx + side * 30,
          cy - 18,
          cx + side * 28,
          cy - 4,
        )
        ..cubicTo(cx + side * 27, cy + 6, cx + side * 12, cy + 6, cx, cy)
        ..close();
      canvas.drawPath(
        loop,
        Paint()..shader = satin(loop.getBounds(), Alignment(side * -0.3, -0.5)),
      );
      final fold = Path()
        ..moveTo(cx + side * 3, cy - 1)
        ..cubicTo(
          cx + side * 12,
          cy - 10,
          cx + side * 20,
          cy - 9,
          cx + side * 21,
          cy - 4,
        )
        ..cubicTo(
          cx + side * 15,
          cy - 5,
          cx + side * 9,
          cy - 2,
          cx + side * 3,
          cy - 1,
        )
        ..close();
      canvas.drawPath(
        fold,
        Paint()..color = SeasonalPalette.ribbonDark.withValues(alpha: 0.55),
      );
    }
    // The knot.
    final knot = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy), width: 10, height: 11),
      const Radius.circular(3.5),
    );
    canvas
      ..drawRRect(
        knot,
        Paint()..shader = satin(knot.outerRect, const Alignment(-0.3, -0.4)),
      )
      ..drawOval(
        Rect.fromCenter(
          center: Offset(cx - 1.5, cy - 2.2),
          width: 3,
          height: 2,
        ),
        Paint()..color = Colors.white.withValues(alpha: 0.5),
      );
  }

  @override
  bool shouldRepaint(_BowPainter old) => false;
}

/// A striped party popper with curly streamers and confetti coming out.
class _PopperPainter extends CustomPainter {
  const _PopperPainter({this.dark = false});

  /// A navy cone would vanish on dark cards, so it turns a lighter blue.
  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    // Streamers.
    final streamers = [
      (
        SeasonalPalette.red,
        [
          const Offset(36, 30),
          const Offset(40, 12),
          const Offset(30, 8),
          const Offset(34, 0),
        ],
      ),
      (
        SeasonalPalette.blue,
        [
          const Offset(38, 32),
          const Offset(54, 22),
          const Offset(52, 10),
          const Offset(66, 6),
        ],
      ),
      (
        SeasonalPalette.gold,
        [
          const Offset(37, 31),
          const Offset(48, 30),
          const Offset(58, 36),
          const Offset(70, 28),
        ],
      ),
    ];
    for (final (colour, p) in streamers) {
      canvas.drawPath(
        Path()
          ..moveTo(p[0].dx, p[0].dy)
          ..cubicTo(p[1].dx, p[1].dy, p[2].dx, p[2].dy, p[3].dx, p[3].dy),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.4
          ..strokeCap = StrokeCap.round
          ..color = colour,
      );
    }

    // The cone with diagonal stripes; its opening faces up and to the
    // right, between (26, 20) and (50, 36).
    final cone = Path()
      ..moveTo(9, 57)
      ..lineTo(26, 20)
      ..lineTo(50, 36)
      ..lineTo(13, 60)
      ..quadraticBezierTo(7, 61, 9, 57)
      ..close();
    canvas
      ..save()
      ..clipPath(cone)
      ..drawPath(
        cone,
        Paint()
          ..shader = LinearGradient(
            colors: dark
                ? const [
                    Color(0xFF7FA3D6),
                    Color(0xFF5B82B8),
                    Color(0xFF3F6496),
                  ]
                : const [
                    Color(0xFF2B4C78),
                    SeasonalPalette.navy,
                    Color(0xFF14283F),
                  ],
          ).createShader(cone.getBounds()),
      );
    final stripe = Paint()
      ..color = SeasonalPalette.gold
      ..strokeWidth = 4.5;
    for (var k = 0; k < 5; k++) {
      final d = 9.0 + k * 10;
      // Stripes run across the cone, parallel to its opening.
      canvas.drawLine(
        Offset(26 - d * 0.45, 20 + d),
        Offset(50 - d * 0.75, 36 + d * 0.45),
        stripe,
      );
    }
    canvas
      ..drawPath(
        cone,
        Paint()
          ..shader = LinearGradient(
            colors: [Colors.white.withValues(alpha: 0.3), Colors.transparent],
          ).createShader(cone.getBounds()),
      )
      ..restore();
    // The opening, an ellipse along the cone's wide end.
    canvas
      ..save()
      ..translate(38, 28)
      ..rotate(math.atan2(16, 24))
      ..drawOval(
        const Rect.fromLTWH(-14.5, -4, 29, 8),
        Paint()..color = _darker(SeasonalPalette.navy, 0.45),
      )
      ..drawOval(
        const Rect.fromLTWH(-14.5, -4, 29, 8),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6
          ..color = SeasonalPalette.gold,
      )
      ..restore();

    // Confetti and stars in the air.
    const bits = [
      (Offset(50, 14), SeasonalPalette.red, 0.5),
      (Offset(60, 20), SeasonalPalette.gold, -0.35),
      (Offset(44, 4), SeasonalPalette.leafGreen, 1.0),
      (Offset(26, 12), SeasonalPalette.purple, -0.8),
      (Offset(66, 40), SeasonalPalette.blue, 0.2),
    ];
    for (final (at, colour, angle) in bits) {
      _confettiPiece(canvas, at, colour, angle);
    }
    _star(canvas, const Offset(58, 4), 4, SeasonalPalette.gold);
    _star(canvas, const Offset(20, 22), 3, SeasonalPalette.gold);
  }

  @override
  bool shouldRepaint(_PopperPainter old) => old.dark != dark;
}

/// A small shaded paper rectangle.
void _confettiPiece(Canvas canvas, Offset at, Color colour, double angle) {
  const rect = Rect.fromLTWH(-4, -2, 8, 4);
  canvas
    ..save()
    ..translate(at.dx, at.dy)
    ..rotate(angle)
    ..drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(1)),
      Paint()
        ..shader = LinearGradient(
          colors: [_lighter(colour, 0.35), colour, _darker(colour, 0.2)],
        ).createShader(rect),
    )
    ..restore();
}

/// A four-pointed sparkle star.
void _star(Canvas canvas, Offset at, double r, Color colour) {
  final path = Path()
    ..moveTo(at.dx, at.dy - r)
    ..quadraticBezierTo(at.dx, at.dy, at.dx + r, at.dy)
    ..quadraticBezierTo(at.dx, at.dy, at.dx, at.dy + r)
    ..quadraticBezierTo(at.dx, at.dy, at.dx - r, at.dy)
    ..quadraticBezierTo(at.dx, at.dy, at.dx, at.dy - r)
    ..close();
  canvas.drawPath(path, Paint()..color = colour);
}

/// Confetti, little curls of streamer and a star lying on the tab bar.
class _ConfettiRestPainter extends CustomPainter {
  const _ConfettiRestPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const pieces = 11;
    // Just inside the bar's top edge (the bar starts 10 px down this box).
    final y = size.height - 1;
    for (var i = 0; i < pieces; i++) {
      final x = 18 + (size.width - 36) * i / (pieces - 1);
      final colour =
          SeasonalPalette.confetti[i % SeasonalPalette.confetti.length];
      switch (i % 4) {
        case 0:
          // A little curl of streamer.
          canvas.drawPath(
            Path()
              ..moveTo(x - 6, y + 2)
              ..cubicTo(x - 3, y - 6, x + 1, y + 4, x + 3, y - 3)
              ..cubicTo(x + 4, y - 6, x + 7, y - 2, x + 6, y + 1),
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1.8
              ..strokeCap = StrokeCap.round
              ..color = colour,
          );
        case 2:
          canvas.drawCircle(
            Offset(x, y),
            2.2,
            Paint()
              ..shader =
                  RadialGradient(
                    colors: [_lighter(colour, 0.5), colour],
                  ).createShader(
                    Rect.fromCircle(center: Offset(x, y), radius: 2.2),
                  ),
          );
        default:
          _confettiPiece(canvas, Offset(x, y), colour, (i * 0.7) % 1.2 - 0.6);
      }
    }
    _star(canvas, Offset(size.width * 0.5, y - 2), 3.5, SeasonalPalette.gold);
  }

  @override
  bool shouldRepaint(_ConfettiRestPainter old) => false;
}
