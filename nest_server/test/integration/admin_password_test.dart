import 'package:nest_server/src/generated/protocol.dart';
import 'package:nest_server/src/services/admin_password.dart';
import 'package:nest_server/src/services/host_settings.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import 'test_helpers.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given the set-admin-password command', (
    sessionBuilder,
    endpoints,
  ) {
    const email = 'admin@example.com';
    late Session session;

    // The test server does not initialise the auth module; this is the
    // production setup minus Google and Apple.
    setUpAll(
      () => AuthServices.set(
        tokenManagerBuilders: [JwtConfigFromPasswords()],
        identityProviderBuilders: [EmailIdpConfigFromPasswords()],
      ),
    );

    setUp(() {
      HostSettings.superAdminEmailOverride = email;
      session = sessionBuilder.build();
    });

    tearDown(() => HostSettings.superAdminEmailOverride = null);

    // The password check behind `emailIdp.login`, without issuing tokens.
    Future<UuidValue> signInWith(String password) =>
        AuthServices.getIdentityProvider<EmailIdp>().utils.authentication
            .authenticate(
              session,
              email: email,
              password: password,
              transaction: null,
            );

    Future<NestUser> superAdmin() async => (await NestUser.db.findFirstRow(
      session,
      where: (t) => t.isSuperAdmin.equals(true),
    ))!;

    test(
      'when the super-admin signs in with Google only, then email sign-in '
      'is added to that account',
      () async {
        await signedInUser(sessionBuilder, name: 'Admin', superAdmin: true);
        final admin = await superAdmin();

        final result = await AdminPassword.set(
          session,
          password: 'new-password',
        );

        expect(result, AdminPasswordResult.added);
        expect(await signInWith('new-password'), admin.authUserId);
        final audit = await AdminAuditLog.db.find(session);
        expect(audit.single.action, 'admin.setPassword');
        expect(audit.single.adminId, admin.id);
      },
    );

    test(
      'when the super-admin has a password, then it is changed',
      () async {
        await signedInUser(sessionBuilder, name: 'Admin', superAdmin: true);
        final admin = await superAdmin();
        await AuthServices.getIdentityProvider<EmailIdp>().admin
            .createEmailAuthentication(
              session,
              authUserId: admin.authUserId,
              email: email,
              password: 'old-password',
            );

        final result = await AdminPassword.set(
          session,
          password: 'new-password',
        );

        expect(result, AdminPasswordResult.changed);
        expect(await signInWith('new-password'), admin.authUserId);
        await expectLater(signInWith('old-password'), throwsA(anything));
      },
    );

    test('when there is no super-admin, then it refuses', () async {
      await signedInUser(sessionBuilder, name: 'Member');

      await expectLater(
        AdminPassword.set(session, password: 'new-password'),
        throwsA(isA<AdminPasswordException>()),
      );
      expect(
        await AuthServices.getIdentityProvider<EmailIdp>().admin.findAccount(
          session,
          email: email,
        ),
        isNull,
      );
    });

    test('when there are two super-admins, then it refuses', () async {
      await signedInUser(sessionBuilder, name: 'Admin 1', superAdmin: true);
      await signedInUser(sessionBuilder, name: 'Admin 2', superAdmin: true);

      await expectLater(
        AdminPassword.set(session, password: 'new-password'),
        throwsA(isA<AdminPasswordException>()),
      );
    });

    test('when the password is too short, then it refuses', () async {
      await signedInUser(sessionBuilder, name: 'Admin', superAdmin: true);

      await expectLater(
        AdminPassword.set(session, password: 'short'),
        throwsA(isA<AdminPasswordException>()),
      );
    });

    test('when no super-admin email is set, then it refuses', () async {
      HostSettings.superAdminEmailOverride = '';
      await signedInUser(sessionBuilder, name: 'Admin', superAdmin: true);

      await expectLater(
        AdminPassword.set(session, password: 'new-password'),
        throwsA(isA<AdminPasswordException>()),
      );
    });
  });
}
