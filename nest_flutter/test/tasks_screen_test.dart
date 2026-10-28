import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nest_client/nest_client.dart';

import 'support/fake_task_server.dart';
import 'support/fakes.dart';

void main() {
  // Wednesday 28 October 2026, 12:00.
  DateTime now() => DateTime(2026, 10, 28, 12);
  DateTime day(int offset) => DateTime.utc(2026, 10, 28 + offset);
  final members = [
    HouseholdMember(userId: 1, name: 'Thomas', role: MembershipRole.owner),
    HouseholdMember(userId: 2, name: 'Sarah', role: MembershipRole.member),
  ];

  late FakeTaskServer server;

  /// A label in the bottom tab bar (the home screen names features too).
  Finder tab(String label) => find.byWidgetPredicate(
    (w) => w is Text && w.data == label && w.maxLines == 1,
  );

  setUp(() {
    server = FakeTaskServer();
    server
      ..add(
        'Take out the bins',
        assigneeId: 1,
        dueDate: day(0),
        dueMinutes: 20 * 60,
        recurrence: TaskRecurrence.weekly,
      )
      ..add('Water the plants', assigneeId: 2, dueDate: day(-2))
      ..add('Fix the bike light')
      ..add(
        'Buy a present',
        assigneeId: 1,
        doneAt: DateTime(2026, 10, 27, 18),
        doneById: 2,
      );
  });

  Future<ProviderContainer> openTasks(
    WidgetTester tester, {
    Locale? locale,
    double textScale = 1,
    FakeHealthRepository? health,
  }) async {
    final container = await pumpNestApp(
      tester,
      taskServer: server,
      members: members,
      deviceLocale: locale,
      textScale: textScale,
      health: health,
      clock: now,
      // The UI follows the language in the profile.
      user: testUser(locale: locale?.languageCode ?? 'en'),
    );
    await tester.tap(tab(locale?.languageCode == 'nl' ? 'Taken' : 'Tasks'));
    await tester.pumpAndSettle();
    return container;
  }

  Future<void> chip(WidgetTester tester, String label) async {
    await tester.ensureVisible(find.text(label).first);
    await tester.tap(find.text(label).first);
    await tester.pumpAndSettle();
  }

  testWidgets('Everyone shows open tasks with due labels', (tester) async {
    await openTasks(tester);
    expect(find.text('Water the plants'), findsOneWidget);
    expect(find.text('Take out the bins'), findsOneWidget);
    expect(find.text('Fix the bike light'), findsOneWidget);
    expect(find.text('Buy a present'), findsNothing);
    expect(find.text('Overdue · Mon, Oct 26'), findsOneWidget);
    expect(find.text('Today · 8:00 PM'), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('Repeats: Weekly')), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('Assigned to Sarah')), findsOneWidget);
    // Overdue first, undated last.
    final top = tester.getTopLeft(find.text('Water the plants')).dy;
    final middle = tester.getTopLeft(find.text('Take out the bins')).dy;
    final bottom = tester.getTopLeft(find.text('Fix the bike light')).dy;
    expect(top < middle && middle < bottom, isTrue);
  });

  testWidgets('the filter chips', (tester) async {
    await openTasks(tester);
    await chip(tester, 'Mine');
    expect(find.text('Take out the bins'), findsOneWidget);
    expect(find.text('Water the plants'), findsNothing);

    await chip(tester, 'Overdue');
    expect(find.text('Water the plants'), findsOneWidget);
    expect(find.text('Take out the bins'), findsNothing);

    await chip(tester, 'Done');
    expect(find.text('Buy a present'), findsOneWidget);
    expect(find.text('Done by Sarah'), findsOneWidget);
    expect(find.text('Water the plants'), findsNothing);
  });

  testWidgets('checking off a recurring task adds the next one', (
    tester,
  ) async {
    await openTasks(tester);
    await tester.tap(find.bySemanticsLabel('Check off Take out the bins'));
    await tester.pumpAndSettle();
    expect(find.text('Done: Take out the bins'), findsOneWidget);
    expect(server.tasks.first.doneAt, isNotNull);
    // The next occurrence, a week later, replaces it in the list.
    expect(find.text('Take out the bins'), findsOneWidget);
    expect(find.text('Wednesday · 8:00 PM'), findsNothing);
    expect(find.textContaining('Nov 4'), findsOneWidget);

    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(server.tasks.first.doneAt, isNull);
    expect(find.text('Today · 8:00 PM'), findsOneWidget);
    expect(find.textContaining('Nov 4'), findsNothing);
  });

  testWidgets('a new task is created with the + button', (tester) async {
    await openTasks(tester);
    await tester.tap(find.byTooltip('New task'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Vacuum upstairs');
    await tester.tap(find.text('Sarah'));
    await tester.tap(find.text('Tomorrow'));
    await tester.pump();
    await tester.ensureVisible(find.text('Weekly'));
    await tester.tap(find.text('Weekly'));
    await tester.pump();
    expect(
      find.text('When you check it off, the next one is added.'),
      findsOneWidget,
    );
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final saved = server.tasks.last;
    expect(saved.title, 'Vacuum upstairs');
    expect(saved.assigneeId, 2);
    expect(saved.dueDate, day(1));
    expect(saved.recurrence, TaskRecurrence.weekly);
    expect(find.text('Vacuum upstairs'), findsOneWidget);
    expect(find.text('Tomorrow'), findsOneWidget);
  });

  testWidgets('a task is edited and deleted from its sheet', (tester) async {
    await openTasks(tester);
    await tester.tap(find.text('Fix the bike light'));
    await tester.pumpAndSettle();
    expect(find.text('Edit task'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'Fix both lights');
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Fix both lights'), findsOneWidget);

    await tester.tap(find.text('Fix both lights'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Delete task'));
    await tester.tap(find.text('Delete task'));
    await tester.pumpAndSettle();
    expect(find.text('Fix both lights'), findsNothing);
    expect(
      server.tasks.map((t) => t.title),
      isNot(contains('Fix both lights')),
    );
  });

  testWidgets('a task added by someone else appears live', (tester) async {
    await openTasks(tester);
    server.addByOther('Feed the cat');
    await tester.pumpAndSettle();
    expect(find.text('Feed the cat'), findsOneWidget);
  });

  testWidgets('offline, a check-off is kept and the notice shown', (
    tester,
  ) async {
    final container = await openTasks(tester);
    server
      ..online = false
      ..disconnect();
    await tester.pumpAndSettle();
    expect(find.textContaining('Offline.'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Check off Fix the bike light'));
    await tester.pumpAndSettle();
    expect(find.text('Fix the bike light'), findsNothing);
    expect(find.textContaining('1 change waiting to be sent'), findsOneWidget);
    expect(server.tasks[2].doneAt, isNull);

    // Reconnecting is covered by the repository tests. Stop the sync's
    // retry timer.
    await tester.pumpWidget(const SizedBox());
    container.dispose();
  });

  testWidgets('the Tasks tab is hidden on servers without tasks', (
    tester,
  ) async {
    await pumpNestApp(
      tester,
      taskServer: server,
      health: FakeHealthRepository(apiVersion: 2),
    );
    expect(tab('Shopping'), findsOneWidget);
    expect(tab('Tasks'), findsNothing);
  });

  testWidgets('lays out in Dutch with large text', (tester) async {
    await openTasks(tester, locale: const Locale('nl'), textScale: 2);
    expect(find.text('Iedereen'), findsWidgets);
    expect(find.textContaining('Te laat · '), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byTooltip('Nieuwe taak'));
    await tester.pumpAndSettle();
    expect(find.text('Wat moet er gebeuren?'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
