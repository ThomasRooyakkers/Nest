import 'package:nest_server/src/generated/protocol.dart';
import 'package:nest_server/src/services/admin_alerts.dart';
import 'package:serverpod/protocol.dart' as sp;
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'test_helpers.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given admin alerts', (sessionBuilder, endpoints) {
    late Session session;
    late List<({String to, String subject, String text})> sent;
    var free = 0.5;
    final now = DateTime.utc(2026, 11, 4, 12);

    setUp(() {
      session = sessionBuilder.build();
      sent = [];
      free = 0.5;
      AdminAlerts.enabledOverride = true;
      AdminAlerts.recipientOverride = 'admin@example.com';
      AdminAlerts.sendOverride =
          ({required to, required subject, required text}) async {
            sent.add((to: to, subject: subject, text: text));
            return null;
          };
      AdminAlerts.diskOverride = () async =>
          (freeBytes: (free * 1000).round(), totalBytes: 1000);
      AdminAlerts.resetDatabaseState();
    });

    tearDown(() {
      AdminAlerts.enabledOverride = null;
      AdminAlerts.recipientOverride = null;
      AdminAlerts.sendOverride = null;
      AdminAlerts.diskOverride = null;
    });

    Future<void> backup(BackupRunStatus status, DateTime at, String target) =>
        BackupRun.db.insertRow(
          session,
          BackupRun(
            startedAt: at,
            finishedAt: at,
            status: status,
            target: target,
          ),
        );

    Future<List<AdminAlert>> open() => AdminAlert.db.find(
      session,
      where: (t) => t.resolvedAt.equals(null),
    );

    test(
      'a fresh server without backups alerts once, in both languages',
      () async {
        await AdminAlerts.check(session, at: now);
        expect((await open()).map((a) => a.kind), [AdminAlertKind.backupLate]);
        expect(sent, hasLength(1));
        expect(sent.single.to, 'admin@example.com');
        expect(sent.single.subject, contains('No backup in over a day'));
        expect(sent.single.text, contains('Al meer dan een dag geen back-up'));
        expect(sent.single.text, contains('nog nooit een back-up gelukt'));

        // Five minutes later: still open, no second email.
        await AdminAlerts.check(
          session,
          at: now.add(const Duration(minutes: 5)),
        );
        expect(sent, hasLength(1));

        // A day later: a reminder.
        await AdminAlerts.check(
          session,
          at: now.add(const Duration(hours: 24)),
        );
        expect(sent, hasLength(2));
        expect(sent.last.subject, contains('still'));
      },
    );

    test(
      'a recent good backup clears the alert with a resolved email',
      () async {
        await AdminAlerts.check(session, at: now);
        await backup(BackupRunStatus.succeeded, now, 'local');
        await AdminAlerts.check(
          session,
          at: now.add(const Duration(minutes: 5)),
        );

        expect(await open(), isEmpty);
        expect(sent.last.subject, contains('resolved'));
        final resolved = await AdminAlert.db.find(session);
        expect(resolved.single.resolvedAt, isNotNull);
      },
    );

    test('a failed target and low disk each open an alert', () async {
      await backup(BackupRunStatus.succeeded, now, 'local');
      await backup(
        BackupRunStatus.failed,
        now.subtract(const Duration(hours: 1)),
        'onedrive',
      );
      free = 0.06;
      await AdminAlerts.check(session, at: now);

      final alerts = {for (final a in await open()) a.kind: a.details};
      expect(alerts, {
        AdminAlertKind.backupFailed: 'onedrive',
        AdminAlertKind.diskLow: '6%',
      });
      expect(sent, hasLength(2));
    });

    test(
      'ten real server errors in 15 minutes open an alert; refusals do not',
      () async {
        // Log entries are counted against the real clock, so the backup
        // must be recent by the real clock too.
        final recent = DateTime.now().toUtc();
        await backup(BackupRunStatus.succeeded, recent, 'local');
        for (var i = 0; i < 12; i++) {
          await sp.SessionLogEntry.db.insertRow(
            session,
            sp.SessionLogEntry(
              serverId: 'default',
              time: recent,
              touched: recent,
              error: i < 9
                  ? 'StateError: boom'
                  : 'NestException(code: notSignedIn)',
            ),
          );
        }
        await AdminAlerts.check(session);
        expect(await open(), isEmpty, reason: '9 real errors, 3 refusals');

        await sp.SessionLogEntry.db.insertRow(
          session,
          sp.SessionLogEntry(
            serverId: 'default',
            time: recent,
            touched: recent,
            error: 'StateError: boom',
          ),
        );
        await AdminAlerts.check(session);
        final alert = (await open()).single;
        expect(alert.kind, AdminAlertKind.errorBurst);
        expect(alert.details, '10');
      },
    );

    test(
      'with alerts off nothing is sent, but the portal still shows them',
      () async {
        AdminAlerts.enabledOverride = false;
        await AdminAlerts.check(session, at: now);
        expect(sent, isEmpty);
        final alert = (await open()).single;
        expect(alert.lastSentAt, isNull);

        final admin = await signedInUser(
          sessionBuilder,
          name: 'Thomas',
          superAdmin: true,
        );
        final overview = await endpoints.adminAlerts.overview(admin);
        expect(overview.enabled, isFalse);
        expect(overview.alerts.single.kind, AdminAlertKind.backupLate);
      },
    );

    test(
      'an unreachable database is emailed once and resolved when back',
      () async {
        await backup(BackupRunStatus.succeeded, now, 'local');
        await AdminAlerts.databaseFailed(Exception('down'), now: now);
        await AdminAlerts.databaseFailed(
          Exception('down'),
          now: now.add(const Duration(minutes: 5)),
        );
        expect(sent, hasLength(1));
        expect(sent.single.subject, contains('database cannot be reached'));

        await AdminAlerts.check(
          session,
          at: now.add(const Duration(minutes: 10)),
        );
        expect(sent.last.subject, contains('resolved'));
        final history = await AdminAlert.db.find(session);
        expect(history.single.kind, AdminAlertKind.databaseDown);
        expect(history.single.resolvedAt, isNotNull);
      },
    );

    test('alert emails hold no personal data', () async {
      await signedInUser(sessionBuilder, name: 'Anna Secret');
      await AdminAlerts.check(session, at: now);
      expect(sent.single.text, isNot(contains('Anna')));
    });
  });
}
