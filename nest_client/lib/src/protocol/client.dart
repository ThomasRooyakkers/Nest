/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'dart:typed_data' as _idt;
import 'package:http/http.dart' as _i85jenna;
import 'package:nest_client/src/protocol/admin_household_summary.dart'
    as _ipf5tkzm;
import 'package:nest_client/src/protocol/household_feature.dart' as _iejl7hre;
import 'package:nest_client/src/protocol/household_invite.dart' as _iidsgy2i;
import 'package:nest_client/src/protocol/household_member.dart' as _ihqqoxyh;
import 'package:nest_client/src/protocol/household_status.dart' as _iluf117q;
import 'package:nest_client/src/protocol/meals/meal_plan_entry.dart'
    as _i0zriapn;
import 'package:nest_client/src/protocol/meals/meal_plan_event.dart'
    as _i5lx2h1m;
import 'package:nest_client/src/protocol/meals/meal_slot.dart' as _iebxn6ex;
import 'package:nest_client/src/protocol/my_household.dart' as _itexq6j2;
import 'package:nest_client/src/protocol/nest_user.dart' as _i7k4hj0f;
import 'package:nest_client/src/protocol/recipes/recipe.dart' as _iexyob0t;
import 'package:nest_client/src/protocol/recipes/recipe_event.dart'
    as _im8ua6et;
import 'package:nest_client/src/protocol/server_ping.dart' as _i4l166nw;
import 'package:nest_client/src/protocol/shopping/added_shopping_items.dart'
    as _i2y92sha;
import 'package:nest_client/src/protocol/shopping/catalog_item.dart'
    as _it9evoh8;
import 'package:nest_client/src/protocol/shopping/new_shopping_item.dart'
    as _iw62wp9a;
import 'package:nest_client/src/protocol/shopping/shopping_event.dart'
    as _ik38nayf;
import 'package:nest_client/src/protocol/shopping/shopping_item.dart'
    as _ihcj2s21;
import 'package:nest_client/src/protocol/shopping/shopping_item_status.dart'
    as _iobprl20;
import 'package:nest_client/src/protocol/shopping/shopping_list.dart'
    as _i9yltxrs;
