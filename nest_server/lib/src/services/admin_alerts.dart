import 'dart:async';
import 'dart:io';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'disk_space.dart';
import 'host_settings.dart';
import 'nest_metrics.dart';
import 'verification_mail.dart';

/// Emails the super-admin about server problems (decided 2026-11-04: the
/// one exception to "no notifications in v1").
///
/// Every [interval] the server checks for problems. A new problem opens an
/// [AdminAlert] and sends one email; while it lasts a reminder goes out
/// every [remindEvery]; when it clears, a "resolved" email. Emails are in
/// English and Dutch and hold no personal data, only the kind of problem
/// and a measurement.
///
/// Host settings (server passwords): `alerts: off` stops the emails (alerts
/// are still shown in the portal); `alertEmail` sends them somewhere other
/// than the super-admin email; `uptimePingUrl` is fetched after every
/// successful check, so an outside service (e.g. healthchecks.io) notices
/// when the server stops checking in.
abstract final class AdminAlerts {
  static const interval = Duration(minutes: 5);
  static const remindEvery = Duration(hours: 24);
  static const keepResolved = Duration(days: 90);
  static const backupLateAfter = Duration(hours: 26);
  static const errorBurstWindow = Duration(minutes: 15);
  static const errorBurstCount = 10;

  /// For tests: replaces sending (returns null when sent, else a problem).
  static Future<String?> Function({
    required String to,
    required String subject,
    required String text,
  })?
  sendOverride;

  /// For tests: replace the `alerts` and `alertEmail` settings.
  static bool? enabledOverride;
  static String? recipientOverride;

  /// For tests: replaces reading the disk.
  static Future<DiskSpace?> Function()? diskOverride;

  /// The database being down cannot be stored in the database, so it is
  /// kept here until the database is back.
  static DateTime? _databaseDownSince;
  static DateTime? _databaseDownSentAt;

  static Timer? _timer;

  static bool get enabled =>
      enabledOverride ?? _password('alerts')?.toLowerCase() != 'off';

  static String? get recipient =>
      recipientOverride ??
      _password('alertEmail')?.toLowerCase() ??
      HostSettings.superAdminEmail;

  static String? get uptimePingUrl => _password('uptimePingUrl');

  /// Starts checking every [interval]. Called once at server start.
  static void start(Serverpod pod) {
    _timer?.cancel();
    // A first check soon after start, then every interval.
    Timer(const Duration(minutes: 1), () => runOnce(pod));
    _timer = Timer.periodic(interval, (_) => runOnce(pod));
  }

  /// One round: check, and ping the uptime service when the check worked.
  static Future<void> runOnce(Serverpod pod) async {
    Session? session;
    try {
      session = await pod.createSession(enableLogging: false);
      await check(session);
    } on Object catch (e) {
      await databaseFailed(e);
      return;
    } finally {
      await session?.close();
    }
    await _pingUptime();
  }

  /// Current problems, by kind, with a short measurement.
  static Future<Map<AdminAlertKind, String>> evaluate(
    Session session, {
    DateTime? now,
  }) async {
    now ??= DateTime.now().toUtc();
    final problems = <AdminAlertKind, String>{};

    final lastSuccess = await BackupRun.db.findFirstRow(
      session,
      where: (t) => t.status.equals(BackupRunStatus.succeeded),
      orderBy: (t) => t.startedAt.desc(),
    );
    final lastSuccessAt = lastSuccess?.finishedAt ?? lastSuccess?.startedAt;
    if (lastSuccessAt == null) {
      problems[AdminAlertKind.backupLate] = '';
    } else if (now.difference(lastSuccessAt) > backupLateAfter) {
      problems[AdminAlertKind.backupLate] = lastSuccessAt
          .toUtc()
          .toIso8601String();
    }

    final recent = await BackupRun.db.find(
      session,
      orderBy: (t) => t.startedAt.desc(),
      limit: 50,
    );
    final latestPerTarget = <String, BackupRun>{};
    for (final run in recent) {
      latestPerTarget.putIfAbsent(run.target, () => run);
    }
    final failed = [
      for (final run in latestPerTarget.values)
        if (run.status == BackupRunStatus.failed) run.target,
    ]..sort();
    if (failed.isNotEmpty) {
      problems[AdminAlertKind.backupFailed] = failed.join(', ');
    }

    final disk = await (diskOverride ?? readDiskSpace)();
    if (disk != null && disk.totalBytes > 0) {
      final ratio = disk.freeBytes / disk.totalBytes;
      if (ratio < NestMetrics.diskLowRatio) {
        problems[AdminAlertKind.diskLow] = '${(ratio * 100).round()}%';
      }
    }

    final errors = await NestMetrics.errorCounts(
      session,
      now.subtract(errorBurstWindow),
    );
    if (errors.server >= errorBurstCount) {
      problems[AdminAlertKind.errorBurst] = '${errors.server}';
    }
    return problems;
  }

