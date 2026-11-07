import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_flutter/core/backend/live_sync.dart';

/// The tests that check the loop stops run in fake time (testWidgets).
void main() {
  late StreamController<int> events;
  late List<LiveSyncState> states;
  late int refreshes;
  late int checks;

  LiveSyncLoop<int> loop({
    required Future<void> Function() refresh,
    bool stillSignedIn = false,
  }) {
    final loop = LiveSyncLoop<int>(
      events: () => (events = StreamController<int>()).stream,
      apply: (_) async {},
      refresh: () {
        refreshes++;
        return refresh();
      },
      onState: states.add,
      checkSignIn: () async {
        checks++;
        return stillSignedIn;
      },
    );
    addTearDown(loop.dispose);
    return loop;
  }

  setUp(() {
    states = [];
    refreshes = 0;
    checks = 0;
  });

  testWidgets('stops for good when the sign-in is dead', (tester) async {
    loop(
      refresh: () async => throw NestException(code: NestErrorCode.notSignedIn),
    ).start();
    await tester.pump();
    await tester.pump(const Duration(minutes: 5));

    expect(refreshes, 1);
    expect(checks, 1);
    expect(states, [LiveSyncState.offline]);
  });

  testWidgets('stops when the live connection is refused with a 401', (
    tester,
  ) async {
    loop(refresh: () async {}).start();
    await tester.pump();
    expect(states, [LiveSyncState.live]);

    events.addError(ServerpodClientUnauthorized());
    await tester.pump();
    await tester.pump(const Duration(minutes: 5));

    expect(refreshes, 1);
    expect(checks, 1);
    expect(states.last, LiveSyncState.offline);
  });

  // Real time: the first retry comes after two seconds.
  test('keeps retrying when the check says the sign-in holds', () async {
    loop(
      refresh: () async => throw NestException(code: NestErrorCode.notSignedIn),
      stillSignedIn: true,
    ).start();
    await Future<void>.delayed(const Duration(milliseconds: 2500));

    expect(refreshes, 2);
    expect(checks, 2);
  });

  // Real time: the first retry comes after two seconds.
  test('retries a network error without checking the sign-in', () async {
    loop(
      refresh: () async =>
          throw const ServerpodClientNetworkException('offline'),
    ).start();
    await Future<void>.delayed(const Duration(milliseconds: 2500));

    expect(refreshes, 2);
    expect(checks, 0);
  });

  test('isSignInError', () {
    expect(
      isSignInError(NestException(code: NestErrorCode.notSignedIn)),
      isTrue,
    );
    expect(isSignInError(ServerpodClientUnauthorized()), isTrue);
    expect(
      isSignInError(NestException(code: NestErrorCode.notAMember)),
      isFalse,
    );
    expect(isSignInError(null), isFalse);
  });
}
