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

  testWidgets('a new user without a code is pointed to Create account', (
    tester,
  ) async {
    final social = FakeSocialSignInRepository()
      ..error = NestException(code: NestErrorCode.inviteRequired);
    await pumpNestApp(
      tester,
      signedIn: false,
      health: socialServer(),
      socialSignIn: social,
    );
    await tester.tap(find.text('Continue with Google'));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Tap Create account, enter your invite code'),
      findsOneWidget,
    );
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
}
