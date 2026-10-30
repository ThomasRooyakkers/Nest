/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:nest_client/src/protocol/admin/admin_audit_entry.dart'
    as _iu6tpcav;
import 'package:nest_client/src/protocol/admin/admin_household_summary.dart'
    as _ik1o4tpa;
import 'package:nest_client/src/protocol/admin/admin_user_summary.dart'
    as _iavs2480;
import 'package:nest_client/src/protocol/household_feature.dart' as _iejl7hre;
import 'package:nest_client/src/protocol/household_member.dart' as _ihqqoxyh;
import 'package:nest_client/src/protocol/meals/meal_plan_entry.dart'
    as _i0zriapn;
import 'package:nest_client/src/protocol/meals/meal_slot.dart' as _iebxn6ex;
import 'package:nest_client/src/protocol/my_household.dart' as _itexq6j2;
import 'package:nest_client/src/protocol/recipes/recipe.dart' as _iexyob0t;
import 'package:nest_client/src/protocol/shopping/catalog_item.dart'
    as _it9evoh8;
import 'package:nest_client/src/protocol/shopping/new_shopping_item.dart'
    as _iw62wp9a;
import 'package:nest_client/src/protocol/shopping/shopping_item.dart'
    as _ihcj2s21;
import 'package:nest_client/src/protocol/shopping/shopping_list.dart'
    as _i9yltxrs;
import 'package:nest_client/src/protocol/shopping/store.dart' as _i4n9gtf6;
import 'package:nest_client/src/protocol/tasks/task.dart' as _ipqeu8zh;
import 'package:nest_client/src/protocol/watchlist/tmdb_title.dart'
    as _ixjtjk6s;
import 'package:nest_client/src/protocol/watchlist/watchlist_item.dart'
    as _it1jqm16;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'admin/admin_audit_entry.dart' as _i0hg09us;
import 'admin/admin_audit_log.dart' as _iha05d3i;
import 'admin/admin_backups.dart' as _iwl7hvp6;
import 'admin/admin_household_summary.dart' as _i1ee57op;
import 'admin/admin_system_health.dart' as _i9cu0zbm;
import 'admin/admin_user_summary.dart' as _infu3osd;
import 'admin/backup_request.dart' as _iskrofwd;
import 'admin/backup_run.dart' as _iabyer0k;
import 'admin/backup_run_status.dart' as _io9tgzbh;
import 'household.dart' as _ijonbu5t;
import 'household_feature.dart' as _idhxy0am;
import 'household_invite.dart' as _itc130bt;
import 'household_member.dart' as _iv10erpj;
import 'household_status.dart' as _imk37xix;
import 'meals/meal_plan_entry.dart' as _ieufxm3y;
import 'meals/meal_plan_event.dart' as _ig1w91gd;
import 'meals/meal_slot.dart' as _irc89x16;
import 'membership.dart' as _iu35fd1a;
import 'membership_role.dart' as _iur1rrwm;
import 'my_household.dart' as _i46wom1w;
import 'nest_error_code.dart' as _i11cf01m;
import 'nest_exception.dart' as _id4drunt;
import 'nest_user.dart' as _iasjmgi7;
import 'recipes/recipe.dart' as _ihz7f6c5;
import 'recipes/recipe_event.dart' as _ih8tv5ny;
import 'recipes/recipe_ingredient.dart' as _i2xp5czv;
import 'recipes/recipe_step.dart' as _i24txk3r;
import 'server_ping.dart' as _i7aj6ss6;
import 'shopping/added_shopping_items.dart' as _i3qdje8t;
import 'shopping/catalog_item.dart' as _ivm0zj1y;
import 'shopping/new_shopping_item.dart' as _ii7fl845;
import 'shopping/shopping_category.dart' as _iplosgx6;
import 'shopping/shopping_event.dart' as _iuoywej7;
import 'shopping/shopping_item.dart' as _iiy01kib;
import 'shopping/shopping_item_status.dart' as _ivkuu3ll;
import 'shopping/shopping_list.dart' as _i8tkdv3k;
import 'shopping/store.dart' as _icm155bx;
import 'shopping/store_color.dart' as _ip61som0;
import 'sign_up_mode.dart' as _i4y3a5ag;
import 'tasks/task.dart' as _i253is06;
import 'tasks/task_event.dart' as _iuwcsatz;
import 'tasks/task_recurrence.dart' as _ieirl7mq;
import 'watchlist/tmdb_title.dart' as _inbfv6m4;
import 'watchlist/watch_status.dart' as _itdekt2o;
import 'watchlist/watch_type.dart' as _irhe6aqe;
import 'watchlist/watchlist_event.dart' as _i1vaprkc;
import 'watchlist/watchlist_item.dart' as _i28z76f1;
export 'admin/admin_audit_entry.dart';
export 'admin/admin_audit_log.dart';
export 'admin/admin_backups.dart';
export 'admin/admin_household_summary.dart';
export 'admin/admin_system_health.dart';
export 'admin/admin_user_summary.dart';
export 'admin/backup_request.dart';
export 'admin/backup_run.dart';
export 'admin/backup_run_status.dart';
export 'household.dart';
export 'household_feature.dart';
export 'household_invite.dart';
export 'household_member.dart';
export 'household_status.dart';
export 'meals/meal_plan_entry.dart';
export 'meals/meal_plan_event.dart';
export 'meals/meal_slot.dart';
export 'membership.dart';
export 'membership_role.dart';
export 'my_household.dart';
export 'nest_error_code.dart';
export 'nest_exception.dart';
export 'nest_user.dart';
export 'recipes/recipe.dart';
export 'recipes/recipe_event.dart';
export 'recipes/recipe_ingredient.dart';
export 'recipes/recipe_step.dart';
export 'server_ping.dart';
export 'shopping/added_shopping_items.dart';
export 'shopping/catalog_item.dart';
export 'shopping/new_shopping_item.dart';
export 'shopping/shopping_category.dart';
export 'shopping/shopping_event.dart';
export 'shopping/shopping_item.dart';
export 'shopping/shopping_item_status.dart';
export 'shopping/shopping_list.dart';
export 'shopping/store.dart';
export 'shopping/store_color.dart';
export 'sign_up_mode.dart';
export 'tasks/task.dart';
export 'tasks/task_event.dart';
export 'tasks/task_recurrence.dart';
export 'watchlist/tmdb_title.dart';
export 'watchlist/watch_status.dart';
export 'watchlist/watch_type.dart';
export 'watchlist/watchlist_event.dart';
export 'watchlist/watchlist_item.dart';
export 'client.dart';

