import 'package:flutter_test/flutter_test.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_flutter/features/seasonal/domain/seasonal_logic.dart';

void main() {
  SeasonalTheme? active(
    SeasonalMode? mode,
    List<String>? themes,
    DateTime at,
  ) => activeSeasonalTheme(mode: mode, themes: themes, now: at);
  const both = ['christmas', 'newYear'];

  test('automatic shows each theme on its own dates', () {
    expect(active(SeasonalMode.automatic, both, DateTime(2026, 12, 6)), isNull);
    expect(
      active(SeasonalMode.automatic, both, DateTime(2026, 12, 7)),
      SeasonalTheme.christmas,
    );
    expect(
      active(SeasonalMode.automatic, both, DateTime(2026, 12, 28, 23)),
      SeasonalTheme.christmas,
    );
    expect(
      active(SeasonalMode.automatic, both, DateTime(2026, 12, 29)),
      isNull,
    );
    expect(
      active(SeasonalMode.automatic, both, DateTime(2026, 12, 31)),
      SeasonalTheme.newYear,
    );
    expect(
      active(SeasonalMode.automatic, both, DateTime(2027, 1, 2)),
      SeasonalTheme.newYear,
    );
    expect(active(SeasonalMode.automatic, both, DateTime(2027, 1, 3)), isNull);
  });

  test('a switched-off theme does not show on its dates', () {
    expect(
      active(SeasonalMode.automatic, ['newYear'], DateTime(2026, 12, 20)),
      isNull,
    );
  });

  test(
    'always shows the one theme; off, old servers and unknown keys none',
    () {
      expect(
        active(SeasonalMode.always, ['newYear'], DateTime(2026, 6, 1)),
        SeasonalTheme.newYear,
      );
      expect(active(SeasonalMode.off, both, DateTime(2026, 12, 20)), isNull);
      expect(active(null, null, DateTime(2026, 12, 20)), isNull);
      expect(
        active(SeasonalMode.always, ['midsummer'], DateTime(2026, 6, 21)),
        isNull,
      );
    },
  );

  test('the Christmas greeting counts the nights down', () {
    SeasonalGreeting at(DateTime t) =>
        seasonalGreeting(SeasonalTheme.christmas, t);
    expect((at(DateTime(2026, 12, 23, 20)) as NightsUntilChristmas).nights, 2);
    expect((at(DateTime(2026, 12, 24, 8)) as NightsUntilChristmas).nights, 1);
    expect(at(DateTime(2026, 12, 25)), isA<MerryChristmas>());
    expect(at(DateTime(2026, 12, 26)), isA<MerryChristmas>());
    expect(at(DateTime(2026, 12, 27)), isA<HappyHolidays>());
  });

  test('the New Year greeting counts the hours on New Year\'s Eve', () {
    final eve =
        seasonalGreeting(
              SeasonalTheme.newYear,
              DateTime(2026, 12, 31, 19),
            )
            as HoursUntilNewYear;
    expect((eve.hours, eve.year), (5, 2027));
    final late =
        seasonalGreeting(
              SeasonalTheme.newYear,
              DateTime(2026, 12, 31, 23, 30),
            )
            as HoursUntilNewYear;
    expect(late.hours, 1);
    expect(
      seasonalGreeting(SeasonalTheme.newYear, DateTime(2027, 1, 1)),
      isA<HappyNewYear>(),
    );
  });
}
