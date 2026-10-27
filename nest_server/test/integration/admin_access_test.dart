import 'package:nest_server/src/generated/protocol.dart';
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
    });

    final adminCalls = <String, AdminCall>{
      'adminHouseholds.list': (s) => endpoints.adminHouseholds.list(s),
      'adminHouseholds.setStatus': (s) => endpoints.adminHouseholds.setStatus(
        s,
        householdId,
        HouseholdStatus.suspended,
      ),
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
