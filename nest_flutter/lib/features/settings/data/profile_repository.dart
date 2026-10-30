import 'package:nest_client/nest_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/backend/nest_client.dart';
import '../../auth/data/auth_repository.dart';

part 'profile_repository.g.dart';

/// The signed-in user's own profile.
class ProfileRepository {
  ProfileRepository(this._client, this._auth);

  final Client _client;
  final AuthRepository _auth;

  Future<NestUser> me() => _client.profile.me();

  Future<NestUser> update({required String name, required String locale}) =>
      _client.profile.updateMe(name, locale);

  /// Deletes the account on the server, then signs out on this device and
  /// clears the cache.
  Future<void> deleteAccount() async {
    await _client.profile.deleteMe();
    await _auth.signOut();
  }
}

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) => ProfileRepository(
  ref.watch(nestClientProvider),
  ref.watch(authRepositoryProvider),
);

/// The signed-in user, or `null` when signed out.
@Riverpod(keepAlive: true)
class CurrentUser extends _$CurrentUser {
  @override
  Future<NestUser?> build() async {
    if (!ref.watch(signedInProvider)) return null;
    return ref.watch(profileRepositoryProvider).me();
  }

  Future<void> save({required String name, required String locale}) async {
    final user = await ref
        .read(profileRepositoryProvider)
        .update(name: name, locale: locale);
    state = AsyncData(user);
  }
}
