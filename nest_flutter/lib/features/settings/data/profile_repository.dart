import 'package:nest_client/nest_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/backend/nest_client.dart';
import '../../auth/data/auth_repository.dart';

part 'profile_repository.g.dart';

/// The signed-in user's own profile.
class ProfileRepository {
  ProfileRepository(this._client);

  final Client _client;

  Future<NestUser> me() => _client.profile.me();

  Future<NestUser> update({required String name, required String locale}) =>
      _client.profile.updateMe(name, locale);
}

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) =>
    ProfileRepository(ref.watch(nestClientProvider));

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
