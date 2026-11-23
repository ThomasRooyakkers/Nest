import 'package:nest_client/nest_client.dart';

/// Server API level that sends holiday decorations in its ping.
const seasonalApiVersion = 14;

/// Holiday themes this app can show. The server sends theme keys; keys
/// this app does not know are ignored.
enum SeasonalTheme {
  christmas('christmas'),
  newYear('newYear');

  const SeasonalTheme(this.key);

  final String key;

  static SeasonalTheme? fromKey(String key) =>
      values.where((t) => t.key == key).firstOrNull;
}

/// Whether [date] falls in [theme]'s dates. Keep in line with the admin
/// portal's `seasonalThemeIsOn`.
bool seasonalThemeOn(SeasonalTheme theme, DateTime date) => switch (theme) {
  SeasonalTheme.christmas =>
    date.month == 12 && date.day >= 7 && date.day <= 28,
  SeasonalTheme.newYear =>
    (date.month == 12 && date.day == 31) || (date.month == 1 && date.day <= 2),
};

/// The theme to show at [now] for the server's [mode] and [themes]; null
/// for none (also on servers that send no setting).
SeasonalTheme? activeSeasonalTheme({
  required SeasonalMode? mode,
  required List<String>? themes,
  required DateTime now,
}) {
  final known = [
    for (final key in themes ?? const <String>[]) ?SeasonalTheme.fromKey(key),
  ];
  return switch (mode) {
    null || SeasonalMode.off => null,
    SeasonalMode.always => known.firstOrNull,
    SeasonalMode.automatic =>
      known.where((t) => seasonalThemeOn(t, now)).firstOrNull,
  };
}

/// The line under the greeting while a theme shows.
sealed class SeasonalGreeting {
  const SeasonalGreeting();
}

/// "2 more sleeps until Christmas" (up to Christmas Eve).
class NightsUntilChristmas extends SeasonalGreeting {
  const NightsUntilChristmas(this.nights);
  final int nights;
}

/// "Merry Christmas" on the 25th and 26th.
class MerryChristmas extends SeasonalGreeting {
  const MerryChristmas();
}

/// "Happy holidays" on the other days of the theme.
class HappyHolidays extends SeasonalGreeting {
  const HappyHolidays();
}

/// "5 hours to 2027" on New Year's Eve.
class HoursUntilNewYear extends SeasonalGreeting {
  const HoursUntilNewYear(this.hours, this.year);
  final int hours;
  final int year;
}

/// "Happy New Year" from 1 January.
class HappyNewYear extends SeasonalGreeting {
  const HappyNewYear();
}

/// The greeting line for [theme] at [now].
SeasonalGreeting seasonalGreeting(SeasonalTheme theme, DateTime now) {
  switch (theme) {
    case SeasonalTheme.christmas:
      // Until Christmas Day (also before December when the theme is
      // shown all the time).
      if (now.isBefore(DateTime(now.year, 12, 25))) {
        final today = DateTime(now.year, now.month, now.day);
        final christmas = DateTime(now.year, 12, 25);
        return NightsUntilChristmas(christmas.difference(today).inDays);
      }
      if (now.month == 12 && now.day <= 26) return const MerryChristmas();
      return const HappyHolidays();
    case SeasonalTheme.newYear:
      if (now.month == 12 && now.day == 31) {
        final midnight = DateTime(now.year + 1);
        final hours = (midnight.difference(now).inMinutes / 60).ceil();
        return HoursUntilNewYear(hours, now.year + 1);
      }
      return const HappyNewYear();
  }
}
