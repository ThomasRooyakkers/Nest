import 'package:nest_server/src/generated/protocol.dart';
import 'package:nest_server/src/services/seasonal_themes.dart';
import 'package:test/test.dart';

void main() {
  (SeasonalMode, String) ping(SeasonalSetting s, DateTime now) {
    final (mode, themes) = SeasonalThemes.forPing(s, now);
    return (mode, themes.join(','));
  }

  SeasonalSetting automatic({List<SeasonalThemeDates>? dates}) =>
      SeasonalSetting(
        mode: SeasonalMode.automatic,
        enabledThemes: SeasonalThemes.available,
        themeDates: dates,
      );

  group('Given the default dates', () {
    final setting = automatic();

    test('Christmas shows from 7 to 28 December', () {
      expect(SeasonalThemes.activeTheme(setting, DateTime(2026, 12, 6)), null);
      expect(
        SeasonalThemes.activeTheme(setting, DateTime(2026, 12, 7)),
        'christmas',
      );
      expect(
        SeasonalThemes.activeTheme(setting, DateTime(2026, 12, 28, 23, 59)),
        'christmas',
      );
      expect(SeasonalThemes.activeTheme(setting, DateTime(2026, 12, 29)), null);
    });

    test('New Year runs over the new year', () {
      expect(
        SeasonalThemes.activeTheme(setting, DateTime(2026, 12, 31)),
        'newYear',
      );
      expect(
        SeasonalThemes.activeTheme(setting, DateTime(2027, 1, 2)),
        'newYear',
      );
      expect(SeasonalThemes.activeTheme(setting, DateTime(2027, 1, 3)), null);
    });

    test('the ping sends a theme that is on as always', () {
      expect(ping(setting, DateTime(2026, 12, 10)), (
        SeasonalMode.always,
        'christmas',
      ));
      expect(ping(setting, DateTime(2026, 11, 24)), (
        SeasonalMode.automatic,
        '',
      ));
    });
  });

  test('overlapping dates: the theme that started last wins', () {
    final setting = automatic(
      dates: [
        SeasonalThemeDates(
          theme: 'christmas',
          startMonth: 12,
          startDay: 1,
          endMonth: 1,
          endDay: 6,
        ),
      ],
    );
    expect(
      SeasonalThemes.activeTheme(setting, DateTime(2026, 12, 30)),
      'christmas',
    );
    expect(
      SeasonalThemes.activeTheme(setting, DateTime(2027, 1, 1)),
      'newYear',
    );
    expect(
      SeasonalThemes.activeTheme(setting, DateTime(2027, 1, 5)),
      'christmas',
    );
  });

  test('off and always ignore the dates', () {
    final off = automatic().copyWith(mode: SeasonalMode.off);
    expect(ping(off, DateTime(2026, 12, 10)), (SeasonalMode.off, ''));
    final always = automatic().copyWith(
      mode: SeasonalMode.always,
      alwaysTheme: 'newYear',
    );
    expect(SeasonalThemes.activeTheme(always, DateTime(2026, 6, 1)), 'newYear');
  });
}
