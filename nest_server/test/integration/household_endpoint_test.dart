import 'package:nest_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_helpers.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given the household endpoint', (sessionBuilder, endpoints) {
    late TestSessionBuilder owner;
    late TestSessionBuilder other;
    late int householdId;

    setUp(() async {
      owner = await signedInUser(sessionBuilder, name: 'Anna');
      other = await signedInUser(sessionBuilder, name: 'Bram');
      householdId = (await endpoints.household.create(
        owner,
        '  Home  ',
      )).household.id!;
    });

    Future<String> invite() async =>
        (await endpoints.household.createInvite(owner, householdId)).code;

    test(
      'create trims the name, makes the caller owner, enables all features',
      () async {
        final mine = await endpoints.household.listMine(owner);
        expect(mine.single.household.name, 'Home');
        expect(mine.single.role, MembershipRole.owner);
        expect(mine.single.household.enabledFeatures, HouseholdFeature.values);
      },
    );

    test('create rejects an empty name', () {
      expect(
        endpoints.household.create(owner, '   '),
        throwsNest(NestErrorCode.invalidInput),
      );
    });

    test('an invite code lets another user join as member', () async {
      final code = await invite();
      expect(code, hasLength(8));

      // Typed in lower case with a dash still works.
      final joined = await endpoints.household.join(
        other,
        '${code.substring(0, 4).toLowerCase()}-${code.substring(4)}',
      );
      expect(joined.role, MembershipRole.member);
      expect(joined.household.inviteCode, isNull, reason: 'hidden for members');

      final members = await endpoints.household.members(owner, householdId);
      expect(members.map((m) => (m.name, m.role)), [
        ('Anna', MembershipRole.owner),
        ('Bram', MembershipRole.member),
      ]);
    });

    test('joining twice gives alreadyMember', () async {
      final code = await invite();
      await endpoints.household.join(other, code);
      expect(
        endpoints.household.join(other, code),
        throwsNest(NestErrorCode.alreadyMember),
      );
    });

    test('an unknown code gives invalidInviteCode', () {
      expect(
        endpoints.household.join(other, 'ABCDEFGH'),
        throwsNest(NestErrorCode.invalidInviteCode),
      );
    });

    test('a revoked code no longer works', () async {
      final code = await invite();
      await endpoints.household.revokeInvite(owner, householdId);
      expect(
        endpoints.household.join(other, code),
        throwsNest(NestErrorCode.invalidInviteCode),
      );
    });

    test('an expired code gives inviteExpired', () async {
      final code = await invite();
      final session = sessionBuilder.build();
      final household = (await Household.db.findById(session, householdId))!;
      await Household.db.updateRow(
        session,
        household.copyWith(
          inviteExpiresAt: DateTime.now().subtract(const Duration(minutes: 1)),
        ),
      );
      expect(
        endpoints.household.join(other, code),
        throwsNest(NestErrorCode.inviteExpired),
      );
    });

    test('members cannot do owner actions', () async {
      await endpoints.household.join(other, await invite());
      for (final call in [
        () => endpoints.household.rename(other, householdId, 'Mine now'),
        () => endpoints.household.setFeatures(other, householdId, []),
        () => endpoints.household.createInvite(other, householdId),
        () => endpoints.household.revokeInvite(other, householdId),
      ]) {
        await expectLater(call(), throwsNest(NestErrorCode.notAnOwner));
      }
    });

    test(
      'setFeatures keeps the canonical order and drops duplicates',
      () async {
        final updated = await endpoints.household.setFeatures(
          owner,
          householdId,
          [
            HouseholdFeature.tasks,
            HouseholdFeature.shopping,
            HouseholdFeature.tasks,
          ],
        );
        expect(updated.household.enabledFeatures, [
          HouseholdFeature.shopping,
          HouseholdFeature.tasks,
        ]);
      },
    );

    test('a member can leave; the last owner cannot', () async {
      await endpoints.household.join(other, await invite());
      await endpoints.household.leave(other, householdId);
      expect(await endpoints.household.listMine(other), isEmpty);

      expect(
        endpoints.household.leave(owner, householdId),
        throwsNest(NestErrorCode.lastOwner),
      );
    });

    test('a suspended household is hidden and blocked', () async {
      final admin = await signedInUser(sessionBuilder, superAdmin: true);
      await endpoints.adminHouseholds.setStatus(
        admin,
        householdId,
        HouseholdStatus.suspended,
      );

      expect(await endpoints.household.listMine(owner), isEmpty);
      expect(
        endpoints.household.get(owner, householdId),
        throwsNest(NestErrorCode.householdSuspended),
      );
    });

    test('a disabled user is blocked everywhere', () async {
      final session = sessionBuilder.build();
      final user = await endpoints.profile.me(owner);
      await NestUser.db.updateRow(
        session,
        user.copyWith(disabledAt: DateTime.now()),
      );

      await expectLater(
        endpoints.profile.me(owner),
        throwsNest(NestErrorCode.userDisabled),
      );
      await expectLater(
        endpoints.household.get(owner, householdId),
        throwsNest(NestErrorCode.userDisabled),
      );
    });
  });

  withServerpod('Given the profile endpoint', (sessionBuilder, endpoints) {
    test('updateMe stores name and locale', () async {
      final user = await signedInUser(sessionBuilder);
      final updated = await endpoints.profile.updateMe(user, ' Thomas ', 'nl');
      expect((updated.name, updated.locale), ('Thomas', 'nl'));
    });

    test('updateMe rejects unsupported locales and empty names', () async {
      final user = await signedInUser(sessionBuilder);
      await expectLater(
        endpoints.profile.updateMe(user, 'Thomas', 'fr'),
        throwsNest(NestErrorCode.invalidInput),
      );
      await expectLater(
        endpoints.profile.updateMe(user, ' ', 'en'),
        throwsNest(NestErrorCode.invalidInput),
      );
    });
  });

  withServerpod('Given the admin households endpoint', (
    sessionBuilder,
    endpoints,
  ) {
    test('setStatus writes an audit log row', () async {
      final user = await signedInUser(sessionBuilder, name: 'Anna');
      final admin = await signedInUser(sessionBuilder, superAdmin: true);
      final id = (await endpoints.household.create(user, 'Home')).household.id!;

      final summary = await endpoints.adminHouseholds.setStatus(
        admin,
        id,
        HouseholdStatus.suspended,
      );
      expect(summary.status, HouseholdStatus.suspended);
      expect(summary.ownerNames, ['Anna']);

      final log = await AdminAuditLog.db.find(sessionBuilder.build());
      expect(log.single.action, 'household.setStatus');
      expect(log.single.targetId, '$id');
    });
  });
}
