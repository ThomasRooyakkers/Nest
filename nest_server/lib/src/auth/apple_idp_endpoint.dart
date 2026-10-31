import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/apple.dart';

import '../services/nest_users.dart';
import '../services/social_sign_in.dart';

/// Sign in with Apple, available when the host configured an Apple key
/// (see `HostSettings.appleSignInEnabled`). Follows [SocialSignIn]'s rules.
class AppleIdpEndpoint extends AppleIdpBaseEndpoint {
  /// Signs in with Apple's identity token and authorization code. A new
  /// account needs [inviteCode] on an invite-only server.
  Future<AuthSuccess> signIn(
    Session session, {
    required String identityToken,
    required String authorizationCode,
    required bool isNativeApplePlatformSignIn,
    String? firstName,
    String? lastName,
    String? inviteCode,
  }) => SocialSignIn.run(
    session,
    method: appleIdp.method,
    inviteCode: inviteCode,
    login: (transaction) => appleIdp.login(
      session,
      identityToken: identityToken,
      authorizationCode: authorizationCode,
      isNativeApplePlatformSignIn: isNativeApplePlatformSignIn,
      firstName: firstName,
      lastName: lastName,
      transaction: transaction,
    ),
    merge: appleIdp.mergeAuthUsers,
  );

  /// Links an Apple ID to the signed-in account (see [SocialSignIn.link]).
  Future<void> link(
    Session session, {
    required String identityToken,
    required String authorizationCode,
    required bool isNativeApplePlatformSignIn,
  }) async {
    final user = await NestUsers.require(session);
    await SocialSignIn.link(
      session,
      authUserId: user.authUserId,
      authenticate: (transaction) async {
        final result = await appleIdp.utils.authenticate(
          session,
          identityToken: identityToken,
          authorizationCode: authorizationCode,
          isNativeApplePlatformSignIn: isNativeApplePlatformSignIn,
          transaction: transaction,
        );
        return (
          authUserId: result.authUserId,
          newAccount: result.newAccount,
        );
      },
      merge: appleIdp.mergeAuthUsers,
    );
  }

  /// The auth module's sign-in, under the same rules (without an invite).
  @override
  Future<AuthSuccess> login(
    Session session, {
    required String identityToken,
    required String authorizationCode,
    required bool isNativeApplePlatformSignIn,
    String? firstName,
    String? lastName,
  }) => signIn(
    session,
    identityToken: identityToken,
    authorizationCode: authorizationCode,
    isNativeApplePlatformSignIn: isNativeApplePlatformSignIn,
    firstName: firstName,
    lastName: lastName,
  );
}
