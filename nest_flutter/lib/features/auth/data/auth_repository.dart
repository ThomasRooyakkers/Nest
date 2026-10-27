import 'package:flutter/foundation.dart';
import 'package:nest_client/nest_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../core/backend/nest_client.dart';

part 'auth_repository.g.dart';

/// Sign-in state and email sign-in flows.
class AuthRepository {
  AuthRepository(this._client);

  final Client _client;

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

  Future<void> signOut() => _client.auth.signOutDevice();
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) =>
    AuthRepository(ref.watch(nestClientProvider));

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
