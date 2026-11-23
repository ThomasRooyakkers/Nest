import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/data/auth_repository.dart';
import '../../features/settings/data/notification_repository.dart';
import '../backend/server_health_repository.dart';
import '../database/nest_database.dart';
import 'push_messaging.dart';

part 'push_registration.g.dart';

/// Whether the server sends push notifications (API level 15 and a Firebase
/// key on the server; always in development). Older servers: false.
@riverpod
bool serverSendsPush(Ref ref) =>
    ref.watch(serverPingProvider).value?.pushNotifications ?? false;

/// The push messaging of this build.
@Riverpod(keepAlive: true)
PushMessaging pushMessaging(Ref ref) => PushMessaging.instance;

/// Registers this phone for push while the user is signed in on a server
/// that sends push: asks for permission (the system asks only once), sends
/// the token to the server and keeps it current. Watched by the app shell.
@Riverpod(keepAlive: true)
class PushRegistration extends _$PushRegistration {
  StreamSubscription<String>? _refresh;

  @override
  bool build() {
    final signedIn = ref.watch(signedInProvider);
    final sends = ref.watch(serverSendsPushProvider);
    final messaging = ref.watch(pushMessagingProvider);
    ref.onDispose(() => _refresh?.cancel());
    if (!signedIn || !sends || !messaging.available) return false;
    unawaited(_register(messaging));
    return true;
  }

  Future<void> _register(PushMessaging messaging) async {
    try {
      if (!await messaging.requestPermission()) return;
      final token = await messaging.token();
      if (token != null) await _send(token, messaging);
      await _refresh?.cancel();
      _refresh = messaging.tokenRefresh.listen((t) => _send(t, messaging));
    } catch (e) {
      debugPrint('Push registration failed: $e');
    }
  }

  Future<void> _send(String token, PushMessaging messaging) async {
    if (!ref.mounted) return;
    await ref
        .read(notificationRepositoryProvider)
        .registerDevice(token, messaging.platform);
    await ref.read(nestDatabaseProvider).writeValue(pushTokenKey, token);
  }
}