  /// Opens, reminds and resolves alerts for the current problems.
  static Future<void> check(Session session, {DateTime? at}) async {
    final now = at ?? DateTime.now().toUtc();

    // Reaching this point means the database answers again.
    if (_databaseDownSince case final since?) {
      _databaseDownSince = null;
      _databaseDownSentAt = null;
      await AdminAlert.db.insertRow(
        session,
        AdminAlert(
          kind: AdminAlertKind.databaseDown,
          openedAt: since,
          resolvedAt: now,
          lastSentAt: now,
        ),
      );
      await _send(session, AdminAlertKind.databaseDown, null, resolved: true);
    }

    final problems = await evaluate(session, now: now);
    final open = await AdminAlert.db.find(
      session,
      where: (t) => t.resolvedAt.equals(null),
    );

    for (final MapEntry(key: kind, value: details) in problems.entries) {
      final existing = open.where((a) => a.kind == kind).firstOrNull;
      if (existing == null) {
        final sent = await _send(session, kind, details);
        await AdminAlert.db.insertRow(
          session,
          AdminAlert(
            kind: kind,
            details: details.isEmpty ? null : details,
            openedAt: now,
            lastSentAt: sent ? now : null,
          ),
        );
        session.log('Alert: ${kind.name} $details', level: LogLevel.warning);
      } else {
        final last = existing.lastSentAt;
        final due = last == null || now.difference(last) >= remindEvery;
        final sent = due && await _send(session, kind, details, reminder: true);
        await AdminAlert.db.updateRow(
          session,
          existing.copyWith(
            details: details.isEmpty ? null : details,
            lastSentAt: sent ? now : existing.lastSentAt,
          ),
        );
      }
    }

    for (final alert in open) {
      if (problems.containsKey(alert.kind)) continue;
      await AdminAlert.db.updateRow(
        session,
        alert.copyWith(resolvedAt: now),
      );
      // Only tell about the end of a problem the admin was told about.
      if (alert.lastSentAt != null) {
        await _send(session, alert.kind, alert.details, resolved: true);
      }
    }

    await AdminAlert.db.deleteWhere(
      session,
      where: (t) => t.resolvedAt < now.subtract(keepResolved),
    );
  }

  /// Called when a check could not reach the database.
  static Future<void> databaseFailed(Object error, {DateTime? now}) async {
    now ??= DateTime.now().toUtc();
    stderr.writeln('Alert check failed, database unreachable? $error');
    _databaseDownSince ??= now;
    final last = _databaseDownSentAt;
    if (last != null && now.difference(last) < remindEvery) return;
    final sent = await _deliver(
      _subject(AdminAlertKind.databaseDown, resolved: false),
      _body(AdminAlertKind.databaseDown, null, resolved: false),
    );
    if (sent) _databaseDownSentAt = now;
  }

  /// For tests.
  static void resetDatabaseState() {
    _databaseDownSince = null;
    _databaseDownSentAt = null;
  }

  static Future<bool> _send(
    Session session,
    AdminAlertKind kind,
    String? details, {
    bool reminder = false,
    bool resolved = false,
  }) => _deliver(
    _subject(kind, resolved: resolved, reminder: reminder),
    _body(kind, details, resolved: resolved),
  );

