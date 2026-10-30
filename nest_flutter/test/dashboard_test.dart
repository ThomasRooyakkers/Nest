import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_shared/nest_shared.dart';
import 'package:nest_flutter/features/tasks/presentation/task_row.dart';

import 'support/fake_meal_plan_server.dart';
import 'support/fake_recipe_server.dart';
import 'support/fake_shopping_server.dart';
import 'support/fake_task_server.dart';
import 'support/fake_watchlist_server.dart';
import 'support/fakes.dart';

void main() {
  // Wednesday 28 October 2026, 12:00.
  DateTime now() => DateTime(2026, 10, 28, 12);
  DateTime day(int offset) => DateTime.utc(2026, 10, 28 + offset);

  final members = [
    HouseholdMember(userId: 1, name: 'Thomas', role: MembershipRole.owner),
    HouseholdMember(userId: 2, name: 'Sarah', role: MembershipRole.member),
  ];

  late FakeMealPlanServer meals;
  late FakeRecipeServer recipes;
  late FakeShoppingServer shopping;
  late FakeTaskServer tasks;
  late FakeWatchlistServer watchlist;

  setUp(() {
    recipes = FakeRecipeServer();
    final soup = recipes.add(
      'Pumpkin soup',
      servings: 4,
      ingredients: [(1, 'kg', 'Pumpkin')],
      steps: ['Simmer and blend.'],
    );
    meals = FakeMealPlanServer()
      ..add(day(0), recipe: soup, note: 'Roast the pumpkin')
      ..add(day(1), freeText: 'Pizza night');

    shopping = FakeShoppingServer();
    final list = shopping.addList('Weekly shop');
    final milk = shopping.addCatalogItem(
      'Milk',
      'Melk',
      ShoppingCategory.dairyEggs,
    );
    final bread = shopping.addCatalogItem(
      'Bread',
      'Brood',
      ShoppingCategory.bakery,
    );
    shopping
      ..addByOther(list.id!, milk)
      ..addByOther(list.id!, bread);

    tasks = FakeTaskServer()
      ..add('Bins out', dueDate: day(-1))
      ..add(
        'Water the plants',
        dueDate: day(0),
        dueMinutes: 18 * 60,
        assigneeId: 2,
      )
      ..add('Book the dentist', dueDate: day(1))
      ..add('Pay rent', dueDate: day(0), doneAt: DateTime.utc(2026, 10, 28, 9));

    watchlist = FakeWatchlistServer()
      ..add(1)
      ..add(14, type: WatchType.series, status: WatchStatus.watching);
  });

  Future<void> openHome(
    WidgetTester tester, {
    Locale? locale,
    double textScale = 1,
    List<HouseholdFeature> features = HouseholdFeature.values,
  }) async {
    await pumpNestApp(
      tester,
      mealPlanServer: meals,
      recipeServer: recipes,
      shoppingServer: shopping,
      taskServer: tasks,
      watchlistServer: watchlist,
      members: members,
      deviceLocale: locale,
      textScale: textScale,
      clock: now,
      households: [
        MyHousehold(
          household: Household(id: 1, name: 'Home', enabledFeatures: features),
          role: MembershipRole.owner,
        ),
      ],
      user: testUser(locale: locale?.languageCode ?? 'en'),
    );
  }

  Future<void> scrollTo(WidgetTester tester, Finder finder) async {
    await tester.scrollUntilVisible(
      finder,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows tonight, the tiles, today\'s tasks and what to watch', (
    tester,
  ) async {
    await openHome(tester);
    expect(find.text('WEDNESDAY, OCTOBER 28'), findsOneWidget);
    expect(find.text('TONIGHT'), findsOneWidget);
    expect(find.text('Pumpkin soup'), findsOneWidget);
    expect(find.text('4 servings'), findsOneWidget);
    expect(find.text('Prep ahead: Roast the pumpkin'), findsOneWidget);
    expect(find.text('Pizza night'), findsNothing);

    expect(find.text('2 items to buy'), findsOneWidget);
    expect(find.text('2 tasks today'), findsOneWidget);

    await scrollTo(tester, find.text('Water the plants'));
    // Overdue first, then today's; tomorrow's and done tasks are left out.
    expect(
      tester.getTopLeft(find.text('Bins out')).dy,
      lessThan(tester.getTopLeft(find.text('Water the plants')).dy),
    );
    expect(find.text('Book the dentist'), findsNothing);
    expect(find.text('Pay rent'), findsNothing);
    expect(
      find.descendant(
        of: find.widgetWithText(TaskRow, 'Water the plants'),
        matching: find.byType(NestAvatar),
      ),
      findsOneWidget,
    );

    await scrollTo(tester, find.text('Bluey'));
    expect(find.text('WATCHING NOW'), findsOneWidget);
    expect(find.text('Paddington 2'), findsNothing);
  });

  testWidgets('a task is checked off on the dashboard', (tester) async {
    await openHome(tester);
    await scrollTo(tester, find.text('Bins out'));
    await tester.tap(
      find.descendant(
        of: find.widgetWithText(TaskRow, 'Bins out'),
        matching: find.byType(InkResponse),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      tasks.tasks.firstWhere((t) => t.title == 'Bins out').doneAt,
      isNotNull,
    );
    expect(find.widgetWithText(TaskRow, 'Bins out'), findsNothing);
    await scrollTo(tester, find.text('1 task today'));
    expect(find.text('1 task today'), findsOneWidget);
  });

  testWidgets('Open recipe opens tonight\'s recipe', (tester) async {
    await openHome(tester);
    await tester.tap(find.text('Open recipe'));
    await tester.pumpAndSettle();
    expect(find.text('Simmer and blend.'), findsOneWidget);
  });

  testWidgets('an empty day offers to plan dinner', (tester) async {
    meals.entries.clear();
    tasks.tasks.clear();
    watchlist.items.clear();
    await openHome(tester);
    expect(find.text('Nothing planned for tonight yet.'), findsOneWidget);
    expect(find.text('Nothing due today'), findsOneWidget);
    await scrollTo(tester, find.text('Nothing due today.'));
    expect(find.text('WATCHING NOW'), findsNothing);
    expect(find.text('UP NEXT TO WATCH'), findsNothing);

    await scrollTo(tester, find.text('Plan dinner'));
    await tester.tap(find.text('Plan dinner'));
    await tester.pumpAndSettle();
    expect(find.text('Meal plan'), findsOneWidget);
  });

  testWidgets('cards of switched-off features are hidden', (tester) async {
    await openHome(tester, features: [HouseholdFeature.shopping]);
    expect(find.text('2 items to buy'), findsOneWidget);
    expect(find.text('TONIGHT'), findsNothing);
    expect(find.textContaining('tasks today'), findsNothing);
    expect(find.text("Today's tasks"), findsNothing);
    expect(find.text('Bluey'), findsNothing);
    expect(find.text("Your household's recipe library"), findsNothing);
  });

  testWidgets('the next title to watch when nothing is being watched', (
    tester,
  ) async {
    watchlist.items.removeWhere((i) => i.status == WatchStatus.watching);
    await openHome(tester);
    await scrollTo(tester, find.text('Paddington 2'));
    expect(find.text('UP NEXT TO WATCH'), findsOneWidget);
  });

  testWidgets('lays out in Dutch with large text', (tester) async {
    await openHome(tester, locale: const Locale('nl'), textScale: 2);
    expect(tester.takeException(), isNull);
    expect(find.text('VANAVOND'), findsOneWidget);
    expect(find.text('Recept openen'), findsOneWidget);
    await scrollTo(tester, find.text('2 taken vandaag'));
    await scrollTo(tester, find.text('Bluey'));
    expect(find.text('NU AAN HET KIJKEN'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
