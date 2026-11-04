import 'package:nest_server/src/generated/protocol.dart';
import 'package:nest_server/src/services/nest_metrics.dart';
import 'package:serverpod/protocol.dart' as sp;
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'test_helpers.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given the Overview metrics', (sessionBuilder, endpoints) {
    late TestSessionBuilder admin;
    late Session session;

    setUp(() async {
      session = sessionBuilder.build();
      admin = await signedInUser(
        sessionBuilder,
        name: 'Thomas',
        superAdmin: true,
      );
    });

    AdminMetricSeries seriesOf(AdminMetrics m, String name) =>
        m.series.firstWhere((s) => s.name == name);

    Future<void> metric(String name, DateTime at, double value) =>
        sp.ServerHealthMetric.db.insertRow(
          session,
          sp.ServerHealthMetric(
            name: name,
            serverId: 'default',
            timestamp: at,
            isHealthy: true,
            value: value,
            granularity: 1,
          ),
        );

    Future<void> call(DateTime at, {String? error, bool slow = false}) =>
        sp.SessionLogEntry.db.insertRow(
          session,
          sp.SessionLogEntry(
            serverId: 'default',
            time: at,
            touched: at,
            endpoint: 'shopping',
            method: 'items',
            error: error,
            slow: slow,
          ),
        );

    test('health checks are averaged per 15-minute bucket for a day', () async {
      final bucket = NestMetrics.bucketStart(
        DateTime.now().toUtc().subtract(const Duration(hours: 2)),
        15,
      );
      await metric(
        'serverpod_cpu',
        bucket.add(const Duration(minutes: 1)),
        0.2,
      );
      await metric(
        'serverpod_cpu',
        bucket.add(const Duration(minutes: 2)),
        0.4,
      );
      await metric('serverpod_database', bucket, 0.004);
      await metric(NestMetrics.diskFree, bucket, 0.5);
      // Older than a day: left out.
      await metric(
        'serverpod_cpu',
        DateTime.now().toUtc().subtract(const Duration(days: 2)),
        0.9,
      );

      final m = await endpoints.adminMetrics.metrics(admin, MetricsRange.day);
      expect(m.bucketMinutes, 15);
      final cpu = seriesOf(m, 'cpu').points.single;
      expect(cpu.at, bucket);
      expect(cpu.value, closeTo(0.3, 1e-9));
      expect(seriesOf(m, 'databaseMs').points.single.value, closeTo(4, 1e-9));
      expect(seriesOf(m, 'diskFree').points.single.value, 0.5);
    });

    test('refused calls are counted apart from real server errors', () async {
      final now = DateTime.now().toUtc();
      await call(now, error: 'Exception: NestException(code: notSignedIn)');
      await call(
        now,
        error: 'Exception: EmailAccountLoginException(reason: x)',
      );
      await call(now, error: 'Null check operator used on a null value');
      await call(now, slow: true);
      await call(
        now.subtract(const Duration(hours: 3)),
        error: 'StateError: boom',
      );

      final m = await endpoints.adminMetrics.metrics(admin, MetricsRange.day);
      expect(m.serverErrorsLastHour, 1);
      expect(m.refusedLastHour, 2);
      final errors = seriesOf(m, 'serverErrors').points;
      expect(errors.map((p) => p.value).reduce((a, b) => a + b), 2);
      final slow = seriesOf(m, 'slowCalls').points;
      expect(slow.map((p) => p.value).reduce((a, b) => a + b), 1);
    });

    test('the health check adds free disk share and database size', () async {
      final metrics = await NestMetrics.healthCheck(
        Serverpod.instance,
        DateTime.now().toUtc(),
      );
      final byName = {for (final m in metrics) m.name: m.value};
      expect(byName[NestMetrics.diskFree], inInclusiveRange(0, 1));
      expect(byName[NestMetrics.databaseSize], greaterThan(0));
    });
  });

  test('bucketStart rounds down to the bucket', () {
    expect(
      NestMetrics.bucketStart(DateTime.utc(2026, 11, 4, 10, 37, 12), 15),
      DateTime.utc(2026, 11, 4, 10, 30),
    );
    expect(
      NestMetrics.bucketStart(DateTime.utc(2026, 11, 4, 10, 37), 120),
      DateTime.utc(2026, 11, 4, 10),
    );
  });
}
