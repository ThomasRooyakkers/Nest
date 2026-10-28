import 'package:nest_server/src/generated/protocol.dart';
import 'package:nest_server/src/services/host_settings.dart';
import 'package:nest_server/src/services/sign_up_policy.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import 'test_helpers.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given sign-up modes', (sessionBuilder, endpoints) {
    late Session session;
    late int householdId;
    late String code;

    setUp(() async {
      HostSettings.signUpModeOverride = null;
      HostSettings.superAdminEmailOverride = 'admin@example.com';
      session = sessionBuilder.build();
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

    /// Creates an auth user as the auth module would, then runs the hook.
    Future<NestUser> createAccount(String email) async {
      final authUser = await AuthUser.db.insertRow(
        session,
        AuthUser(scopeNames: {}),
      );
      await SignUpPolicy.afterAccountCreated(
        session,
        email: email,
        authUserId: authUser.id!,
      );
      return (await NestUser.db.findFirstRow(
        session,
        where: (t) => t.authUserId.equals(authUser.id!),
      ))!;
    }

    Future<List<Membership>> membershipsOf(NestUser user) =>
        Membership.db.find(session, where: (t) => t.userId.equals(user.id!));

    test('health reports invite-only by default', () async {
      expect(
        (await endpoints.health.ping(sessionBuilder)).signUpMode,
        SignUpMode.inviteOnly,
      );
      HostSettings.signUpModeOverride = SignUpMode.open;
      expect(
        (await endpoints.health.ping(sessionBuilder)).signUpMode,
        SignUpMode.open,
      );
    });

    test('invite-only: registering without an invite is refused', () async {
      await expectLater(
        endpoints.emailIdp.startRegistration(
          sessionBuilder,
          email: 'new@example.com',
        ),
        throwsNest(NestErrorCode.inviteRequired),
      );
    });

    test('the super-admin email may always register', () async {
      await SignUpPolicy.checkMayRegister(session, ' Admin@Example.com ');
    });

    test('open: anyone may register', () async {
      HostSettings.signUpModeOverride = SignUpMode.open;
      await SignUpPolicy.checkMayRegister(session, 'new@example.com');
    });

    test('a wrong or expired invite code is refused', () async {
      await expectLater(
        endpoints.signUp.redeemInvite(sessionBuilder, 'a@example.com', 'XXXX'),
        throwsNest(NestErrorCode.invalidInviteCode),
      );
      await expectLater(
        endpoints.signUp.redeemInvite(sessionBuilder, 'not-an-email', code),
        throwsNest(NestErrorCode.invalidInput),
      );

      final household = await Household.db.findById(session, householdId);
      await Household.db.updateRow(
        session,
        household!.copyWith(
          inviteExpiresAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      );
      await expectLater(
        endpoints.signUp.redeemInvite(sessionBuilder, 'a@example.com', code),
        throwsNest(NestErrorCode.inviteExpired),
      );
      expect(await SignUpInvite.db.count(session), 0);
    });

    test('with a redeemed invite the account joins the household', () async {
      final name = await endpoints.signUp.redeemInvite(
        sessionBuilder,
        'New@Example.com',
        code.toLowerCase(),
      );
      expect(name, 'Home');
      await SignUpPolicy.checkMayRegister(session, 'new@example.com');

      final user = await createAccount('new@example.com');
      expect(user.isSuperAdmin, isFalse);
      final memberships = await membershipsOf(user);
      expect(memberships.single.householdId, householdId);
      expect(memberships.single.role, MembershipRole.member);
      // The invite is used up.
      expect(await SignUpInvite.db.count(session), 0);
    });

    test('an expired redeemed invite no longer lets one register', () async {
      await endpoints.signUp.redeemInvite(
        sessionBuilder,
        'a@example.com',
        code,
      );
      final invite = await SignUpInvite.db.findFirstRow(session);
      await SignUpInvite.db.updateRow(
        session,
        invite!.copyWith(
          expiresAt: DateTime.now().toUtc().subtract(const Duration(hours: 1)),
        ),
      );
      await expectLater(
        SignUpPolicy.checkMayRegister(session, 'a@example.com'),
        throwsNest(NestErrorCode.inviteRequired),
      );
    });

    test('a household suspended in the meantime is not joined', () async {
      await endpoints.signUp.redeemInvite(
        sessionBuilder,
        'a@example.com',
        code,
      );
      final household = await Household.db.findById(session, householdId);
      await Household.db.updateRow(
        session,
        household!.copyWith(status: HouseholdStatus.suspended),
      );
      final user = await createAccount('a@example.com');
      expect(await membershipsOf(user), isEmpty);
    });

    test('the super-admin email becomes super-admin', () async {
      final user = await createAccount('admin@example.com');
      expect(user.isSuperAdmin, isTrue);
      expect(await membershipsOf(user), isEmpty);
    });

    test(
      'at start, an existing account with the email is made super-admin',
      () async {
        final authUser = await AuthUser.db.insertRow(
          session,
          AuthUser(scopeNames: {}),
        );
        await EmailAccount.db.insertRow(
          session,
          EmailAccount(
            authUserId: authUser.id!,
            email: 'admin@example.com',
            passwordHash: 'not-a-real-hash',
          ),
        );
        final existing = await NestUser.db.insertRow(
          session,
          NestUser(authUserId: authUser.id!, name: 'Admin'),
        );

        await SignUpPolicy.syncSuperAdmin(session);

        final user = await NestUser.db.findById(session, existing.id!);
        expect(user!.isSuperAdmin, isTrue);
        expect(user.name, 'Admin');
      },
    );
  });
}
