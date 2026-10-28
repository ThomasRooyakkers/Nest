import 'dart:async';

/// Connection state of a feature's live sync.
enum LiveSyncState { connecting, live, offline }

/// Keeps a feature's local cache in sync with the server: listens to its
/// live events, loads everything, and reconnects with a growing delay
/// (2–30 s) after the connection drops. [refresh] sends queued offline
/// changes first.
class LiveSyncLoop<E> {
  LiveSyncLoop({
    required this.events,
    required this.apply,
    required this.refresh,
    required this.onState,
  });

  static const _firstRetryDelay = Duration(seconds: 2);
  static const _maxRetryDelay = Duration(seconds: 30);

  /// Live changes from the server; errors when the connection drops.
  final Stream<E> Function() events;
  final Future<void> Function(E event) apply;
  final Future<void> Function() refresh;
  final void Function(LiveSyncState state) onState;

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
    void close([_, _]) {
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
    } on Exception {
      close();
    }

    await closed.future;
    if (_disposed) return;
    onState(LiveSyncState.offline);
    _retry = Timer(_retryDelay, _connect);
    final doubled = _retryDelay * 2;
    _retryDelay = doubled > _maxRetryDelay ? _maxRetryDelay : doubled;
  }
}
