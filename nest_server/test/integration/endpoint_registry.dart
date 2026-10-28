/// Every endpoint method of the server, classified. `endpoint_registry_test`
/// fails when a new method is not listed here, so it cannot skip the
/// isolation or admin tests.
library;

/// Household-scoped methods (start with `HouseholdGuard`). Each one must be
/// exercised in `isolation_test.dart`.
const householdScopedMethods = {
  'household.get',
  'household.members',
  'household.rename',
  'household.setFeatures',
  'household.createInvite',
  'household.revokeInvite',
  'household.leave',
  'shopping.lists',
  'shopping.saveList',
  'shopping.deleteList',
  'shopping.stores',
  'shopping.saveStore',
  'shopping.deleteStore',
  'shopping.catalog',
  'shopping.items',
  'shopping.addItem',
  'shopping.updateItem',
  'shopping.setItemStatus',
  'shopping.removeItem',
  'shopping.watch',
};

/// Admin methods (start with `AdminGuard`). Each one must be exercised in
/// `admin_access_test.dart`.
const adminMethods = {'adminHouseholds.list', 'adminHouseholds.setStatus'};

/// Methods that are deliberately not household-scoped.
const unscopedMethods = {
  // Serverpod auth module.
  'emailIdp.login',
  'emailIdp.startRegistration',
  'emailIdp.verifyRegistrationCode',
  'emailIdp.finishRegistration',
  'emailIdp.startPasswordReset',
  'emailIdp.verifyPasswordResetCode',
  'emailIdp.finishPasswordReset',
  'emailIdp.hasAccount',
  'jwtRefresh.refreshAccessToken',
  // Public health check, no data.
  'health.ping',
  // Only returns the caller's own memberships.
  'household.listMine',
  // Creates a new household for the caller.
  'household.create',
  // Access is granted by the invite code itself.
  'household.join',
  'signUp.redeemInvite',
  // The caller's own profile.
  'profile.me',
  'profile.updateMe',
};
