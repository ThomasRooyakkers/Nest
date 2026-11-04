import 'package:nest_server/src/endpoints/health_endpoint.dart';
import 'package:nest_server/src/generated/protocol.dart';
import 'package:nest_server/src/services/tmdb_service.dart';
import 'package:nest_server/src/services/update_check.dart';
import 'package:serverpod_auth_idp_server/core.dart';
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

    setUpAll(useTestAuthServices);

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

    Future<List<String>> auditActions() async => [
      for (final e in await endpoints.adminAudit.entries(admin)) e.action,
    ];

    group('household management', () {
      test('detail shows members, invite and counts, no content', () async {
        await endpoints.task.save(
          anna,
          householdId,
          Task(
            householdId: householdId,
            title: 'Bins',
            dueDate: DateTime.utc(2026, 11),
          ),
        );
        final detail = await endpoints.adminHouseholds.detail(
          admin,
          householdId,
        );
        expect(detail.summary.name, 'Home');
        expect(detail.members.single.userId, annaId);
        expect(detail.members.single.role, MembershipRole.owner);
        expect(detail.counts.tasks, 1);
        expect(detail.counts.recipes, 0);
        expect(detail.inviteCode, isNull);
        expect(detail.toJson().toString(), isNot(contains('Bins')));
      });

      test('an unknown household is not found', () {
        expect(
          endpoints.adminHouseholds.detail(admin, 999999),
          throwsNest(NestErrorCode.notFound),
        );
      });

      test('create makes an empty household with an invite code; the first '
          'to join becomes its owner, the next a member', () async {
        final created = await endpoints.adminHouseholds.create(
          admin,
          '  Family B  ',
        );
        expect(created.summary.name, 'Family B');
        expect(created.members, isEmpty);
        expect(created.summary.enabledFeatures, HouseholdFeature.values);
        expect(created.inviteCode, hasLength(8));
        expect(created.inviteExpiresAt!.isAfter(DateTime.now()), isTrue);

        final bob = await signedInUser(sessionBuilder, name: 'Bob');
        final first = await endpoints.household.join(
          bob,
          created.inviteCode!,
        );
        expect(first.role, MembershipRole.owner);
        final second = await endpoints.household.join(
          anna,
          created.inviteCode!,
        );
        expect(second.role, MembershipRole.member);
        expect(await auditActions(), contains('household.create'));
      });

      test('create refuses an empty name', () {
        expect(
          endpoints.adminHouseholds.create(admin, '  '),
          throwsNest(NestErrorCode.invalidInput),
        );
      });

      test('rename, features and invites are applied and audited', () async {
        var detail = await endpoints.adminHouseholds.rename(
          admin,
          householdId,
          'Our home',
        );
        expect(detail.summary.name, 'Our home');

        detail = await endpoints.adminHouseholds.setFeatures(
          admin,
          householdId,
          [HouseholdFeature.tasks, HouseholdFeature.shopping],
        );
        expect(detail.summary.enabledFeatures, [
          HouseholdFeature.shopping,
          HouseholdFeature.tasks,
        ]);

        detail = await endpoints.adminHouseholds.createInvite(
          admin,
          householdId,
        );
        expect(detail.inviteCode, hasLength(8));
        detail = await endpoints.adminHouseholds.revokeInvite(
          admin,
          householdId,
        );
        expect(detail.inviteCode, isNull);

        expect(
          await auditActions(),
          containsAll([
            'household.rename',
            'household.setFeatures',
            'household.createInvite',
            'household.revokeInvite',
          ]),
        );
        final rename = (await endpoints.adminAudit.entries(
          admin,
        )).firstWhere((e) => e.action == 'household.rename');
        expect(rename.details, isNull, reason: 'no household name in the log');
      });

      test('ownership moves between members; the last owner stays', () async {
        final bob = await signedInUser(sessionBuilder, name: 'Bob');
        final bobId = (await endpoints.profile.me(bob)).id!;
        final code = (await endpoints.adminHouseholds.createInvite(
          admin,
          householdId,
        )).inviteCode!;
        await endpoints.household.join(bob, code);

        await expectLater(
          endpoints.adminHouseholds.setMemberRole(
            admin,
            householdId,
            annaId,
            MembershipRole.member,
          ),
          throwsNest(NestErrorCode.lastOwner),
        );

        await endpoints.adminHouseholds.setMemberRole(
          admin,
          householdId,
          bobId,
          MembershipRole.owner,
        );
        final detail = await endpoints.adminHouseholds.setMemberRole(
          admin,
          householdId,
          annaId,
          MembershipRole.member,
        );
        final roles = {for (final m in detail.members) m.userId: m.role};
        expect(roles, {
          bobId: MembershipRole.owner,
          annaId: MembershipRole.member,
        });
        expect(detail.summary.ownerNames, ['Bob']);
      });

      test('setMemberRole for someone outside the household is not found', () {
        expect(
          endpoints.adminHouseholds.setMemberRole(
            admin,
            householdId,
            adminId,
            MembershipRole.owner,
          ),
          throwsNest(NestErrorCode.notFound),
        );
      });
    });

    group('user management', () {
      test('detail shows households, sign-in methods and devices', () async {
        final session = sessionBuilder.build();
        final anne = await NestUser.db.findById(session, annaId);
        await addRefreshToken(session, anne!.authUserId);
        await addRefreshToken(session, anne.authUserId);

        final detail = await endpoints.adminUsers.detail(admin, annaId);
        expect(detail.summary.name, 'Anna');
        expect(detail.households.single.name, 'Home');
        expect(detail.households.single.role, MembershipRole.owner);
        expect(detail.signInMethods.email, isFalse);
        expect(detail.activeSessions, 2);
        expect(detail.lastSeenAt, isNotNull);
      });

      test('sign out everywhere removes every device, audited', () async {
        final session = sessionBuilder.build();
        final anne = await NestUser.db.findById(session, annaId);
        await addRefreshToken(session, anne!.authUserId);

        final detail = await endpoints.adminUsers.signOutEverywhere(
          admin,
          annaId,
        );
        expect(detail.activeSessions, 0);
        expect(
          await RefreshToken.db.count(
            session,
            where: (t) => t.authUserId.equals(anne.authUserId),
          ),
          0,
        );
        expect(await auditActions(), contains('user.signOutEverywhere'));
      });

      test('disabling also signs the user out everywhere', () async {
        final session = sessionBuilder.build();
        final anne = await NestUser.db.findById(session, annaId);
        await addRefreshToken(session, anne!.authUserId);
        await endpoints.adminUsers.setDisabled(admin, annaId, true);
        expect(
          (await endpoints.adminUsers.detail(admin, annaId)).activeSessions,
          0,
        );
      });

      test('an admin cannot sign themselves out everywhere', () {
        expect(
          endpoints.adminUsers.signOutEverywhere(admin, adminId),
          throwsNest(NestErrorCode.invalidInput),
        );
      });
    });

    group('server settings', () {
      tearDown(() {
        TmdbService.override = null;
        UpdateCheck.fetchOverride = null;
        UpdateCheck.enabledOverride = null;
        UpdateCheck.clearCache();
      });

      test('settings report versions and what is set, no secrets', () async {
        final settings = await endpoints.adminSystem.settings(admin);
        expect(settings.version, nestServerVersion);
        expect(settings.apiVersion, nestApiVersion);
        expect(settings.mailConfigured, isFalse);
        expect(settings.filmDataConfigured, isFalse);
        final json = settings.toJson().toString().toLowerCase();
        for (final secret in ['apikey', 'secret', 'pepper', 'password']) {
          expect(json, isNot(contains(secret)));
        }
      });

      test('a test email without mail settings says so, audited', () async {
        final result = await endpoints.adminSystem.sendTestMail(admin);
        expect(result.ok, isFalse);
        expect(result.detail, 'notConfigured');
        expect(await auditActions(), contains('system.testMail'));
      });

      test('the film data test uses the film data service', () async {
        final notSet = await endpoints.adminSystem.testFilmData(admin);
        expect(notSet.ok, isFalse);
        expect(notSet.detail, 'notConfigured');

        TmdbService.override = FakeTmdbService();
        expect((await endpoints.adminSystem.testFilmData(admin)).ok, isTrue);
      });

      test('the update status compares with the newest release', () async {
        UpdateCheck.fetchOverride = () async => ['v0.1.0', 'v99.0.0', 'x'];
        final newer = await endpoints.adminSystem.updateStatus(admin);
        expect(newer.latestVersion, '99.0.0');
        expect(newer.updateAvailable, isTrue);

        UpdateCheck.clearCache();
        UpdateCheck.fetchOverride = () async => ['v$nestServerVersion'];
        final same = await endpoints.adminSystem.updateStatus(admin);
        expect(same.updateAvailable, isFalse);

        UpdateCheck.clearCache();
        UpdateCheck.fetchOverride = () async => throw Exception('offline');
        final offline = await endpoints.adminSystem.updateStatus(admin);
        expect(offline.problem, 'unreachable');

        UpdateCheck.enabledOverride = false;
        final off = await endpoints.adminSystem.updateStatus(admin);
        expect(off.problem, 'off');
        expect(off.latestVersion, isNull);
      });
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
