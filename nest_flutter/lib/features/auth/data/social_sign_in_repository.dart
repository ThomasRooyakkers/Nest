import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nest_client/nest_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../core/backend/nest_client.dart';
import '../../../core/backend/server_health_repository.dart';

part 'social_sign_in_repository.g.dart';

/// The iOS OAuth client of the Nest app in Google Cloud. Not a secret: it
/// identifies this app to Google. Empty until it is set up, which hides
/// Google sign-in.
const googleIosClientId = '';

/// [googleIosClientId], replaceable in tests.
@Riverpod(keepAlive: true)
String googleIosClient(Ref ref) => googleIosClientId;

/// Which of Google and Apple sign-in to offer.
typedef SocialSignInOptions = ({String? googleServerClientId, bool apple});

/// Google and Apple sign-in, in the iOS app only and only when the server
/// supports them (API level 9, configured by the host).
@riverpod
SocialSignInOptions socialSignInOptions(Ref ref) {
  if (kIsWeb || defaultTargetPlatform != TargetPlatform.iOS) {
    return (googleServerClientId: null, apple: false);
  }
  final ping = ref.watch(serverPingProvider).value;
  return (
    googleServerClientId: ref.watch(googleIosClientProvider).isEmpty
        ? null
        : ping?.googleServerClientId,
    apple: ping?.appleSignIn ?? false,
  );
}

/// Signs in through Google or Apple, then with the Nest server. A new
/// account needs the household invite code on an invite-only server.
class SocialSignInRepository {
  SocialSignInRepository(this._client);

  final Client _client;
  static bool _googleReady = false;

  /// Returns false when the user cancelled.
  Future<bool> signInWithGoogle({
    required String serverClientId,
    String? inviteCode,
  }) async {
    final google = GoogleSignIn.instance;
    if (!_googleReady) {
      await google.initialize(
        clientId: googleIosClientId,
        serverClientId: serverClientId,
      );
      _googleReady = true;
    }
    final GoogleSignInAccount account;
    try {
      account = await google.authenticate();
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return false;
      rethrow;
    }
    final idToken = account.authentication.idToken;
    if (idToken == null) throw StateError('Google returned no ID token');

    final success = await _client.googleIdp.signIn(
      idToken: idToken,
      inviteCode: _code(inviteCode),
    );
    await _client.auth.updateSignedInUser(success);
    return true;
  }

  /// Returns false when the user cancelled.
  Future<bool> signInWithApple({String? inviteCode}) async {
    final AuthorizationCredentialAppleID credential;
    try {
      credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) return false;
      rethrow;
    }
    final identityToken = credential.identityToken;
    if (identityToken == null) throw StateError('Apple returned no token');

    final success = await _client.appleIdp.signIn(
      identityToken: identityToken,
      authorizationCode: credential.authorizationCode,
      isNativeApplePlatformSignIn: true,
      firstName: credential.givenName,
      lastName: credential.familyName,
      inviteCode: _code(inviteCode),
    );
    await _client.auth.updateSignedInUser(success);
    return true;
  }

  /// Forgets the Google account on this device, so the next Google sign-in
  /// lets the user pick an account again.
  static Future<void> signOutGoogle() async {
    if (_googleReady) await GoogleSignIn.instance.signOut();
  }

  static String? _code(String? code) {
    final trimmed = code?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
  }
}

@Riverpod(keepAlive: true)
SocialSignInRepository socialSignInRepository(Ref ref) =>
    SocialSignInRepository(ref.watch(nestClientProvider));
