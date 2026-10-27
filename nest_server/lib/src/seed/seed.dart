import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import '../generated/protocol.dart';

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

/// Fills an empty development database with sample data. Does nothing when
/// the first seed user already exists.
///
/// Feature fixtures (catalog, stores, recipes, tasks, watchlist) are added
/// here as the features are built.
Future<void> seed(Session session, {required String password}) async {
  if (session.serverpod.runMode == 'production') {
    throw StateError('Refusing to seed a production database.');
  }

  final emailIdp = AuthServices.getIdentityProvider<EmailIdp>();
  if (await emailIdp.admin.findAccount(
        session,
        email: seedUsers.first.email,
      ) !=
      null) {
    session.log('Seed data already present, nothing to do.');
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
