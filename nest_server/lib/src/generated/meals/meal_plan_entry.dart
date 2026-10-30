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
import '../meals/meal_slot.dart' as _izm7s29y;
import '../nest_user.dart' as _ihr4yuyc;
import '../recipes/recipe.dart' as _ieuwfnog;

/// A planned meal: a recipe from the library or free text, for one meal
/// of one day. There is at most one entry per day and meal.
abstract class MealPlanEntry
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  MealPlanEntry._({
    this.id,
    required this.householdId,
    this.household,
    required this.date,
    _izm7s29y.MealSlot? slot,
    this.recipeId,
    this.recipe,
    String? freeText,
    this.servings,
    String? prepAheadNote,
    this.createdById,
    this.createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : slot = slot ?? _izm7s29y.MealSlot.dinner,
       freeText = freeText ?? '',
       prepAheadNote = prepAheadNote ?? '',
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory MealPlanEntry({
    int? id,
    required int householdId,
    _iaj5kvsg.Household? household,
    required DateTime date,
    _izm7s29y.MealSlot? slot,
    int? recipeId,
    _ieuwfnog.Recipe? recipe,
    String? freeText,
    int? servings,
    String? prepAheadNote,
    int? createdById,
    _ihr4yuyc.NestUser? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _MealPlanEntryImpl;

  factory MealPlanEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return MealPlanEntry(
      id: jsonSerialization['id'] as int?,
      householdId: jsonSerialization['householdId'] as int,
      household: jsonSerialization['household'] == null
          ? null
          : _imc1swab.Protocol().deserialize<_iaj5kvsg.Household>(
              jsonSerialization['household'],
            ),
      date: _is.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      slot: jsonSerialization['slot'] == null
          ? null
          : _izm7s29y.MealSlot.fromJson((jsonSerialization['slot'] as String)),
      recipeId: jsonSerialization['recipeId'] as int?,
      recipe: jsonSerialization['recipe'] == null
          ? null
          : _imc1swab.Protocol().deserialize<_ieuwfnog.Recipe>(
              jsonSerialization['recipe'],
            ),
      freeText: jsonSerialization['freeText'] as String?,
      servings: jsonSerialization['servings'] as int?,
      prepAheadNote: jsonSerialization['prepAheadNote'] as String?,
      createdById: jsonSerialization['createdById'] as int?,
      createdBy: jsonSerialization['createdBy'] == null
          ? null
          : _imc1swab.Protocol().deserialize<_ihr4yuyc.NestUser>(
              jsonSerialization['createdBy'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = MealPlanEntryTable();

  static const db = MealPlanEntryRepository._();

  @override
  int? id;

  int householdId;

  _iaj5kvsg.Household? household;

  /// Calendar day, as 00:00 UTC of that day (no time zone): the day is
  /// the same for everyone in the household.
  DateTime date;

  _izm7s29y.MealSlot slot;

  int? recipeId;

  /// The recipe to cook; null for a free-text meal.
  _ieuwfnog.Recipe? recipe;

  /// What to eat, e.g. "Pizza night". With a recipe, the server puts the
  /// recipe's title here, so the meal keeps its name when the recipe is
  /// deleted.
  String freeText;

  /// Servings to cook; null for the recipe's own servings.
  int? servings;

  /// Something to do in advance, e.g. "Take the chicken out of the freezer".
  String prepAheadNote;

  int? createdById;

  _ihr4yuyc.NestUser? createdBy;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [MealPlanEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  MealPlanEntry copyWith({
    int? id,
    int? householdId,
    _iaj5kvsg.Household? household,
    DateTime? date,
    _izm7s29y.MealSlot? slot,
    int? recipeId,
    _ieuwfnog.Recipe? recipe,
    String? freeText,
    int? servings,
    String? prepAheadNote,
    int? createdById,
    _ihr4yuyc.NestUser? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MealPlanEntry',
      if (id != null) 'id': id,
      'householdId': householdId,
      if (household != null) 'household': household?.toJson(),
      'date': date.toJson(),
      'slot': slot.toJson(),
      if (recipeId != null) 'recipeId': recipeId,
      if (recipe != null) 'recipe': recipe?.toJson(),
      'freeText': freeText,
      if (servings != null) 'servings': servings,
      'prepAheadNote': prepAheadNote,
      if (createdById != null) 'createdById': createdById,
      if (createdBy != null) 'createdBy': createdBy?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MealPlanEntry',
      if (id != null) 'id': id,
      'householdId': householdId,
      if (household != null) 'household': household?.toJsonForProtocol(),
      'date': date.toJson(),
      'slot': slot.toJson(),
      if (recipeId != null) 'recipeId': recipeId,
      if (recipe != null) 'recipe': recipe?.toJsonForProtocol(),
      'freeText': freeText,
      if (servings != null) 'servings': servings,
      'prepAheadNote': prepAheadNote,
      if (createdById != null) 'createdById': createdById,
      if (createdBy != null) 'createdBy': createdBy?.toJsonForProtocol(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static MealPlanEntryInclude include({
    _iaj5kvsg.HouseholdInclude? household,
    _ieuwfnog.RecipeInclude? recipe,
    _ihr4yuyc.NestUserInclude? createdBy,
  }) {
    return MealPlanEntryInclude._(
      household: household,
      recipe: recipe,
      createdBy: createdBy,
    );
  }

  static MealPlanEntryIncludeList includeList({
    _is.WhereExpressionBuilder<MealPlanEntryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<MealPlanEntryTable>? orderBy,
    _is.OrderByListBuilder<MealPlanEntryTable>? orderByList,
    MealPlanEntryInclude? include,
  }) {
    return MealPlanEntryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MealPlanEntry.t),
      orderByList: orderByList?.call(MealPlanEntry.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MealPlanEntryImpl extends MealPlanEntry {
  _MealPlanEntryImpl({
    int? id,
    required int householdId,
    _iaj5kvsg.Household? household,
    required DateTime date,
    _izm7s29y.MealSlot? slot,
    int? recipeId,
    _ieuwfnog.Recipe? recipe,
    String? freeText,
    int? servings,
    String? prepAheadNote,
    int? createdById,
    _ihr4yuyc.NestUser? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         householdId: householdId,
         household: household,
         date: date,
         slot: slot,
         recipeId: recipeId,
         recipe: recipe,
         freeText: freeText,
         servings: servings,
         prepAheadNote: prepAheadNote,
         createdById: createdById,
         createdBy: createdBy,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [MealPlanEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  MealPlanEntry copyWith({
    Object? id = _Undefined,
    int? householdId,
    Object? household = _Undefined,
    DateTime? date,
    _izm7s29y.MealSlot? slot,
    Object? recipeId = _Undefined,
    Object? recipe = _Undefined,
    String? freeText,
    Object? servings = _Undefined,
    String? prepAheadNote,
    Object? createdById = _Undefined,
    Object? createdBy = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MealPlanEntry(
      id: id is int? ? id : this.id,
      householdId: householdId ?? this.householdId,
      household: household is _iaj5kvsg.Household?
          ? household
          : this.household?.copyWith(),
      date: date ?? this.date,
      slot: slot ?? this.slot,
      recipeId: recipeId is int? ? recipeId : this.recipeId,
      recipe: recipe is _ieuwfnog.Recipe? ? recipe : this.recipe?.copyWith(),
      freeText: freeText ?? this.freeText,
      servings: servings is int? ? servings : this.servings,
      prepAheadNote: prepAheadNote ?? this.prepAheadNote,
      createdById: createdById is int? ? createdById : this.createdById,
      createdBy: createdBy is _ihr4yuyc.NestUser?
          ? createdBy
          : this.createdBy?.copyWith(),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class MealPlanEntryUpdateTable extends _is.UpdateTable<MealPlanEntryTable> {
  MealPlanEntryUpdateTable(super.table);

  _is.ColumnValue<int, int> householdId(int value) => _is.ColumnValue(
    table.householdId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> date(DateTime value) => _is.ColumnValue(
    table.date,
    value,
  );

  _is.ColumnValue<_izm7s29y.MealSlot, _izm7s29y.MealSlot> slot(
    _izm7s29y.MealSlot value,
  ) => _is.ColumnValue(
    table.slot,
    value,
  );

  _is.ColumnValue<int, int> recipeId(int? value) => _is.ColumnValue(
    table.recipeId,
    value,
  );

  _is.ColumnValue<String, String> freeText(String value) => _is.ColumnValue(
    table.freeText,
    value,
  );

  _is.ColumnValue<int, int> servings(int? value) => _is.ColumnValue(
    table.servings,
    value,
  );

  _is.ColumnValue<String, String> prepAheadNote(String value) =>
      _is.ColumnValue(
        table.prepAheadNote,
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

class MealPlanEntryTable extends _is.Table<int?> {
  MealPlanEntryTable({super.tableRelation})
    : super(tableName: 'meal_plan_entry') {
    updateTable = MealPlanEntryUpdateTable(this);
    householdId = _is.ColumnInt(
      'householdId',
      this,
    );
    date = _is.ColumnDateTime(
      'date',
      this,
    );
    slot = _is.ColumnEnum(
      'slot',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    recipeId = _is.ColumnInt(
      'recipeId',
      this,
    );
    freeText = _is.ColumnString(
      'freeText',
      this,
      hasDefault: true,
    );
    servings = _is.ColumnInt(
      'servings',
      this,
    );
    prepAheadNote = _is.ColumnString(
      'prepAheadNote',
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

  late final MealPlanEntryUpdateTable updateTable;

  late final _is.ColumnInt householdId;

  _iaj5kvsg.HouseholdTable? _household;

  /// Calendar day, as 00:00 UTC of that day (no time zone): the day is
  /// the same for everyone in the household.
  late final _is.ColumnDateTime date;

  late final _is.ColumnEnum<_izm7s29y.MealSlot> slot;

  late final _is.ColumnInt recipeId;

  /// The recipe to cook; null for a free-text meal.
  _ieuwfnog.RecipeTable? _recipe;

  /// What to eat, e.g. "Pizza night". With a recipe, the server puts the
  /// recipe's title here, so the meal keeps its name when the recipe is
  /// deleted.
  late final _is.ColumnString freeText;

  /// Servings to cook; null for the recipe's own servings.
  late final _is.ColumnInt servings;

  /// Something to do in advance, e.g. "Take the chicken out of the freezer".
  late final _is.ColumnString prepAheadNote;

  late final _is.ColumnInt createdById;

  _ihr4yuyc.NestUserTable? _createdBy;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  _iaj5kvsg.HouseholdTable get household {
    if (_household != null) return _household!;
    _household = _is.createRelationTable(
      relationFieldName: 'household',
      field: MealPlanEntry.t.householdId,
      foreignField: _iaj5kvsg.Household.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iaj5kvsg.HouseholdTable(tableRelation: foreignTableRelation),
    );
    return _household!;
  }

  _ieuwfnog.RecipeTable get recipe {
    if (_recipe != null) return _recipe!;
    _recipe = _is.createRelationTable(
      relationFieldName: 'recipe',
      field: MealPlanEntry.t.recipeId,
      foreignField: _ieuwfnog.Recipe.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ieuwfnog.RecipeTable(tableRelation: foreignTableRelation),
    );
    return _recipe!;
  }

  _ihr4yuyc.NestUserTable get createdBy {
    if (_createdBy != null) return _createdBy!;
    _createdBy = _is.createRelationTable(
      relationFieldName: 'createdBy',
      field: MealPlanEntry.t.createdById,
      foreignField: _ihr4yuyc.NestUser.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ihr4yuyc.NestUserTable(tableRelation: foreignTableRelation),
    );
    return _createdBy!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    householdId,
    date,
    slot,
    recipeId,
    freeText,
    servings,
    prepAheadNote,
    createdById,
    createdAt,
    updatedAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'household') {
      return household;
    }
    if (relationField == 'recipe') {
      return recipe;
    }
    if (relationField == 'createdBy') {
      return createdBy;
    }
    return null;
  }
}

class MealPlanEntryInclude extends _is.IncludeObject {
  MealPlanEntryInclude._({
    _iaj5kvsg.HouseholdInclude? household,
    _ieuwfnog.RecipeInclude? recipe,
    _ihr4yuyc.NestUserInclude? createdBy,
  }) {
    _household = household;
    _recipe = recipe;
    _createdBy = createdBy;
  }

  _iaj5kvsg.HouseholdInclude? _household;

  _ieuwfnog.RecipeInclude? _recipe;

  _ihr4yuyc.NestUserInclude? _createdBy;

  @override
  Map<String, _is.Include?> get includes => {
    'household': _household,
    'recipe': _recipe,
    'createdBy': _createdBy,
  };

  @override
  _is.Table<int?> get table => MealPlanEntry.t;
}

class MealPlanEntryIncludeList extends _is.IncludeList {
  MealPlanEntryIncludeList._({
    _is.WhereExpressionBuilder<MealPlanEntryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(MealPlanEntry.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => MealPlanEntry.t;
}

class MealPlanEntryRepository {
  const MealPlanEntryRepository._();

  final attachRow = const MealPlanEntryAttachRowRepository._();

  final detachRow = const MealPlanEntryDetachRowRepository._();

  /// Returns a list of [MealPlanEntry]s matching the given query parameters.
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
  Future<List<MealPlanEntry>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<MealPlanEntryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<MealPlanEntryTable>? orderBy,
    _is.OrderByListBuilder<MealPlanEntryTable>? orderByList,
    _is.Transaction? transaction,
    MealPlanEntryInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<MealPlanEntry>(
      where: where?.call(MealPlanEntry.t),
      orderBy: orderBy?.call(MealPlanEntry.t),
      orderByList: orderByList?.call(MealPlanEntry.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [MealPlanEntry] matching the given query parameters.
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
  Future<MealPlanEntry?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<MealPlanEntryTable>? where,
    int? offset,
    _is.OrderByBuilder<MealPlanEntryTable>? orderBy,
    _is.OrderByListBuilder<MealPlanEntryTable>? orderByList,
    _is.Transaction? transaction,
    MealPlanEntryInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<MealPlanEntry>(
      where: where?.call(MealPlanEntry.t),
      orderBy: orderBy?.call(MealPlanEntry.t),
      orderByList: orderByList?.call(MealPlanEntry.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [MealPlanEntry] by its [id] or null if no such row exists.
  Future<MealPlanEntry?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    MealPlanEntryInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<MealPlanEntry>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [MealPlanEntry]s in the list and returns the inserted rows.
  ///
  /// The returned [MealPlanEntry]s will have their `id` fields set.
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
  Future<List<MealPlanEntry>> insert(
    _is.DatabaseSession session,
    List<MealPlanEntry> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<MealPlanEntry>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [MealPlanEntry] and returns the inserted row.
  ///
  /// The returned [MealPlanEntry] will have its `id` field set.
  Future<MealPlanEntry> insertRow(
    _is.DatabaseSession session,
    MealPlanEntry row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<MealPlanEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [MealPlanEntry]s in the list and returns the resulting rows.
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
  /// The returned [MealPlanEntry]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<MealPlanEntry>> upsert(
    _is.DatabaseSession session,
    List<MealPlanEntry> rows, {
    required _is.ColumnSelections<MealPlanEntryTable> conflictColumns,
    _is.ColumnSelections<MealPlanEntryTable>? updateColumns,
    _is.WhereExpressionBuilder<MealPlanEntryTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<MealPlanEntry>(
      rows,
      conflictColumns: conflictColumns(MealPlanEntry.t),
      updateColumns: updateColumns?.call(MealPlanEntry.t),
      updateWhere: updateWhere?.call(MealPlanEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [MealPlanEntry] and returns the resulting row.
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
  /// The returned [MealPlanEntry] will have its `id` field set.
  Future<MealPlanEntry?> upsertRow(
    _is.DatabaseSession session,
    MealPlanEntry row, {
    required _is.ColumnSelections<MealPlanEntryTable> conflictColumns,
    _is.ColumnSelections<MealPlanEntryTable>? updateColumns,
    _is.WhereExpressionBuilder<MealPlanEntryTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<MealPlanEntry>(
      row,
      conflictColumns: conflictColumns(MealPlanEntry.t),
      updateColumns: updateColumns?.call(MealPlanEntry.t),
      updateWhere: updateWhere?.call(MealPlanEntry.t),
      transaction: transaction,
    );
  }

  /// Updates all [MealPlanEntry]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<MealPlanEntry>> update(
    _is.DatabaseSession session,
    List<MealPlanEntry> rows, {
    _is.ColumnSelections<MealPlanEntryTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<MealPlanEntry>(
      rows,
      columns: columns?.call(MealPlanEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [MealPlanEntry]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<MealPlanEntry> updateRow(
    _is.DatabaseSession session,
    MealPlanEntry row, {
    _is.ColumnSelections<MealPlanEntryTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<MealPlanEntry>(
      row,
      columns: columns?.call(MealPlanEntry.t),
      transaction: transaction,
    );
  }

  /// Updates a single [MealPlanEntry] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<MealPlanEntry?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<MealPlanEntryUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<MealPlanEntry>(
      id,
      columnValues: columnValues(MealPlanEntry.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [MealPlanEntry]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<MealPlanEntry>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<MealPlanEntryUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<MealPlanEntryTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<MealPlanEntryTable>? orderBy,
    _is.OrderByListBuilder<MealPlanEntryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<MealPlanEntry>(
      columnValues: columnValues(MealPlanEntry.t.updateTable),
      where: where(MealPlanEntry.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MealPlanEntry.t),
      orderByList: orderByList?.call(MealPlanEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [MealPlanEntry]s in the list and returns the deleted rows.
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
  Future<List<MealPlanEntry>> delete(
    _is.DatabaseSession session,
    List<MealPlanEntry> rows, {
    _is.OrderByBuilder<MealPlanEntryTable>? orderBy,
    _is.OrderByListBuilder<MealPlanEntryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<MealPlanEntry>(
      rows,
      orderBy: orderBy?.call(MealPlanEntry.t),
      orderByList: orderByList?.call(MealPlanEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [MealPlanEntry].
  Future<MealPlanEntry> deleteRow(
    _is.DatabaseSession session,
    MealPlanEntry row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<MealPlanEntry>(
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
  Future<List<MealPlanEntry>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<MealPlanEntryTable> where,
    _is.OrderByBuilder<MealPlanEntryTable>? orderBy,
    _is.OrderByListBuilder<MealPlanEntryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<MealPlanEntry>(
      where: where(MealPlanEntry.t),
      orderBy: orderBy?.call(MealPlanEntry.t),
      orderByList: orderByList?.call(MealPlanEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<MealPlanEntryTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<MealPlanEntry>(
      where: where?.call(MealPlanEntry.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [MealPlanEntry] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<MealPlanEntryTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<MealPlanEntry>(
      where: where(MealPlanEntry.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class MealPlanEntryAttachRowRepository {
  const MealPlanEntryAttachRowRepository._();

  /// Creates a relation between the given [MealPlanEntry] and [Household]
  /// by setting the [MealPlanEntry]'s foreign key `householdId` to refer to the [Household].
  Future<void> household(
    _is.DatabaseSession session,
    MealPlanEntry mealPlanEntry,
    _iaj5kvsg.Household household, {
    _is.Transaction? transaction,
  }) async {
    if (mealPlanEntry.id == null) {
      throw ArgumentError.notNull('mealPlanEntry.id');
    }
    if (household.id == null) {
      throw ArgumentError.notNull('household.id');
    }

    var $mealPlanEntry = mealPlanEntry.copyWith(householdId: household.id);
    await session.db.updateRow<MealPlanEntry>(
      $mealPlanEntry,
      columns: [MealPlanEntry.t.householdId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [MealPlanEntry] and [Recipe]
  /// by setting the [MealPlanEntry]'s foreign key `recipeId` to refer to the [Recipe].
  Future<void> recipe(
    _is.DatabaseSession session,
    MealPlanEntry mealPlanEntry,
    _ieuwfnog.Recipe recipe, {
    _is.Transaction? transaction,
  }) async {
    if (mealPlanEntry.id == null) {
      throw ArgumentError.notNull('mealPlanEntry.id');
    }
    if (recipe.id == null) {
      throw ArgumentError.notNull('recipe.id');
    }

    var $mealPlanEntry = mealPlanEntry.copyWith(recipeId: recipe.id);
    await session.db.updateRow<MealPlanEntry>(
      $mealPlanEntry,
      columns: [MealPlanEntry.t.recipeId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [MealPlanEntry] and [NestUser]
  /// by setting the [MealPlanEntry]'s foreign key `createdById` to refer to the [NestUser].
  Future<void> createdBy(
    _is.DatabaseSession session,
    MealPlanEntry mealPlanEntry,
    _ihr4yuyc.NestUser createdBy, {
    _is.Transaction? transaction,
  }) async {
    if (mealPlanEntry.id == null) {
      throw ArgumentError.notNull('mealPlanEntry.id');
    }
    if (createdBy.id == null) {
      throw ArgumentError.notNull('createdBy.id');
    }

    var $mealPlanEntry = mealPlanEntry.copyWith(createdById: createdBy.id);
    await session.db.updateRow<MealPlanEntry>(
      $mealPlanEntry,
      columns: [MealPlanEntry.t.createdById],
      transaction: transaction,
    );
  }
}

class MealPlanEntryDetachRowRepository {
  const MealPlanEntryDetachRowRepository._();

  /// Detaches the relation between this [MealPlanEntry] and the [Recipe] set in `recipe`
  /// by setting the [MealPlanEntry]'s foreign key `recipeId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> recipe(
    _is.DatabaseSession session,
    MealPlanEntry mealPlanEntry, {
    _is.Transaction? transaction,
  }) async {
    if (mealPlanEntry.id == null) {
      throw ArgumentError.notNull('mealPlanEntry.id');
    }

    var $mealPlanEntry = mealPlanEntry.copyWith(recipeId: null);
    await session.db.updateRow<MealPlanEntry>(
      $mealPlanEntry,
      columns: [MealPlanEntry.t.recipeId],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [MealPlanEntry] and the [NestUser] set in `createdBy`
  /// by setting the [MealPlanEntry]'s foreign key `createdById` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> createdBy(
    _is.DatabaseSession session,
    MealPlanEntry mealPlanEntry, {
    _is.Transaction? transaction,
  }) async {
    if (mealPlanEntry.id == null) {
      throw ArgumentError.notNull('mealPlanEntry.id');
    }

    var $mealPlanEntry = mealPlanEntry.copyWith(createdById: null);
    await session.db.updateRow<MealPlanEntry>(
      $mealPlanEntry,
      columns: [MealPlanEntry.t.createdById],
      transaction: transaction,
    );
  }
}
