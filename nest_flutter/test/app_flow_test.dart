import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_flutter/app/app_gate.dart';
import 'package:nest_flutter/core/household/household_switcher.dart';

import 'support/fakes.dart';

void main() {
  group('gate and redirects', () {
    testWidgets('signed out shows sign in', (tester) async {
      final container = await pumpNestApp(tester, signedIn: false);
      expect(container.read(appGateProvider), AppGate.signedOut);
      expect(find.text('New to Nest?'), findsOneWidget);
    });

    testWidgets('a new user is asked for a name, then a household', (
      tester,
    ) async {
      final container = await pumpNestApp(
        tester,
        user: testUser(name: ''),
        households: [],
      );
      expect(container.read(appGateProvider), AppGate.needsName);
      expect(find.text("What's your name?"), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Thomas');
      await tester.pump();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(container.read(appGateProvider), AppGate.needsHousehold);
      expect(find.text('Set up your household'), findsOneWidget);

      await tester.enterText(find.byType(TextField).first, 'Home');
      await tester.pump();
      await tester.tap(find.text('Create household'));
      await tester.pumpAndSettle();

      expect(container.read(appGateProvider), AppGate.ready);
      expect(find.text('Hi Thomas'), findsOneWidget);
    });

    testWidgets('the name step stores the language shown on screen', (
      tester,
    ) async {
      final container = await pumpNestApp(
        tester,
        user: testUser(name: ''),
        households: [],
        deviceLocale: const Locale('nl'),
      );
      expect(find.text('Hoe heet je?'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Thomas');
      await tester.pump();
      await tester.tap(find.text('Doorgaan'));
      await tester.pumpAndSettle();

      expect(container.read(appGateProvider), AppGate.needsHousehold);
      expect(find.text('Stel je huishouden in'), findsOneWidget);
    });
  });

  group('sign in screen', () {
    testWidgets('is shown in Dutch on a Dutch device', (tester) async {
      await pumpNestApp(
        tester,
        signedIn: false,
        deviceLocale: const Locale('nl'),
      );
      expect(find.text('Wachtwoord vergeten?'), findsOneWidget);
    });

    testWidgets('the language picker switches before signing in', (
      tester,
    ) async {
      await pumpNestApp(tester, signedIn: false);
      await tester.tap(find.text('Nederlands'));
      await tester.pumpAndSettle();
      expect(find.text('Nieuw bij Nest?'), findsOneWidget);
      await flushEmailDebounce(tester);
    });

    testWidgets('lays out in Dutch with large text', (tester) async {
      await pumpNestApp(
        tester,
        signedIn: false,
        deviceLocale: const Locale('nl'),
        textScale: 2,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('moves to registration and back', (tester) async {
      await pumpNestApp(tester, signedIn: false);
      await tester.tap(find.text('Create account'));
      await tester.pumpAndSettle();
      await flushEmailDebounce(tester);
      expect(find.text("We'll send a code to your email address."), findsOne);

      await tester.tap(find.text('Back to sign in'));
      await tester.pumpAndSettle();
      expect(find.text('Forgot password?'), findsOneWidget);
      await flushEmailDebounce(tester);
    });
  });

  group('home and settings', () {
    final two = [
      myHousehold(1, 'Home', MembershipRole.owner),
      myHousehold(2, 'Test family', MembershipRole.member),
    ];

    testWidgets('uses the stored language of the user', (tester) async {
      await pumpNestApp(tester, user: testUser(locale: 'nl'));
      expect(find.text('Hoi Thomas'), findsOneWidget);
    });

    testWidgets('the switcher changes the active household', (tester) async {
      await pumpNestApp(tester, households: two);
      // The household name in the switcher, not the "Home" tab.
      Finder switcherText(String name) => find.descendant(
        of: find.byType(HouseholdSwitcher),
        matching: find.text(name),
      );
      expect(switcherText('Home'), findsOneWidget);

      await tester.tap(switcherText('Home'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Test family').last);
      await tester.pumpAndSettle();

      expect(switcherText('Test family'), findsOneWidget);
      expect(switcherText('Home'), findsNothing);
    });

    testWidgets('owners can create an invite code, members cannot', (
      tester,
    ) async {
      await pumpNestApp(
        tester,
        households: two,
        members: [
          HouseholdMember(
            userId: 1,
            name: 'Thomas',
            role: MembershipRole.owner,
          ),
        ],
      );
      await tester.tap(find.byTooltip('Settings'));
      await tester.pumpAndSettle();

      expect(find.text('Thomas (you)'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Create invite code'),
        200,
        scrollable: mainScrollable,
      );
      expect(find.text('Create invite code'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('Test family'),
        200,
        scrollable: mainScrollable,
      );
      await tester.tap(find.text('Test family'));
      await tester.pumpAndSettle();
      expect(find.text('Create invite code'), findsNothing);
    });

    testWidgets('settings lay out in Dutch with large text', (tester) async {
      await pumpNestApp(
        tester,
        user: testUser(locale: 'nl'),
        households: two,
        textScale: 2,
      );
      await tester.tap(find.byTooltip('Instellingen'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });
}
