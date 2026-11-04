import 'package:nest_server/src/generated/protocol.dart';
import 'package:nest_server/src/services/update_check.dart';
import 'package:test/test.dart';

import 'endpoint_registry.dart';
import 'test_helpers.dart';
import 'test_tools/serverpod_test_tools.dart';

/// Admin endpoints are for the super-admin only (CLAUDE.md rule 3). Every
/// method in [adminMethods] must have an entry in `adminCalls`.
typedef AdminCall = Future<Object?> Function(TestSessionBuilder session);

void main() {
  withServerpod('Given the admin endpoints', (sessionBuilder, endpoints) {
    late TestSessionBuilder user;
    late TestSessionBuilder admin;
    late int householdId;
    late int userId;

    setUpAll(() {
      useTestAuthServices();
      UpdateCheck.fetchOverride = () async => ['v0.13.1'];
    });
    tearDownAll(() => UpdateCheck.fetchOverride = null);

    setUp(() async {
      user = await signedInUser(sessionBuilder, name: 'Anna');
      admin = await signedInUser(
        sessionBuilder,
        name: 'Thomas',
        superAdmin: true,
      );
      householdId = (await endpoints.household.create(
        user,
        'Home',
      )).household.id!;
      userId = (await endpoints.profile.me(user)).id!;
    });

    final adminCalls = <String, AdminCall>{
      'adminHouseholds.list': (s) => endpoints.adminHouseholds.list(s),
      'adminHouseholds.setStatus': (s) => endpoints.adminHouseholds.setStatus(
        s,
        householdId,
        HouseholdStatus.suspended,
      ),
      'adminHouseholds.detail': (s) =>
          endpoints.adminHouseholds.detail(s, householdId),
      'adminHouseholds.create': (s) =>
          endpoints.adminHouseholds.create(s, 'New family'),
      'adminHouseholds.rename': (s) =>
          endpoints.adminHouseholds.rename(s, householdId, 'Home 2'),
      'adminHouseholds.setFeatures': (s) => endpoints.adminHouseholds
          .setFeatures(s, householdId, [HouseholdFeature.shopping]),
      'adminHouseholds.createInvite': (s) =>
          endpoints.adminHouseholds.createInvite(s, householdId),
      'adminHouseholds.revokeInvite': (s) =>
          endpoints.adminHouseholds.revokeInvite(s, householdId),
      'adminHouseholds.setMemberRole': (s) => endpoints.adminHouseholds
          .setMemberRole(s, householdId, userId, MembershipRole.owner),
      'adminUsers.list': (s) => endpoints.adminUsers.list(s),
      'adminUsers.detail': (s) => endpoints.adminUsers.detail(s, userId),
      'adminUsers.signOutEverywhere': (s) =>
          endpoints.adminUsers.signOutEverywhere(s, userId),
      'adminUsers.setDisabled': (s) async => endpoints.adminUsers.setDisabled(
        s,
        (await endpoints.profile.me(user)).id!,
        false,
      ),
      'adminSystem.health': (s) => endpoints.adminSystem.health(s),
      'adminSystem.settings': (s) => endpoints.adminSystem.settings(s),
      'adminSystem.sendTestMail': (s) => endpoints.adminSystem.sendTestMail(s),
      'adminSystem.testFilmData': (s) => endpoints.adminSystem.testFilmData(s),
      'adminSystem.updateStatus': (s) => endpoints.adminSystem.updateStatus(s),
      'adminBackups.overview': (s) => endpoints.adminBackups.overview(s),
      'adminBackups.requestBackup': (s) =>
          endpoints.adminBackups.requestBackup(s),
      'adminAudit.entries': (s) => endpoints.adminAudit.entries(s),
    };

    for (final MapEntry(key: name, value: call) in adminCalls.entries) {
      test('$name: a normal user gets an error', () {
        expect(call(user), throwsNest(NestErrorCode.notAdmin));
      });

      test('$name: a signed-out caller gets an error', () {
        expect(call(sessionBuilder), throwsNest(NestErrorCode.notSignedIn));
      });

      test('$name: the super-admin is allowed', () async {
        await expectLater(call(admin), completes);
      });
    }

    test('every admin method is exercised', () {
      expect(adminCalls.keys.toSet(), adminMethods);
    });
  });
}
