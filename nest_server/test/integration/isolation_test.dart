import 'package:nest_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'endpoint_registry.dart';
import 'test_helpers.dart';
import 'test_tools/serverpod_test_tools.dart';

/// Tenant isolation (CLAUDE.md rule 3). Every method in
/// [householdScopedMethods] must have an entry in `householdScopedCalls`.
typedef HouseholdCall =
    Future<Object?> Function(TestSessionBuilder session, int householdId);

void main() {
  withServerpod('Given two households', (sessionBuilder, endpoints) {
    final householdScopedCalls = <String, HouseholdCall>{
      'household.get': (s, id) => endpoints.household.get(s, id),
      'household.members': (s, id) => endpoints.household.members(s, id),
      'household.rename': (s, id) =>
          endpoints.household.rename(s, id, 'Taken over'),
      'household.setFeatures': (s, id) =>
          endpoints.household.setFeatures(s, id, []),
      'household.createInvite': (s, id) =>
          endpoints.household.createInvite(s, id),
      'household.revokeInvite': (s, id) =>
          endpoints.household.revokeInvite(s, id),
      'household.leave': (s, id) => endpoints.household.leave(s, id),
    };

    late TestSessionBuilder userA;
    late TestSessionBuilder userB;
    late int householdA;
    late int householdB;

    setUp(() async {
      userA = await signedInUser(sessionBuilder, name: 'Anna');
      userB = await signedInUser(sessionBuilder, name: 'Bram');
      householdA = (await endpoints.household.create(
        userA,
        'Home',
      )).household.id!;
      householdB = (await endpoints.household.create(
        userB,
        'Test family',
      )).household.id!;
    });

    for (final MapEntry(key: name, value: call)
        in householdScopedCalls.entries) {
      test('$name: a user of household A gets an error for household B', () {
        expect(call(userA, householdB), throwsNest(NestErrorCode.notAMember));
      });

      test('$name: a signed-out caller gets an error', () {
        expect(
          call(sessionBuilder, householdA),
          throwsNest(NestErrorCode.notSignedIn),
        );
      });

      test('$name: an unknown household id gives the same error', () {
        expect(call(userA, 999999), throwsNest(NestErrorCode.notAMember));
      });
    }

    test(
      'household B is unchanged after household A tried to modify it',
      () async {
        for (final call in householdScopedCalls.values) {
          await expectLater(call(userA, householdB), throwsA(anything));
        }
        final b = await endpoints.household.get(userB, householdB);
        expect(b.household.name, 'Test family');
        expect(b.household.enabledFeatures, HouseholdFeature.values);
        final members = await endpoints.household.members(userB, householdB);
        expect(members.map((m) => m.name), ['Bram']);
      },
    );

    test('every household-scoped method is exercised', () {
      expect(householdScopedCalls.keys.toSet(), householdScopedMethods);
    });

    test('listMine only returns the households of the caller', () async {
      final mine = await endpoints.household.listMine(userA);
      expect(mine.map((h) => h.household.id), [householdA]);
    });
  });
}
