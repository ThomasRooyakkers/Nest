import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// The server's holiday decoration setting. The apps decide from the dates
/// which theme shows, so every member sees it in their own time zone.
abstract final class SeasonalThemes {
  /// Every theme this server knows, in calendar order. Apps ignore keys
  /// they do not know, so new themes can be added here first.
  static const available = ['christmas', 'newYear'];

  /// Without a saved setting: automatic, every theme on.
  static SeasonalSetting get defaults => SeasonalSetting(
    mode: SeasonalMode.automatic,
    enabledThemes: available,
  );

  static Future<SeasonalSetting> current(Session session) async =>
      await SeasonalSetting.db.findFirstRow(session) ?? defaults;

  /// The themes the apps may show for [setting].
  static List<String> shownThemes(SeasonalSetting setting) =>
      switch (setting.mode) {
        SeasonalMode.off => const [],
        SeasonalMode.always => [?setting.alwaysTheme],
        SeasonalMode.automatic => setting.enabledThemes,
      };

  /// Saves the setting after checking it. Returns the saved row.
  static Future<SeasonalSetting> save(
    Session session, {
    required SeasonalMode mode,
    required List<String> enabledThemes,
    String? alwaysTheme,
  }) async {
    final enabled = [
      for (final key in available)
        if (enabledThemes.contains(key)) key,
    ];
    final unknown = enabledThemes.where((k) => !available.contains(k));
    if (unknown.isNotEmpty ||
        (alwaysTheme != null && !available.contains(alwaysTheme)) ||
        (mode == SeasonalMode.always && alwaysTheme == null)) {
      throw NestException(code: NestErrorCode.invalidInput);
    }
    final existing = await SeasonalSetting.db.findFirstRow(session);
    final row = SeasonalSetting(
      id: existing?.id,
      mode: mode,
      enabledThemes: enabled,
      alwaysTheme: alwaysTheme,
      updatedAt: DateTime.now(),
    );
    return existing == null
        ? SeasonalSetting.db.insertRow(session, row)
        : SeasonalSetting.db.updateRow(session, row);
  }
}
