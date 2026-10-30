import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nest_client/nest_client.dart';

import 'support/fake_meal_plan_server.dart';
import 'support/fake_recipe_server.dart';
import 'support/fakes.dart';

void main() {
  // Wednesday 28 October 2026, 12:00.
  DateTime now() => DateTime(2026, 10, 28, 12);
  DateTime day(int offset) => DateTime.utc(2026, 10, 28 + offset);

  late FakeMealPlanServer server;
  late FakeRecipeServer recipes;
  late Recipe soup;

  /// A label in the bottom tab bar (the home screen names features too).
  Finder tab(String label) => find.byWidgetPredicate(
    (w) => w is Text && w.data == label && w.maxLines == 1,
  );

  setUp(() {
    recipes = FakeRecipeServer();
    soup = recipes.add(
      'Pumpkin soup',
      servings: 4,
      ingredients: [(1, 'kg', 'Pumpkin')],
      steps: ['Simmer and blend.'],
    );
    recipes.add('Pancakes', servings: 2);
    server = FakeMealPlanServer();
    server
      ..add(day(0), recipe: soup, note: 'Roast the pumpkin')
      ..add(day(1), freeText: 'Pizza night')
      // Next week.
      ..add(day(7), freeText: 'Curry');
  });

  Future<ProviderContainer> openMeals(
    WidgetTester tester, {
    Locale? locale,
    double textScale = 1,
    FakeHealthRepository? health,
    MembershipRole role = MembershipRole.owner,
  }) async {
    final container = await pumpNestApp(
      tester,
      mealPlanServer: server,
      recipeServer: recipes,
      deviceLocale: locale,
      textScale: textScale,
      health: health,
      clock: now,
      households: [myHousehold(1, 'Home', role)],
      user: testUser(locale: locale?.languageCode ?? 'en'),
    );
    await tester.tap(
      tab(locale?.languageCode == 'nl' ? 'Maaltijden' : 'Meals'),
    );
    await tester.pumpAndSettle();
    return container;
  }

  Future<void> tapText(WidgetTester tester, String text) async {
    await tester.ensureVisible(find.text(text).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text(text).first);
    await tester.pumpAndSettle();
  }

  testWidgets('the week shows planned meals and empty days', (tester) async {
    await openMeals(tester);
    expect(find.text('Meal plan'), findsOneWidget);
    expect(find.text('This week'), findsOneWidget);
    expect(find.text('Oct 26 – Nov 1'), findsOneWidget);
    expect(find.text('Pumpkin soup'), findsOneWidget);
    expect(find.text('4 servings'), findsOneWidget);
    expect(find.text('Prep ahead: Roast the pumpkin'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Curry'), findsNothing);
    await tester.ensureVisible(find.text('Pizza night'));
    expect(find.text('Pizza night'), findsOneWidget);
    // Monday, Tuesday, Friday, Saturday and Sunday are empty.
    expect(find.text('Plan dinner', skipOffstage: false), findsNWidgets(5));
    expect(
      find.bySemanticsLabel('Wednesday, October 28: Pumpkin soup'),
      findsOneWidget,
    );
  });

  testWidgets('this week opens at today; a day in the strip scrolls to it', (
    tester,
  ) async {
    await openMeals(tester);
    final strip = tester.getBottomLeft(find.text('Wed')).dy;
    double top(String text) => tester.getTopLeft(find.text(text)).dy;
    // Wednesday's card is just below the strip; Monday's scrolled away.
    expect(top('Wednesday'), inInclusiveRange(strip, strip + 80));
    expect(top('Monday'), lessThan(strip));

    await tester.tap(find.text('Mon'));
    await tester.pumpAndSettle();
    expect(top('Monday'), inInclusiveRange(strip, strip + 80));
  });

  testWidgets('previous and next week', (tester) async {
    await openMeals(tester);
    await tester.tap(find.byTooltip('Next week'));
    await tester.pumpAndSettle();
    expect(find.text('Next week'), findsWidgets);
    expect(find.text('Curry'), findsOneWidget);
    expect(find.text('Pumpkin soup'), findsNothing);

    await tester.tap(find.byTooltip('Next week'));
    await tester.pumpAndSettle();
    expect(find.text('Nov 9 – Nov 15'), findsOneWidget);
    await tester.tap(find.text('Back to this week'));
    await tester.pumpAndSettle();
    expect(find.text('Pumpkin soup'), findsOneWidget);

    await tester.tap(find.byTooltip('Last week'));
    await tester.pumpAndSettle();
    expect(find.text('Last week'), findsWidgets);
    // This week, next week, the week after and last week; this week stays
    // in sync for the dashboard, so it is not loaded again.
    expect(server.calls.where((c) => c == 'entries'), hasLength(4));
  });

  testWidgets('a dinner is planned as free text', (tester) async {
    await openMeals(tester);
    // Monday, the first empty day.
    await tapText(tester, 'Plan dinner');
    expect(find.text('Dinner · Monday, October 26'), findsOneWidget);
    await tester.tap(find.text('Something else'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, "What's on the menu?"),
      'Leftovers',
    );
    await tester.enterText(
      find.widgetWithText(
        TextField,
        'E.g. take the chicken out of the freezer',
      ),
      'Defrost the soup',
    );
    await tester.pump();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final saved = server.entries.firstWhere((e) => e.freeText == 'Leftovers');
    expect(saved.date, day(-2));
    expect(saved.recipeId, isNull);
    expect(saved.prepAheadNote, 'Defrost the soup');
    expect(find.text('Leftovers'), findsOneWidget);
  });

  testWidgets('a dinner is planned from a recipe with other servings', (
    tester,
  ) async {
    await openMeals(tester);
    await tapText(tester, 'Plan dinner');
    await tester.tap(find.text('Pancakes'));
    await tester.pumpAndSettle();
    expect(find.text('2 servings'), findsOneWidget);
    await tester.tap(find.byTooltip('More servings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final saved = server.entries.firstWhere((e) => e.freeText == 'Pancakes');
    expect(saved.recipeId, isNotNull);
    expect(saved.servings, 3);
  });

  testWidgets('a planned meal opens its recipe at its servings', (
    tester,
  ) async {
    server.entries.first = server.entries.first.copyWith(servings: 6);
    await openMeals(tester);
    expect(find.text('6 servings'), findsOneWidget);
    await tapText(tester, 'Open recipe');
    expect(find.text('Simmer and blend.'), findsOneWidget);
    // 1 kg for 4 servings, scaled to 6.
    expect(find.textContaining('1½'), findsOneWidget);
    expect(find.textContaining('6 servings'), findsOneWidget);
  });

  testWidgets('a meal is moved to another day and removed', (tester) async {
    await openMeals(tester);
    await tapText(tester, 'Pizza night');
    await tester.tap(find.text('Thursday, October 29'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(DatePickerDialog),
        matching: find.text('30'),
      ),
    );
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(
      server.entries.firstWhere((e) => e.freeText == 'Pizza night').date,
      day(2),
    );

    await tapText(tester, 'Pizza night');
    await tester.tap(find.text('Remove from the plan'));
    await tester.pumpAndSettle();
    expect(server.entries.any((e) => e.freeText == 'Pizza night'), isFalse);
    expect(find.text('Pizza night'), findsNothing);
  });

  testWidgets('a meal planned by someone else appears live', (tester) async {
    await openMeals(tester);
    server.addByOther(day(3), 'Fish and chips');
    await tester.pumpAndSettle();
    expect(find.text('Fish and chips', skipOffstage: false), findsOneWidget);
  });

  testWidgets('owners switch on lunch for the household', (tester) async {
    await openMeals(tester);
    expect(find.text('Plan lunch', skipOffstage: false), findsNothing);
    await tester.tap(find.byTooltip('Meals to plan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lunch'));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(20, 20));
    await tester.pumpAndSettle();
    expect(find.text('Plan lunch', skipOffstage: false), findsNWidgets(7));
    expect(find.text('LUNCH', skipOffstage: false), findsNWidgets(7));
  });

  testWidgets('members cannot change the meals to plan', (tester) async {
    await openMeals(tester, role: MembershipRole.member);
    expect(find.byTooltip('Meals to plan'), findsNothing);
  });

  testWidgets('offline, the cached week shows with a notice', (
    tester,
  ) async {
    final container = await openMeals(tester);
    server
      ..online = false
      ..disconnect();
    await tester.pumpAndSettle();
    expect(find.textContaining('Offline.'), findsOneWidget);
    expect(find.text('Pumpkin soup'), findsOneWidget);

    // Stop the sync's retry timer.
    await tester.pumpWidget(const SizedBox());
    container.dispose();
  });

  testWidgets('a failed save shows the error in the sheet', (tester) async {
    await openMeals(tester);
    await tapText(tester, 'Plan dinner');
    await tester.tap(find.text('Something else'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, "What's on the menu?"),
      'Leftovers',
    );
    await tester.pump();
    server.online = false;
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text("What's on the menu?"), findsOneWidget);
    expect(server.entries.any((e) => e.freeText == 'Leftovers'), isFalse);
  });

  testWidgets('the tab is hidden on servers without the meal plan', (
    tester,
  ) async {
    await pumpNestApp(
      tester,
      mealPlanServer: server,
      health: FakeHealthRepository(apiVersion: 4),
    );
    expect(tab('Meals'), findsNothing);
    expect(tab('Tasks'), findsOneWidget);
  });

  testWidgets('Dutch with large text fits', (tester) async {
    await openMeals(tester, locale: const Locale('nl'), textScale: 2);
    expect(tester.takeException(), isNull);
    expect(find.text('Weekmenu'), findsOneWidget);
    expect(find.text('Deze week'), findsOneWidget);
    await tapText(tester, 'Avondeten plannen');
    expect(tester.takeException(), isNull);
    expect(find.text('Iets anders'), findsOneWidget);
  });
}
