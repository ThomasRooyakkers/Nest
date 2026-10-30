import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/google.dart';

import '../services/social_sign_in.dart';

/// Google sign-in, available when the host configured a Google client
/// (see `HostSettings.googleClientSecret`). Follows [SocialSignIn]'s rules.
class GoogleIdpEndpoint extends GoogleIdpBaseEndpoint {
  /// Signs in with a Google ID token. A new account needs [inviteCode] on
  /// an invite-only server.
  Future<AuthSuccess> signIn(
    Session session, {
    required String idToken,
    String? accessToken,
    String? inviteCode,
  }) => SocialSignIn.run(
    session,
    method: googleIdp.method,
    inviteCode: inviteCode,
    login: (transaction) => googleIdp.login(
      session,
      idToken: idToken,
      accessToken: accessToken,
      transaction: transaction,
    ),
    merge: googleIdp.mergeAuthUsers,
  );

  /// The auth module's sign-in, under the same rules (without an invite).
  @override
  Future<AuthSuccess> login(
    Session session, {
    required String idToken,
    required String? accessToken,
  }) => signIn(session, idToken: idToken, accessToken: accessToken);

  /// The web flow, under the same rules (without an invite).
  @override
  Future<AuthSuccess> loginWithCode(
    Session session, {
    required String code,
    required String codeVerifier,
    required String redirectUri,
  }) => SocialSignIn.run(
    session,
    method: googleIdp.method,
    inviteCode: null,
    login: (transaction) => googleIdp.loginWithCode(
      session,
      code: code,
      codeVerifier: codeVerifier,
      redirectUri: redirectUri,
      transaction: transaction,
    ),
    merge: googleIdp.mergeAuthUsers,
  );
}
