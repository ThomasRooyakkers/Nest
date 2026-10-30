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
import 'package:nest_server/src/generated/admin_household_summary.dart'
    as _it78yatv;
import 'package:nest_server/src/generated/household_feature.dart' as _iez4op0n;
import 'package:nest_server/src/generated/household_member.dart' as _i9scnr3x;
import 'package:nest_server/src/generated/meals/meal_plan_entry.dart'
    as _i33h3ld7;
import 'package:nest_server/src/generated/meals/meal_slot.dart' as _iliwnvwg;
import 'package:nest_server/src/generated/my_household.dart' as _i87acs67;
import 'package:nest_server/src/generated/recipes/recipe.dart' as _iei9bazg;
import 'package:nest_server/src/generated/shopping/catalog_item.dart'
    as _iped7yon;
import 'package:nest_server/src/generated/shopping/new_shopping_item.dart'
    as _i97lm970;
import 'package:nest_server/src/generated/shopping/shopping_item.dart'
    as _i8kxgwhu;
import 'package:nest_server/src/generated/shopping/shopping_list.dart'
    as _iustknb5;
import 'package:nest_server/src/generated/shopping/store.dart' as _iq3p81du;
import 'package:nest_server/src/generated/tasks/task.dart' as _iw4rp4ni;
import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import 'admin_audit_log.dart' as _ihc3ja42;
import 'admin_household_summary.dart' as _isoedyc0;
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
import 'sign_up_invite.dart' as _izkprrmi;
import 'sign_up_mode.dart' as _i4y3a5ag;
import 'tasks/task.dart' as _i253is06;
import 'tasks/task_event.dart' as _iuwcsatz;
import 'tasks/task_recurrence.dart' as _ieirl7mq;
export 'admin_audit_log.dart';
export 'admin_household_summary.dart';
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
export 'sign_up_invite.dart';
export 'sign_up_mode.dart';
export 'tasks/task.dart';
export 'tasks/task_event.dart';
export 'tasks/task_recurrence.dart';

