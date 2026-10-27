import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_flutter/app/nest_app.dart';
import 'package:nest_flutter/core/backend/nest_client.dart';
import 'package:nest_flutter/core/backend/server_health_repository.dart';
import 'package:nest_flutter/core/household/household_repository.dart';
import 'package:nest_flutter/features/auth/data/auth_repository.dart';
import 'package:nest_flutter/features/settings/data/profile_repository.dart';

class FakeProfileRepository implements ProfileRepository {
  FakeProfileRepository(this.user);

  NestUser user;

  @override
  Future<NestUser> me() async => user;

  @override
  Future<NestUser> update({
    required String name,
    required String locale,
  }) async => user = user.copyWith(name: name.trim(), locale: locale);
}

class FakeHouseholdRepository implements HouseholdRepository {
  FakeHouseholdRepository(this.households, {this.memberList = const []});

  List<MyHousehold> households;
  List<HouseholdMember> memberList;
  var _nextId = 100;

  @override
  Future<List<MyHousehold>> listMine() async => households;

  @override
  Future<MyHousehold> create(String name) async {
    final created = myHousehold(_nextId++, name.trim(), MembershipRole.owner);
    households = [...households, created];
    return created;
  }

  @override
  Future<MyHousehold> join(String code) async =>
      throw NestException(code: NestErrorCode.invalidInviteCode);

  @override
  Future<List<HouseholdMember>> members(int householdId) async => memberList;

  @override
  Future<HouseholdInvite> createInvite(int householdId) async =>
      throw UnimplementedError();

  @override
  Future<void> revokeInvite(int householdId) async {}

  @override
  Future<MyHousehold> rename(int householdId, String name) async =>
      throw UnimplementedError();

  @override
  Future<void> leave(int householdId) async {}
}

class FakeHealthRepository implements ServerHealthRepository {
  @override
  Future<ServerPing> ping() async =>
      ServerPing(serverTime: DateTime.utc(2026), version: '0.1.0');
}

NestUser testUser({String name = 'Thomas', String locale = 'en'}) => NestUser(
  id: 1,
  authUserId: UuidValue.fromString('0190f0a0-0000-7000-8000-000000000001'),
  name: name,
  locale: locale,
);

MyHousehold myHousehold(int id, String name, MembershipRole role) =>
    MyHousehold(
      household: Household(
        id: id,
        name: name,
        enabledFeatures: HouseholdFeature.values,
      ),
      role: role,
    );

/// Pumps the whole app on a phone-sized screen with fake repositories.
Future<ProviderContainer> pumpNestApp(
  WidgetTester tester, {
  bool signedIn = true,
  NestUser? user,
  List<MyHousehold>? households,
  List<HouseholdMember> members = const [],
  Locale? deviceLocale,
  double textScale = 1,
}) async {
  tester.view.physicalSize = const Size(375, 812);
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  if (deviceLocale != null) {
    tester.platformDispatcher.localesTestValue = [deviceLocale];
  }
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearAllTestValues);

  final container = ProviderContainer(
    retry: (_, _) => null,
    overrides: [
      // Never called: every repository is faked. The sign-in screen only
      // hands it to Serverpod's EmailAuthController.
      nestClientProvider.overrideWithValue(Client('http://localhost:1/')),
      signedInProvider.overrideWithBuild((ref, notifier) => signedIn),
      profileRepositoryProvider.overrideWithValue(
        FakeProfileRepository(user ?? testUser()),
      ),
      householdRepositoryProvider.overrideWithValue(
        FakeHouseholdRepository(
          households ?? [myHousehold(1, 'Home', MembershipRole.owner)],
          memberList: members,
        ),
      ),
      serverHealthRepositoryProvider.overrideWithValue(FakeHealthRepository()),
    ],
  );
  addTearDown(container.dispose);

  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const NestApp()),
  );
  await tester.pumpAndSettle();
  await flushEmailDebounce(tester);
  return container;
}

/// The sign-in controller validates the email 500 ms after each change;
/// let that timer fire so no timers are pending when a test ends.
Future<void> flushEmailDebounce(WidgetTester tester) =>
    tester.pump(const Duration(milliseconds: 600));

/// The settings and home screens have one main list view.
Finder get mainScrollable => find
    .descendant(of: find.byType(ListView), matching: find.byType(Scrollable))
    .first;
