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
import '../recipes/recipe.dart' as _ieuwfnog;

/// A numbered step of a recipe. Only reachable through its recipe.
abstract class RecipeStep
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  RecipeStep._({
    this.id,
    required this.recipeId,
    this.recipe,
    required this.position,
    required this.text,
  });

  factory RecipeStep({
    int? id,
    required int recipeId,
    _ieuwfnog.Recipe? recipe,
    required int position,
    required String text,
  }) = _RecipeStepImpl;

  factory RecipeStep.fromJson(Map<String, dynamic> jsonSerialization) {
    return RecipeStep(
      id: jsonSerialization['id'] as int?,
      recipeId: jsonSerialization['recipeId'] as int,
      recipe: jsonSerialization['recipe'] == null
          ? null
          : _imc1swab.Protocol().deserialize<_ieuwfnog.Recipe>(
              jsonSerialization['recipe'],
            ),
      position: jsonSerialization['position'] as int,
      text: jsonSerialization['text'] as String,
    );
  }

  static final t = RecipeStepTable();

  static const db = RecipeStepRepository._();

  @override
  int? id;

  int recipeId;

  _ieuwfnog.Recipe? recipe;

  int position;

  String text;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [RecipeStep]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  RecipeStep copyWith({
    int? id,
    int? recipeId,
    _ieuwfnog.Recipe? recipe,
    int? position,
    String? text,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RecipeStep',
      if (id != null) 'id': id,
      'recipeId': recipeId,
      if (recipe != null) 'recipe': recipe?.toJson(),
      'position': position,
      'text': text,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RecipeStep',
      if (id != null) 'id': id,
      'recipeId': recipeId,
      if (recipe != null) 'recipe': recipe?.toJsonForProtocol(),
      'position': position,
      'text': text,
    };
  }

  static RecipeStepInclude include({_ieuwfnog.RecipeInclude? recipe}) {
    return RecipeStepInclude._(recipe: recipe);
  }

  static RecipeStepIncludeList includeList({
    _is.WhereExpressionBuilder<RecipeStepTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RecipeStepTable>? orderBy,
    _is.OrderByListBuilder<RecipeStepTable>? orderByList,
    RecipeStepInclude? include,
  }) {
    return RecipeStepIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RecipeStep.t),
      orderByList: orderByList?.call(RecipeStep.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RecipeStepImpl extends RecipeStep {
  _RecipeStepImpl({
    int? id,
    required int recipeId,
    _ieuwfnog.Recipe? recipe,
    required int position,
    required String text,
  }) : super._(
         id: id,
         recipeId: recipeId,
         recipe: recipe,
         position: position,
         text: text,
       );

  /// Returns a shallow copy of this [RecipeStep]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  RecipeStep copyWith({
    Object? id = _Undefined,
    int? recipeId,
    Object? recipe = _Undefined,
    int? position,
    String? text,
  }) {
    return RecipeStep(
      id: id is int? ? id : this.id,
      recipeId: recipeId ?? this.recipeId,
      recipe: recipe is _ieuwfnog.Recipe? ? recipe : this.recipe?.copyWith(),
      position: position ?? this.position,
      text: text ?? this.text,
    );
  }
}

class RecipeStepUpdateTable extends _is.UpdateTable<RecipeStepTable> {
  RecipeStepUpdateTable(super.table);

  _is.ColumnValue<int, int> recipeId(int value) => _is.ColumnValue(
    table.recipeId,
    value,
  );

  _is.ColumnValue<int, int> position(int value) => _is.ColumnValue(
    table.position,
    value,
  );

  _is.ColumnValue<String, String> text(String value) => _is.ColumnValue(
    table.text,
    value,
  );
}

class RecipeStepTable extends _is.Table<int?> {
  RecipeStepTable({super.tableRelation}) : super(tableName: 'recipe_step') {
    updateTable = RecipeStepUpdateTable(this);
    recipeId = _is.ColumnInt(
      'recipeId',
      this,
    );
    position = _is.ColumnInt(
      'position',
      this,
    );
    text = _is.ColumnString(
      'text',
      this,
    );
  }

