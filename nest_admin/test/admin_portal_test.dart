import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nest_admin/app/admin_app.dart';
import 'package:nest_admin/app/admin_router.dart';
import 'package:nest_admin/data/admin_repository.dart';
import 'package:nest_admin/presentation/pages/backups_page.dart';
import 'package:nest_client/nest_client.dart';

import 'fake_admin_repository.dart';

void main() {
  Future<ProviderContainer> pumpPortal(
    WidgetTester tester,
    FakeAdminRepository repository, {
    Locale locale = const Locale('en'),
    Size size = const Size(1280, 900),
    double textScale = 1,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.localesTestValue = [locale];
    tester.platformDispatcher.textScaleFactorTestValue = textScale;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearAllTestValues);

    final container = ProviderContainer(
      overrides: [adminRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const NestAdminApp(),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  Future<void> go(
    ProviderContainer container,
    WidgetTester tester,
    String path,
  ) async {
    container.read(adminRouterProvider).go(path);
    await tester.pumpAndSettle();
  }

  testWidgets('signed out, the portal asks to sign in and then opens', (
    tester,
  ) async {
    await pumpPortal(tester, FakeAdminRepository(signedIn: false));
    expect(find.text('Sign in with your super-admin account.'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'thomas@nest.test');
    await tester.enterText(find.byType(TextField).last, 'secret');
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Test family'), findsOneWidget);
  });

  testWidgets('a wrong password shows a translated error', (tester) async {
    final repository = FakeAdminRepository(signedIn: false)..failSignIn = true;
    await pumpPortal(tester, repository, locale: const Locale('nl'));
    await tester.tap(find.widgetWithText(FilledButton, 'Inloggen'));
    await tester.pumpAndSettle();
    expect(find.text('Verkeerd e-mailadres of wachtwoord.'), findsOneWidget);
  });

  testWidgets('a user who is not a super-admin is turned away', (tester) async {
    await pumpPortal(tester, FakeAdminRepository(isSuperAdmin: false));
    expect(
      find.text('This account is not a super-admin of this server.'),
      findsOneWidget,
    );
    expect(find.text('Test family'), findsNothing);
  });

  testWidgets('households: summary cards, table and suspend', (tester) async {
    final repository = FakeAdminRepository();
    await pumpPortal(tester, repository);

    expect(find.text('LAST BACKUP'), findsOneWidget);
    expect(find.text('Backups are up to date'), findsOneWidget);
    expect(find.text('200.0 GB free'), findsOneWidget);
    expect(find.text('Shopping, Tasks'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Suspend'));
    await tester.pumpAndSettle();
    expect(find.text('Suspend Home?'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Suspend').last);
    await tester.pumpAndSettle();

    expect(repository.householdList.first.status, HouseholdStatus.suspended);
    expect(find.widgetWithText(FilledButton, 'Reactivate'), findsNWidgets(2));
  });

  testWidgets('users: disable someone else, not yourself', (tester) async {
    final repository = FakeAdminRepository();
    final container = await pumpPortal(tester, repository);
    await go(container, tester, '/users');

    expect(find.text('Super-admin'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Disable'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Disable'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Disable').last);
    await tester.pumpAndSettle();

    expect(repository.userList.last.disabledAt, isNotNull);
    expect(find.text('Disabled'), findsOneWidget);
  });

  testWidgets('backups: runs, Back up now and the restore command', (
    tester,
  ) async {
    final repository = FakeAdminRepository();
    final container = await pumpPortal(tester, repository);
    await go(container, tester, '/backups');

    expect(find.text('restic init: token expired'), findsOneWidget);
    expect(find.text(restoreCommand(repository.runs.first)), findsOneWidget);

    await tester.tap(find.text('Back up now'));
    await tester.pumpAndSettle();
    expect(repository.requestedBackups, hasLength(1));
    expect(find.textContaining('It starts within a minute.'), findsOneWidget);
    final button = tester.widget<ButtonStyleButton>(
      find
          .ancestor(
            of: find.text('Back up now'),
            matching: find.bySubtype<ButtonStyleButton>(),
          )
          .first,
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('system health and audit log in Dutch', (tester) async {
    final repository = FakeAdminRepository()
      ..audit.add(
        AdminAuditEntry(
          id: 1,
          at: DateTime.utc(2026, 10, 30, 10),
          adminId: 1,
          adminName: 'Thomas',
          action: 'household.setStatus',
          targetType: 'household',
          targetId: '2',
          details: 'active -> suspended',
        ),
      );
    final container = await pumpPortal(
      tester,
      repository,
      locale: const Locale('nl'),
    );
    await go(container, tester, '/health');
    expect(find.text('Niet ingesteld: codes in het serverlog'), findsOneWidget);
    expect(find.text('API-niveau 7, draait 3 dagen'), findsOneWidget);
    expect(find.text('Back-up naar onedrive'), findsOneWidget);

    await go(container, tester, '/audit');
    expect(find.text('Huishouden geschorst'), findsOneWidget);
    expect(find.text('household #2'), findsOneWidget);
  });

  testWidgets(
    'narrow screens get a menu and stacked rows, also with large text in Dutch',
    (tester) async {
      final container = await pumpPortal(
        tester,
        FakeAdminRepository(),
        locale: const Locale('nl'),
        size: const Size(390, 844),
        textScale: 1.6,
      );
      expect(tester.takeException(), isNull);
      await tester.tap(find.byType(DrawerButton));
      await tester.pumpAndSettle();
      expect(find.text('Systeemstatus'), findsOneWidget);
      await tester.tap(find.text('Gebruikers'));
      await tester.pumpAndSettle();
      expect(
        container.read(adminRouterProvider).state.matchedLocation,
        '/users',
      );
      expect(find.text('E-MAIL'), findsNWidgets(2));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('a new household for a family opens with its invite code', (
    tester,
  ) async {
    final repository = FakeAdminRepository();
    final container = await pumpPortal(tester, repository);

    await tester.tap(find.text('New household'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Family B');
    await tester.tap(find.widgetWithText(FilledButton, 'Create'));
    await tester.pumpAndSettle();

    expect(
      container.read(adminRouterProvider).state.matchedLocation,
      '/households/3',
    );
    expect(find.text('Family B'), findsOneWidget);
    expect(find.text('NEWFAM23'), findsOneWidget);
    expect(
      find.text('No members yet. Share the invite code with the family.'),
      findsOneWidget,
    );
  });

  testWidgets('household detail: members, roles, invite, features, counts', (
    tester,
  ) async {
    final repository = FakeAdminRepository();
    final container = await pumpPortal(tester, repository);
    await tester.tap(find.text('Test family'));
    await tester.pumpAndSettle();
    expect(find.text('Test family'), findsOneWidget);
    await go(container, tester, '/households/1');

    expect(find.text('K7PM3QXA'), findsOneWidget);
    expect(find.text('41'), findsOneWidget);
    expect(
      find.text('Counts only: the portal never shows what a household stores.'),
      findsOneWidget,
    );
    // The only owner has no role button; the member can be made owner.
    expect(find.widgetWithText(FilledButton, 'Make member'), findsNothing);
    await tester.tap(find.widgetWithText(FilledButton, 'Make owner'));
    await tester.pumpAndSettle();
    expect(find.text('Make Sarah an owner?'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Make owner').last);
    await tester.pumpAndSettle();
    expect(repository.members[1]!.last.role, MembershipRole.owner);
    expect(find.widgetWithText(FilledButton, 'Make member'), findsNWidgets(2));

    await tester.tap(find.widgetWithText(FilledButton, 'Revoke'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Revoke').last);
    await tester.pumpAndSettle();
    expect(find.text('K7PM3QXA'), findsNothing);
    expect(
      find.text('No invite code. Make one to let someone join.'),
      findsOneWidget,
    );

    final recipes = find.byKey(const ValueKey('feature-recipes'));
    await tester.ensureVisible(recipes);
    await tester.pumpAndSettle();
    await tester.tap(recipes);
    await tester.pumpAndSettle();
    expect(repository.householdList.first.enabledFeatures, [
      HouseholdFeature.shopping,
      HouseholdFeature.recipes,
      HouseholdFeature.tasks,
    ]);
  });

  testWidgets('user detail: devices and sign out everywhere', (tester) async {
    final repository = FakeAdminRepository();
    final container = await pumpPortal(tester, repository);
    await go(container, tester, '/users');
    await tester.tap(find.text('Sarah'));
    await tester.pumpAndSettle();

    expect(
      container.read(adminRouterProvider).state.matchedLocation,
      '/users/2',
    );
    expect(find.text('Email, Google'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Sign out everywhere'));
    await tester.pumpAndSettle();
    expect(find.text('Sign Sarah out on every device?'), findsOneWidget);
    await tester.tap(
      find.widgetWithText(FilledButton, 'Sign out everywhere').last,
    );
    await tester.pumpAndSettle();
    expect(repository.signedOut, [2]);
    expect(find.text('Not signed in anywhere'), findsOneWidget);
  });

  testWidgets('your own user page has no actions', (tester) async {
    final container = await pumpPortal(tester, FakeAdminRepository());
    await go(container, tester, '/users/1');
    expect(find.text('Sign out everywhere'), findsNothing);
    expect(find.text('Disable'), findsNothing);
  });

  testWidgets('server page: settings, update and test email', (tester) async {
    final repository = FakeAdminRepository();
    final container = await pumpPortal(tester, repository);
    await go(container, tester, '/server');

    expect(find.text('nest-api.example.com'), findsOneWidget);
    expect(find.text('11 (apps from level 1)'), findsOneWidget);
    expect(find.text('Version 0.14.0 is available'), findsOneWidget);

    final sendTest = find.text('Send test email');
    await tester.ensureVisible(sendTest);
    await tester.pumpAndSettle();
    await tester.tap(sendTest);
    await tester.pumpAndSettle();
    expect(find.text('Not set up on this server.'), findsOneWidget);
  });

  testWidgets('detail pages fit a phone in Dutch with large text', (
    tester,
  ) async {
    final container = await pumpPortal(
      tester,
      FakeAdminRepository(),
      locale: const Locale('nl'),
      size: const Size(390, 844),
      textScale: 1.6,
    );
    for (final path in ['/households/1', '/users/2', '/server']) {
      await go(container, tester, path);
      expect(tester.takeException(), isNull, reason: path);
    }
    expect(find.text('Serverversie'), findsOneWidget);
  });

  testWidgets('an id that is not a number goes back to the list', (
    tester,
  ) async {
    final container = await pumpPortal(tester, FakeAdminRepository());
    await go(container, tester, '/households/abc');
    expect(
      container.read(adminRouterProvider).state.matchedLocation,
      '/households',
    );
  });

  testWidgets('logs: errors filter, and details with redacted text', (
    tester,
  ) async {
    final container = await pumpPortal(tester, FakeAdminRepository());
    await go(container, tester, '/logs');

    expect(find.text('14 days'), findsOneWidget);
    expect(find.text('shopping.addItem'), findsOneWidget);
    expect(find.text('1,820 ms'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Errors'));
    await tester.pumpAndSettle();
    expect(find.text('shopping.addItem'), findsNothing);

    await tester.tap(find.text('emailIdp.login'));
    await tester.pumpAndSettle();
    expect(find.text('Call details'), findsOneWidget);
    expect(
      find.textContaining('Registration code for s***@nest.test: <code>'),
      findsOneWidget,
    );
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();
    expect(find.text('Call details'), findsNothing);
  });

  testWidgets('security: masked failed attempt and the sign-in filter', (
    tester,
  ) async {
    final container = await pumpPortal(tester, FakeAdminRepository());
    await go(container, tester, '/security');

    expect(find.text('x***@example.com'), findsOneWidget);
    expect(find.text('Wrong email or password'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Sign-ins'));
    await tester.pumpAndSettle();
    expect(find.text('x***@example.com'), findsNothing);
    expect(find.text('Sarah'), findsOneWidget);

    await tester.tap(find.text('Sarah'));
    await tester.pumpAndSettle();
    expect(
      container.read(adminRouterProvider).state.matchedLocation,
      '/users/2',
    );
  });

  testWidgets('logs and security fit a phone in Dutch with large text', (
    tester,
  ) async {
    final container = await pumpPortal(
      tester,
      FakeAdminRepository(),
      locale: const Locale('nl'),
      size: const Size(390, 844),
      textScale: 1.6,
    );
    for (final path in ['/logs', '/security']) {
      await go(container, tester, path);
      expect(tester.takeException(), isNull, reason: path);
    }
    expect(find.textContaining('30 dagen bewaard'), findsOneWidget);
  });
}