import 'package:nest_client/src/protocol/shopping/store.dart' as _i4n9gtf6;
import 'package:nest_client/src/protocol/tasks/task.dart' as _ipqeu8zh;
import 'package:nest_client/src/protocol/tasks/task_event.dart' as _i8pjkixi;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'protocol.dart' as _il2as5qe;

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
/// {@category Endpoint}
class EndpointEmailIdp extends _iaic.EndpointEmailIdpBase {
  EndpointEmailIdp(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// On an invite-only server, registration needs a redeemed invite code
  /// (see [SignUpPolicy]).
  @override
  _ida.Future<_isc.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<_iacc.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _ida.Future<String> verifyRegistrationCode({
    required _isc.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _ida.Future<_iacc.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _ida.Future<_isc.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _ida.Future<String> verifyPasswordResetCode({
    required _isc.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );

  @override
  _ida.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailIdp',
    'hasAccount',
    {},
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _iacc.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// If [refreshToken] is omitted, cookie-mode web clients fall back to the
  /// configured HttpOnly refresh cookie. When neither source is present this
  /// throws [RefreshTokenNotFoundException], the same public "no usable refresh
  /// credential" exception used for unknown refresh tokens.
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _ida.Future<_iacc.AuthSuccess> refreshAccessToken({String? refreshToken}) =>
      caller.callServerEndpoint<_iacc.AuthSuccess>(
        'jwtRefresh',
        'refreshAccessToken',
        {'refreshToken': refreshToken},
        authenticated: false,
      );
}

/// Household management for the admin portal. Metadata and counts only.
/// {@category Endpoint}
class EndpointAdminHouseholds extends _isc.EndpointRef {
  EndpointAdminHouseholds(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'adminHouseholds';

  /// All households with member counts and owner names.
  _ida.Future<List<_ipf5tkzm.AdminHouseholdSummary>> list() =>
      caller.callServerEndpoint<List<_ipf5tkzm.AdminHouseholdSummary>>(
        'adminHouseholds',
        'list',
        {},
      );

  /// Suspends or reactivates a household.
  _ida.Future<_ipf5tkzm.AdminHouseholdSummary> setStatus(
    int householdId,
    _iluf117q.HouseholdStatus status,
  ) => caller.callServerEndpoint<_ipf5tkzm.AdminHouseholdSummary>(
    'adminHouseholds',
    'setStatus',
    {
      'householdId': householdId,
      'status': status,
    },
  );
}

/// Public health check. Not household-scoped and returns no household data.
/// {@category Endpoint}
class EndpointHealth extends _isc.EndpointRef {
  EndpointHealth(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'health';

  /// Returns the server time, version, API levels and sign-up mode, so the
  /// app can show it is connected, check that it is a compatible Nest server
  /// and ask for an invite code when signing up needs one.
  _ida.Future<_i4l166nw.ServerPing> ping() =>
      caller.callServerEndpoint<_i4l166nw.ServerPing>(
        'health',
        'ping',
        {},
      );
}

/// Households, memberships and invite codes.
/// {@category Endpoint}
class EndpointHousehold extends _isc.EndpointRef {
  EndpointHousehold(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'household';

  /// Active households the signed-in user belongs to, sorted by name.
  _ida.Future<List<_itexq6j2.MyHousehold>> listMine() =>
      caller.callServerEndpoint<List<_itexq6j2.MyHousehold>>(
        'household',
        'listMine',
        {},
      );

  /// Creates a household with the signed-in user as owner.
  _ida.Future<_itexq6j2.MyHousehold> create(String name) =>
      caller.callServerEndpoint<_itexq6j2.MyHousehold>(
        'household',
        'create',
        {'name': name},
      );

  /// A household the signed-in user belongs to.
  _ida.Future<_itexq6j2.MyHousehold> get(int householdId) =>
      caller.callServerEndpoint<_itexq6j2.MyHousehold>(
        'household',
        'get',
        {'householdId': householdId},
      );

  /// Members of a household, owners first, then by name.
  _ida.Future<List<_ihqqoxyh.HouseholdMember>> members(int householdId) =>
      caller.callServerEndpoint<List<_ihqqoxyh.HouseholdMember>>(
        'household',
        'members',
        {'householdId': householdId},
      );

  /// Renames a household. Owners only.
  _ida.Future<_itexq6j2.MyHousehold> rename(
    int householdId,
    String name,
  ) => caller.callServerEndpoint<_itexq6j2.MyHousehold>(
    'household',
    'rename',
    {
      'householdId': householdId,
      'name': name,
    },
  );

  /// Switches features on or off for a household. Owners only.
  _ida.Future<_itexq6j2.MyHousehold> setFeatures(
    int householdId,
    List<_iejl7hre.HouseholdFeature> features,
  ) => caller.callServerEndpoint<_itexq6j2.MyHousehold>(
    'household',
    'setFeatures',
    {
      'householdId': householdId,
      'features': features,
    },
  );

  /// Chooses which meals besides dinner the household plans (breakfast,
  /// lunch). Owners only. Meals already planned in a slot that is switched
  /// off are kept, but not shown.
  _ida.Future<_itexq6j2.MyHousehold> setMealSlots(
    int householdId,
    List<_iebxn6ex.MealSlot> slots,
  ) => caller.callServerEndpoint<_itexq6j2.MyHousehold>(
    'household',
    'setMealSlots',
    {
      'householdId': householdId,
      'slots': slots,
    },
  );

  /// Creates a new invite code, replacing any previous one. Owners only.
  _ida.Future<_iidsgy2i.HouseholdInvite> createInvite(int householdId) =>
      caller.callServerEndpoint<_iidsgy2i.HouseholdInvite>(
        'household',
        'createInvite',
        {'householdId': householdId},
      );

  /// Removes the current invite code. Owners only.
  _ida.Future<void> revokeInvite(int householdId) =>
      caller.callServerEndpoint<void>(
        'household',
        'revokeInvite',
        {'householdId': householdId},
      );

  /// Joins the household that owns [code] as a member.
  _ida.Future<_itexq6j2.MyHousehold> join(String code) =>
      caller.callServerEndpoint<_itexq6j2.MyHousehold>(
        'household',
        'join',
        {'code': code},
      );

  /// Leaves a household. The last owner cannot leave while others remain.
  _ida.Future<void> leave(int householdId) => caller.callServerEndpoint<void>(
    'household',
    'leave',
    {'householdId': householdId},
  );
}

/// The household's meal plan: per day a dinner (and breakfast and lunch
/// where the household switched them on), from the recipe library or free
/// text. Every change is also sent to [watch], so all members see it live.
/// {@category Endpoint}
class EndpointMealPlan extends _isc.EndpointRef {
  EndpointMealPlan(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'mealPlan';

  /// Meals planned on the days from [from] up to (not including) [to].
  _ida.Future<List<_i0zriapn.MealPlanEntry>> entries(
    int householdId,
    DateTime from,
    DateTime to,
  ) => caller.callServerEndpoint<List<_i0zriapn.MealPlanEntry>>(
    'mealPlan',
    'entries',
    {
      'householdId': householdId,
      'from': from,
      'to': to,
    },
  );

  /// Plans a meal, or changes a planned one (when [entry] has an id),
  /// including moving it to another day.
  ///
  /// There is one meal per day and slot: a meal already planned there is
  /// replaced (a new entry takes its place and id; a moved one removes it).
  /// Returns every entry that changed.
  _ida.Future<_i5lx2h1m.MealPlanEvent> save(
    int householdId,
    _i0zriapn.MealPlanEntry entry,
  ) => caller.callServerEndpoint<_i5lx2h1m.MealPlanEvent>(
    'mealPlan',
    'save',
    {
      'householdId': householdId,
      'entry': entry,
    },
  );

  /// Removes a planned meal.
  _ida.Future<void> remove(
    int householdId,
    int entryId,
  ) => caller.callServerEndpoint<void>(
    'mealPlan',
    'remove',
    {
      'householdId': householdId,
      'entryId': entryId,
    },
  );

  /// Changes to the household's meal plan as they happen. The app loads
  /// the weeks it shows first and then applies these events.
  _ida.Stream<_i5lx2h1m.MealPlanEvent> watch(int householdId) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<_i5lx2h1m.MealPlanEvent>,
        _i5lx2h1m.MealPlanEvent
      >(
        'mealPlan',
        'watch',
        {'householdId': householdId},
        {},
      );
}

/// The signed-in user's own profile. Not household-scoped.
/// {@category Endpoint}
class EndpointProfile extends _isc.EndpointRef {
  EndpointProfile(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'profile';

  /// Returns the signed-in user, creating the Nest profile on first use.
  _ida.Future<_i7k4hj0f.NestUser> me() =>
      caller.callServerEndpoint<_i7k4hj0f.NestUser>(
        'profile',
        'me',
        {},
      );

  /// Updates the signed-in user's name and language.
  _ida.Future<_i7k4hj0f.NestUser> updateMe(
    String name,
    String locale,
  ) => caller.callServerEndpoint<_i7k4hj0f.NestUser>(
    'profile',
    'updateMe',
    {
      'name': name,
      'locale': locale,
    },
  );
}

/// The household's recipe library, with ingredients, steps and a photo.
/// Every change is also sent to [watch], so all members see it live.
///
/// Photos are kept in the server's private file storage, which is stored
/// in Postgres (so the database backup includes them), and only handed out
/// through [photo], after the guard.
/// {@category Endpoint}
class EndpointRecipe extends _isc.EndpointRef {
  EndpointRecipe(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'recipe';

  /// All of the household's recipes with their ingredients and steps.
  _ida.Future<List<_iexyob0t.Recipe>> recipes(int householdId) =>
      caller.callServerEndpoint<List<_iexyob0t.Recipe>>(
        'recipe',
        'recipes',
        {'householdId': householdId},
      );

  /// Creates a recipe (when [recipe] has no id) or saves its changes. The
  /// ingredients and steps are replaced by those of [recipe], numbered in
  /// the order given. The photo and favourite flag are not changed here
  /// (see [setPhoto] and [setFavorite]).
  _ida.Future<_iexyob0t.Recipe> save(
    int householdId,
    _iexyob0t.Recipe recipe,
  ) => caller.callServerEndpoint<_iexyob0t.Recipe>(
    'recipe',
    'save',
    {
      'householdId': householdId,
      'recipe': recipe,
    },
  );

  /// Marks a recipe as a favourite of the household, or not.
  _ida.Future<_iexyob0t.Recipe> setFavorite(
    int householdId,
    int recipeId,
    bool favorite,
  ) => caller.callServerEndpoint<_iexyob0t.Recipe>(
    'recipe',
    'setFavorite',
    {
      'householdId': householdId,
      'recipeId': recipeId,
      'favorite': favorite,
    },
  );

  /// Replaces a recipe's photo with [photo] (a JPEG, PNG or WebP image of
  /// at most [maxPhotoBytes]), or removes it when [photo] is null.
  _ida.Future<_iexyob0t.Recipe> setPhoto(
    int householdId,
    int recipeId,
    _idt.ByteData? photo,
  ) => caller.callServerEndpoint<_iexyob0t.Recipe>(
    'recipe',
    'setPhoto',
    {
      'householdId': householdId,
      'recipeId': recipeId,
      'photo': photo,
    },
  );

  /// The photo of a recipe, or null when it has none.
  _ida.Future<_idt.ByteData?> photo(
    int householdId,
    int recipeId,
  ) => caller.callServerEndpoint<_idt.ByteData?>(
    'recipe',
    'photo',
    {
      'householdId': householdId,
      'recipeId': recipeId,
    },
  );

  /// Deletes a recipe with its photo. Meal plans and shopping items that
  /// came from it keep their own copy of what they need.
  _ida.Future<void> remove(
    int householdId,
    int recipeId,
  ) => caller.callServerEndpoint<void>(
    'recipe',
    'remove',
    {
      'householdId': householdId,
      'recipeId': recipeId,
    },
  );

  /// Changes to the household's recipes as they happen. The app loads the
  /// recipes first and then applies these events.
  _ida.Stream<_im8ua6et.RecipeEvent> watch(int householdId) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<_im8ua6et.RecipeEvent>,
        _im8ua6et.RecipeEvent
      >(
        'recipe',
        'watch',
        {'householdId': householdId},
        {},
      );
}

/// Shopping lists, stores, the catalog and the items on the lists.
///
/// Every change is also sent to [watch], so all members see it live.
/// {@category Endpoint}
class EndpointShopping extends _isc.EndpointRef {
  EndpointShopping(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'shopping';

  /// The household's shopping lists, oldest first. Creates a first list
  /// (named in the caller's language) when the household has none yet.
  _ida.Future<List<_i9yltxrs.ShoppingList>> lists(int householdId) =>
      caller.callServerEndpoint<List<_i9yltxrs.ShoppingList>>(
        'shopping',
        'lists',
        {'householdId': householdId},
      );

  /// Creates a list (when [list] has no id) or renames it and changes its
  /// members.
  _ida.Future<_i9yltxrs.ShoppingList> saveList(
    int householdId,
    _i9yltxrs.ShoppingList list,
  ) => caller.callServerEndpoint<_i9yltxrs.ShoppingList>(
    'shopping',
    'saveList',
    {
      'householdId': householdId,
      'list': list,
    },
  );

  /// Deletes a list and its items. The last list cannot be deleted.
  _ida.Future<void> deleteList(
    int householdId,
    int listId,
  ) => caller.callServerEndpoint<void>(
    'shopping',
    'deleteList',
    {
      'householdId': householdId,
      'listId': listId,
    },
  );

  /// The household's stores, sorted by name.
  _ida.Future<List<_i4n9gtf6.Store>> stores(int householdId) =>
      caller.callServerEndpoint<List<_i4n9gtf6.Store>>(
        'shopping',
        'stores',
        {'householdId': householdId},
      );

  /// Creates a store (when [store] has no id) or updates it.
  _ida.Future<_i4n9gtf6.Store> saveStore(
    int householdId,
    _i4n9gtf6.Store store,
  ) => caller.callServerEndpoint<_i4n9gtf6.Store>(
    'shopping',
    'saveStore',
    {
      'householdId': householdId,
      'store': store,
    },
  );

  /// Deletes a store. Items limited to it become "any store" items when it
  /// was their only store.
  _ida.Future<void> deleteStore(
    int householdId,
    int storeId,
  ) => caller.callServerEndpoint<void>(
    'shopping',
    'deleteStore',
    {
      'householdId': householdId,
      'storeId': storeId,
    },
  );

  /// The built-in catalog plus the household's own items.
  _ida.Future<List<_it9evoh8.CatalogItem>> catalog(int householdId) =>
      caller.callServerEndpoint<List<_it9evoh8.CatalogItem>>(
        'shopping',
        'catalog',
        {'householdId': householdId},
      );

  /// All items on all of the household's lists.
  _ida.Future<List<_ihcj2s21.ShoppingItem>> items(int householdId) =>
      caller.callServerEndpoint<List<_ihcj2s21.ShoppingItem>>(
        'shopping',
        'items',
        {'householdId': householdId},
      );

  /// Puts an item on a list as "to buy".
  ///
  /// Without a catalog item id, [NewShoppingItem.name] is matched against the
  /// catalog (in both languages); an unknown name becomes one of the
  /// household's own catalog items. An item that is already on the list
  /// (also under Recently used) is moved to "to buy" instead of duplicated.
  _ida.Future<_ihcj2s21.ShoppingItem> addItem(
    int householdId,
    int listId,
    _iw62wp9a.NewShoppingItem newItem,
  ) => caller.callServerEndpoint<_ihcj2s21.ShoppingItem>(
    'shopping',
    'addItem',
    {
      'householdId': householdId,
      'listId': listId,
      'newItem': newItem,
    },
  );

  /// Puts several items on a list as "to buy", e.g. a recipe's
  /// ingredients. Like [addItem], but items that are already to buy are
  /// skipped (their spec is left alone). [sourceRecipeId] (one of the
  /// household's recipes) is noted on the items that are added.
  _ida.Future<_i2y92sha.AddedShoppingItems> addItems(
    int householdId,
    int listId,
    List<_iw62wp9a.NewShoppingItem> newItems,
    int? sourceRecipeId,
  ) => caller.callServerEndpoint<_i2y92sha.AddedShoppingItems>(
    'shopping',
    'addItems',
    {
      'householdId': householdId,
      'listId': listId,
      'newItems': newItems,
      'sourceRecipeId': sourceRecipeId,
    },
  );

  /// Changes an item's spec and stores.
  _ida.Future<_ihcj2s21.ShoppingItem> updateItem(
    int householdId,
    int itemId,
    String spec,
    List<int> storeIds,
  ) => caller.callServerEndpoint<_ihcj2s21.ShoppingItem>(
    'shopping',
    'updateItem',
    {
      'householdId': householdId,
      'itemId': itemId,
      'spec': spec,
      'storeIds': storeIds,
    },
  );

  /// Moves an item between "to buy" and "recently used".
  _ida.Future<_ihcj2s21.ShoppingItem> setItemStatus(
    int householdId,
    int itemId,
    _iobprl20.ShoppingItemStatus status,
  ) => caller.callServerEndpoint<_ihcj2s21.ShoppingItem>(
    'shopping',
    'setItemStatus',
    {
      'householdId': householdId,
      'itemId': itemId,
      'status': status,
    },
  );

  /// Removes an item from its list entirely (also from Recently used).
  _ida.Future<void> removeItem(
    int householdId,
    int itemId,
  ) => caller.callServerEndpoint<void>(
    'shopping',
    'removeItem',
    {
      'householdId': householdId,
      'itemId': itemId,
    },
  );

  /// Changes to the household's shopping data as they happen. The app loads
  /// the full data first and then applies these events.
  _ida.Stream<_ik38nayf.ShoppingEvent> watch(int householdId) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<_ik38nayf.ShoppingEvent>,
        _ik38nayf.ShoppingEvent
      >(
        'shopping',
        'watch',
        {'householdId': householdId},
        {},
      );
}

/// Sign-up with a household invite code, before the account exists. Not
/// household-scoped: access is granted by the invite code itself.
/// {@category Endpoint}
class EndpointSignUp extends _isc.EndpointRef {
  EndpointSignUp(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'signUp';

  /// Lets [email] create an account and join the household of
  /// [inviteCode] once it exists. Returns the household's name.
  _ida.Future<String> redeemInvite(
    String email,
    String inviteCode,
  ) => caller.callServerEndpoint<String>(
    'signUp',
    'redeemInvite',
    {
      'email': email,
      'inviteCode': inviteCode,
    },
  );
}

/// The household's tasks. Every change is also sent to [watch], so all
/// members see it live.
/// {@category Endpoint}
class EndpointTask extends _isc.EndpointRef {
  EndpointTask(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'task';

  /// Open tasks, and tasks done in the last [doneTasksKept].
  _ida.Future<List<_ipqeu8zh.Task>> tasks(int householdId) =>
      caller.callServerEndpoint<List<_ipqeu8zh.Task>>(
        'task',
        'tasks',
        {'householdId': householdId},
      );

  /// Creates a task (when [task] has no id) or changes its title, notes,
  /// assignee, due date and time, and recurrence.
  _ida.Future<_ipqeu8zh.Task> save(
    int householdId,
    _ipqeu8zh.Task task,
  ) => caller.callServerEndpoint<_ipqeu8zh.Task>(
    'task',
    'save',
    {
      'householdId': householdId,
      'task': task,
    },
  );

  /// Checks a task off or reopens it.
  ///
  /// Completing a recurring task creates its next occurrence, due on the
  /// first step after both its due date and [today] (the caller's calendar
  /// day). Reopening it removes that occurrence again unless it was done
  /// as well. Returns every task that changed.
  _ida.Future<_i8pjkixi.TaskEvent> setDone(
    int householdId,
    int taskId,
    bool done,
    DateTime today,
  ) => caller.callServerEndpoint<_i8pjkixi.TaskEvent>(
    'task',
    'setDone',
    {
      'householdId': householdId,
      'taskId': taskId,
      'done': done,
      'today': today,
    },
  );

  /// Deletes a task.
  _ida.Future<void> remove(
    int householdId,
    int taskId,
  ) => caller.callServerEndpoint<void>(
    'task',
    'remove',
    {
      'householdId': householdId,
      'taskId': taskId,
    },
  );

  /// Changes to the household's tasks as they happen. The app loads the
  /// tasks first and then applies these events.
  _ida.Stream<_i8pjkixi.TaskEvent> watch(int householdId) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<_i8pjkixi.TaskEvent>,
        _i8pjkixi.TaskEvent
      >(
        'task',
        'watch',
        {'householdId': householdId},
        {},
      );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _iaic.Caller(client);
    serverpod_auth_core = _iacc.Caller(client);
  }

  late final _iaic.Caller serverpod_auth_idp;

  late final _iacc.Caller serverpod_auth_core;
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
         host,
         _il2as5qe.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
       ) {
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    adminHouseholds = EndpointAdminHouseholds(this);
    health = EndpointHealth(this);
    household = EndpointHousehold(this);
    mealPlan = EndpointMealPlan(this);
    profile = EndpointProfile(this);
    recipe = EndpointRecipe(this);
    shopping = EndpointShopping(this);
    signUp = EndpointSignUp(this);
    task = EndpointTask(this);
    modules = Modules(this);
  }

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointAdminHouseholds adminHouseholds;

  late final EndpointHealth health;

  late final EndpointHousehold household;

  late final EndpointMealPlan mealPlan;

  late final EndpointProfile profile;

  late final EndpointRecipe recipe;

  late final EndpointShopping shopping;

  late final EndpointSignUp signUp;

  late final EndpointTask task;

  late final Modules modules;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'adminHouseholds': adminHouseholds,
    'health': health,
    'household': household,
    'mealPlan': mealPlan,
    'profile': profile,
    'recipe': recipe,
    'shopping': shopping,
    'signUp': signUp,
    'task': task,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