  late final RecipeStepUpdateTable updateTable;

  late final _is.ColumnInt recipeId;

  _ieuwfnog.RecipeTable? _recipe;

  late final _is.ColumnInt position;

  late final _is.ColumnString text;

  _ieuwfnog.RecipeTable get recipe {
    if (_recipe != null) return _recipe!;
    _recipe = _is.createRelationTable(
      relationFieldName: 'recipe',
      field: RecipeStep.t.recipeId,
      foreignField: _ieuwfnog.Recipe.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ieuwfnog.RecipeTable(tableRelation: foreignTableRelation),
    );
    return _recipe!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    recipeId,
    position,
    text,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'recipe') {
      return recipe;
    }
    return null;
  }
}

class RecipeStepInclude extends _is.IncludeObject {
  RecipeStepInclude._({_ieuwfnog.RecipeInclude? recipe}) {
    _recipe = recipe;
  }

  _ieuwfnog.RecipeInclude? _recipe;

  @override
  Map<String, _is.Include?> get includes => {'recipe': _recipe};

  @override
  _is.Table<int?> get table => RecipeStep.t;
}

class RecipeStepIncludeList extends _is.IncludeList {
  RecipeStepIncludeList._({
    _is.WhereExpressionBuilder<RecipeStepTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RecipeStep.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => RecipeStep.t;
}

class RecipeStepRepository {
  const RecipeStepRepository._();

  final attachRow = const RecipeStepAttachRowRepository._();

  /// Returns a list of [RecipeStep]s matching the given query parameters.
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
  Future<List<RecipeStep>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RecipeStepTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RecipeStepTable>? orderBy,
    _is.OrderByListBuilder<RecipeStepTable>? orderByList,
    _is.Transaction? transaction,
    RecipeStepInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<RecipeStep>(
      where: where?.call(RecipeStep.t),
      orderBy: orderBy?.call(RecipeStep.t),
      orderByList: orderByList?.call(RecipeStep.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [RecipeStep] matching the given query parameters.
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
  Future<RecipeStep?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RecipeStepTable>? where,
    int? offset,
    _is.OrderByBuilder<RecipeStepTable>? orderBy,
    _is.OrderByListBuilder<RecipeStepTable>? orderByList,
    _is.Transaction? transaction,
    RecipeStepInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<RecipeStep>(
      where: where?.call(RecipeStep.t),
      orderBy: orderBy?.call(RecipeStep.t),
      orderByList: orderByList?.call(RecipeStep.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [RecipeStep] by its [id] or null if no such row exists.
  Future<RecipeStep?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    RecipeStepInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<RecipeStep>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [RecipeStep]s in the list and returns the inserted rows.
  ///
  /// The returned [RecipeStep]s will have their `id` fields set.
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
  Future<List<RecipeStep>> insert(
    _is.DatabaseSession session,
    List<RecipeStep> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<RecipeStep>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [RecipeStep] and returns the inserted row.
  ///
  /// The returned [RecipeStep] will have its `id` field set.
  Future<RecipeStep> insertRow(
    _is.DatabaseSession session,
    RecipeStep row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<RecipeStep>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [RecipeStep]s in the list and returns the resulting rows.
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
  /// The returned [RecipeStep]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RecipeStep>> upsert(
    _is.DatabaseSession session,
    List<RecipeStep> rows, {
    required _is.ColumnSelections<RecipeStepTable> conflictColumns,
    _is.ColumnSelections<RecipeStepTable>? updateColumns,
    _is.WhereExpressionBuilder<RecipeStepTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<RecipeStep>(
      rows,
      conflictColumns: conflictColumns(RecipeStep.t),
      updateColumns: updateColumns?.call(RecipeStep.t),
      updateWhere: updateWhere?.call(RecipeStep.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [RecipeStep] and returns the resulting row.
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
  /// The returned [RecipeStep] will have its `id` field set.
  Future<RecipeStep?> upsertRow(
    _is.DatabaseSession session,
    RecipeStep row, {
    required _is.ColumnSelections<RecipeStepTable> conflictColumns,
    _is.ColumnSelections<RecipeStepTable>? updateColumns,
    _is.WhereExpressionBuilder<RecipeStepTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<RecipeStep>(
      row,
      conflictColumns: conflictColumns(RecipeStep.t),
      updateColumns: updateColumns?.call(RecipeStep.t),
      updateWhere: updateWhere?.call(RecipeStep.t),
      transaction: transaction,
    );
  }

  /// Updates all [RecipeStep]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RecipeStep>> update(
    _is.DatabaseSession session,
    List<RecipeStep> rows, {
    _is.ColumnSelections<RecipeStepTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<RecipeStep>(
      rows,
      columns: columns?.call(RecipeStep.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [RecipeStep]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RecipeStep> updateRow(
    _is.DatabaseSession session,
    RecipeStep row, {
    _is.ColumnSelections<RecipeStepTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<RecipeStep>(
      row,
      columns: columns?.call(RecipeStep.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RecipeStep] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RecipeStep?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<RecipeStepUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<RecipeStep>(
      id,
      columnValues: columnValues(RecipeStep.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RecipeStep]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RecipeStep>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<RecipeStepUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<RecipeStepTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RecipeStepTable>? orderBy,
    _is.OrderByListBuilder<RecipeStepTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<RecipeStep>(
      columnValues: columnValues(RecipeStep.t.updateTable),
      where: where(RecipeStep.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RecipeStep.t),
      orderByList: orderByList?.call(RecipeStep.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [RecipeStep]s in the list and returns the deleted rows.
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
  Future<List<RecipeStep>> delete(
    _is.DatabaseSession session,
    List<RecipeStep> rows, {
    _is.OrderByBuilder<RecipeStepTable>? orderBy,
    _is.OrderByListBuilder<RecipeStepTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<RecipeStep>(
      rows,
      orderBy: orderBy?.call(RecipeStep.t),
      orderByList: orderByList?.call(RecipeStep.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [RecipeStep].
  Future<RecipeStep> deleteRow(
    _is.DatabaseSession session,
    RecipeStep row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RecipeStep>(
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
  Future<List<RecipeStep>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RecipeStepTable> where,
    _is.OrderByBuilder<RecipeStepTable>? orderBy,
    _is.OrderByListBuilder<RecipeStepTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<RecipeStep>(
      where: where(RecipeStep.t),
      orderBy: orderBy?.call(RecipeStep.t),
      orderByList: orderByList?.call(RecipeStep.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RecipeStepTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<RecipeStep>(
      where: where?.call(RecipeStep.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [RecipeStep] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RecipeStepTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<RecipeStep>(
      where: where(RecipeStep.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class RecipeStepAttachRowRepository {
  const RecipeStepAttachRowRepository._();

  /// Creates a relation between the given [RecipeStep] and [Recipe]
  /// by setting the [RecipeStep]'s foreign key `recipeId` to refer to the [Recipe].
  Future<void> recipe(
    _is.DatabaseSession session,
    RecipeStep recipeStep,
    _ieuwfnog.Recipe recipe, {
    _is.Transaction? transaction,
  }) async {
    if (recipeStep.id == null) {
      throw ArgumentError.notNull('recipeStep.id');
    }
    if (recipe.id == null) {
      throw ArgumentError.notNull('recipe.id');
    }

    var $recipeStep = recipeStep.copyWith(recipeId: recipe.id);
    await session.db.updateRow<RecipeStep>(
      $recipeStep,
      columns: [RecipeStep.t.recipeId],
      transaction: transaction,
    );
  }
}
