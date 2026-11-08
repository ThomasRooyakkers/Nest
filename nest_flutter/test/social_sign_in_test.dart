import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_flutter/core/backend/server_health_repository.dart';
import 'package:nest_flutter/features/auth/data/social_sign_in_repository.dart';

import 'support/fakes.dart';

void main() {
  FakeHealthRepository socialServer() => FakeHealthRepository(
    googleServerClientId: 'server-client',
    appleSignIn: true,
  );

  /// The tests run on the host; the buttons are for iOS and Android only.
  final ios = TargetPlatformVariant.only(TargetPlatform.iOS);
  final android = TargetPlatformVariant.only(TargetPlatform.android);

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

  testWidgets('iOS offers another Google account (NEST-23)', (tester) async {
    final social = FakeSocialSignInRepository();
    await pumpNestApp(
      tester,
      signedIn: false,
      health: socialServer(),
      socialSignIn: social,
    );

    await tester.scrollUntilVisible(
      find.text('Use another Google account'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Use another Google account'));
    await tester.pumpAndSettle();
    expect(social.calls, [('another google:server-client', null)]);
  }, variant: ios);

  testWidgets('no buttons on servers without Google or Apple', (tester) async {
    await pumpNestApp(tester, signedIn: false);
    expect(find.text('Continue with Apple'), findsNothing);
    expect(find.text('Continue with Google'), findsNothing);
  }, variant: ios);

  testWidgets('Android shows Google only', (tester) async {
    final social = FakeSocialSignInRepository();
    await pumpNestApp(
      tester,
      signedIn: false,
      health: socialServer(),
      socialSignIn: social,
    );

    expect(find.text('Continue with Apple'), findsNothing);
    expect(find.text('Use another Google account'), findsNothing);
    await tester.tap(find.text('Continue with Google'));
    await tester.pumpAndSettle();
    expect(social.calls, [('google:server-client', null)]);
  }, variant: android);

  test('Android needs no iOS client ID', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    final container = ProviderContainer(
      overrides: [
        serverHealthRepositoryProvider.overrideWithValue(socialServer()),
        googleIosClientProvider.overrideWithValue(''),
      ],
    );
    addTearDown(container.dispose);
    await container.read(serverPingProvider.future);
    expect(
      container.read(socialSignInOptionsProvider).googleServerClientId,
      'server-client',
    );
  });

  testWidgets('no buttons on other platforms', (tester) async {
    await pumpNestApp(tester, signedIn: false, health: socialServer());
    expect(find.text('Continue with Apple'), findsNothing);
    expect(find.text('Continue with Google'), findsNothing);
  }, variant: TargetPlatformVariant.only(TargetPlatform.macOS));

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
          'This Apple or Google account already belongs to another Hoomly account.',
        ),
        findsOneWidget,
      );
    }, variant: ios);

    testWidgets('Android offers Google only', (tester) async {
      await pumpNestApp(tester, health: socialServer());
      await openSettings(tester);
      expect(
        find.text('Link Google once, and it signs you into this account.'),
        findsOneWidget,
      );
      expect(find.text('Apple'), findsNothing);
      expect(find.text('Google'), findsOneWidget);
    }, variant: android);

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
