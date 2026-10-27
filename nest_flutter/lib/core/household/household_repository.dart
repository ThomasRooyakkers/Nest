import 'package:nest_client/nest_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/data/auth_repository.dart';
import '../backend/nest_client.dart';

part 'household_repository.g.dart';

/// Households, members and invites.
class HouseholdRepository {
  HouseholdRepository(this._client);

  final Client _client;

  Future<List<MyHousehold>> listMine() => _client.household.listMine();

  Future<MyHousehold> create(String name) => _client.household.create(name);

  Future<MyHousehold> join(String code) => _client.household.join(code);

  Future<List<HouseholdMember>> members(int householdId) =>
      _client.household.members(householdId);

  Future<HouseholdInvite> createInvite(int householdId) =>
      _client.household.createInvite(householdId);

  Future<void> revokeInvite(int householdId) =>
      _client.household.revokeInvite(householdId);

  Future<MyHousehold> rename(int householdId, String name) =>
      _client.household.rename(householdId, name);

  Future<void> leave(int householdId) => _client.household.leave(householdId);
}

@Riverpod(keepAlive: true)
HouseholdRepository householdRepository(Ref ref) =>
    HouseholdRepository(ref.watch(nestClientProvider));

/// Households of the signed-in user; empty when signed out.
@Riverpod(keepAlive: true)
Future<List<MyHousehold>> myHouseholds(Ref ref) async {
  if (!ref.watch(signedInProvider)) return const [];
  return ref.watch(householdRepositoryProvider).listMine();
}

/// Household id picked in the switcher; reset on sign-in and sign-out.
///
/// Not persisted yet, so the app starts with the first household.
@Riverpod(keepAlive: true)
class SelectedHouseholdId extends _$SelectedHouseholdId {
  @override
  int? build() {
    ref.watch(signedInProvider);
    return null;
  }

  void select(int householdId) => state = householdId;
}

/// The household the app currently shows, or `null` if the user has none.
@riverpod
MyHousehold? activeHousehold(Ref ref) {
  final households = ref.watch(myHouseholdsProvider).value ?? const [];
  if (households.isEmpty) return null;
  final selected = ref.watch(selectedHouseholdIdProvider);
  return households.firstWhere(
    (h) => h.household.id == selected,
    orElse: () => households.first,
  );
}

/// Members of a household.
@riverpod
Future<List<HouseholdMember>> householdMembers(Ref ref, int householdId) =>
    ref.watch(householdRepositoryProvider).members(householdId);
