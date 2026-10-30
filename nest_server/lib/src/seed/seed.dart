import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import '../generated/protocol.dart';
import '../services/built_in_catalog.dart';
import '../services/tmdb_service.dart';

/// A development user created by the seed command.
class SeedUser {
  const SeedUser(this.email, this.name, this.locale, {this.superAdmin = false});

  final String email;
  final String name;
  final String locale;
  final bool superAdmin;
}

/// A development household and its members (first member is the owner).
class SeedHousehold {
  const SeedHousehold(this.name, this.memberEmails);

  final String name;
  final List<String> memberEmails;
}

const seedUsers = [
  SeedUser('thomas@nest.test', 'Thomas', 'nl', superAdmin: true),
  SeedUser('sarah@nest.test', 'Sarah', 'en'),
  SeedUser('emma@nest.test', 'Emma', 'nl'),
  SeedUser('oma@nest.test', 'Oma', 'nl'),
  SeedUser('jan@nest.test', 'Jan', 'nl'),
];

const seedHouseholds = [
  SeedHousehold('Home', [
    'thomas@nest.test',
    'sarah@nest.test',
    'emma@nest.test',
    'oma@nest.test',
  ]),
  SeedHousehold('Test family', ['jan@nest.test', 'oma@nest.test']),
];

/// Fills a development database with sample data. Each part is skipped when
/// it is already present, so the command can be run again after new
/// features add fixtures.
///
Future<void> seed(Session session, {required String password}) async {
  if (session.serverpod.runMode == 'production') {
    throw StateError('Refusing to seed a production database.');
  }

  await BuiltInCatalog.sync(session);
  await _seedUsersAndHouseholds(session, password: password);
  for (final seedHousehold in seedHouseholds) {
    final household = await Household.db.findFirstRow(
      session,
      where: (t) => t.name.equals(seedHousehold.name),
    );
    if (household == null) continue;
    await _seedShopping(session, household);
    await _seedTasks(session, household);
    await _seedRecipes(session, household);
    await _seedMealPlan(session, household);
    await _seedWatchlist(session, household);
  }
}

Future<void> _seedUsersAndHouseholds(
  Session session, {
  required String password,
}) async {
  final emailIdp = AuthServices.getIdentityProvider<EmailIdp>();
  if (await emailIdp.admin.findAccount(
        session,
        email: seedUsers.first.email,
      ) !=
      null) {
    session.log('Seed users already present.');
    return;
  }

  await session.db.transaction((transaction) async {
    final userIds = <String, int>{};
    for (final seedUser in seedUsers) {
      final authUser = await AuthServices.instance.authUsers.create(
        session,
        transaction: transaction,
      );
      await emailIdp.admin.createEmailAuthentication(
        session,
        authUserId: authUser.id,
        email: seedUser.email,
        password: password,
        transaction: transaction,
      );
      await AuthServices.instance.userProfiles.createUserProfile(
        session,
        authUser.id,
        UserProfileData(email: seedUser.email),
        transaction: transaction,
      );
      final user = await NestUser.db.insertRow(
        session,
        NestUser(
          authUserId: authUser.id,
          name: seedUser.name,
          locale: seedUser.locale,
          isSuperAdmin: seedUser.superAdmin,
        ),
        transaction: transaction,
      );
      userIds[seedUser.email] = user.id!;
    }

    for (final seedHousehold in seedHouseholds) {
      final household = await Household.db.insertRow(
        session,
        Household(
          name: seedHousehold.name,
          enabledFeatures: HouseholdFeature.values,
        ),
        transaction: transaction,
      );
      for (final (index, email) in seedHousehold.memberEmails.indexed) {
        await Membership.db.insertRow(
          session,
          Membership(
            userId: userIds[email]!,
            householdId: household.id!,
            role: index == 0 ? MembershipRole.owner : MembershipRole.member,
          ),
          transaction: transaction,
        );
      }
    }
  });

  session.log(
    'Seeded ${seedUsers.length} users and ${seedHouseholds.length} households.',
  );
}

