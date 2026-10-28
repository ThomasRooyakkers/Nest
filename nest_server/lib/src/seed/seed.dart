import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import '../generated/protocol.dart';
import '../services/built_in_catalog.dart';

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
/// Feature fixtures (recipes, tasks, watchlist) are added here as the
/// features are built.
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
    if (household != null) await _seedShopping(session, household);
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
