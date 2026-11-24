import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// The server's holiday decoration setting and calendar.
///
/// The server decides which theme shows (API level 16): the super-admin
/// sets the dates of each theme, and the ping tells the apps which one
/// shows right now. Days follow the server's local time zone (`TZ` in the
/// host's `.env`). Apps before 2.1 knew only their built-in dates; they
/// follow this because the ping sends a theme that is on as `always`.
abstract final class SeasonalThemes {
  /// Every theme this server knows, in calendar order. Apps ignore keys
  /// they do not know, so new themes can be added here first.
  static const available = ['christmas', 'newYear'];

  /// The dates of each theme when the super-admin set none.
  static final defaultDates = {
    'christmas': SeasonalThemeDates(
      theme: 'christmas',
      startMonth: 12,
      startDay: 7,
      endMonth: 12,
      endDay: 28,
    ),
    'newYear': SeasonalThemeDates(
      theme: 'newYear',
      startMonth: 12,
      startDay: 31,
      endMonth: 1,
      endDay: 2,
    ),
  };

  /// Without a saved setting: automatic, every theme on.
  static SeasonalSetting get defaults => SeasonalSetting(
    mode: SeasonalMode.automatic,
    enabledThemes: available,
  );

  static Future<SeasonalSetting> current(Session session) async =>
      await SeasonalSetting.db.findFirstRow(session) ?? defaults;

  /// The dates of every available theme in [setting], in calendar order.
  static List<SeasonalThemeDates> datesOf(SeasonalSetting setting) => [
    for (final key in available)
      setting.themeDates?.where((d) => d.theme == key).firstOrNull ??
          defaultDates[key]!,
  ];

  /// Whether [dates] include the day of [date] (local time).
  static bool includes(SeasonalThemeDates dates, DateTime date) {
    final day = date.month * 100 + date.day;
    final start = dates.startMonth * 100 + dates.startDay;
    final end = dates.endMonth * 100 + dates.endDay;
    return start <= end
        ? day >= start && day <= end
        : day >= start || day <= end;
  }

  /// The theme that shows at [now] for [setting], or null. When the dates
  /// of two switched-on themes overlap, the one that started last wins, so
  /// New Year still shows inside a long Christmas.
  static String? activeTheme(SeasonalSetting setting, DateTime now) {
    switch (setting.mode) {
      case SeasonalMode.off:
        return null;
      case SeasonalMode.always:
        return setting.alwaysTheme;
      case SeasonalMode.automatic:
        final today = DateTime(now.year, now.month, now.day);
        String? best;
        int? bestDays;
        for (final dates in datesOf(setting)) {
          if (!setting.enabledThemes.contains(dates.theme)) continue;
          if (!includes(dates, today)) continue;
          var start = DateTime(today.year, dates.startMonth, dates.startDay);
          if (start.isAfter(today)) {
            start = DateTime(today.year - 1, dates.startMonth, dates.startDay);
          }
          final days = today.difference(start).inDays;
          if (bestDays == null || days < bestDays) {
            best = dates.theme;
            bestDays = days;
          }
        }
        return best;
    }
  }

  /// What the ping tells the apps at [now]: a theme that is on is sent as
  /// `always`, so apps show it whatever dates they have built in.
  static (SeasonalMode, List<String>) forPing(
    SeasonalSetting setting,
    DateTime now,
  ) {
    final active = activeTheme(setting, now);
    if (active != null) return (SeasonalMode.always, [active]);
    return (
      setting.mode == SeasonalMode.off
          ? SeasonalMode.off
          : SeasonalMode.automatic,
      const [],
    );
  }

  /// Saves the setting after checking it. [themeDates] null keeps the saved
  /// dates. Returns the saved row.
  static Future<SeasonalSetting> save(
    Session session, {
    required SeasonalMode mode,
    required List<String> enabledThemes,
    String? alwaysTheme,
    List<SeasonalThemeDates>? themeDates,
  }) async {
    final enabled = [
      for (final key in available)
        if (enabledThemes.contains(key)) key,
    ];
    final unknown = enabledThemes.where((k) => !available.contains(k));
    if (unknown.isNotEmpty ||
        (alwaysTheme != null && !available.contains(alwaysTheme)) ||
        (mode == SeasonalMode.always && alwaysTheme == null) ||
        (themeDates != null && !_validDates(themeDates))) {
      throw NestException(code: NestErrorCode.invalidInput);
    }
    final existing = await SeasonalSetting.db.findFirstRow(session);
    final dates = themeDates == null
        ? existing?.themeDates
        : [
            for (final key in available)
              ?themeDates.where((d) => d.theme == key).firstOrNull,
          ];
    final row = SeasonalSetting(
      id: existing?.id,
      mode: mode,
      enabledThemes: enabled,
      alwaysTheme: alwaysTheme,
      themeDates: dates,
      updatedAt: DateTime.now(),
    );
    return existing == null
        ? SeasonalSetting.db.insertRow(session, row)
        : SeasonalSetting.db.updateRow(session, row);
  }

  static bool _validDates(List<SeasonalThemeDates> list) {
    final seen = <String>{};
    for (final d in list) {
      if (!available.contains(d.theme) || !seen.add(d.theme)) return false;
      if (!_validDay(d.startMonth, d.startDay) ||
          !_validDay(d.endMonth, d.endDay)) {
        return false;
      }
    }
    return true;
  }

  /// Day of a month in any year (29 February allowed).
  static bool _validDay(int month, int day) {
    if (month < 1 || month > 12 || day < 1) return false;
    const lengths = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    return day <= lengths[month - 1];
  }

  /// Short text of [dates] for the audit log, e.g. `christmas=12-07..12-28`.
  static String describe(SeasonalThemeDates dates) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${dates.theme}=${two(dates.startMonth)}-${two(dates.startDay)}'
        '..${two(dates.endMonth)}-${two(dates.endDay)}';
  }
}