/// Sample stores, lists and items, so the shopping screens have data.
Future<void> _seedShopping(Session session, Household household) async {
  final householdId = household.id!;
  if (await ShoppingList.db.count(
        session,
        where: (t) => t.householdId.equals(householdId),
      ) >
      0) {
    session.log('Shopping data of ${household.name} already present.');
    return;
  }

  final memberIds = [
    for (final m in await Membership.db.find(
      session,
      where: (t) => t.householdId.equals(householdId),
    ))
      m.userId,
  ];
  final catalog = {
    for (final item in await CatalogItem.db.find(
      session,
      where: (t) => t.householdId.equals(null),
    ))
      item.builtInKey!: item,
  };

  await session.db.transaction((transaction) async {
    final stores = await Store.db.insert(session, [
      Store(
        householdId: householdId,
        name: 'Delhaize',
        color: StoreColor.sage,
        address: 'Grote Markt 1',
        categoryOrder: [
          ShoppingCategory.fruitVegetables,
          ShoppingCategory.bakery,
          ShoppingCategory.meatFish,
          ShoppingCategory.cheeseDeli,
          ShoppingCategory.dairyEggs,
          ShoppingCategory.pantry,
          ShoppingCategory.drinks,
          ShoppingCategory.frozen,
        ],
      ),
      Store(
        householdId: householdId,
        name: 'Aldi',
        color: StoreColor.honey,
        categoryOrder: [
          ShoppingCategory.bakery,
          ShoppingCategory.fruitVegetables,
          ShoppingCategory.dairyEggs,
          ShoppingCategory.household,
          ShoppingCategory.drinks,
        ],
      ),
      Store(
        householdId: householdId,
        name: 'Kruidvat',
        color: StoreColor.lavender,
        categoryOrder: [
          ShoppingCategory.personalCare,
          ShoppingCategory.baby,
          ShoppingCategory.household,
        ],
      ),
    ], transaction: transaction);
    final storeIds = {for (final s in stores) s.name: s.id!};

    final lists = await ShoppingList.db.insert(session, [
      ShoppingList(
        householdId: householdId,
        name: 'Weekly shop',
        memberIds: memberIds,
      ),
      ShoppingList(
        householdId: householdId,
        name: 'DIY store',
        memberIds: memberIds.take(1).toList(),
      ),
    ], transaction: transaction);

    ShoppingItem item(
      String key, {
      String spec = '',
      List<String> stores = const [],
      bool recent = false,
    }) {
      final catalogItem = catalog[key]!;
      return ShoppingItem(
        householdId: householdId,
        listId: lists.first.id!,
        catalogItemId: catalogItem.id,
        name: catalogItem.nameEn,
        spec: spec,
        category: catalogItem.category,
        iconKey: catalogItem.iconKey,
        storeIds: [for (final name in stores) storeIds[name]!],
        status: recent ? ShoppingItemStatus.recent : ShoppingItemStatus.toBuy,
        addedById: memberIds.first,
      );
    }

    await ShoppingItem.db.insert(session, [
      item('milk', spec: '2 l'),
      item('bread', spec: 'whole wheat', stores: ['Delhaize']),
      item('bananas'),
      item('eggs', spec: '12'),
      item('tomatoes', stores: ['Delhaize']),
      item('cheese', spec: 'young Gouda'),
      item('toothpaste', stores: ['Kruidvat']),
      item('dish_soap', stores: ['Aldi', 'Kruidvat']),
      item('coffee', spec: 'beans'),
      item('apples', recent: true),
      item('pasta', recent: true),
      item('yoghurt', recent: true),
      item('orange_juice', recent: true),
      item('toilet_paper', recent: true),
      item('chicken', recent: true),
    ], transaction: transaction);
  });

  session.log('Seeded shopping data for ${household.name}.');
}