class Protocol extends _is.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static List<_isp.TableDefinition> get targetTableDefinitions => [
    _isp.TableDefinition(
      name: 'admin_audit_log',
      dartName: 'AdminAuditLog',
      schema: 'public',
      module: 'nest',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'adminId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'action',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'targetType',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'targetId',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'details',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'at',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'admin_audit_log_at_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'at',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'catalog_item',
      dartName: 'CatalogItem',
      schema: 'public',
      module: 'nest',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'householdId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'builtInKey',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'nameEn',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'nameNl',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'iconKey',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'category',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ShoppingCategory',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'catalog_item_fk_0',
          columns: ['householdId'],
          referenceTable: 'household',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'catalog_item_household_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'householdId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'catalog_item_built_in_key_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'builtInKey',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'household',
      dartName: 'Household',
      schema: 'public',
      module: 'nest',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:HouseholdStatus',
          columnDefault: '\'active\'',
        ),
        _isp.ColumnDefinition(
          name: 'enabledFeatures',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<protocol:HouseholdFeature>',
        ),
        _isp.ColumnDefinition(
          name: 'mealSlots',
          columnType: _isp.ColumnType.json,
          isNullable: true,
          dartType: 'List<protocol:MealSlot>?',
        ),
        _isp.ColumnDefinition(
          name: 'inviteCode',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'inviteExpiresAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'household_invite_code_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'inviteCode',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'meal_plan_entry',
      dartName: 'MealPlanEntry',
      schema: 'public',
      module: 'nest',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'householdId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'date',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'slot',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:MealSlot',
          columnDefault: '\'dinner\'',
        ),
        _isp.ColumnDefinition(
          name: 'recipeId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'freeText',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'\'',
        ),
        _isp.ColumnDefinition(
          name: 'servings',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'prepAheadNote',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'\'',
        ),
        _isp.ColumnDefinition(
          name: 'createdById',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'meal_plan_entry_fk_0',
          columns: ['householdId'],
          referenceTable: 'household',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'meal_plan_entry_fk_1',
          columns: ['recipeId'],
          referenceTable: 'recipe',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.setNull,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'meal_plan_entry_fk_2',
          columns: ['createdById'],
          referenceTable: 'nest_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.setNull,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'meal_plan_entry_day_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'householdId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'date',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'slot',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'membership',
      dartName: 'Membership',
      schema: 'public',
      module: 'nest',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'userId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'householdId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'role',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:MembershipRole',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'membership_fk_0',
          columns: ['userId'],
          referenceTable: 'nest_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'membership_fk_1',
          columns: ['householdId'],
          referenceTable: 'household',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'membership_user_household_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'householdId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'membership_household_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'householdId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'nest_user',
      dartName: 'NestUser',
      schema: 'public',
      module: 'nest',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'locale',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'en\'',
        ),
        _isp.ColumnDefinition(
          name: 'isSuperAdmin',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'disabledAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'nest_user_fk_0',
          columns: ['authUserId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'nest_user_auth_user_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'recipe',
      dartName: 'Recipe',
      schema: 'public',
      module: 'nest',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'householdId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'title',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'description',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'\'',
        ),
        _isp.ColumnDefinition(
          name: 'photoPath',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'servings',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '4',
        ),
        _isp.ColumnDefinition(
          name: 'prepMinutes',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'cookMinutes',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'tags',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<String>',
        ),
        _isp.ColumnDefinition(
          name: 'isFavorite',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'createdById',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'recipe_fk_0',
          columns: ['householdId'],
          referenceTable: 'household',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'recipe_fk_1',
          columns: ['createdById'],
          referenceTable: 'nest_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.setNull,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'recipe_household_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'householdId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'recipe_ingredient',
      dartName: 'RecipeIngredient',
      schema: 'public',
      module: 'nest',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'recipeId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'position',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'quantity',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _isp.ColumnDefinition(
          name: 'unit',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'\'',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'note',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'\'',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'recipe_ingredient_fk_0',
          columns: ['recipeId'],
          referenceTable: 'recipe',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'recipe_ingredient_recipe_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'recipeId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'recipe_step',
      dartName: 'RecipeStep',
      schema: 'public',
      module: 'nest',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'recipeId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'position',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'text',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'recipe_step_fk_0',
          columns: ['recipeId'],
          referenceTable: 'recipe',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'recipe_step_recipe_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'recipeId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'shopping_item',
      dartName: 'ShoppingItem',
      schema: 'public',
      module: 'nest',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'householdId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'listId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'catalogItemId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'spec',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'\'',
        ),
        _isp.ColumnDefinition(
          name: 'category',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ShoppingCategory',
        ),
        _isp.ColumnDefinition(
          name: 'iconKey',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'storeIds',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<int>',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ShoppingItemStatus',
        ),
        _isp.ColumnDefinition(
          name: 'statusChangedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'addedById',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'sourceRecipeId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'shopping_item_fk_0',
          columns: ['householdId'],
          referenceTable: 'household',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'shopping_item_fk_1',
          columns: ['listId'],
          referenceTable: 'shopping_list',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'shopping_item_fk_2',
          columns: ['catalogItemId'],
          referenceTable: 'catalog_item',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.setNull,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'shopping_item_fk_3',
          columns: ['addedById'],
          referenceTable: 'nest_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.setNull,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'shopping_item_list_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'listId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'shopping_item_list_catalog_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'listId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'catalogItemId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'shopping_list',
      dartName: 'ShoppingList',
      schema: 'public',
      module: 'nest',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'householdId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'memberIds',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<int>',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'shopping_list_fk_0',
          columns: ['householdId'],
          referenceTable: 'household',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'shopping_list_household_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'householdId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'sign_up_invite',
      dartName: 'SignUpInvite',
      schema: 'public',
      module: 'nest',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'email',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'householdId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'expiresAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'sign_up_invite_fk_0',
          columns: ['householdId'],
          referenceTable: 'household',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'sign_up_invite_email_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'email',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'store',
      dartName: 'Store',
      schema: 'public',
      module: 'nest',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'householdId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'color',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:StoreColor',
          columnDefault: '\'sage\'',
        ),
        _isp.ColumnDefinition(
          name: 'address',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'categoryOrder',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<protocol:ShoppingCategory>',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'store_fk_0',
          columns: ['householdId'],
          referenceTable: 'household',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'store_household_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'householdId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'task',
      dartName: 'Task',
      schema: 'public',
      module: 'nest',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'householdId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'title',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'notes',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'\'',
        ),
        _isp.ColumnDefinition(
          name: 'assigneeId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'dueDate',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'dueMinutes',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'recurrence',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:TaskRecurrence',
          columnDefault: '\'none\'',
        ),
        _isp.ColumnDefinition(
          name: 'doneAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'doneById',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'nextTaskId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'task_fk_0',
          columns: ['householdId'],
          referenceTable: 'household',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'task_fk_1',
          columns: ['assigneeId'],
          referenceTable: 'nest_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.setNull,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'task_fk_2',
          columns: ['doneById'],
          referenceTable: 'nest_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.setNull,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'task_household_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'householdId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    ..._iais.Protocol.targetTableDefinitions,
    ..._iacs.Protocol.targetTableDefinitions,
    ..._isp.Protocol.targetTableDefinitions,
  ];

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
      } on _is.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _ihc3ja42.AdminAuditLog) {
      return _ihc3ja42.AdminAuditLog.fromJson(data) as T;
    }
    if (t == _isoedyc0.AdminHouseholdSummary) {
      return _isoedyc0.AdminHouseholdSummary.fromJson(data) as T;
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
    if (t == _izkprrmi.SignUpInvite) {
      return _izkprrmi.SignUpInvite.fromJson(data) as T;
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
    if (t == _is.getType<_ihc3ja42.AdminAuditLog?>()) {
      return (data != null ? _ihc3ja42.AdminAuditLog.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_isoedyc0.AdminHouseholdSummary?>()) {
      return (data != null
              ? _isoedyc0.AdminHouseholdSummary.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ijonbu5t.Household?>()) {
      return (data != null ? _ijonbu5t.Household.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_idhxy0am.HouseholdFeature?>()) {
      return (data != null ? _idhxy0am.HouseholdFeature.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_itc130bt.HouseholdInvite?>()) {
      return (data != null ? _itc130bt.HouseholdInvite.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iv10erpj.HouseholdMember?>()) {
      return (data != null ? _iv10erpj.HouseholdMember.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_imk37xix.HouseholdStatus?>()) {
      return (data != null ? _imk37xix.HouseholdStatus.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ieufxm3y.MealPlanEntry?>()) {
      return (data != null ? _ieufxm3y.MealPlanEntry.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ig1w91gd.MealPlanEvent?>()) {
      return (data != null ? _ig1w91gd.MealPlanEvent.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_irc89x16.MealSlot?>()) {
      return (data != null ? _irc89x16.MealSlot.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iu35fd1a.Membership?>()) {
      return (data != null ? _iu35fd1a.Membership.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iur1rrwm.MembershipRole?>()) {
      return (data != null ? _iur1rrwm.MembershipRole.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i46wom1w.MyHousehold?>()) {
      return (data != null ? _i46wom1w.MyHousehold.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i11cf01m.NestErrorCode?>()) {
      return (data != null ? _i11cf01m.NestErrorCode.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_id4drunt.NestException?>()) {
      return (data != null ? _id4drunt.NestException.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iasjmgi7.NestUser?>()) {
      return (data != null ? _iasjmgi7.NestUser.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ihz7f6c5.Recipe?>()) {
      return (data != null ? _ihz7f6c5.Recipe.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ih8tv5ny.RecipeEvent?>()) {
      return (data != null ? _ih8tv5ny.RecipeEvent.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i2xp5czv.RecipeIngredient?>()) {
      return (data != null ? _i2xp5czv.RecipeIngredient.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i24txk3r.RecipeStep?>()) {
      return (data != null ? _i24txk3r.RecipeStep.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i7aj6ss6.ServerPing?>()) {
      return (data != null ? _i7aj6ss6.ServerPing.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i3qdje8t.AddedShoppingItems?>()) {
      return (data != null ? _i3qdje8t.AddedShoppingItems.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ivm0zj1y.CatalogItem?>()) {
      return (data != null ? _ivm0zj1y.CatalogItem.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ii7fl845.NewShoppingItem?>()) {
      return (data != null ? _ii7fl845.NewShoppingItem.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iplosgx6.ShoppingCategory?>()) {
      return (data != null ? _iplosgx6.ShoppingCategory.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iuoywej7.ShoppingEvent?>()) {
      return (data != null ? _iuoywej7.ShoppingEvent.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iiy01kib.ShoppingItem?>()) {
      return (data != null ? _iiy01kib.ShoppingItem.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ivkuu3ll.ShoppingItemStatus?>()) {
      return (data != null ? _ivkuu3ll.ShoppingItemStatus.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i8tkdv3k.ShoppingList?>()) {
      return (data != null ? _i8tkdv3k.ShoppingList.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_icm155bx.Store?>()) {
      return (data != null ? _icm155bx.Store.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ip61som0.StoreColor?>()) {
      return (data != null ? _ip61som0.StoreColor.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_izkprrmi.SignUpInvite?>()) {
      return (data != null ? _izkprrmi.SignUpInvite.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i4y3a5ag.SignUpMode?>()) {
      return (data != null ? _i4y3a5ag.SignUpMode.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i253is06.Task?>()) {
      return (data != null ? _i253is06.Task.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iuwcsatz.TaskEvent?>()) {
      return (data != null ? _iuwcsatz.TaskEvent.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ieirl7mq.TaskRecurrence?>()) {
      return (data != null ? _ieirl7mq.TaskRecurrence.fromJson(data) : null)
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
    if (t == _is.getType<List<_irc89x16.MealSlot>?>()) {
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
    if (t == _is.getType<List<_ieufxm3y.MealPlanEntry>?>()) {
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
    if (t == _is.getType<List<int>?>()) {
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
    if (t == _is.getType<List<_i2xp5czv.RecipeIngredient>?>()) {
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
    if (t == _is.getType<List<_i24txk3r.RecipeStep>?>()) {
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
    if (t == _is.getType<List<_ihz7f6c5.Recipe>?>()) {
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
    if (t == _is.getType<List<_i8tkdv3k.ShoppingList>?>()) {
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
    if (t == _is.getType<List<_icm155bx.Store>?>()) {
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
    if (t == _is.getType<List<_ivm0zj1y.CatalogItem>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_ivm0zj1y.CatalogItem>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == _is.getType<List<_iiy01kib.ShoppingItem>?>()) {
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
    if (t == _is.getType<List<_i253is06.Task>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i253is06.Task>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_it78yatv.AdminHouseholdSummary>) {
      return (data as List)
              .map((e) => deserialize<_it78yatv.AdminHouseholdSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i87acs67.MyHousehold>) {
      return (data as List)
              .map((e) => deserialize<_i87acs67.MyHousehold>(e))
              .toList()
          as T;
    }
    if (t == List<_i9scnr3x.HouseholdMember>) {
      return (data as List)
              .map((e) => deserialize<_i9scnr3x.HouseholdMember>(e))
              .toList()
          as T;
    }
    if (t == List<_iez4op0n.HouseholdFeature>) {
      return (data as List)
              .map((e) => deserialize<_iez4op0n.HouseholdFeature>(e))
              .toList()
          as T;
    }
    if (t == List<_iliwnvwg.MealSlot>) {
      return (data as List)
              .map((e) => deserialize<_iliwnvwg.MealSlot>(e))
              .toList()
          as T;
    }
    if (t == List<_i33h3ld7.MealPlanEntry>) {
      return (data as List)
              .map((e) => deserialize<_i33h3ld7.MealPlanEntry>(e))
              .toList()
          as T;
    }
    if (t == List<_iei9bazg.Recipe>) {
      return (data as List)
              .map((e) => deserialize<_iei9bazg.Recipe>(e))
              .toList()
          as T;
    }
    if (t == List<_iustknb5.ShoppingList>) {
      return (data as List)
              .map((e) => deserialize<_iustknb5.ShoppingList>(e))
              .toList()
          as T;
    }
    if (t == List<_iq3p81du.Store>) {
      return (data as List).map((e) => deserialize<_iq3p81du.Store>(e)).toList()
          as T;
    }
    if (t == List<_iped7yon.CatalogItem>) {
      return (data as List)
              .map((e) => deserialize<_iped7yon.CatalogItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i8kxgwhu.ShoppingItem>) {
      return (data as List)
              .map((e) => deserialize<_i8kxgwhu.ShoppingItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i97lm970.NewShoppingItem>) {
      return (data as List)
              .map((e) => deserialize<_i97lm970.NewShoppingItem>(e))
              .toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_iw4rp4ni.Task>) {
      return (data as List).map((e) => deserialize<_iw4rp4ni.Task>(e)).toList()
          as T;
    }
    try {
      return _iais.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacs.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _isp.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _ihc3ja42.AdminAuditLog => 'AdminAuditLog',
      _isoedyc0.AdminHouseholdSummary => 'AdminHouseholdSummary',
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
      _izkprrmi.SignUpInvite => 'SignUpInvite',
      _i4y3a5ag.SignUpMode => 'SignUpMode',
      _i253is06.Task => 'Task',
      _iuwcsatz.TaskEvent => 'TaskEvent',
      _ieirl7mq.TaskRecurrence => 'TaskRecurrence',
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
      case _ihc3ja42.AdminAuditLog():
        return 'AdminAuditLog';
      case _isoedyc0.AdminHouseholdSummary():
        return 'AdminHouseholdSummary';
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
      case _izkprrmi.SignUpInvite():
        return 'SignUpInvite';
      case _i4y3a5ag.SignUpMode():
        return 'SignUpMode';
      case _i253is06.Task():
        return 'Task';
      case _iuwcsatz.TaskEvent():
        return 'TaskEvent';
      case _ieirl7mq.TaskRecurrence():
        return 'TaskRecurrence';
    }
    className = _iais.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacs.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    className = _isp.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AdminAuditLog') {
      return deserialize<_ihc3ja42.AdminAuditLog>(data['data']);
    }
    if (dataClassName == 'AdminHouseholdSummary') {
      return deserialize<_isoedyc0.AdminHouseholdSummary>(data['data']);
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
    if (dataClassName == 'SignUpInvite') {
      return deserialize<_izkprrmi.SignUpInvite>(data['data']);
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
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iais.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacs.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _isp.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iais.Protocol().registerHostProtocol('nest', this);
    _iacs.Protocol().registerHostProtocol('nest', this);
  }

  @override
  _is.Table? getTableForType(Type t) {
    {
      var table = _iais.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _iacs.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _isp.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _ihc3ja42.AdminAuditLog:
        return _ihc3ja42.AdminAuditLog.t;
      case _ijonbu5t.Household:
        return _ijonbu5t.Household.t;
      case _ieufxm3y.MealPlanEntry:
        return _ieufxm3y.MealPlanEntry.t;
      case _iu35fd1a.Membership:
        return _iu35fd1a.Membership.t;
      case _iasjmgi7.NestUser:
        return _iasjmgi7.NestUser.t;
      case _ihz7f6c5.Recipe:
        return _ihz7f6c5.Recipe.t;
      case _i2xp5czv.RecipeIngredient:
        return _i2xp5czv.RecipeIngredient.t;
      case _i24txk3r.RecipeStep:
        return _i24txk3r.RecipeStep.t;
      case _ivm0zj1y.CatalogItem:
        return _ivm0zj1y.CatalogItem.t;
      case _iiy01kib.ShoppingItem:
        return _iiy01kib.ShoppingItem.t;
      case _i8tkdv3k.ShoppingList:
        return _i8tkdv3k.ShoppingList.t;
      case _icm155bx.Store:
        return _icm155bx.Store.t;
      case _izkprrmi.SignUpInvite:
        return _izkprrmi.SignUpInvite.t;
      case _i253is06.Task:
        return _i253is06.Task.t;
    }
    return null;
  }

  @override
  List<_isp.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

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
      return _iais.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacs.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
