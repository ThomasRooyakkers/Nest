import 'package:serverpod/protocol.dart' as sp;
import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../services/admin_guard.dart';
import '../../services/log_redaction.dart';
import '../../services/security_events.dart';

/// The Logs and Security pages of the admin portal. Reads Serverpod's
/// session logs (failed and slow calls, see `NestLogging`) and Nest's
/// security events. All text is redacted (emails masked, codes hidden) on
/// the server, before it reaches the browser.
class AdminLogsEndpoint extends Endpoint {
  /// Logged calls, newest first: up to [limit] (1–200, default 50) older
  /// than [beforeId]. [errorsOnly] and [slowOnly] filter; [call] keeps calls
  /// whose `endpoint.method` contains it.
  Future<List<AdminLogSession>> sessions(
    Session session, {
    bool? errorsOnly,
    bool? slowOnly,
    String? call,
    int? beforeId,
    int? limit,
  }) async {
    await AdminGuard.require(session);
    limit = _validLimit(limit);
    final search = call?.trim().toLowerCase();

    final rows = await sp.SessionLogEntry.db.find(
      session,
      where: (t) {
        Expression<dynamic> where = Constant.bool(true);
        if (beforeId != null) where = where & (t.id < beforeId);
        if (errorsOnly ?? false) where = where & t.error.notEquals(null);
        if (slowOnly ?? false) where = where & t.slow.equals(true);
        if (search != null && search.isNotEmpty) {
          where =
              where &
              (t.endpoint.ilike('%$search%') | t.method.ilike('%$search%'));
        }
        return where;
      },
      orderBy: (t) => t.id.desc(),
      limit: limit,
    );
    return _toAdmin(session, rows);
  }

  /// One logged call with its stack trace and messages.
  Future<AdminLogSessionDetail> session(Session session, int id) async {
    await AdminGuard.require(session);
    final row = await sp.SessionLogEntry.db.findById(session, id);
    if (row == null) {
      throw NestException(code: NestErrorCode.notFound);
    }
    final messages = await sp.LogEntry.db.find(
      session,
      where: (t) => t.sessionLogId.equals(id),
      orderBy: (t) => t.order,
      limit: 200,
    );
    return AdminLogSessionDetail(
      session: (await _toAdmin(session, [row])).single,
      error: LogRedaction.redactOrNull(row.error),
      stackTrace: LogRedaction.redactOrNull(row.stackTrace, maxLength: 8000),
      messages: [
        for (final m in messages)
          AdminLogMessage(
            time: m.time,
            level: m.logLevel.name,
            message: LogRedaction.redact(m.message),
            error: LogRedaction.redactOrNull(m.error),
            stackTrace: LogRedaction.redactOrNull(
              m.stackTrace,
              maxLength: 8000,
            ),
          ),
      ],
    );
  }

  /// Security events, newest first, optionally of one [type].
  Future<List<AdminSecurityEvent>> securityEvents(
    Session session, {
    SecurityEventType? type,
    int? beforeId,
    int? limit,
  }) async {
    await AdminGuard.require(session);
    limit = _validLimit(limit);
    await SecurityEvents.deleteExpired(session);
    final rows = await SecurityEvent.db.find(
      session,
      where: (t) {
        Expression<dynamic> where = Constant.bool(true);
        if (beforeId != null) where = where & (t.id < beforeId);
        if (type != null) where = where & t.type.equals(type);
        return where;
      },
      orderBy: (t) => t.id.desc(),
      limit: limit,
    );
    final userIds = {for (final r in rows) ?r.userId};
    final users = userIds.isEmpty
        ? <NestUser>[]
        : await NestUser.db.find(
            session,
            where: (t) => t.id.inSet(userIds),
          );
    final names = {for (final u in users) u.id: u.name};
    return [
      for (final r in rows)
        AdminSecurityEvent(
          id: r.id!,
          at: r.at,
          type: r.type,
          method: r.method,
          userId: r.userId,
          userName: names[r.userId],
          emailHint: r.emailHint,
          reason: r.reason,
        ),
    ];
  }

  /// Counts over the last 24 hours and the retention settings.
  Future<AdminLogSummary> summary(Session session) async {
    await AdminGuard.require(session);
    final since = DateTime.now().toUtc().subtract(const Duration(days: 1));
    final retention = Serverpod.instance.config.sessionLogs.retentionPeriod;
    return AdminLogSummary(
      errors24h: await sp.SessionLogEntry.db.count(
        session,
        where: (t) => (t.time > since) & t.error.notEquals(null),
      ),
      slow24h: await sp.SessionLogEntry.db.count(
        session,
        where: (t) => (t.time > since) & t.slow.equals(true),
      ),
      failedSignIns24h: await SecurityEvent.db.count(
        session,
        where: (t) =>
            (t.at > since) & t.type.equals(SecurityEventType.signInFailed),
      ),
      signIns24h: await SecurityEvent.db.count(
        session,
        where: (t) =>
            (t.at > since) &
            t.type.inSet({
              SecurityEventType.signIn,
              SecurityEventType.adminSignIn,
            }),
      ),
      logRetentionDays: retention?.inDays,
      securityRetentionDays: SecurityEvents.retention.inDays,
    );
  }

  static int _validLimit(int? limit) {
    limit ??= 50;
    if (limit < 1 || limit > 200) {
      throw NestException(code: NestErrorCode.invalidInput);
    }
    return limit;
  }

  static Future<List<AdminLogSession>> _toAdmin(
    Session session,
    List<sp.SessionLogEntry> rows,
  ) async {
    final authUserIds = <UuidValue>{
      for (final r in rows) ?_uuid(r.userId),
    };
    final users = authUserIds.isEmpty
        ? <NestUser>[]
        : await NestUser.db.find(
            session,
            where: (t) => t.authUserId.inSet(authUserIds),
          );
    final byAuthId = {for (final u in users) u.authUserId.uuid: u};

    final ids = {for (final r in rows) r.id!};
    final counts = <int, int>{};
    if (ids.isNotEmpty) {
      final result = await session.db.unsafeQuery(
        'SELECT "sessionLogId", count(*) FROM "serverpod_log" '
        'WHERE "sessionLogId" = ANY(@ids) GROUP BY "sessionLogId"',
        parameters: QueryParameters.named({'ids': ids.toList()}),
      );
      for (final row in result) {
        counts[row[0] as int] = row[1] as int;
      }
    }

    return [
      for (final r in rows)
        AdminLogSession(
          id: r.id!,
          time: r.time,
          call: _callName(r),
          durationMs: r.duration == null ? null : r.duration! * 1000,
          numQueries: r.numQueries,
          slow: r.slow ?? false,
          error: LogRedaction.firstLine(r.error),
          userId: byAuthId[r.userId]?.id,
          userName: byAuthId[r.userId]?.name,
          messageCount: counts[r.id] ?? 0,
        ),
    ];
  }

  static UuidValue? _uuid(String? id) {
    if (id == null) return null;
    try {
      return UuidValue.withValidation(id);
    } on FormatException {
      return null;
    }
  }

  static String _callName(sp.SessionLogEntry r) {
    final name = [r.endpoint, r.method].nonNulls.join('.');
    if (name.isNotEmpty) return name;
    return r.module ?? '–';
  }
}
