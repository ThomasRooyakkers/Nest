import 'package:nest_server/src/generated/protocol.dart';
import 'package:nest_server/src/services/seasonal_themes.dart';
import 'package:test/test.dart';

import 'test_helpers.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given holiday decorations', (sessionBuilder, endpoints) {
    late TestSessionBuilder admin;

    setUpAll(useTestAuthServices);

    setUp(() async {
      admin = await signedInUser(
        sessionBuilder,
        name: 'Thomas',
        superAdmin: true,
      );
    });

    SeasonalThemeDates on(String theme, DateTime day) => SeasonalThemeDates(
      theme: theme,
      startMonth: day.month,
      startDay: day.day,
      endMonth: day.month,
      endDay: day.day,
    );

    test('without a setting every theme has its default dates', () async {
      final settings = await endpoints.adminSeasonal.settings(admin);
      expect(settings.mode, SeasonalMode.automatic);
      expect(settings.availableThemes, ['christmas', 'newYear']);
      expect(settings.themeDates.map(SeasonalThemes.describe), [
        'christmas=12-07..12-28',
        'newYear=12-31..01-02',
      ]);
    });

    test('the server sends the theme that is on today as always', () async {
      final today = DateTime.now();
      final saved = await endpoints.adminSeasonal.save(
        admin,
        SeasonalMode.automatic,
        ['christmas', 'newYear'],
        null,
        [on('newYear', today)],
      );
      expect(saved.activeTheme, 'newYear');
      // Christmas kept its default dates.
      expect(saved.themeDates.first.startDay, 7);
      var ping = await endpoints.health.ping(sessionBuilder);
      expect(ping.seasonalMode, SeasonalMode.always);
      expect(ping.seasonalThemes, ['newYear']);

      // A switched-off theme does not show, even on its dates.
      await endpoints.adminSeasonal.save(
        admin,
        SeasonalMode.automatic,
        ['christmas'],
        null,
      );
      ping = await endpoints.health.ping(sessionBuilder);
      expect(ping.seasonalMode, SeasonalMode.automatic);
      expect(ping.seasonalThemes, isEmpty);

      // Saving without dates kept them.
      final settings = await endpoints.adminSeasonal.settings(admin);
      expect(settings.themeDates.last.startMonth, today.month);
      expect(settings.activeTheme, isNull);

      final audit = await AdminAuditLog.db.find(
        sessionBuilder.build(),
        where: (t) => t.action.equals('system.seasonalThemes'),
        orderBy: (t) => t.id,
      );
      expect(audit.first.details, contains('newYear='));
      expect(audit.last.details, 'automatic christmas');
    });

    test('invalid dates are refused', () async {
      for (final dates in [
        SeasonalThemeDates(
          theme: 'christmas',
          startMonth: 2,
          startDay: 30,
          endMonth: 3,
          endDay: 1,
        ),
        SeasonalThemeDates(
          theme: 'midsummer',
          startMonth: 6,
          startDay: 21,
          endMonth: 6,
          endDay: 24,
        ),
      ]) {
        await expectLater(
          endpoints.adminSeasonal.save(
            admin,
            SeasonalMode.automatic,
            const ['christmas'],
            null,
            [dates],
          ),
          throwsA(isA<NestException>()),
        );
      }
      final today = DateTime.now();
      await expectLater(
        endpoints.adminSeasonal.save(
          admin,
          SeasonalMode.automatic,
          const ['christmas'],
          null,
          [on('christmas', today), on('christmas', today)],
        ),
        throwsA(isA<NestException>()),
      );
    });

    test('the saved setting reaches the ping and the audit log', () async {
      final saved0 = await endpoints.adminSeasonal.save(
        admin,
        SeasonalMode.automatic,
        ['newYear'],
        null,
      );
      expect(saved0.enabledThemes, ['newYear']);

      await endpoints.adminSeasonal.save(
        admin,
        SeasonalMode.always,
        ['newYear'],
        'christmas',
      );
      var ping = await endpoints.health.ping(sessionBuilder);
      expect(ping.seasonalMode, SeasonalMode.always);
      expect(ping.seasonalThemes, ['christmas']);

      final saved = await endpoints.adminSeasonal.save(
        admin,
        SeasonalMode.off,
        ['christmas', 'newYear'],
        null,
      );
      expect(saved.enabledThemes, ['christmas', 'newYear']);
      ping = await endpoints.health.ping(sessionBuilder);
      expect(ping.seasonalMode, SeasonalMode.off);
      expect(ping.seasonalThemes, isEmpty);

      final rows = await SeasonalSetting.db.find(sessionBuilder.build());
      expect(rows, hasLength(1));
      final audit = await AdminAuditLog.db.find(
        sessionBuilder.build(),
        where: (t) => t.action.equals('system.seasonalThemes'),
      );
      expect(audit.map((a) => a.details), [
        'automatic newYear',
        'always christmas',
        'off',
      ]);
    });

    test('unknown themes and always without a theme are refused', () async {
      await expectLater(
        endpoints.adminSeasonal.save(
          admin,
          SeasonalMode.automatic,
          ['christmas', 'midsummer'],
          null,
        ),
        throwsA(isA<NestException>()),
      );
      await expectLater(
        endpoints.adminSeasonal.save(
          admin,
          SeasonalMode.always,
          const [],
          null,
        ),
        throwsA(isA<NestException>()),
      );
    });
  });
}
