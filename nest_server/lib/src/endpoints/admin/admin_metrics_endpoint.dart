import 'package:serverpod/protocol.dart' as sp;
import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../services/admin_guard.dart';
import '../../services/nest_metrics.dart';

/// Trends for the Overview page: server load from Serverpod's health checks
/// and errors and slow calls from the logs. Measures only, no household
/// data.
class AdminMetricsEndpoint extends Endpoint {
  /// Health check names (Serverpod's and [NestMetrics]') → series names.
  static const _healthSeries = {
    'serverpod_cpu': 'cpu',
    'serverpod_memory': 'memory',
    'serverpod_database': 'databaseMs',
    NestMetrics.diskFree: 'diskFree',
    NestMetrics.databaseSize: 'databaseSize',
  };

  Future<AdminMetrics> metrics(Session session, MetricsRange range) async {
    await AdminGuard.require(session);
    final shape = NestMetrics.shape(range);
    final to = DateTime.now().toUtc();
    final from = to.subtract(shape.length);
    final bucket = shape.bucketMinutes;

    // Minute rows for the last 48 hours, hourly ones before (see
    // NestMetrics); both are averaged into the buckets.
    final health = await sp.ServerHealthMetric.db.find(
      session,
      where: (t) =>
          (t.timestamp > from) &
          t.name.inSet(_healthSeries.keys.toSet()) &
          t.granularity.inSet({1, 60}),
    );
    final connections = await sp.ServerHealthConnectionInfo.db.find(
      session,
      where: (t) => (t.timestamp > from) & t.granularity.inSet({1, 60}),
    );

    final series = <AdminMetricSeries>[
      for (final MapEntry(key: metric, value: name) in _healthSeries.entries)
        AdminMetricSeries(
          name: name,
          points: NestMetrics.average(
            [
              for (final m in health)
                if (m.name == metric)
                  (
                    at: m.timestamp,
                    // Database response time is stored in seconds.
                    value: metric == 'serverpod_database'
                        ? m.value * 1000
                        : m.value,
                  ),
            ],
            bucket,
          ),
        ),
      AdminMetricSeries(
        name: 'connections',
        points: NestMetrics.average([
          for (final c in connections)
            (at: c.timestamp, value: c.active.toDouble()),
        ], bucket),
      ),
      ...await _logSeries(session, from, bucket),
    ];

    final hourAgo = to.subtract(const Duration(hours: 1));
    final lastHour = await NestMetrics.errorCounts(session, hourAgo);
    return AdminMetrics(
      range: range,
      from: from,
      to: to,
      bucketMinutes: bucket,
      series: series,
      serverErrorsLastHour: lastHour.server,
      refusedLastHour: lastHour.refused,
    );
  }

  /// Unexpected errors and slow calls per bucket, from the session logs
  /// (which are kept for the log retention only).
  static Future<List<AdminMetricSeries>> _logSeries(
    Session session,
    DateTime from,
    int bucketMinutes,
  ) async {
    final rows = await session.db.unsafeQuery(
      'SELECT (floor(extract(epoch FROM "time") / @size) * @size)::bigint AS b, '
      'count(*) FILTER (WHERE "error" IS NOT NULL AND NOT ${NestMetrics.refusedSql}), '
      'count(*) FILTER (WHERE "slow") '
      'FROM "serverpod_session_log" WHERE "time" > @from '
      'GROUP BY b ORDER BY b',
      parameters: QueryParameters.named({
        'size': bucketMinutes * 60,
        'from': from,
        'refused': NestMetrics.refusedPatterns,
      }),
    );
    final errors = <AdminMetricPoint>[];
    final slow = <AdminMetricPoint>[];
    for (final row in rows) {
      final at = DateTime.fromMillisecondsSinceEpoch(
        ((row[0] as num) * 1000).round(),
        isUtc: true,
      );
      errors.add(AdminMetricPoint(at: at, value: (row[1] as int).toDouble()));
      slow.add(AdminMetricPoint(at: at, value: (row[2] as int).toDouble()));
    }
    return [
      AdminMetricSeries(name: 'serverErrors', points: errors),
      AdminMetricSeries(name: 'slowCalls', points: slow),
    ];
  }
}
