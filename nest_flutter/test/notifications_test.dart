import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nest_flutter/app/router.dart';
import 'package:nest_flutter/core/notifications/push_messaging.dart';
import 'package:nest_flutter/core/notifications/push_open.dart';

import 'support/fakes.dart';

void main() {
  group('a tapped notification', () {
    test('of a task opens the task list of its household', () {
      final target = PushTarget.fromData({
        'type': 'task',
        'householdId': '3',
        'taskId': '9',
      })!;
      expect(target.householdId, 3);
      expect(target.route, Routes.tasks);
      expect(target.listId, isNull);
    });

    test('of a shopping list opens that list', () {
      final target = PushTarget.fromData({
        'type': 'shopping',
        'householdId': '3',
        'listId': '7',
      })!;
      expect(target.route, Routes.shopping);
      expect(target.listId, 7);
    });

    test('of an unknown kind is ignored', () {
      expect(
        PushTarget.fromData({'type': 'party', 'householdId': '3'}),
        isNull,
      );
      expect(PushTarget.fromData({'type': 'task'}), isNull);
    });
  });

  Future<void> openSettings(WidgetTester tester) async {
    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
  }

  testWidgets('the notification switches show only when the server sends '
      'push', (tester) async {
    await pumpNestApp(tester, health: FakeHealthRepository(apiVersion: 15));
    await openSettings(tester);
    expect(find.text('Notifications'), findsNothing);
  });

  testWidgets('a switch is saved on the server', (tester) async {
    final notifications = FakeNotificationRepository();
    await pumpNestApp(
      tester,
      health: FakeHealthRepository(apiVersion: 15, pushNotifications: true),
      notifications: notifications,
    );
    await openSettings(tester);
    await tester.scrollUntilVisible(
      find.text('Shopping list additions'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Notifications'), findsOneWidget);
    await tester.tap(find.text('Shopping list additions'));
    await tester.pumpAndSettle();
    expect(notifications.current.shoppingAdded, isFalse);
    expect(notifications.current.taskAssigned, isTrue);
  });

  testWidgets('the phone registers its token when push is on', (tester) async {
    final notifications = FakeNotificationRepository();
    final db = testDatabase();
    await pumpNestApp(
      tester,
      database: db,
      health: FakeHealthRepository(apiVersion: 15, pushNotifications: true),
      notifications: notifications,
      pushMessaging: FakePushMessaging(),
    );
    await tester.pumpAndSettle();
    expect(notifications.registered, ['test-token']);
    expect(await db.readValue(pushTokenKey), 'test-token');
  });

  testWidgets('nothing registers without permission', (tester) async {
    final notifications = FakeNotificationRepository();
    await pumpNestApp(
      tester,
      health: FakeHealthRepository(apiVersion: 15, pushNotifications: true),
      notifications: notifications,
      pushMessaging: FakePushMessaging(granted: false),
    );
    await tester.pumpAndSettle();
    expect(notifications.registered, isEmpty);
  });

  testWidgets('without permission Settings says so', (tester) async {
    await pumpNestApp(
      tester,
      health: FakeHealthRepository(apiVersion: 15, pushNotifications: true),
      pushMessaging: FakePushMessaging(granted: false),
    );
    await openSettings(tester);
    await tester.scrollUntilVisible(
      find.textContaining('phone\'s settings'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.textContaining('phone\'s settings'), findsOneWidget);
  });
}