/// Sample tasks around today: overdue, today, upcoming, recurring and done.
Future<void> _seedTasks(Session session, Household household) async {
  final householdId = household.id!;
  if (await Task.db.count(
        session,
        where: (t) => t.householdId.equals(householdId),
      ) >
      0) {
    session.log('Tasks of ${household.name} already present.');
    return;
  }

  final memberIds = [
    for (final m in await Membership.db.find(
      session,
      where: (t) => t.householdId.equals(householdId),
      orderBy: (t) => t.id,
    ))
      m.userId,
  ];
  int? member(int index) => index < memberIds.length ? memberIds[index] : null;
  final now = DateTime.now();
  DateTime day(int offset) =>
      DateTime.utc(now.year, now.month, now.day + offset);

  await Task.db.insert(session, [
    Task(
      householdId: householdId,
      title: 'Take out the bins',
      notes: 'Green and blue bin',
      assigneeId: member(0),
      dueDate: day(0),
      dueMinutes: 20 * 60,
      recurrence: TaskRecurrence.weekly,
    ),
    Task(
      householdId: householdId,
      title: 'Water the plants',
      assigneeId: member(1),
      dueDate: day(-2),
      recurrence: TaskRecurrence.weekly,
    ),
    Task(
      householdId: householdId,
      title: 'Book the dentist',
      assigneeId: member(0),
      dueDate: day(-1),
    ),
    Task(
      householdId: householdId,
      title: 'Empty the dishwasher',
      assigneeId: member(2),
      dueDate: day(0),
      recurrence: TaskRecurrence.daily,
    ),
    Task(
      householdId: householdId,
      title: 'Pay the electricity bill',
      dueDate: day(3),
      recurrence: TaskRecurrence.monthly,
    ),
    Task(
      householdId: householdId,
      title: 'Vacuum upstairs',
      assigneeId: member(1),
      dueDate: day(1),
      dueMinutes: 10 * 60,
    ),
    Task(householdId: householdId, title: 'Fix the bike light'),
    Task(
      householdId: householdId,
      title: 'Buy a birthday present',
      assigneeId: member(0),
      dueDate: day(-1),
      doneAt: now.subtract(const Duration(hours: 20)),
      doneById: member(0),
    ),
  ]);
  session.log('Seeded tasks for ${household.name}.');
}

/// A few recipes (user content, so in one language), without photos.
Future<void> _seedRecipes(Session session, Household household) async {
  final householdId = household.id!;
  if (await Recipe.db.count(
        session,
        where: (t) => t.householdId.equals(householdId),
      ) >
      0) {
    session.log('Recipes of ${household.name} already present.');
    return;
  }

  RecipeIngredient ingredient(
    String name, [
    double? quantity,
    String unit = '',
    String note = '',
  ]) => RecipeIngredient(
    recipeId: 0,
    position: 0,
    quantity: quantity,
    unit: unit,
    name: name,
    note: note,
  );

  final recipes = [
    (
      Recipe(
        householdId: householdId,
        title: 'Pancakes',
        description: 'Thin Dutch pancakes for a lazy Sunday.',
        servings: 4,
        prepMinutes: 10,
        cookMinutes: 30,
        tags: ['Breakfast', 'Sweet'],
        isFavorite: true,
      ),
      [
        ingredient('Flour', 250, 'g'),
        ingredient('Milk', 0.5, 'l'),
        ingredient('Eggs', 2),
        ingredient('Salt', null, '', 'a pinch'),
        ingredient('Butter', null, '', 'for the pan'),
      ],
      [
        'Whisk the flour, salt and eggs with half of the milk until smooth.',
        'Whisk in the rest of the milk and let the batter rest for 15 minutes.',
        'Melt a little butter in a hot pan, pour in a thin layer of batter '
            'and bake each pancake golden on both sides.',
      ],
    ),
    (
      Recipe(
        householdId: householdId,
        title: 'Spaghetti bolognese',
        servings: 4,
        prepMinutes: 15,
        cookMinutes: 45,
        tags: ['Pasta', 'Weeknight'],
      ),
      [
        ingredient('Spaghetti', 400, 'g'),
        ingredient('Minced beef', 500, 'g'),
        ingredient('Onion', 1, '', 'finely chopped'),
        ingredient('Garlic', 2, 'cloves'),
        ingredient('Tomatoes', 800, 'g', 'tinned'),
        ingredient('Olive oil', 2, 'tbsp'),
      ],
      [
        'Fry the onion and garlic in the olive oil until soft.',
        'Add the beef and brown it, then add the tomatoes and simmer for '
            '30 minutes.',
        'Cook the spaghetti and serve with the sauce.',
      ],
    ),
    (
      Recipe(
        householdId: householdId,
        title: 'Pumpkin soup',
        description: 'Velvety and warming.',
        servings: 6,
        prepMinutes: 20,
        cookMinutes: 25,
        tags: ['Soup', 'Vegetarian'],
      ),
      [
        ingredient('Pumpkin', 1, 'kg'),
        ingredient('Onion', 1),
        ingredient('Vegetable stock', 1, 'l'),
        ingredient('Cream', 100, 'ml'),
      ],
      [
        'Peel and dice the pumpkin and onion.',
        'Simmer in the stock for 20 minutes, then blend until smooth.',
        'Stir in the cream and season to taste.',
      ],
    ),
  ];

  for (final (recipe, ingredients, steps) in recipes) {
    final saved = await Recipe.db.insertRow(session, recipe);
    await RecipeIngredient.db.insert(session, [
      for (final (index, i) in ingredients.indexed)
        i.copyWith(recipeId: saved.id, position: index),
    ]);
    await RecipeStep.db.insert(session, [
      for (final (index, text) in steps.indexed)
        RecipeStep(recipeId: saved.id!, position: index, text: text),
    ]);
  }
}

