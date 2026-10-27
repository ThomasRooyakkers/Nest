import 'package:flutter/painting.dart';

/// Font family name for the bundled Nunito font, prefixed with this package.
const nestFontFamily = 'packages/nest_shared/Nunito';

/// Builds a Nunito text style.
///
/// Nunito is bundled as a variable font, so the weight is also set on the
/// `wght` axis; [FontWeight] alone does not pick the variation on every
/// platform. Use this helper for any custom text style.
TextStyle nunito({
  required double size,
  required int weight,
  Color? color,
  double? letterSpacing,
  double? height,
}) {
  return TextStyle(
    fontFamily: nestFontFamily,
    fontSize: size,
    fontWeight: FontWeight.values.firstWhere((w) => w.value == weight),
    fontVariations: [FontVariation.weight(weight.toDouble())],
    color: color,
    letterSpacing: letterSpacing,
    height: height,
  );
}
