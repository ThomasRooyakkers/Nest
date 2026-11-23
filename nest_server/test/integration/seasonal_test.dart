import 'package:nest_server/src/generated/protocol.dart';
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

    test('without a setting every theme shows on its dates', () async {
      final ping = await endpoints.health.ping(sessionBuilder);
      expect(ping.seasonalMode, SeasonalMode.automatic);
      expect(ping.seasonalThemes, ['christmas', 'newYear']);

      final settings = await endpoints.adminSeasonal.settings(admin);
      expect(settings.mode, SeasonalMode.automatic);
      expect(settings.availableThemes, ['christmas', 'newYear']);
    });

    test('the saved setting reaches the ping and the audit log', () async {
      await endpoints.adminSeasonal.save(
        admin,
        SeasonalMode.automatic,
        ['newYear'],
        null,
      );
      var ping = await endpoints.health.ping(sessionBuilder);
      expect(ping.seasonalThemes, ['newYear']);

      await endpoints.adminSeasonal.save(
        admin,
        SeasonalMode.always,
        ['newYear'],
        'christmas',
      );
      ping = await endpoints.health.ping(sessionBuilder);
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
