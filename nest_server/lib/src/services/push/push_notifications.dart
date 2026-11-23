import 'dart:async';
import 'dart:io';

import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../host_settings.dart';
import 'fcm_client.dart';

/// One push message to one phone.
class PushMessage {
  const PushMessage({
    required this.token,
    required this.title,
    required this.body,
    required this.data,
  });

  final String token;
  final String title;
  final String body;
  final Map<String, String> data;
}

/// Delivers push messages. [FcmPushSender] when the host configured the
/// Firebase key, [LogPushSender] otherwise (development, other servers).
abstract class PushSender {
  /// Whether messages really reach phones (reported in the health ping).
  bool get delivers;

  Future<PushOutcome> send(PushMessage message);
}

/// Writes each push to the server log instead of sending it. The token is
/// shortened so the log never holds a usable one.
class LogPushSender implements PushSender {
  @override
  bool get delivers => false;

  @override
  Future<PushOutcome> send(PushMessage message) async {
    final token = message.token.length > 8
        ? '${message.token.substring(0, 8)}…'
        : message.token;
    stdout.writeln(
      '[push] to $token: ${message.title} — ${message.body} ${message.data}',
    );
    return PushOutcome.sent;
  }
}

class FcmPushSender implements PushSender {
  FcmPushSender(FcmCredentials credentials) : _client = FcmClient(credentials);

  final FcmClient _client;

  @override
  bool get delivers => true;

  @override
  Future<PushOutcome> send(PushMessage message) async {
    final (outcome, problem) = await _client.send(
      token: message.token,
      title: message.title,
      body: message.body,
      data: message.data,
    );
    if (outcome == PushOutcome.failed) {
      stdout.writeln('[push] FCM send failed: $problem');
    }
    return outcome;
  }
}

/// The push notifications of 2.0 (NEST-49): someone assigns you a task, and
/// someone adds items to a shopping list you share. Never to the person who
/// made the change, never to disabled users, only when the recipient's
/// switch is on. Texts in the recipient's language; besides who did it they
/// carry only the task title or the list name.
///
/// Recipients and their phones are looked up during the request; sending
/// happens afterwards, so a slow FCM never slows the app down.
abstract final class PushNotifications {
  /// For tests: replaces the sender chosen from the host settings.
  static PushSender? senderOverride;

  /// How long additions to one list by one person are collected into one
  /// notification. Tests set it to zero.
  static Duration shoppingDelay = const Duration(minutes: 2);

  static PushSender? _configured;

  /// Whether the health ping reports push: when messages really reach
  /// phones, and in development (where they go to the log) so the app's
  /// notification screens can be tried without keys.
  static bool get reported =>
      sender.delivers || Serverpod.instance.runMode == 'development';

  static PushSender get sender =>
      senderOverride ?? (_configured ??= _fromSettings());

  static PushSender _fromSettings() {
    final json = HostSettings.fcmServiceAccount;
    final credentials = json == null ? null : FcmCredentials.parse(json);
    if (json != null && credentials == null) {
      stdout.writeln('[push] fcmServiceAccount is not a usable key; logging');
    }
    return credentials == null ? LogPushSender() : FcmPushSender(credentials);
  }

  static final _inFlight = <Future<void>>{};
  static final _batches = <String, _ShoppingBatch>{};

  /// For tests: sends collected shopping additions now and waits until every
  /// message was handed to the sender.
  static Future<void> flush() async {
    for (final batch in _batches.values.toList()) {
      batch.timer?.cancel();
      batch.fire();
    }
    while (_inFlight.isNotEmpty) {
      await Future.wait(_inFlight.toList());
    }
  }

  /// Called after a task was saved. [previousAssigneeId] is the assignee
  /// before the change (null for a new task).
  static Future<void> taskAssigned(
    Session session, {
    required NestUser actor,
    required Task task,
    required int? previousAssigneeId,
  }) async {
    final assigneeId = task.assigneeId;
    if (assigneeId == null ||
        assigneeId == actor.id ||
        assigneeId == previousAssigneeId) {
      return;
    }
    final targets = await _targets(session, [
      assigneeId,
    ], (p) => p.taskAssigned);
    if (targets.isEmpty) return;
    _deliver([
      for (final target in targets)
        PushMessage(
          token: target.token,
          title: PushTexts.taskTitle(target.locale),
          body: PushTexts.taskBody(target.locale, actor.name, task.title),
          data: {
            'type': 'task',
            'householdId': '${task.householdId}',
            'taskId': '${task.id}',
          },
        ),
    ]);
  }

