import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nest_client/nest_client.dart';

import 'support/fakes.dart';

void main() {
  FakeHealthRepository socialServer() => FakeHealthRepository(
    googleServerClientId: 'server-client',
    appleSignIn: true,
  );

  /// The tests run on the host; the buttons are for iOS only.
  final ios = TargetPlatformVariant.only(TargetPlatform.iOS);

  testWidgets('iOS shows Apple and Google when the server offers them', (
    tester,
  ) async {
    final social = FakeSocialSignInRepository();
    await pumpNestApp(
      tester,
      signedIn: false,
      health: socialServer(),
      socialSignIn: social,
    );

    expect(find.text('Continue with Apple'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);

    await tester.tap(find.text('Continue with Apple'));
    await tester.pumpAndSettle();
    expect(social.calls, [('apple', null)]);
  }, variant: ios);

  testWidgets('no buttons on servers without Google or Apple', (tester) async {
    await pumpNestApp(tester, signedIn: false);
    expect(find.text('Continue with Apple'), findsNothing);
    expect(find.text('Continue with Google'), findsNothing);
  }, variant: ios);

  testWidgets('no buttons outside iOS', (tester) async {
    await pumpNestApp(tester, signedIn: false, health: socialServer());
    expect(find.text('Continue with Apple'), findsNothing);
  });

  testWidgets('Create account passes the typed invite code', (tester) async {
    final social = FakeSocialSignInRepository();
    await pumpNestApp(
      tester,
      signedIn: false,
      health: socialServer(),
      socialSignIn: social,
    );
    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();
    await flushEmailDebounce(tester);

    await tester.enterText(find.byType(TextField).at(1), ' ABCD1234 ');
    await tester.scrollUntilVisible(
      find.text('Continue with Google'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Continue with Google'));
    await tester.pumpAndSettle();
    expect(social.calls, [('google:server-client', ' ABCD1234 ')]);
  }, variant: ios);

  testWidgets('lays out in Dutch with large text', (tester) async {
    await pumpNestApp(
      tester,
      signedIn: false,
      health: socialServer(),
      deviceLocale: const Locale('nl'),
      textScale: 2,
    );
    expect(find.text('Doorgaan met Apple'), findsOneWidget);
    expect(tester.takeException(), isNull);
  }, variant: ios);

  group('linking in Settings', () {
    Future<void> openSettings(WidgetTester tester) async {
      await tester.tap(find.byTooltip('Settings'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Sign-in methods'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
    }

    testWidgets('shows what is linked and links Apple', (tester) async {
      final social = FakeSocialSignInRepository();
      await pumpNestApp(tester, health: socialServer(), socialSignIn: social);
      await openSettings(tester);

      expect(find.text('Linked'), findsOneWidget, reason: 'Google is linked');
      await tester.tap(find.text('Link'));
      await tester.pumpAndSettle();
      expect(social.calls, [('link apple', null)]);
      expect(find.text('Apple is now linked to your account.'), findsOneWidget);
    }, variant: ios);

    testWidgets("another account's Apple ID is refused with a message", (
      tester,
    ) async {
      final social = FakeSocialSignInRepository()
        ..error = NestException(code: NestErrorCode.alreadyLinked);
      await pumpNestApp(tester, health: socialServer(), socialSignIn: social);
      await openSettings(tester);
      await tester.tap(find.text('Link'));
      await tester.pumpAndSettle();
      expect(
        find.text(
          'This Apple or Google account already belongs to another Nest account.',
        ),
        findsOneWidget,
      );
    }, variant: ios);

    testWidgets('hidden on servers before linking existed', (tester) async {
      await pumpNestApp(
        tester,
        health: FakeHealthRepository(
          apiVersion: 9,
          googleServerClientId: 'server-client',
          appleSignIn: true,
        ),
      );
      await tester.tap(find.byTooltip('Settings'));
      await tester.pumpAndSettle();
      expect(find.text('Sign-in methods'), findsNothing);
    }, variant: ios);
  });
}
