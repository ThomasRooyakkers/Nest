import 'package:nest_server/src/generated/protocol.dart';
import 'package:nest_server/src/services/host_settings.dart';
import 'package:nest_server/src/services/social_sign_in.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_helpers.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given a new Google or Apple identity', (
    sessionBuilder,
    endpoints,
  ) {
    late Session session;
    late int householdId;
    late String code;
    late List<(UuidValue, UuidValue)> merges;

    setUp(() async {
      HostSettings.signUpModeOverride = null;
      HostSettings.superAdminEmailOverride = 'admin@example.com';
      session = sessionBuilder.build();
      merges = [];
      final owner = await signedInUser(sessionBuilder, name: 'Owner');
      householdId = (await endpoints.household.create(
        owner,
        'Home',
      )).household.id!;
      code = (await endpoints.household.createInvite(owner, householdId)).code;
    });

    tearDown(() {
      HostSettings.signUpModeOverride = null;
      HostSettings.superAdminEmailOverride = null;
    });

    /// An auth user with a profile, as the provider creates it.
    Future<UuidValue> identity(String? email, {String? fullName}) async {
      final user = await AuthUser.db.insertRow(
        session,
        AuthUser(scopeNames: {}),
      );
      await UserProfile.db.insertRow(
        session,
        UserProfile(authUserId: user.id!, email: email, fullName: fullName),
      );
      return user.id!;
    }

    Future<UuidValue> settle(
      UuidValue authUserId, {
      required String? email,
      bool verified = true,
      String? inviteCode,
    }) => session.db.transaction(
      (transaction) => SocialSignIn.settleNewIdentity(
        session,
        transaction: transaction,
        authUserId: authUserId,
        email: email,
        emailVerified: verified,
        inviteCode: inviteCode,
        merge:
            (
              session, {
              required userToKeepId,
              required userToRemoveId,
              required transaction,
            }) async => merges.add((userToKeepId, userToRemoveId)),
      ),
    );

    Future<List<String>> householdsOf(UuidValue authUserId) async {
      final user = await NestUser.db.findFirstRow(
        session,
        where: (t) => t.authUserId.equals(authUserId),
      );
      if (user == null) return [];
      final memberships = await Membership.db.find(
        session,
        where: (t) => t.userId.equals(user.id!),
        include: Membership.include(household: Household.include()),
      );
      return [for (final m in memberships) m.household!.name];
    }

    test('joins the existing email account with the same address', () async {
      final existing = await AuthUser.db.insertRow(
        session,
        AuthUser(scopeNames: {}),
      );
      await EmailAccount.db.insertRow(
        session,
        EmailAccount(
          authUserId: existing.id!,
          email: 'anna@example.com',
          passwordHash: 'x',
        ),
      );
      final fresh = await identity('anna@example.com');

      final kept = await settle(fresh, email: 'Anna@Example.com ');

      expect(kept, existing.id);
      expect(merges, [(existing.id!, fresh)]);
      expect(await AuthUser.db.findById(session, fresh), isNull);
    });

    test(
      'joins an account of another provider with the same address',
      () async {
        final google = await identity('bram@example.com');
        final apple = await identity('bram@example.com');

        expect(await settle(apple, email: 'bram@example.com'), google);
        expect(merges.single, (google, apple));
      },
    );

    test('an unverified email is never used to join an account', () async {
      await identity('cas@example.com');
      final fresh = await identity('cas@example.com');

      await expectLater(
        settle(fresh, email: 'cas@example.com', verified: false),
        throwsNest(NestErrorCode.inviteRequired),
      );
      expect(merges, isEmpty);
    });

    test('a new account needs an invite code on an invite-only server', () {
      return identity('dirk@example.com').then(
        (fresh) => expectLater(
          settle(fresh, email: 'dirk@example.com'),
          throwsNest(NestErrorCode.inviteRequired),
        ),
      );
    });

    test('a new account with an invite code joins that household', () async {
      final fresh = await identity('eva@example.com');

      expect(
        await settle(fresh, email: 'eva@example.com', inviteCode: code),
        fresh,
      );
      expect(await householdsOf(fresh), ['Home']);
    });

    test('a new account takes the name Google or Apple gave', () async {
      final fresh = await identity(
        'gijs@example.com',
        fullName: ' Gijs Peeters ',
      );
      await settle(fresh, email: 'gijs@example.com', inviteCode: code);
      final user = await NestUser.db.findFirstRow(
        session,
        where: (t) => t.authUserId.equals(fresh),
      );
      expect(user!.name, 'Gijs Peeters');
    });

    test('a wrong invite code is refused', () async {
      final fresh = await identity('fien@example.com');
      await expectLater(
        settle(fresh, email: 'fien@example.com', inviteCode: 'NOPE1234'),
        throwsNest(NestErrorCode.invalidInviteCode),
      );
    });

    test('the super-admin email needs no invite', () async {
      final fresh = await identity('admin@example.com');

      expect(await settle(fresh, email: 'admin@example.com'), fresh);
      final user = await NestUser.db.findFirstRow(
        session,
        where: (t) => t.authUserId.equals(fresh),
      );
      expect(user!.isSuperAdmin, isTrue);
    });

    test('an open server lets anyone in, even without an email', () async {
      HostSettings.signUpModeOverride = SignUpMode.open;
      final fresh = await identity(null);

      expect(await settle(fresh, email: null), fresh);
      expect(await householdsOf(fresh), isEmpty);
    });

    test('without an email an invite-only server refuses', () async {
      final fresh = await identity(null);
      await expectLater(
        settle(fresh, email: null, inviteCode: code),
        throwsNest(NestErrorCode.inviteRequired),
      );
    });
  });

  withServerpod('Given the health check', (sessionBuilder, endpoints) {
    test('reports no Google or Apple sign-in without keys', () async {
      final ping = await endpoints.health.ping(sessionBuilder);
      expect(ping.googleServerClientId, isNull);
      expect(ping.appleSignIn, isFalse);
    });
  });
}
