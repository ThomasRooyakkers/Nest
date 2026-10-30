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
}
