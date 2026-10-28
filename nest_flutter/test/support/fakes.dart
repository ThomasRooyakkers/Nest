import 'package:drift/drift.dart' show DatabaseConnection;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_flutter/app/nest_app.dart';
import 'package:nest_flutter/core/backend/nest_client.dart';
import 'package:nest_flutter/core/backend/server_health_repository.dart';
import 'package:nest_flutter/core/database/nest_database.dart';
import 'package:nest_flutter/core/household/household_repository.dart';
import 'package:nest_flutter/core/server/server_address.dart';
import 'package:nest_flutter/core/server/server_check.dart';
import 'package:nest_flutter/core/server/server_compatibility.dart';
import 'package:nest_flutter/core/server/server_session.dart';
import 'package:nest_flutter/features/auth/data/auth_repository.dart';
import 'package:nest_flutter/features/settings/data/profile_repository.dart';
import 'package:nest_flutter/features/tasks/presentation/task_providers.dart';

import 'fake_recipe_server.dart';
import 'fake_shopping_server.dart';
import 'fake_task_server.dart';

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
  FakeHealthRepository({
    this.apiVersion = appApiVersion,
    this.minClientApiVersion = 1,
    this.signUpMode = SignUpMode.inviteOnly,
  });

  final int? apiVersion;
  final int? minClientApiVersion;
  final SignUpMode? signUpMode;

  @override
  Future<ServerPing> ping() async => ServerPing(
    serverTime: DateTime.utc(2026),
    version: '0.2.0',
    apiVersion: apiVersion,
    minClientApiVersion: minClientApiVersion,
    signUpMode: signUpMode,
  );
}

/// Records server switches instead of restarting the app.
class FakeServerSwitcher implements ServerSwitcher {
  final switches = <ServerAddress>[];

  @override
  Future<void> switchTo(ServerAddress server, {Locale? locale}) async =>
      switches.add(server);
}

/// The server the tests are "connected" to.
const testServer = ServerAddress(
  label: 'nest.test',
  apiUrl: 'https://nest-api.test/',
);

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

/// An in-memory database for tests.
NestDatabase testDatabase() => NestDatabase(
  DatabaseConnection(
    NativeDatabase.memory(),
    closeStreamsSynchronously: true,
  ),
);

/// Pumps the whole app on a phone-sized screen with fake repositories and
/// an in-memory shopping server and database.
Future<ProviderContainer> pumpNestApp(
  WidgetTester tester, {
  bool signedIn = true,
  NestUser? user,
  List<MyHousehold>? households,
  List<HouseholdMember> members = const [],
  Locale? deviceLocale,
  double textScale = 1,
  FakeShoppingServer? shoppingServer,
  FakeTaskServer? taskServer,
  FakeRecipeServer? recipeServer,
  NestDatabase? database,
  FakeHealthRepository? health,
  FakeServerSwitcher? serverSwitcher,
  ServerChecker? serverChecker,
  FakeNestClient? client,
  DateTime Function()? clock,
}) async {
  tester.view.physicalSize = const Size(375, 812);
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  if (deviceLocale != null) {
    tester.platformDispatcher.localesTestValue = [deviceLocale];
  }
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearAllTestValues);

  final db = database ?? testDatabase();
  addTearDown(db.close);

  final container = ProviderContainer(
    retry: (_, _) => null,
    overrides: [
      // Serves the shopping endpoint from memory; the other repositories are
      // faked. The sign-in screen only hands it to EmailAuthController.
      nestClientProvider.overrideWithValue(
        client ??
            FakeNestClient(
              server: shoppingServer,
              taskServer: taskServer,
              recipeServer: recipeServer,
            ),
      ),
      nestDatabaseProvider.overrideWithValue(db),
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
      serverHealthRepositoryProvider.overrideWithValue(
        health ?? FakeHealthRepository(),
      ),
      currentServerProvider.overrideWithValue(testServer),
      serverSwitcherProvider.overrideWithValue(
        serverSwitcher ?? FakeServerSwitcher(),
      ),
      if (serverChecker != null)
        serverCheckerProvider.overrideWithValue(serverChecker),
      if (clock != null) clockProvider.overrideWithValue(clock),
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