class Protocol extends _isc.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i0hg09us.AdminAuditEntry) {
      return _i0hg09us.AdminAuditEntry.fromJson(data) as T;
    }
    if (t == _iha05d3i.AdminAuditLog) {
      return _iha05d3i.AdminAuditLog.fromJson(data) as T;
    }
    if (t == _iwl7hvp6.AdminBackups) {
      return _iwl7hvp6.AdminBackups.fromJson(data) as T;
    }
    if (t == _i1ee57op.AdminHouseholdSummary) {
      return _i1ee57op.AdminHouseholdSummary.fromJson(data) as T;
    }
    if (t == _i9cu0zbm.AdminSystemHealth) {
      return _i9cu0zbm.AdminSystemHealth.fromJson(data) as T;
    }
    if (t == _infu3osd.AdminUserSummary) {
      return _infu3osd.AdminUserSummary.fromJson(data) as T;
    }
    if (t == _iskrofwd.BackupRequest) {
      return _iskrofwd.BackupRequest.fromJson(data) as T;
    }
    if (t == _iabyer0k.BackupRun) {
      return _iabyer0k.BackupRun.fromJson(data) as T;
    }
    if (t == _io9tgzbh.BackupRunStatus) {
      return _io9tgzbh.BackupRunStatus.fromJson(data) as T;
    }
    if (t == _ijonbu5t.Household) {
      return _ijonbu5t.Household.fromJson(data) as T;
    }
    if (t == _idhxy0am.HouseholdFeature) {
      return _idhxy0am.HouseholdFeature.fromJson(data) as T;
    }
    if (t == _itc130bt.HouseholdInvite) {
      return _itc130bt.HouseholdInvite.fromJson(data) as T;
    }
    if (t == _iv10erpj.HouseholdMember) {
      return _iv10erpj.HouseholdMember.fromJson(data) as T;
    }
    if (t == _imk37xix.HouseholdStatus) {
      return _imk37xix.HouseholdStatus.fromJson(data) as T;
    }
    if (t == _ieufxm3y.MealPlanEntry) {
      return _ieufxm3y.MealPlanEntry.fromJson(data) as T;
    }
    if (t == _ig1w91gd.MealPlanEvent) {
      return _ig1w91gd.MealPlanEvent.fromJson(data) as T;
    }
    if (t == _irc89x16.MealSlot) {
      return _irc89x16.MealSlot.fromJson(data) as T;
    }
    if (t == _iu35fd1a.Membership) {
      return _iu35fd1a.Membership.fromJson(data) as T;
    }
    if (t == _iur1rrwm.MembershipRole) {
      return _iur1rrwm.MembershipRole.fromJson(data) as T;
    }
    if (t == _i46wom1w.MyHousehold) {
      return _i46wom1w.MyHousehold.fromJson(data) as T;
    }
    if (t == _i11cf01m.NestErrorCode) {
      return _i11cf01m.NestErrorCode.fromJson(data) as T;
    }
    if (t == _id4drunt.NestException) {
      return _id4drunt.NestException.fromJson(data) as T;
    }
    if (t == _iasjmgi7.NestUser) {
      return _iasjmgi7.NestUser.fromJson(data) as T;
    }
    if (t == _ihz7f6c5.Recipe) {
      return _ihz7f6c5.Recipe.fromJson(data) as T;
    }
    if (t == _ih8tv5ny.RecipeEvent) {
      return _ih8tv5ny.RecipeEvent.fromJson(data) as T;
    }
    if (t == _i2xp5czv.RecipeIngredient) {
      return _i2xp5czv.RecipeIngredient.fromJson(data) as T;
    }
    if (t == _i24txk3r.RecipeStep) {
      return _i24txk3r.RecipeStep.fromJson(data) as T;
    }
    if (t == _i7aj6ss6.ServerPing) {
      return _i7aj6ss6.ServerPing.fromJson(data) as T;
    }
    if (t == _i3qdje8t.AddedShoppingItems) {
      return _i3qdje8t.AddedShoppingItems.fromJson(data) as T;
    }
    if (t == _ivm0zj1y.CatalogItem) {
      return _ivm0zj1y.CatalogItem.fromJson(data) as T;
    }
    if (t == _ii7fl845.NewShoppingItem) {
      return _ii7fl845.NewShoppingItem.fromJson(data) as T;
    }
    if (t == _iplosgx6.ShoppingCategory) {
      return _iplosgx6.ShoppingCategory.fromJson(data) as T;
    }
    if (t == _iuoywej7.ShoppingEvent) {
      return _iuoywej7.ShoppingEvent.fromJson(data) as T;
    }
    if (t == _iiy01kib.ShoppingItem) {
      return _iiy01kib.ShoppingItem.fromJson(data) as T;
    }
    if (t == _ivkuu3ll.ShoppingItemStatus) {
      return _ivkuu3ll.ShoppingItemStatus.fromJson(data) as T;
    }
    if (t == _i8tkdv3k.ShoppingList) {
      return _i8tkdv3k.ShoppingList.fromJson(data) as T;
    }
    if (t == _icm155bx.Store) {
      return _icm155bx.Store.fromJson(data) as T;
    }
    if (t == _ip61som0.StoreColor) {
      return _ip61som0.StoreColor.fromJson(data) as T;
    }
    if (t == _i4y3a5ag.SignUpMode) {
      return _i4y3a5ag.SignUpMode.fromJson(data) as T;
    }
    if (t == _i253is06.Task) {
      return _i253is06.Task.fromJson(data) as T;
    }
    if (t == _iuwcsatz.TaskEvent) {
      return _iuwcsatz.TaskEvent.fromJson(data) as T;
    }
    if (t == _ieirl7mq.TaskRecurrence) {
      return _ieirl7mq.TaskRecurrence.fromJson(data) as T;
    }
    if (t == _inbfv6m4.TmdbTitle) {
      return _inbfv6m4.TmdbTitle.fromJson(data) as T;
    }
    if (t == _itdekt2o.WatchStatus) {
      return _itdekt2o.WatchStatus.fromJson(data) as T;
    }
    if (t == _irhe6aqe.WatchType) {
      return _irhe6aqe.WatchType.fromJson(data) as T;
    }
    if (t == _i1vaprkc.WatchlistEvent) {
      return _i1vaprkc.WatchlistEvent.fromJson(data) as T;
    }
    if (t == _i28z76f1.WatchlistItem) {
      return _i28z76f1.WatchlistItem.fromJson(data) as T;
    }
    if (t == _isc.getType<_i0hg09us.AdminAuditEntry?>()) {
      return (data != null ? _i0hg09us.AdminAuditEntry.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iha05d3i.AdminAuditLog?>()) {
      return (data != null ? _iha05d3i.AdminAuditLog.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iwl7hvp6.AdminBackups?>()) {
      return (data != null ? _iwl7hvp6.AdminBackups.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i1ee57op.AdminHouseholdSummary?>()) {
      return (data != null
              ? _i1ee57op.AdminHouseholdSummary.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i9cu0zbm.AdminSystemHealth?>()) {
      return (data != null ? _i9cu0zbm.AdminSystemHealth.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_infu3osd.AdminUserSummary?>()) {
      return (data != null ? _infu3osd.AdminUserSummary.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iskrofwd.BackupRequest?>()) {
      return (data != null ? _iskrofwd.BackupRequest.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iabyer0k.BackupRun?>()) {
      return (data != null ? _iabyer0k.BackupRun.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_io9tgzbh.BackupRunStatus?>()) {
      return (data != null ? _io9tgzbh.BackupRunStatus.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ijonbu5t.Household?>()) {
      return (data != null ? _ijonbu5t.Household.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_idhxy0am.HouseholdFeature?>()) {
      return (data != null ? _idhxy0am.HouseholdFeature.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_itc130bt.HouseholdInvite?>()) {
      return (data != null ? _itc130bt.HouseholdInvite.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iv10erpj.HouseholdMember?>()) {
      return (data != null ? _iv10erpj.HouseholdMember.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_imk37xix.HouseholdStatus?>()) {
      return (data != null ? _imk37xix.HouseholdStatus.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ieufxm3y.MealPlanEntry?>()) {
      return (data != null ? _ieufxm3y.MealPlanEntry.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ig1w91gd.MealPlanEvent?>()) {
      return (data != null ? _ig1w91gd.MealPlanEvent.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_irc89x16.MealSlot?>()) {
      return (data != null ? _irc89x16.MealSlot.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iu35fd1a.Membership?>()) {
      return (data != null ? _iu35fd1a.Membership.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iur1rrwm.MembershipRole?>()) {
      return (data != null ? _iur1rrwm.MembershipRole.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i46wom1w.MyHousehold?>()) {
      return (data != null ? _i46wom1w.MyHousehold.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i11cf01m.NestErrorCode?>()) {
      return (data != null ? _i11cf01m.NestErrorCode.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_id4drunt.NestException?>()) {
      return (data != null ? _id4drunt.NestException.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iasjmgi7.NestUser?>()) {
      return (data != null ? _iasjmgi7.NestUser.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ihz7f6c5.Recipe?>()) {
      return (data != null ? _ihz7f6c5.Recipe.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ih8tv5ny.RecipeEvent?>()) {
      return (data != null ? _ih8tv5ny.RecipeEvent.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i2xp5czv.RecipeIngredient?>()) {
      return (data != null ? _i2xp5czv.RecipeIngredient.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i24txk3r.RecipeStep?>()) {
      return (data != null ? _i24txk3r.RecipeStep.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i7aj6ss6.ServerPing?>()) {
      return (data != null ? _i7aj6ss6.ServerPing.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i3qdje8t.AddedShoppingItems?>()) {
      return (data != null ? _i3qdje8t.AddedShoppingItems.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ivm0zj1y.CatalogItem?>()) {
      return (data != null ? _ivm0zj1y.CatalogItem.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ii7fl845.NewShoppingItem?>()) {
      return (data != null ? _ii7fl845.NewShoppingItem.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iplosgx6.ShoppingCategory?>()) {
      return (data != null ? _iplosgx6.ShoppingCategory.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iuoywej7.ShoppingEvent?>()) {
      return (data != null ? _iuoywej7.ShoppingEvent.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iiy01kib.ShoppingItem?>()) {
      return (data != null ? _iiy01kib.ShoppingItem.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ivkuu3ll.ShoppingItemStatus?>()) {
      return (data != null ? _ivkuu3ll.ShoppingItemStatus.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i8tkdv3k.ShoppingList?>()) {
      return (data != null ? _i8tkdv3k.ShoppingList.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_icm155bx.Store?>()) {
      return (data != null ? _icm155bx.Store.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ip61som0.StoreColor?>()) {
      return (data != null ? _ip61som0.StoreColor.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i4y3a5ag.SignUpMode?>()) {
      return (data != null ? _i4y3a5ag.SignUpMode.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i253is06.Task?>()) {
      return (data != null ? _i253is06.Task.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iuwcsatz.TaskEvent?>()) {
      return (data != null ? _iuwcsatz.TaskEvent.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ieirl7mq.TaskRecurrence?>()) {
      return (data != null ? _ieirl7mq.TaskRecurrence.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_inbfv6m4.TmdbTitle?>()) {
      return (data != null ? _inbfv6m4.TmdbTitle.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_itdekt2o.WatchStatus?>()) {
      return (data != null ? _itdekt2o.WatchStatus.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_irhe6aqe.WatchType?>()) {
      return (data != null ? _irhe6aqe.WatchType.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i1vaprkc.WatchlistEvent?>()) {
      return (data != null ? _i1vaprkc.WatchlistEvent.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i28z76f1.WatchlistItem?>()) {
      return (data != null ? _i28z76f1.WatchlistItem.fromJson(data) : null)
          as T;
    }
    if (t == List<_iabyer0k.BackupRun>) {
      return (data as List)
              .map((e) => deserialize<_iabyer0k.BackupRun>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_idhxy0am.HouseholdFeature>) {
      return (data as List)
              .map((e) => deserialize<_idhxy0am.HouseholdFeature>(e))
              .toList()
          as T;
    }
    if (t == List<_irc89x16.MealSlot>) {
      return (data as List)
              .map((e) => deserialize<_irc89x16.MealSlot>(e))
              .toList()
          as T;
    }
    if (t == _isc.getType<List<_irc89x16.MealSlot>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_irc89x16.MealSlot>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_ieufxm3y.MealPlanEntry>) {
      return (data as List)
              .map((e) => deserialize<_ieufxm3y.MealPlanEntry>(e))
              .toList()
          as T;
    }
    if (t == _isc.getType<List<_ieufxm3y.MealPlanEntry>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_ieufxm3y.MealPlanEntry>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == _isc.getType<List<int>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<int>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i2xp5czv.RecipeIngredient>) {
      return (data as List)
              .map((e) => deserialize<_i2xp5czv.RecipeIngredient>(e))
              .toList()
          as T;
    }
    if (t == _isc.getType<List<_i2xp5czv.RecipeIngredient>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i2xp5czv.RecipeIngredient>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i24txk3r.RecipeStep>) {
      return (data as List)
              .map((e) => deserialize<_i24txk3r.RecipeStep>(e))
              .toList()
          as T;
    }
    if (t == _isc.getType<List<_i24txk3r.RecipeStep>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i24txk3r.RecipeStep>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_ihz7f6c5.Recipe>) {
      return (data as List)
              .map((e) => deserialize<_ihz7f6c5.Recipe>(e))
              .toList()
          as T;
    }
    if (t == _isc.getType<List<_ihz7f6c5.Recipe>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_ihz7f6c5.Recipe>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_iiy01kib.ShoppingItem>) {
      return (data as List)
              .map((e) => deserialize<_iiy01kib.ShoppingItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i8tkdv3k.ShoppingList>) {
      return (data as List)
              .map((e) => deserialize<_i8tkdv3k.ShoppingList>(e))
              .toList()
          as T;
    }
    if (t == _isc.getType<List<_i8tkdv3k.ShoppingList>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i8tkdv3k.ShoppingList>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_icm155bx.Store>) {
      return (data as List).map((e) => deserialize<_icm155bx.Store>(e)).toList()
          as T;
    }
    if (t == _isc.getType<List<_icm155bx.Store>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_icm155bx.Store>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_ivm0zj1y.CatalogItem>) {
      return (data as List)
              .map((e) => deserialize<_ivm0zj1y.CatalogItem>(e))
              .toList()
          as T;
    }
    if (t == _isc.getType<List<_ivm0zj1y.CatalogItem>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_ivm0zj1y.CatalogItem>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == _isc.getType<List<_iiy01kib.ShoppingItem>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_iiy01kib.ShoppingItem>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_iplosgx6.ShoppingCategory>) {
      return (data as List)
              .map((e) => deserialize<_iplosgx6.ShoppingCategory>(e))
              .toList()
          as T;
    }
    if (t == List<_i253is06.Task>) {
      return (data as List).map((e) => deserialize<_i253is06.Task>(e)).toList()
          as T;
    }
    if (t == _isc.getType<List<_i253is06.Task>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i253is06.Task>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i28z76f1.WatchlistItem>) {
      return (data as List)
              .map((e) => deserialize<_i28z76f1.WatchlistItem>(e))
              .toList()
          as T;
    }
    if (t == _isc.getType<List<_i28z76f1.WatchlistItem>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i28z76f1.WatchlistItem>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_iu6tpcav.AdminAuditEntry>) {
      return (data as List)
              .map((e) => deserialize<_iu6tpcav.AdminAuditEntry>(e))
              .toList()
          as T;
    }
    if (t == List<_ik1o4tpa.AdminHouseholdSummary>) {
      return (data as List)
              .map((e) => deserialize<_ik1o4tpa.AdminHouseholdSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_iavs2480.AdminUserSummary>) {
      return (data as List)
              .map((e) => deserialize<_iavs2480.AdminUserSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_itexq6j2.MyHousehold>) {
      return (data as List)
              .map((e) => deserialize<_itexq6j2.MyHousehold>(e))
              .toList()
          as T;
    }
    if (t == List<_ihqqoxyh.HouseholdMember>) {
      return (data as List)
              .map((e) => deserialize<_ihqqoxyh.HouseholdMember>(e))
              .toList()
          as T;
    }
    if (t == List<_iejl7hre.HouseholdFeature>) {
      return (data as List)
              .map((e) => deserialize<_iejl7hre.HouseholdFeature>(e))
              .toList()
          as T;
    }
    if (t == List<_iebxn6ex.MealSlot>) {
      return (data as List)
              .map((e) => deserialize<_iebxn6ex.MealSlot>(e))
              .toList()
          as T;
    }
    if (t == List<_i0zriapn.MealPlanEntry>) {
      return (data as List)
              .map((e) => deserialize<_i0zriapn.MealPlanEntry>(e))
              .toList()
          as T;
    }
    if (t == List<_iexyob0t.Recipe>) {
      return (data as List)
              .map((e) => deserialize<_iexyob0t.Recipe>(e))
              .toList()
          as T;
    }
    if (t == List<_i9yltxrs.ShoppingList>) {
      return (data as List)
              .map((e) => deserialize<_i9yltxrs.ShoppingList>(e))
              .toList()
          as T;
    }
    if (t == List<_i4n9gtf6.Store>) {
      return (data as List).map((e) => deserialize<_i4n9gtf6.Store>(e)).toList()
          as T;
    }
    if (t == List<_it9evoh8.CatalogItem>) {
      return (data as List)
              .map((e) => deserialize<_it9evoh8.CatalogItem>(e))
              .toList()
          as T;
    }
    if (t == List<_ihcj2s21.ShoppingItem>) {
      return (data as List)
              .map((e) => deserialize<_ihcj2s21.ShoppingItem>(e))
              .toList()
          as T;
    }
    if (t == List<_iw62wp9a.NewShoppingItem>) {
      return (data as List)
              .map((e) => deserialize<_iw62wp9a.NewShoppingItem>(e))
              .toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_ipqeu8zh.Task>) {
      return (data as List).map((e) => deserialize<_ipqeu8zh.Task>(e)).toList()
          as T;
    }
    if (t == List<_it1jqm16.WatchlistItem>) {
      return (data as List)
              .map((e) => deserialize<_it1jqm16.WatchlistItem>(e))
              .toList()
          as T;
    }
    if (t == List<_ixjtjk6s.TmdbTitle>) {
      return (data as List)
              .map((e) => deserialize<_ixjtjk6s.TmdbTitle>(e))
              .toList()
          as T;
    }
    try {
      return _iaic.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacc.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i0hg09us.AdminAuditEntry => 'AdminAuditEntry',
      _iha05d3i.AdminAuditLog => 'AdminAuditLog',
      _iwl7hvp6.AdminBackups => 'AdminBackups',
      _i1ee57op.AdminHouseholdSummary => 'AdminHouseholdSummary',
      _i9cu0zbm.AdminSystemHealth => 'AdminSystemHealth',
      _infu3osd.AdminUserSummary => 'AdminUserSummary',
      _iskrofwd.BackupRequest => 'BackupRequest',
      _iabyer0k.BackupRun => 'BackupRun',
      _io9tgzbh.BackupRunStatus => 'BackupRunStatus',
      _ijonbu5t.Household => 'Household',
      _idhxy0am.HouseholdFeature => 'HouseholdFeature',
      _itc130bt.HouseholdInvite => 'HouseholdInvite',
      _iv10erpj.HouseholdMember => 'HouseholdMember',
      _imk37xix.HouseholdStatus => 'HouseholdStatus',
      _ieufxm3y.MealPlanEntry => 'MealPlanEntry',
      _ig1w91gd.MealPlanEvent => 'MealPlanEvent',
      _irc89x16.MealSlot => 'MealSlot',
      _iu35fd1a.Membership => 'Membership',
      _iur1rrwm.MembershipRole => 'MembershipRole',
      _i46wom1w.MyHousehold => 'MyHousehold',
      _i11cf01m.NestErrorCode => 'NestErrorCode',
      _id4drunt.NestException => 'NestException',
      _iasjmgi7.NestUser => 'NestUser',
      _ihz7f6c5.Recipe => 'Recipe',
      _ih8tv5ny.RecipeEvent => 'RecipeEvent',
      _i2xp5czv.RecipeIngredient => 'RecipeIngredient',
      _i24txk3r.RecipeStep => 'RecipeStep',
      _i7aj6ss6.ServerPing => 'ServerPing',
      _i3qdje8t.AddedShoppingItems => 'AddedShoppingItems',
      _ivm0zj1y.CatalogItem => 'CatalogItem',
      _ii7fl845.NewShoppingItem => 'NewShoppingItem',
      _iplosgx6.ShoppingCategory => 'ShoppingCategory',
      _iuoywej7.ShoppingEvent => 'ShoppingEvent',
      _iiy01kib.ShoppingItem => 'ShoppingItem',
      _ivkuu3ll.ShoppingItemStatus => 'ShoppingItemStatus',
      _i8tkdv3k.ShoppingList => 'ShoppingList',
      _icm155bx.Store => 'Store',
      _ip61som0.StoreColor => 'StoreColor',
      _i4y3a5ag.SignUpMode => 'SignUpMode',
      _i253is06.Task => 'Task',
      _iuwcsatz.TaskEvent => 'TaskEvent',
      _ieirl7mq.TaskRecurrence => 'TaskRecurrence',
      _inbfv6m4.TmdbTitle => 'TmdbTitle',
      _itdekt2o.WatchStatus => 'WatchStatus',
      _irhe6aqe.WatchType => 'WatchType',
      _i1vaprkc.WatchlistEvent => 'WatchlistEvent',
      _i28z76f1.WatchlistItem => 'WatchlistItem',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('nest.', '');
    }

    switch (data) {
      case _i0hg09us.AdminAuditEntry():
        return 'AdminAuditEntry';
      case _iha05d3i.AdminAuditLog():
        return 'AdminAuditLog';
      case _iwl7hvp6.AdminBackups():
        return 'AdminBackups';
      case _i1ee57op.AdminHouseholdSummary():
        return 'AdminHouseholdSummary';
      case _i9cu0zbm.AdminSystemHealth():
        return 'AdminSystemHealth';
      case _infu3osd.AdminUserSummary():
        return 'AdminUserSummary';
      case _iskrofwd.BackupRequest():
        return 'BackupRequest';
      case _iabyer0k.BackupRun():
        return 'BackupRun';
      case _io9tgzbh.BackupRunStatus():
        return 'BackupRunStatus';
      case _ijonbu5t.Household():
        return 'Household';
      case _idhxy0am.HouseholdFeature():
        return 'HouseholdFeature';
      case _itc130bt.HouseholdInvite():
        return 'HouseholdInvite';
      case _iv10erpj.HouseholdMember():
        return 'HouseholdMember';
      case _imk37xix.HouseholdStatus():
        return 'HouseholdStatus';
      case _ieufxm3y.MealPlanEntry():
        return 'MealPlanEntry';
      case _ig1w91gd.MealPlanEvent():
        return 'MealPlanEvent';
      case _irc89x16.MealSlot():
        return 'MealSlot';
      case _iu35fd1a.Membership():
        return 'Membership';
      case _iur1rrwm.MembershipRole():
        return 'MembershipRole';
      case _i46wom1w.MyHousehold():
        return 'MyHousehold';
      case _i11cf01m.NestErrorCode():
        return 'NestErrorCode';
      case _id4drunt.NestException():
        return 'NestException';
      case _iasjmgi7.NestUser():
        return 'NestUser';
      case _ihz7f6c5.Recipe():
        return 'Recipe';
      case _ih8tv5ny.RecipeEvent():
        return 'RecipeEvent';
      case _i2xp5czv.RecipeIngredient():
        return 'RecipeIngredient';
      case _i24txk3r.RecipeStep():
        return 'RecipeStep';
      case _i7aj6ss6.ServerPing():
        return 'ServerPing';
      case _i3qdje8t.AddedShoppingItems():
        return 'AddedShoppingItems';
      case _ivm0zj1y.CatalogItem():
        return 'CatalogItem';
      case _ii7fl845.NewShoppingItem():
        return 'NewShoppingItem';
      case _iplosgx6.ShoppingCategory():
        return 'ShoppingCategory';
      case _iuoywej7.ShoppingEvent():
        return 'ShoppingEvent';
      case _iiy01kib.ShoppingItem():
        return 'ShoppingItem';
      case _ivkuu3ll.ShoppingItemStatus():
        return 'ShoppingItemStatus';
      case _i8tkdv3k.ShoppingList():
        return 'ShoppingList';
      case _icm155bx.Store():
        return 'Store';
      case _ip61som0.StoreColor():
        return 'StoreColor';
      case _i4y3a5ag.SignUpMode():
        return 'SignUpMode';
      case _i253is06.Task():
        return 'Task';
      case _iuwcsatz.TaskEvent():
        return 'TaskEvent';
      case _ieirl7mq.TaskRecurrence():
        return 'TaskRecurrence';
      case _inbfv6m4.TmdbTitle():
        return 'TmdbTitle';
      case _itdekt2o.WatchStatus():
        return 'WatchStatus';
      case _irhe6aqe.WatchType():
        return 'WatchType';
      case _i1vaprkc.WatchlistEvent():
        return 'WatchlistEvent';
      case _i28z76f1.WatchlistItem():
        return 'WatchlistItem';
    }
    className = _iaic.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacc.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AdminAuditEntry') {
      return deserialize<_i0hg09us.AdminAuditEntry>(data['data']);
    }
    if (dataClassName == 'AdminAuditLog') {
      return deserialize<_iha05d3i.AdminAuditLog>(data['data']);
    }
    if (dataClassName == 'AdminBackups') {
      return deserialize<_iwl7hvp6.AdminBackups>(data['data']);
    }
    if (dataClassName == 'AdminHouseholdSummary') {
      return deserialize<_i1ee57op.AdminHouseholdSummary>(data['data']);
    }
    if (dataClassName == 'AdminSystemHealth') {
      return deserialize<_i9cu0zbm.AdminSystemHealth>(data['data']);
    }
    if (dataClassName == 'AdminUserSummary') {
      return deserialize<_infu3osd.AdminUserSummary>(data['data']);
    }
    if (dataClassName == 'BackupRequest') {
      return deserialize<_iskrofwd.BackupRequest>(data['data']);
    }
    if (dataClassName == 'BackupRun') {
      return deserialize<_iabyer0k.BackupRun>(data['data']);
    }
    if (dataClassName == 'BackupRunStatus') {
      return deserialize<_io9tgzbh.BackupRunStatus>(data['data']);
    }
    if (dataClassName == 'Household') {
      return deserialize<_ijonbu5t.Household>(data['data']);
    }
    if (dataClassName == 'HouseholdFeature') {
      return deserialize<_idhxy0am.HouseholdFeature>(data['data']);
    }
    if (dataClassName == 'HouseholdInvite') {
      return deserialize<_itc130bt.HouseholdInvite>(data['data']);
    }
    if (dataClassName == 'HouseholdMember') {
      return deserialize<_iv10erpj.HouseholdMember>(data['data']);
    }
    if (dataClassName == 'HouseholdStatus') {
      return deserialize<_imk37xix.HouseholdStatus>(data['data']);
    }
    if (dataClassName == 'MealPlanEntry') {
      return deserialize<_ieufxm3y.MealPlanEntry>(data['data']);
    }
    if (dataClassName == 'MealPlanEvent') {
      return deserialize<_ig1w91gd.MealPlanEvent>(data['data']);
    }
    if (dataClassName == 'MealSlot') {
      return deserialize<_irc89x16.MealSlot>(data['data']);
    }
    if (dataClassName == 'Membership') {
      return deserialize<_iu35fd1a.Membership>(data['data']);
    }
    if (dataClassName == 'MembershipRole') {
      return deserialize<_iur1rrwm.MembershipRole>(data['data']);
    }
    if (dataClassName == 'MyHousehold') {
      return deserialize<_i46wom1w.MyHousehold>(data['data']);
    }
    if (dataClassName == 'NestErrorCode') {
      return deserialize<_i11cf01m.NestErrorCode>(data['data']);
    }
    if (dataClassName == 'NestException') {
      return deserialize<_id4drunt.NestException>(data['data']);
    }
    if (dataClassName == 'NestUser') {
      return deserialize<_iasjmgi7.NestUser>(data['data']);
    }
    if (dataClassName == 'Recipe') {
      return deserialize<_ihz7f6c5.Recipe>(data['data']);
    }
    if (dataClassName == 'RecipeEvent') {
      return deserialize<_ih8tv5ny.RecipeEvent>(data['data']);
    }
    if (dataClassName == 'RecipeIngredient') {
      return deserialize<_i2xp5czv.RecipeIngredient>(data['data']);
    }
    if (dataClassName == 'RecipeStep') {
      return deserialize<_i24txk3r.RecipeStep>(data['data']);
    }
    if (dataClassName == 'ServerPing') {
      return deserialize<_i7aj6ss6.ServerPing>(data['data']);
    }
    if (dataClassName == 'AddedShoppingItems') {
      return deserialize<_i3qdje8t.AddedShoppingItems>(data['data']);
    }
    if (dataClassName == 'CatalogItem') {
      return deserialize<_ivm0zj1y.CatalogItem>(data['data']);
    }
    if (dataClassName == 'NewShoppingItem') {
      return deserialize<_ii7fl845.NewShoppingItem>(data['data']);
    }
    if (dataClassName == 'ShoppingCategory') {
      return deserialize<_iplosgx6.ShoppingCategory>(data['data']);
    }
    if (dataClassName == 'ShoppingEvent') {
      return deserialize<_iuoywej7.ShoppingEvent>(data['data']);
    }
    if (dataClassName == 'ShoppingItem') {
      return deserialize<_iiy01kib.ShoppingItem>(data['data']);
    }
    if (dataClassName == 'ShoppingItemStatus') {
      return deserialize<_ivkuu3ll.ShoppingItemStatus>(data['data']);
    }
    if (dataClassName == 'ShoppingList') {
      return deserialize<_i8tkdv3k.ShoppingList>(data['data']);
    }
    if (dataClassName == 'Store') {
      return deserialize<_icm155bx.Store>(data['data']);
    }
    if (dataClassName == 'StoreColor') {
      return deserialize<_ip61som0.StoreColor>(data['data']);
    }
    if (dataClassName == 'SignUpMode') {
      return deserialize<_i4y3a5ag.SignUpMode>(data['data']);
    }
    if (dataClassName == 'Task') {
      return deserialize<_i253is06.Task>(data['data']);
    }
    if (dataClassName == 'TaskEvent') {
      return deserialize<_iuwcsatz.TaskEvent>(data['data']);
    }
    if (dataClassName == 'TaskRecurrence') {
      return deserialize<_ieirl7mq.TaskRecurrence>(data['data']);
    }
    if (dataClassName == 'TmdbTitle') {
      return deserialize<_inbfv6m4.TmdbTitle>(data['data']);
    }
    if (dataClassName == 'WatchStatus') {
      return deserialize<_itdekt2o.WatchStatus>(data['data']);
    }
    if (dataClassName == 'WatchType') {
      return deserialize<_irhe6aqe.WatchType>(data['data']);
    }
    if (dataClassName == 'WatchlistEvent') {
      return deserialize<_i1vaprkc.WatchlistEvent>(data['data']);
    }
    if (dataClassName == 'WatchlistItem') {
      return deserialize<_i28z76f1.WatchlistItem>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iaic.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacc.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iaic.Protocol().registerHostProtocol('nest', this);
    _iacc.Protocol().registerHostProtocol('nest', this);
  }

  @override
  String getModuleName() => 'nest';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iaic.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacc.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