  static Future<bool> _deliver(String subject, String text) async {
    final to = recipient;
    if (!enabled || to == null) return false;
    final problem = await (sendOverride ?? VerificationMail.deliver)(
      to: to,
      subject: subject,
      text: text,
    );
    if (problem != null) {
      stderr.writeln('Alert email failed: $problem');
    }
    return problem == null;
  }

  static (String, String) _title(AdminAlertKind kind) => switch (kind) {
    AdminAlertKind.backupLate => (
      'No backup in over a day',
      'Al meer dan een dag geen back-up',
    ),
    AdminAlertKind.backupFailed => (
      'A backup failed',
      'Een back-up is mislukt',
    ),
    AdminAlertKind.diskLow => (
      'Disk space is running out',
      'De schijfruimte raakt op',
    ),
    AdminAlertKind.errorBurst => (
      'Many server errors',
      'Veel serverfouten',
    ),
    AdminAlertKind.databaseDown => (
      'The database cannot be reached',
      'De database is niet bereikbaar',
    ),
  };

  static String _subject(
    AdminAlertKind kind, {
    required bool resolved,
    bool reminder = false,
  }) {
    final (en, nl) = _title(kind);
    final host = Serverpod.instance.config.apiServer.publicHost;
    if (resolved) return 'Nest $host: resolved / opgelost: $en';
    if (reminder) return 'Nest $host: still / nog steeds: $en / $nl';
    return 'Nest $host: $en / $nl';
  }

  static String _body(
    AdminAlertKind kind,
    String? details, {
    required bool resolved,
  }) {
    final (en, nl) = _title(kind);
    final portal = HostSettings.adminDomain == null
        ? null
        : 'https://${HostSettings.adminDomain}/';
    final (detailEn, detailNl) = _detail(kind, details);
    return [
      if (resolved) ...[
        'Resolved: $en.',
        'Opgelost: $nl.',
      ] else ...[
        '$en.$detailEn',
        '$nl.$detailNl',
      ],
      '',
      if (portal != null) ...[
        'Admin portal / Beheerportaal: $portal',
        '',
      ],
      'You get this email as the super-admin of this Nest server. Turn '
          'alert emails off with ALERTS=off in .env.',
      'Je krijgt deze mail als superbeheerder van deze Nest-server. Zet '
          'meldingen uit met ALERTS=off in .env.',
    ].join('\n');
  }

  /// The measurement in a sentence per language, with a leading space.
  static (String, String) _detail(AdminAlertKind kind, String? details) {
    if (details == null || details.isEmpty) {
      return kind == AdminAlertKind.backupLate
          ? (
              ' There has never been a successful backup.',
              ' Er is nog nooit een back-up gelukt.',
            )
          : ('', '');
    }
    return switch (kind) {
      AdminAlertKind.backupLate => (
        ' Last successful backup: $details (UTC).',
        ' Laatste geslaagde back-up: $details (UTC).',
      ),
      AdminAlertKind.backupFailed => (
        ' Target: $details.',
        ' Doel: $details.',
      ),
      AdminAlertKind.diskLow => (' $details free.', ' $details vrij.'),
      AdminAlertKind.errorBurst => (
        ' $details errors in ${errorBurstWindow.inMinutes} minutes.',
        ' $details fouten in ${errorBurstWindow.inMinutes} minuten.',
      ),
      AdminAlertKind.databaseDown => ('', ''),
    };
  }

  static Future<void> _pingUptime() async {
    final url = uptimePingUrl;
    if (url == null) return;
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 10)
      ..userAgent = 'nest-server';
    try {
      final request = await client.getUrl(Uri.parse(url));
      final response = await request.close().timeout(
        const Duration(seconds: 15),
      );
      await response.drain<void>();
    } on Object catch (e) {
      stderr.writeln('Uptime ping failed: $e');
    } finally {
      client.close();
    }
  }

  static String? _password(String name) {
    final value = Serverpod.instance.getPassword(name)?.trim();
    return value == null || value.isEmpty ? null : value;
  }
}
