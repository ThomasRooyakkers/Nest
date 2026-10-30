import 'package:nest_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_helpers.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given the admin portal endpoints', (
    sessionBuilder,
    endpoints,
  ) {
    late TestSessionBuilder admin;
    late TestSessionBuilder anna;
    late int adminId;
    late int annaId;
    late int householdId;

    setUp(() async {
      admin = await signedInUser(
        sessionBuilder,
        name: 'Thomas',
        superAdmin: true,
      );
      anna = await signedInUser(sessionBuilder, name: 'Anna');
      adminId = (await endpoints.profile.me(admin)).id!;
      annaId = (await endpoints.profile.me(anna)).id!;
      householdId = (await endpoints.household.create(
        anna,
        'Home',
      )).household.id!;
    });

    group('households', () {
      test('list shows the last activity, newest change of its data', () async {
        final before = (await endpoints.adminHouseholds.list(admin)).single;
        expect(before.lastActivityAt, isNotNull);

        await Future<void>.delayed(const Duration(milliseconds: 20));
        await endpoints.task.save(
          anna,
          householdId,
          Task(
            householdId: householdId,
            title: 'Bins',
            dueDate: DateTime.utc(2026, 11),
          ),
        );
        final after = (await endpoints.adminHouseholds.list(admin)).single;
        expect(after.lastActivityAt!.isAfter(before.lastActivityAt!), isTrue);
      });

      test('setStatus keeps the last activity', () async {
        final summary = await endpoints.adminHouseholds.setStatus(
          admin,
          householdId,
          HouseholdStatus.suspended,
        );
        expect(summary.status, HouseholdStatus.suspended);
        expect(summary.lastActivityAt, isNotNull);
      });
    });

    group('users', () {
      test('list shows every user with their household count', () async {
        final users = await endpoints.adminUsers.list(admin);
        expect(users.map((u) => u.name), ['Anna', 'Thomas']);
        final annaSummary = users.firstWhere((u) => u.id == annaId);
        expect(annaSummary.householdCount, 1);
        expect(annaSummary.isSuperAdmin, isFalse);
        expect(users.firstWhere((u) => u.id == adminId).isSuperAdmin, isTrue);
      });

      test('a disabled user is blocked until enabled again', () async {
        final disabled = await endpoints.adminUsers.setDisabled(
          admin,
          annaId,
          true,
        );
        expect(disabled.disabledAt, isNotNull);
        await expectLater(
          endpoints.household.listMine(anna),
          throwsNest(NestErrorCode.userDisabled),
        );

        final enabled = await endpoints.adminUsers.setDisabled(
          admin,
          annaId,
          false,
        );
        expect(enabled.disabledAt, isNull);
        await expectLater(endpoints.household.listMine(anna), completes);
      });

      test('disabling and enabling is audited once per change', () async {
        await endpoints.adminUsers.setDisabled(admin, annaId, true);
        await endpoints.adminUsers.setDisabled(admin, annaId, true);
        await endpoints.adminUsers.setDisabled(admin, annaId, false);
        final entries = await endpoints.adminAudit.entries(admin);
        expect(entries.map((e) => e.action), ['user.enable', 'user.disable']);
        expect(entries.first.adminName, 'Thomas');
        expect(entries.first.targetId, '$annaId');
      });

      test('an admin cannot disable themselves', () {
        expect(
          endpoints.adminUsers.setDisabled(admin, adminId, true),
          throwsNest(NestErrorCode.invalidInput),
        );
      });

      test('an unknown user is not found', () {
        expect(
          endpoints.adminUsers.setDisabled(admin, 999999, true),
          throwsNest(NestErrorCode.notFound),
        );
      });
    });

    group('audit log', () {
      test('pages from newest to oldest', () async {
        for (final status in [
          HouseholdStatus.suspended,
          HouseholdStatus.active,
          HouseholdStatus.suspended,
        ]) {
          await endpoints.adminHouseholds.setStatus(admin, householdId, status);
        }
        final first = await endpoints.adminAudit.entries(admin, limit: 2);
        expect(first.map((e) => e.details), [
          'active -> suspended',
          'suspended -> active',
        ]);
        final next = await endpoints.adminAudit.entries(
          admin,
          beforeId: first.last.id,
          limit: 2,
        );
        expect(next.map((e) => e.details), ['active -> suspended']);
      });

      test('rejects a limit outside 1–200', () async {
        await expectLater(
          endpoints.adminAudit.entries(admin, limit: 0),
          throwsNest(NestErrorCode.invalidInput),
        );
        await expectLater(
          endpoints.adminAudit.entries(admin, limit: 201),
          throwsNest(NestErrorCode.invalidInput),
        );
      });
    });

    group('backups', () {
      Future<void> insertRun(
        String target,
        BackupRunStatus status,
        DateTime startedAt,
      ) async {
        await BackupRun.db.insertRow(
          sessionBuilder.build(),
          BackupRun(
            startedAt: startedAt,
            finishedAt: startedAt.add(const Duration(minutes: 1)),
            status: status,
            target: target,
            snapshotId: status == BackupRunStatus.succeeded ? 'abc123' : null,
            sizeBytes: 1024,
          ),
        );
      }

      test('Back up now creates one pending request, audited', () async {
        final first = await endpoints.adminBackups.requestBackup(admin);
        expect(first.pendingRequest, isNotNull);
        expect(first.pendingRequest!.requestedBy, adminId);

        final second = await endpoints.adminBackups.requestBackup(admin);
        expect(second.pendingRequest!.id, first.pendingRequest!.id);
        expect(await BackupRequest.db.count(sessionBuilder.build()), 1);

        final entries = await endpoints.adminAudit.entries(admin);
        expect(entries.map((e) => e.action), ['backup.request']);
      });

      test('a picked up request is no longer pending', () async {
        final overview = await endpoints.adminBackups.requestBackup(admin);
        final session = sessionBuilder.build();
        await BackupRequest.db.updateRow(
          session,
          overview.pendingRequest!.copyWith(pickedUpAt: DateTime.now()),
        );
        expect(
          (await endpoints.adminBackups.overview(admin)).pendingRequest,
          isNull,
        );
      });

      test('overview lists runs newest first', () async {
        await insertRun(
          'local',
          BackupRunStatus.succeeded,
          DateTime.utc(2026, 10, 1),
        );
        await insertRun(
          'local',
          BackupRunStatus.failed,
          DateTime.utc(2026, 10, 2),
        );
        final runs = (await endpoints.adminBackups.overview(admin)).runs;
        expect(runs.map((r) => r.status), [
          BackupRunStatus.failed,
          BackupRunStatus.succeeded,
        ]);
      });

      test(
        'health shows the newest run per target and the last success',
        () async {
          await insertRun(
            'local',
            BackupRunStatus.succeeded,
            DateTime.utc(2026, 10, 1),
          );
          await insertRun(
            'local',
            BackupRunStatus.failed,
            DateTime.utc(2026, 10, 2),
          );
          await insertRun(
            'onedrive',
            BackupRunStatus.succeeded,
            DateTime.utc(2026, 10, 1, 12),
          );

          final health = await endpoints.adminSystem.health(admin);
          expect(
            {for (final r in health.lastBackups) r.target: r.status},
            {
              'local': BackupRunStatus.failed,
              'onedrive': BackupRunStatus.succeeded,
            },
          );
          expect(
            health.lastSuccessfulBackupAt,
            DateTime.utc(2026, 10, 1, 12, 1),
          );
        },
      );
    });

    group('system health', () {
      test('reports versions, database, disk and counts', () async {
        await endpoints.adminUsers.setDisabled(admin, annaId, true);
        await endpoints.adminHouseholds.setStatus(
          admin,
          householdId,
          HouseholdStatus.suspended,
        );
        final health = await endpoints.adminSystem.health(admin);
        expect(health.databaseOk, isTrue);
        expect(health.databaseSizeBytes, greaterThan(0));
        expect(health.diskTotalBytes, greaterThan(0));
        expect(health.diskFreeBytes, lessThanOrEqualTo(health.diskTotalBytes!));
        expect(health.householdCount, 1);
        expect(health.activeHouseholdCount, 0);
        expect(health.userCount, 2);
        expect(health.disabledUserCount, 1);
        expect(health.lastBackups, isEmpty);
        expect(health.lastSuccessfulBackupAt, isNull);
        expect(health.startedAt.isBefore(health.serverTime), isTrue);
      });
    });
  });
}
