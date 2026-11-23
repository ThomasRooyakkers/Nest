import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/nest_users.dart';

/// The signed-in user's phones and notification switches (2.0, NEST-49).
/// Not household-scoped: everything here belongs to the caller only.
class NotificationEndpoint extends Endpoint {
  static const _maxTokenLength = 4096;

  /// Registers this phone's FCM token for the caller. A token that was
  /// registered for another user (the phone changed hands) moves over.
  Future<void> registerDevice(
    Session session,
    String token,
    PushPlatform platform,
  ) async {
    final user = await NestUsers.require(session);
    final trimmed = token.trim();
    if (trimmed.isEmpty || trimmed.length > _maxTokenLength) {
      throw NestException(code: NestErrorCode.invalidInput);
    }
    final existing = await PushDevice.db.findFirstRow(
      session,
      where: (t) => t.token.equals(trimmed),
    );
    if (existing == null) {
      await PushDevice.db.insertRow(
        session,
        PushDevice(userId: user.id!, token: trimmed, platform: platform),
      );
    } else {
      await PushDevice.db.updateRow(
        session,
        existing.copyWith(
          userId: user.id!,
          platform: platform,
          lastSeenAt: DateTime.now(),
        ),
      );
    }
  }

  /// Forgets this phone's token for the caller, e.g. before signing out.
  Future<void> unregisterDevice(Session session, String token) async {
    final user = await NestUsers.require(session);
    await PushDevice.db.deleteWhere(
      session,
      where: (t) => t.token.equals(token.trim()) & t.userId.equals(user.id!),
    );
  }

  /// The caller's switches; both on until changed.
  Future<NotificationSettings> settings(Session session) async {
    final user = await NestUsers.require(session);
    final row = await NotificationPreference.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(user.id!),
    );
    return NotificationSettings(
      taskAssigned: row?.taskAssigned ?? true,
      shoppingAdded: row?.shoppingAdded ?? true,
    );
  }

  /// Saves the caller's switches.
  Future<NotificationSettings> saveSettings(
    Session session,
    NotificationSettings settings,
  ) async {
    final user = await NestUsers.require(session);
    final row = await NotificationPreference.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(user.id!),
    );
    if (row == null) {
      await NotificationPreference.db.insertRow(
        session,
        NotificationPreference(
          userId: user.id!,
          taskAssigned: settings.taskAssigned,
          shoppingAdded: settings.shoppingAdded,
        ),
      );
    } else {
      await NotificationPreference.db.updateRow(
        session,
        row.copyWith(
          taskAssigned: settings.taskAssigned,
          shoppingAdded: settings.shoppingAdded,
        ),
      );
    }
    return settings;
  }
}
