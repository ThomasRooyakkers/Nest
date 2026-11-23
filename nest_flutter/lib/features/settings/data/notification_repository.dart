import 'package:nest_client/nest_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/backend/nest_client.dart';

part 'notification_repository.g.dart';

/// The signed-in user's phones and notification switches on the server
/// (2.0, NEST-50).
class NotificationRepository {
  NotificationRepository(this._client);

  final Client _client;

  Future<void> registerDevice(String token, PushPlatform platform) =>
      _client.notification.registerDevice(token, platform);

  Future<NotificationSettings> settings() => _client.notification.settings();

  Future<NotificationSettings> save(NotificationSettings settings) =>
      _client.notification.saveSettings(settings);
}

@Riverpod(keepAlive: true)
NotificationRepository notificationRepository(Ref ref) =>
    NotificationRepository(ref.watch(nestClientProvider));

/// The switches as stored on the server.
@riverpod
Future<NotificationSettings> notificationSettings(Ref ref) =>
    ref.watch(notificationRepositoryProvider).settings();
