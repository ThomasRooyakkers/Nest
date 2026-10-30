import 'package:flutter/foundation.dart';
import 'package:nest_client/nest_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../core/backend/nest_client.dart';
import '../../../core/database/nest_database.dart';
import 'social_sign_in_repository.dart';

part 'auth_repository.g.dart';

/// Sign-in state and email sign-in flows.
class AuthRepository {
  AuthRepository(this._client, this._db);

  final Client _client;
  final NestDatabase _db;

  /// Emits whenever the user signs in or out.
  ValueListenable<AuthSuccess?> get authChanges =>
      _client.auth.authInfoListenable;

  bool get isSignedIn => _client.auth.isAuthenticated;

  /// Creates the controller that drives the email sign-in screens.
  EmailAuthController createEmailController({
    required String passwordRequirement,
  }) => EmailAuthController(
    client: _client,
    // Matches the server's default policy.
    passwordRequirements: [
      PasswordRequirement(
        description: passwordRequirement,
        validator: (p) => p.length >= 8 && p.trim() == p,
      ),
    ],
  );

  /// Checks an invite code before signing up, so [email] may create an
  /// account and joins the household. Returns the household's name.
  Future<String> redeemInvite(String email, String inviteCode) =>
      _client.signUp.redeemInvite(email.trim(), inviteCode);

  /// Signs out and removes the cached data, so the next user of the device
  /// sees nothing of this one.
  Future<void> signOut() async {
    await _client.auth.signOutDevice();
    await SocialSignInRepository.signOutGoogle();
    await _db.clearAll();
  }
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) => AuthRepository(
  ref.watch(nestClientProvider),
  ref.watch(nestDatabaseProvider),
);

/// Whether a user is signed in. Follows sign-in and sign-out.
@Riverpod(keepAlive: true)
class SignedIn extends _$SignedIn {
  @override
  bool build() {
    final changes = ref.watch(authRepositoryProvider).authChanges;
    void listener() => state = changes.value != null;
    changes.addListener(listener);
    ref.onDispose(() => changes.removeListener(listener));
    return changes.value != null;
  }
}
