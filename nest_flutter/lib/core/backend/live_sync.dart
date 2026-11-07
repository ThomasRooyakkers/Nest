import 'dart:async';

import 'package:nest_client/nest_client.dart';

/// Connection state of a feature's live sync.
enum LiveSyncState { connecting, live, offline }

/// Keeps a feature's local cache in sync with the server: listens to its
/// live events, loads everything, and reconnects with a growing delay
/// (2–30 s) after the connection drops. [refresh] sends queued offline
/// changes first.
///
/// When the server refuses the sign-in, it asks [checkSignIn] whether the
/// sign-in still holds and stops for good when it does not (the check signs
/// the device out, so the app shows the sign-in screen).
class LiveSyncLoop<E> {
  LiveSyncLoop({
    required this.events,
    required this.apply,
    required this.refresh,
    required this.onState,
    required this.checkSignIn,
  });

  static const _firstRetryDelay = Duration(seconds: 2);
  static const _maxRetryDelay = Duration(seconds: 30);

  /// Live changes from the server; errors when the connection drops.
  final Stream<E> Function() events;
  final Future<void> Function(E event) apply;
  final Future<void> Function() refresh;
  final void Function(LiveSyncState state) onState;

  /// Returns whether this device is still signed in (see [SignInCheck]).
  final SignInCheck checkSignIn;

  StreamSubscription<E>? _subscription;
  Timer? _retry;
  var _retryDelay = _firstRetryDelay;
  var _disposed = false;

  void start() => unawaited(_connect());

  /// Reconnects at once, e.g. after the user pulled to refresh.
  void retryNow() {
    _retry?.cancel();
    unawaited(_connect());
  }

  void dispose() {
    _disposed = true;
    _subscription?.cancel();
    _retry?.cancel();
  }

  Future<void> _connect() async {
    if (_disposed) return;
    await _subscription?.cancel();
    final closed = Completer<void>();
    Object? failure;
    void close([Object? error, _]) {
      failure ??= error;
      if (!closed.isCompleted) closed.complete();
    }

    // Listen before loading, so no change between the two is missed.
    _subscription = events().listen(
      (event) => unawaited(apply(event)),
      onError: close,
      onDone: close,
      cancelOnError: true,
    );
    try {
      await refresh();
      if (_disposed) return;
      onState(LiveSyncState.live);
      _retryDelay = _firstRetryDelay;
    } on Exception catch (error) {
      close(error);
    }

    await closed.future;
    if (_disposed) return;
    onState(LiveSyncState.offline);
    if (isSignInError(failure)) {
      final stillSignedIn = await checkSignIn();
      if (_disposed || !stillSignedIn) return;
    }
    _retry = Timer(_retryDelay, _connect);
    final doubled = _retryDelay * 2;
    _retryDelay = doubled > _maxRetryDelay ? _maxRetryDelay : doubled;
  }
}

/// Asks the server whether this device's sign-in still holds, signs the
/// device out when it does not, and returns whether it is still signed in.
/// Returns true when the server cannot be reached.
typedef SignInCheck = Future<bool> Function();

/// Whether [error] means the server did not accept this device's sign-in.
bool isSignInError(Object? error) => switch (error) {
  NestException(code: NestErrorCode.notSignedIn) => true,
  ServerpodClientUnauthorized() => true,
  _ => false,
};
