/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:nest_server/src/generated/protocol.dart' as _imc1swab;
import 'package:serverpod/serverpod.dart' as _is;
import '../household.dart' as _iaj5kvsg;
import '../nest_user.dart' as _ihr4yuyc;
import '../recipes/recipe_ingredient.dart' as _i86ex859;
import '../recipes/recipe_step.dart' as _ifnvjxdn;

/// A recipe in the household's library.
abstract class Recipe implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Recipe._({
    this.id,
    required this.householdId,
    this.household,
    required this.title,
    String? description,
    this.photoPath,
    int? servings,
    this.prepMinutes,
    this.cookMinutes,
    required this.tags,
    bool? isFavorite,
    this.createdById,
    this.createdBy,
    this.ingredients,
    this.steps,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : description = description ?? '',
       servings = servings ?? 4,
       isFavorite = isFavorite ?? false,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Recipe({
    int? id,
    required int householdId,
    _iaj5kvsg.Household? household,
    required String title,
    String? description,
    String? photoPath,
    int? servings,
    int? prepMinutes,
    int? cookMinutes,
    required List<String> tags,
    bool? isFavorite,
    int? createdById,
    _ihr4yuyc.NestUser? createdBy,
    List<_i86ex859.RecipeIngredient>? ingredients,
    List<_ifnvjxdn.RecipeStep>? steps,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _RecipeImpl;

  factory Recipe.fromJson(Map<String, dynamic> jsonSerialization) {
    return Recipe(
      id: jsonSerialization['id'] as int?,
      householdId: jsonSerialization['householdId'] as int,
      household: jsonSerialization['household'] == null
          ? null
          : _imc1swab.Protocol().deserialize<_iaj5kvsg.Household>(
              jsonSerialization['household'],
            ),
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String?,
      photoPath: jsonSerialization['photoPath'] as String?,
      servings: jsonSerialization['servings'] as int?,
      prepMinutes: jsonSerialization['prepMinutes'] as int?,
      cookMinutes: jsonSerialization['cookMinutes'] as int?,
      tags: _imc1swab.Protocol().deserialize<List<String>>(
        jsonSerialization['tags'],
      ),
      isFavorite: jsonSerialization['isFavorite'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['isFavorite']),
      createdById: jsonSerialization['createdById'] as int?,
      createdBy: jsonSerialization['createdBy'] == null
          ? null
          : _imc1swab.Protocol().deserialize<_ihr4yuyc.NestUser>(
              jsonSerialization['createdBy'],
            ),
      ingredients: jsonSerialization['ingredients'] == null
          ? null
          : _imc1swab.Protocol().deserialize<List<_i86ex859.RecipeIngredient>>(
              jsonSerialization['ingredients'],
            ),
      steps: jsonSerialization['steps'] == null
          ? null
          : _imc1swab.Protocol().deserialize<List<_ifnvjxdn.RecipeStep>>(
              jsonSerialization['steps'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = RecipeTable();

  static const db = RecipeRepository._();

  @override
  int? id;

  int householdId;

  _iaj5kvsg.Household? household;

  String title;

  String description;

  /// Path of the photo in the server's private file storage (Postgres);
  /// null without a photo. A new photo gets a new path, so the app can
  /// cache photos by path.
  String? photoPath;

  /// Number of servings the ingredient amounts are for.
  int servings;

  int? prepMinutes;

  int? cookMinutes;

  List<String> tags;

  bool isFavorite;

  int? createdById;

  _ihr4yuyc.NestUser? createdBy;

  /// In order of [RecipeIngredient.position]; always included by the
  /// recipe endpoint.
  List<_i86ex859.RecipeIngredient>? ingredients;

  /// In order of [RecipeStep.position]; always included by the recipe
  /// endpoint.
  List<_ifnvjxdn.RecipeStep>? steps;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Recipe]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Recipe copyWith({
    int? id,
    int? householdId,
    _iaj5kvsg.Household? household,
    String? title,
    String? description,
    String? photoPath,
    int? servings,
    int? prepMinutes,
    int? cookMinutes,
    List<String>? tags,
    bool? isFavorite,
    int? createdById,
    _ihr4yuyc.NestUser? createdBy,
    List<_i86ex859.RecipeIngredient>? ingredients,
    List<_ifnvjxdn.RecipeStep>? steps,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Recipe',
      if (id != null) 'id': id,
      'householdId': householdId,
      if (household != null) 'household': household?.toJson(),
      'title': title,
      'description': description,
      if (photoPath != null) 'photoPath': photoPath,
      'servings': servings,
      if (prepMinutes != null) 'prepMinutes': prepMinutes,
      if (cookMinutes != null) 'cookMinutes': cookMinutes,
      'tags': tags.toJson(),
      'isFavorite': isFavorite,
      if (createdById != null) 'createdById': createdById,
      if (createdBy != null) 'createdBy': createdBy?.toJson(),
      if (ingredients != null)
        'ingredients': ingredients?.toJson(valueToJson: (v) => v.toJson()),
      if (steps != null) 'steps': steps?.toJson(valueToJson: (v) => v.toJson()),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Recipe',
      if (id != null) 'id': id,
      'householdId': householdId,
      if (household != null) 'household': household?.toJsonForProtocol(),
      'title': title,
      'description': description,
      if (photoPath != null) 'photoPath': photoPath,
      'servings': servings,
      if (prepMinutes != null) 'prepMinutes': prepMinutes,
      if (cookMinutes != null) 'cookMinutes': cookMinutes,
      'tags': tags.toJson(),
      'isFavorite': isFavorite,
      if (createdById != null) 'createdById': createdById,
      if (createdBy != null) 'createdBy': createdBy?.toJsonForProtocol(),
      if (ingredients != null)
        'ingredients': ingredients?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
      if (steps != null)
        'steps': steps?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static RecipeInclude include({
    _iaj5kvsg.HouseholdInclude? household,
    _ihr4yuyc.NestUserInclude? createdBy,
    _i86ex859.RecipeIngredientIncludeList? ingredients,
    _ifnvjxdn.RecipeStepIncludeList? steps,
  }) {
    return RecipeInclude._(
      household: household,
      createdBy: createdBy,
      ingredients: ingredients,
      steps: steps,
    );
  }

  static RecipeIncludeList includeList({
    _is.WhereExpressionBuilder<RecipeTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RecipeTable>? orderBy,
    _is.OrderByListBuilder<RecipeTable>? orderByList,
    RecipeInclude? include,
  }) {
    return RecipeIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Recipe.t),
      orderByList: orderByList?.call(Recipe.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RecipeImpl extends Recipe {
  _RecipeImpl({
    int? id,
    required int householdId,
    _iaj5kvsg.Household? household,
    required String title,
    String? description,
    String? photoPath,
    int? servings,
    int? prepMinutes,
    int? cookMinutes,
    required List<String> tags,
    bool? isFavorite,
    int? createdById,
    _ihr4yuyc.NestUser? createdBy,
    List<_i86ex859.RecipeIngredient>? ingredients,
    List<_ifnvjxdn.RecipeStep>? steps,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         householdId: householdId,
         household: household,
         title: title,
         description: description,
         photoPath: photoPath,
         servings: servings,
         prepMinutes: prepMinutes,
         cookMinutes: cookMinutes,
         tags: tags,
         isFavorite: isFavorite,
         createdById: createdById,
         createdBy: createdBy,
         ingredients: ingredients,
         steps: steps,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Recipe]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Recipe copyWith({
    Object? id = _Undefined,
    int? householdId,
    Object? household = _Undefined,
    String? title,
    String? description,
    Object? photoPath = _Undefined,
    int? servings,
    Object? prepMinutes = _Undefined,
    Object? cookMinutes = _Undefined,
    List<String>? tags,
    bool? isFavorite,
    Object? createdById = _Undefined,
    Object? createdBy = _Undefined,
    Object? ingredients = _Undefined,
    Object? steps = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Recipe(
      id: id is int? ? id : this.id,
      householdId: householdId ?? this.householdId,
      household: household is _iaj5kvsg.Household?
          ? household
          : this.household?.copyWith(),
      title: title ?? this.title,
      description: description ?? this.description,
      photoPath: photoPath is String? ? photoPath : this.photoPath,
      servings: servings ?? this.servings,
      prepMinutes: prepMinutes is int? ? prepMinutes : this.prepMinutes,
      cookMinutes: cookMinutes is int? ? cookMinutes : this.cookMinutes,
      tags: tags ?? this.tags.map((e0) => e0).toList(),
      isFavorite: isFavorite ?? this.isFavorite,
      createdById: createdById is int? ? createdById : this.createdById,
      createdBy: createdBy is _ihr4yuyc.NestUser?
          ? createdBy
          : this.createdBy?.copyWith(),
      ingredients: ingredients is List<_i86ex859.RecipeIngredient>?
          ? ingredients
          : this.ingredients?.map((e0) => e0.copyWith()).toList(),
      steps: steps is List<_ifnvjxdn.RecipeStep>?
          ? steps
          : this.steps?.map((e0) => e0.copyWith()).toList(),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class RecipeUpdateTable extends _is.UpdateTable<RecipeTable> {
  RecipeUpdateTable(super.table);

  _is.ColumnValue<int, int> householdId(int value) => _is.ColumnValue(
    table.householdId,
    value,
  );

  _is.ColumnValue<String, String> title(String value) => _is.ColumnValue(
    table.title,
    value,
  );

  _is.ColumnValue<String, String> description(String value) => _is.ColumnValue(
    table.description,
    value,
  );

  _is.ColumnValue<String, String> photoPath(String? value) => _is.ColumnValue(
    table.photoPath,
    value,
  );

  _is.ColumnValue<int, int> servings(int value) => _is.ColumnValue(
    table.servings,
    value,
  );

  _is.ColumnValue<int, int> prepMinutes(int? value) => _is.ColumnValue(
    table.prepMinutes,
    value,
  );

  _is.ColumnValue<int, int> cookMinutes(int? value) => _is.ColumnValue(
    table.cookMinutes,
    value,
  );

  _is.ColumnValue<List<String>, List<String>> tags(List<String> value) =>
      _is.ColumnValue(
        table.tags,
        value,
      );

  _is.ColumnValue<bool, bool> isFavorite(bool value) => _is.ColumnValue(
    table.isFavorite,
    value,
  );

  _is.ColumnValue<int, int> createdById(int? value) => _is.ColumnValue(
    table.createdById,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _is.ColumnValue(
        table.updatedAt,
        value,
      );
}

class RecipeTable extends _is.Table<int?> {
  RecipeTable({super.tableRelation}) : super(tableName: 'recipe') {
    updateTable = RecipeUpdateTable(this);
    householdId = _is.ColumnInt(
      'householdId',
      this,
    );
    title = _is.ColumnString(
      'title',
      this,
    );
    description = _is.ColumnString(
      'description',
      this,
      hasDefault: true,
    );
    photoPath = _is.ColumnString(
      'photoPath',
      this,
    );
    servings = _is.ColumnInt(
      'servings',
      this,
      hasDefault: true,
    );
    prepMinutes = _is.ColumnInt(
      'prepMinutes',
      this,
    );
    cookMinutes = _is.ColumnInt(
      'cookMinutes',
      this,
    );
    tags = _is.ColumnSerializable<List<String>>(
      'tags',
      this,
    );
    isFavorite = _is.ColumnBool(
      'isFavorite',
      this,
      hasDefault: true,
    );
    createdById = _is.ColumnInt(
      'createdById',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    updatedAt = _is.ColumnDateTime(
      'updatedAt',
      this,
      hasDefault: true,
    );
  }

  late final RecipeUpdateTable updateTable;

  late final _is.ColumnInt householdId;

  _iaj5kvsg.HouseholdTable? _household;

  late final _is.ColumnString title;

  late final _is.ColumnString description;

  /// Path of the photo in the server's private file storage (Postgres);
  /// null without a photo. A new photo gets a new path, so the app can
  /// cache photos by path.
  late final _is.ColumnString photoPath;

  /// Number of servings the ingredient amounts are for.
  late final _is.ColumnInt servings;

  late final _is.ColumnInt prepMinutes;

  late final _is.ColumnInt cookMinutes;

  late final _is.ColumnSerializable<List<String>> tags;

  late final _is.ColumnBool isFavorite;

  late final _is.ColumnInt createdById;

  _ihr4yuyc.NestUserTable? _createdBy;

  /// In order of [RecipeIngredient.position]; always included by the
  /// recipe endpoint.
  _i86ex859.RecipeIngredientTable? ___ingredients;

  /// In order of [RecipeIngredient.position]; always included by the
  /// recipe endpoint.
  _is.ManyRelation<_i86ex859.RecipeIngredientTable>? _ingredients;

  /// In order of [RecipeStep.position]; always included by the recipe
  /// endpoint.
  _ifnvjxdn.RecipeStepTable? ___steps;

  /// In order of [RecipeStep.position]; always included by the recipe
  /// endpoint.
  _is.ManyRelation<_ifnvjxdn.RecipeStepTable>? _steps;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  _iaj5kvsg.HouseholdTable get household {
    if (_household != null) return _household!;
    _household = _is.createRelationTable(
      relationFieldName: 'household',
      field: Recipe.t.householdId,
      foreignField: _iaj5kvsg.Household.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iaj5kvsg.HouseholdTable(tableRelation: foreignTableRelation),
    );
    return _household!;
  }

  _ihr4yuyc.NestUserTable get createdBy {
    if (_createdBy != null) return _createdBy!;
    _createdBy = _is.createRelationTable(
      relationFieldName: 'createdBy',
      field: Recipe.t.createdById,
      foreignField: _ihr4yuyc.NestUser.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ihr4yuyc.NestUserTable(tableRelation: foreignTableRelation),
    );
    return _createdBy!;
  }

  _i86ex859.RecipeIngredientTable get __ingredients {
    if (___ingredients != null) return ___ingredients!;
    ___ingredients = _is.createRelationTable(
      relationFieldName: '__ingredients',
      field: Recipe.t.id,
      foreignField: _i86ex859.RecipeIngredient.t.recipeId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i86ex859.RecipeIngredientTable(tableRelation: foreignTableRelation),
    );
    return ___ingredients!;
  }

  _ifnvjxdn.RecipeStepTable get __steps {
    if (___steps != null) return ___steps!;
    ___steps = _is.createRelationTable(
      relationFieldName: '__steps',
      field: Recipe.t.id,
      foreignField: _ifnvjxdn.RecipeStep.t.recipeId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ifnvjxdn.RecipeStepTable(tableRelation: foreignTableRelation),
    );
    return ___steps!;
  }

  _is.ManyRelation<_i86ex859.RecipeIngredientTable> get ingredients {
    if (_ingredients != null) return _ingredients!;
    var relationTable = _is.createRelationTable(
      relationFieldName: 'ingredients',
      field: Recipe.t.id,
      foreignField: _i86ex859.RecipeIngredient.t.recipeId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i86ex859.RecipeIngredientTable(tableRelation: foreignTableRelation),
    );
    _ingredients = _is.ManyRelation<_i86ex859.RecipeIngredientTable>(
      tableWithRelations: relationTable,
      table: _i86ex859.RecipeIngredientTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _ingredients!;
  }

  _is.ManyRelation<_ifnvjxdn.RecipeStepTable> get steps {
    if (_steps != null) return _steps!;
    var relationTable = _is.createRelationTable(
      relationFieldName: 'steps',
      field: Recipe.t.id,
      foreignField: _ifnvjxdn.RecipeStep.t.recipeId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ifnvjxdn.RecipeStepTable(tableRelation: foreignTableRelation),
    );
    _steps = _is.ManyRelation<_ifnvjxdn.RecipeStepTable>(
      tableWithRelations: relationTable,
      table: _ifnvjxdn.RecipeStepTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _steps!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    householdId,
    title,
    description,
    photoPath,
    servings,
    prepMinutes,
    cookMinutes,
    tags,
    isFavorite,
    createdById,
    createdAt,
    updatedAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'household') {
      return household;
    }
    if (relationField == 'createdBy') {
      return createdBy;
    }
    if (relationField == 'ingredients') {
      return __ingredients;
    }
    if (relationField == 'steps') {
      return __steps;
    }
    return null;
  }
}

class RecipeInclude extends _is.IncludeObject {
  RecipeInclude._({
    _iaj5kvsg.HouseholdInclude? household,
    _ihr4yuyc.NestUserInclude? createdBy,
    _i86ex859.RecipeIngredientIncludeList? ingredients,
    _ifnvjxdn.RecipeStepIncludeList? steps,
  }) {
    _household = household;
    _createdBy = createdBy;
    _ingredients = ingredients;
    _steps = steps;
  }

  _iaj5kvsg.HouseholdInclude? _household;

  _ihr4yuyc.NestUserInclude? _createdBy;

  _i86ex859.RecipeIngredientIncludeList? _ingredients;

  _ifnvjxdn.RecipeStepIncludeList? _steps;

  @override
  Map<String, _is.Include?> get includes => {
    'household': _household,
    'createdBy': _createdBy,
    'ingredients': _ingredients,
    'steps': _steps,
  };

  @override
  _is.Table<int?> get table => Recipe.t;
}

class RecipeIncludeList extends _is.IncludeList {
  RecipeIncludeList._({
    _is.WhereExpressionBuilder<RecipeTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Recipe.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Recipe.t;
}

class RecipeRepository {
  const RecipeRepository._();

  final attach = const RecipeAttachRepository._();

  final attachRow = const RecipeAttachRowRepository._();

  final detachRow = const RecipeDetachRowRepository._();

  /// Returns a list of [Recipe]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Recipe>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RecipeTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RecipeTable>? orderBy,
    _is.OrderByListBuilder<RecipeTable>? orderByList,
    _is.Transaction? transaction,
    RecipeInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Recipe>(
      where: where?.call(Recipe.t),
      orderBy: orderBy?.call(Recipe.t),
      orderByList: orderByList?.call(Recipe.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Recipe] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Recipe?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RecipeTable>? where,
    int? offset,
    _is.OrderByBuilder<RecipeTable>? orderBy,
    _is.OrderByListBuilder<RecipeTable>? orderByList,
    _is.Transaction? transaction,
    RecipeInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Recipe>(
      where: where?.call(Recipe.t),
      orderBy: orderBy?.call(Recipe.t),
      orderByList: orderByList?.call(Recipe.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Recipe] by its [id] or null if no such row exists.
  Future<Recipe?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    RecipeInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Recipe>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Recipe]s in the list and returns the inserted rows.
  ///
  /// The returned [Recipe]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Recipe>> insert(
    _is.DatabaseSession session,
    List<Recipe> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Recipe>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Recipe] and returns the inserted row.
  ///
  /// The returned [Recipe] will have its `id` field set.
  Future<Recipe> insertRow(
    _is.DatabaseSession session,
    Recipe row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Recipe>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Recipe]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [Recipe]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Recipe>> upsert(
    _is.DatabaseSession session,
    List<Recipe> rows, {
    required _is.ColumnSelections<RecipeTable> conflictColumns,
    _is.ColumnSelections<RecipeTable>? updateColumns,
    _is.WhereExpressionBuilder<RecipeTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Recipe>(
      rows,
      conflictColumns: conflictColumns(Recipe.t),
      updateColumns: updateColumns?.call(Recipe.t),
      updateWhere: updateWhere?.call(Recipe.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Recipe] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [Recipe] will have its `id` field set.
  Future<Recipe?> upsertRow(
    _is.DatabaseSession session,
    Recipe row, {
    required _is.ColumnSelections<RecipeTable> conflictColumns,
    _is.ColumnSelections<RecipeTable>? updateColumns,
    _is.WhereExpressionBuilder<RecipeTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Recipe>(
      row,
      conflictColumns: conflictColumns(Recipe.t),
      updateColumns: updateColumns?.call(Recipe.t),
      updateWhere: updateWhere?.call(Recipe.t),
      transaction: transaction,
    );
  }

  /// Updates all [Recipe]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Recipe>> update(
    _is.DatabaseSession session,
    List<Recipe> rows, {
    _is.ColumnSelections<RecipeTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Recipe>(
      rows,
      columns: columns?.call(Recipe.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Recipe]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Recipe> updateRow(
    _is.DatabaseSession session,
    Recipe row, {
    _is.ColumnSelections<RecipeTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Recipe>(
      row,
      columns: columns?.call(Recipe.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Recipe] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Recipe?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<RecipeUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Recipe>(
      id,
      columnValues: columnValues(Recipe.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Recipe]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Recipe>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<RecipeUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<RecipeTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RecipeTable>? orderBy,
    _is.OrderByListBuilder<RecipeTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Recipe>(
      columnValues: columnValues(Recipe.t.updateTable),
      where: where(Recipe.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Recipe.t),
      orderByList: orderByList?.call(Recipe.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Recipe]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Recipe>> delete(
    _is.DatabaseSession session,
    List<Recipe> rows, {
    _is.OrderByBuilder<RecipeTable>? orderBy,
    _is.OrderByListBuilder<RecipeTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Recipe>(
      rows,
      orderBy: orderBy?.call(Recipe.t),
      orderByList: orderByList?.call(Recipe.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Recipe].
  Future<Recipe> deleteRow(
    _is.DatabaseSession session,
    Recipe row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Recipe>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Recipe>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RecipeTable> where,
    _is.OrderByBuilder<RecipeTable>? orderBy,
    _is.OrderByListBuilder<RecipeTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Recipe>(
      where: where(Recipe.t),
      orderBy: orderBy?.call(Recipe.t),
      orderByList: orderByList?.call(Recipe.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RecipeTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Recipe>(
      where: where?.call(Recipe.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Recipe] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RecipeTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Recipe>(
      where: where(Recipe.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class RecipeAttachRepository {
  const RecipeAttachRepository._();

  /// Creates a relation between this [Recipe] and the given [RecipeIngredient]s
  /// by setting each [RecipeIngredient]'s foreign key `recipeId` to refer to this [Recipe].
  Future<void> ingredients(
    _is.DatabaseSession session,
    Recipe recipe,
    List<_i86ex859.RecipeIngredient> recipeIngredient, {
    _is.Transaction? transaction,
  }) async {
    if (recipeIngredient.any((e) => e.id == null)) {
      throw ArgumentError.notNull('recipeIngredient.id');
    }
    if (recipe.id == null) {
      throw ArgumentError.notNull('recipe.id');
    }

    var $recipeIngredient = recipeIngredient
        .map((e) => e.copyWith(recipeId: recipe.id))
        .toList();
    await session.db.update<_i86ex859.RecipeIngredient>(
      $recipeIngredient,
      columns: [_i86ex859.RecipeIngredient.t.recipeId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [Recipe] and the given [RecipeStep]s
  /// by setting each [RecipeStep]'s foreign key `recipeId` to refer to this [Recipe].
  Future<void> steps(
    _is.DatabaseSession session,
    Recipe recipe,
    List<_ifnvjxdn.RecipeStep> recipeStep, {
    _is.Transaction? transaction,
  }) async {
    if (recipeStep.any((e) => e.id == null)) {
      throw ArgumentError.notNull('recipeStep.id');
    }
    if (recipe.id == null) {
      throw ArgumentError.notNull('recipe.id');
    }

    var $recipeStep = recipeStep
        .map((e) => e.copyWith(recipeId: recipe.id))
        .toList();
    await session.db.update<_ifnvjxdn.RecipeStep>(
      $recipeStep,
      columns: [_ifnvjxdn.RecipeStep.t.recipeId],
      transaction: transaction,
    );
  }
}

class RecipeAttachRowRepository {
  const RecipeAttachRowRepository._();

  /// Creates a relation between the given [Recipe] and [Household]
  /// by setting the [Recipe]'s foreign key `householdId` to refer to the [Household].
  Future<void> household(
    _is.DatabaseSession session,
    Recipe recipe,
    _iaj5kvsg.Household household, {
    _is.Transaction? transaction,
  }) async {
    if (recipe.id == null) {
      throw ArgumentError.notNull('recipe.id');
    }
    if (household.id == null) {
      throw ArgumentError.notNull('household.id');
    }

    var $recipe = recipe.copyWith(householdId: household.id);
    await session.db.updateRow<Recipe>(
      $recipe,
      columns: [Recipe.t.householdId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [Recipe] and [NestUser]
  /// by setting the [Recipe]'s foreign key `createdById` to refer to the [NestUser].
  Future<void> createdBy(
    _is.DatabaseSession session,
    Recipe recipe,
    _ihr4yuyc.NestUser createdBy, {
    _is.Transaction? transaction,
  }) async {
    if (recipe.id == null) {
      throw ArgumentError.notNull('recipe.id');
    }
    if (createdBy.id == null) {
      throw ArgumentError.notNull('createdBy.id');
    }

    var $recipe = recipe.copyWith(createdById: createdBy.id);
    await session.db.updateRow<Recipe>(
      $recipe,
      columns: [Recipe.t.createdById],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [Recipe] and the given [RecipeIngredient]
  /// by setting the [RecipeIngredient]'s foreign key `recipeId` to refer to this [Recipe].
  Future<void> ingredients(
    _is.DatabaseSession session,
    Recipe recipe,
    _i86ex859.RecipeIngredient recipeIngredient, {
    _is.Transaction? transaction,
  }) async {
    if (recipeIngredient.id == null) {
      throw ArgumentError.notNull('recipeIngredient.id');
    }
    if (recipe.id == null) {
      throw ArgumentError.notNull('recipe.id');
    }

    var $recipeIngredient = recipeIngredient.copyWith(recipeId: recipe.id);
    await session.db.updateRow<_i86ex859.RecipeIngredient>(
      $recipeIngredient,
      columns: [_i86ex859.RecipeIngredient.t.recipeId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [Recipe] and the given [RecipeStep]
  /// by setting the [RecipeStep]'s foreign key `recipeId` to refer to this [Recipe].
  Future<void> steps(
    _is.DatabaseSession session,
    Recipe recipe,
    _ifnvjxdn.RecipeStep recipeStep, {
    _is.Transaction? transaction,
  }) async {
    if (recipeStep.id == null) {
      throw ArgumentError.notNull('recipeStep.id');
    }
    if (recipe.id == null) {
      throw ArgumentError.notNull('recipe.id');
    }

    var $recipeStep = recipeStep.copyWith(recipeId: recipe.id);
    await session.db.updateRow<_ifnvjxdn.RecipeStep>(
      $recipeStep,
      columns: [_ifnvjxdn.RecipeStep.t.recipeId],
      transaction: transaction,
    );
  }
}

class RecipeDetachRowRepository {
  const RecipeDetachRowRepository._();

  /// Detaches the relation between this [Recipe] and the [NestUser] set in `createdBy`
  /// by setting the [Recipe]'s foreign key `createdById` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> createdBy(
    _is.DatabaseSession session,
    Recipe recipe, {
    _is.Transaction? transaction,
  }) async {
    if (recipe.id == null) {
      throw ArgumentError.notNull('recipe.id');
    }

    var $recipe = recipe.copyWith(createdById: null);
    await session.db.updateRow<Recipe>(
      $recipe,
      columns: [Recipe.t.createdById],
      transaction: transaction,
    );
  }
}