/// Dinners for this week and next: the seeded recipes, a few free-text
/// meals and empty days, one with a prep-ahead note.
Future<void> _seedMealPlan(Session session, Household household) async {
  final householdId = household.id!;
  if (await MealPlanEntry.db.count(
        session,
        where: (t) => t.householdId.equals(householdId),
      ) >
      0) {
    session.log('Meal plan of ${household.name} already present.');
    return;
  }

  final recipes = await Recipe.db.find(
    session,
    where: (t) => t.householdId.equals(householdId),
    orderBy: (t) => t.id,
  );
  final owner = await Membership.db.findFirstRow(
    session,
    where: (t) =>
        t.householdId.equals(householdId) & t.role.equals(MembershipRole.owner),
  );
  final now = DateTime.now();
  DateTime day(int offset) =>
      DateTime.utc(now.year, now.month, now.day + offset);
  MealPlanEntry recipeMeal(int offset, Recipe recipe, {String note = ''}) =>
      MealPlanEntry(
        householdId: householdId,
        date: day(offset),
        recipeId: recipe.id,
        freeText: recipe.title,
        prepAheadNote: note,
        createdById: owner?.userId,
      );
  MealPlanEntry textMeal(int offset, String text) => MealPlanEntry(
    householdId: householdId,
    date: day(offset),
    freeText: text,
    createdById: owner?.userId,
  );

  await MealPlanEntry.db.insert(session, [
    textMeal(-1, 'Leftovers'),
    if (recipes.length > 1) recipeMeal(0, recipes[1]),
    if (recipes.length > 2)
      recipeMeal(1, recipes[2], note: 'Take the stock out of the freezer'),
    textMeal(3, 'Pizza night'),
    if (recipes.isNotEmpty) recipeMeal(5, recipes[0]),
    textMeal(8, 'Dinner at grandma\'s'),
  ]);
  session.log('Seeded the meal plan for ${household.name}.');
}

Future<void> _seedWatchlist(Session session, Household household) async {
  final householdId = household.id!;
  if (await WatchlistItem.db.count(
        session,
        where: (t) => t.householdId.equals(householdId),
      ) >
      0) {
    session.log('Watchlist of ${household.name} already present.');
    return;
  }

  final members = await Membership.db.find(
    session,
    where: (t) => t.householdId.equals(householdId),
    orderBy: (t) => t.id,
  );
  // The fake film data's ids, with the status and rating to seed.
  const titles = [
    (WatchType.movie, 1, WatchStatus.want, null),
    (WatchType.movie, 2, WatchStatus.want, null),
    (WatchType.series, 14, WatchStatus.want, null),
    (WatchType.movie, 9, WatchStatus.want, null),
    (WatchType.series, 15, WatchStatus.watching, null),
    (WatchType.series, 12, WatchStatus.watching, null),
    (WatchType.movie, 4, WatchStatus.watched, 5),
    (WatchType.movie, 7, WatchStatus.watched, 4),
  ];
  final fake = FakeTmdbService();
  final items = <WatchlistItem>[];
  for (final (i, (type, id, status, rating)) in titles.indexed) {
    final title = (await fake.details(type, id, locale: 'en'))!;
    items.add(
      WatchlistItem(
        householdId: householdId,
        tmdbId: title.tmdbId,
        type: title.type,
        title: title.title,
        year: title.year,
        rating: title.rating,
        status: status,
        householdRating: rating,
        addedById: members.isEmpty ? null : members[i % members.length].userId,
      ),
    );
  }
  await WatchlistItem.db.insert(session, items);
  session.log('Seeded the watchlist for ${household.name}.');
}