  /// Called after [count] items were put on [list] as "to buy" by [actor].
  /// Additions by the same person to the same list within [shoppingDelay]
  /// become one notification.
  static Future<void> shoppingAdded(
    Session session, {
    required NestUser actor,
    required ShoppingList list,
    required int count,
  }) async {
    if (count <= 0) return;
    final memberIds = await _householdMemberIds(session, list.householdId);
    final listMembers = list.memberIds.where(memberIds.contains).toList();
    final recipients = (listMembers.isEmpty ? memberIds : listMembers)
        .where((id) => id != actor.id)
        .toList();
    final targets = await _targets(session, recipients, (p) => p.shoppingAdded);
    if (targets.isEmpty) return;

    final key = '${list.id}:${actor.id}';
    final batch = _batches[key];
    if (batch != null) {
      batch
        ..count += count
        ..targets = targets;
      return;
    }
    final created = _ShoppingBatch(
      actorName: actor.name,
      list: list,
      count: count,
      targets: targets,
    );
    created.fire = () {
      _batches.remove(key);
      _deliver([
        for (final target in created.targets)
          PushMessage(
            token: target.token,
            title: list.name,
            body: PushTexts.shoppingBody(
              target.locale,
              created.actorName,
              created.count,
              list.name,
            ),
            data: {
              'type': 'shopping',
              'householdId': '${list.householdId}',
              'listId': '${list.id}',
            },
          ),
      ]);
    };
    _batches[key] = created;
    if (shoppingDelay > Duration.zero) {
      created.timer = Timer(shoppingDelay, created.fire);
    } else {
      created.fire();
    }
  }

  static Future<Set<int>> _householdMemberIds(
    Session session,
    int householdId,
  ) async {
    final memberships = await Membership.db.find(
      session,
      where: (t) => t.householdId.equals(householdId),
    );
    return {for (final m in memberships) m.userId};
  }

  /// The phones of [userIds] that should get this kind of notification:
  /// enabled users whose switch ([wants]) is on, with their language.
  static Future<List<_Target>> _targets(
    Session session,
    List<int> userIds,
    bool Function(NotificationPreference) wants,
  ) async {
    if (userIds.isEmpty) return const [];
    final ids = userIds.toSet();
    final users = await NestUser.db.find(
      session,
      where: (t) => t.id.inSet(ids) & t.disabledAt.equals(null),
    );
    final preferences = await NotificationPreference.db.find(
      session,
      where: (t) => t.userId.inSet(ids),
    );
    final off = {
      for (final p in preferences)
        if (!wants(p)) p.userId,
    };
    final locales = {
      for (final u in users)
        if (!off.contains(u.id)) u.id!: u.locale,
    };
    if (locales.isEmpty) return const [];
    final devices = await PushDevice.db.find(
      session,
      where: (t) => t.userId.inSet(locales.keys.toSet()),
    );
    return [
      for (final d in devices) _Target(d.token, locales[d.userId]!),
    ];
  }

  static void _deliver(List<PushMessage> messages) {
    late final Future<void> job;
    job = _send(messages).whenComplete(() => _inFlight.remove(job));
    _inFlight.add(job);
  }

  static Future<void> _send(List<PushMessage> messages) async {
    final invalid = <String>[];
    for (final message in messages) {
      try {
        if (await sender.send(message) == PushOutcome.invalidToken) {
          invalid.add(message.token);
        }
      } catch (e) {
        stdout.writeln('[push] send failed: $e');
      }
    }
    if (invalid.isNotEmpty) await _forget(invalid);
  }

  /// Removes tokens FCM no longer accepts, in a session of its own (the
  /// request that caused the push is over by now).
  static Future<void> _forget(List<String> tokens) async {
    try {
      final session = await Serverpod.instance.createSession(
        enableLogging: false,
      );
      try {
        await PushDevice.db.deleteWhere(
          session,
          where: (t) => t.token.inSet(tokens.toSet()),
        );
      } finally {
        await session.close();
      }
    } catch (e) {
      stdout.writeln('[push] could not remove old tokens: $e');
    }
  }
}

class _Target {
  const _Target(this.token, this.locale);

  final String token;
  final String locale;
}

class _ShoppingBatch {
  _ShoppingBatch({
    required this.actorName,
    required this.list,
    required this.count,
    required this.targets,
  });

  final String actorName;
  final ShoppingList list;
  int count;
  List<_Target> targets;
  Timer? timer;
  late void Function() fire;
}

/// Push texts in English and Dutch (rule 5). User content (names, task
/// titles, list names) is shown as entered.
abstract final class PushTexts {
  static String taskTitle(String locale) =>
      locale == 'nl' ? 'Nieuwe taak voor jou' : 'New task for you';

  static String taskBody(String locale, String actor, String title) =>
      locale == 'nl'
      ? '$actor heeft je een taak gegeven: $title'
      : '$actor assigned you: $title';

  static String shoppingBody(
    String locale,
    String actor,
    int count,
    String listName,
  ) {
    if (locale == 'nl') {
      final items = count == 1 ? '1 item' : '$count items';
      return '$actor heeft $items toegevoegd aan $listName';
    }
    final items = count == 1 ? '1 item' : '$count items';
    return '$actor added $items to $listName';
  }
}
