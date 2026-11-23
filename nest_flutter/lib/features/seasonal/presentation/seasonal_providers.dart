import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/backend/server_health_repository.dart';
import '../data/seasonal_preference.dart';
import '../domain/seasonal_logic.dart';

part 'seasonal_providers.g.dart';

/// The holiday theme to show on [day] (a date without time): the server's
/// setting, unless this device switched decorations off.
@riverpod
SeasonalTheme? seasonalTheme(Ref ref, DateTime day) {
  if (ref.watch(seasonalDecorationsOnProvider).value == false) return null;
  final ping = ref.watch(serverPingProvider).value;
  return activeSeasonalTheme(
    mode: ping?.seasonalMode,
    themes: ping?.seasonalThemes,
    now: day,
  );
}
