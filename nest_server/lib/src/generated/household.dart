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
import 'package:nest_server/src/generated/protocol.dart' as _imc1swab;
import 'package:serverpod/serverpod.dart' as _is;
import 'household_feature.dart' as _idhxy0am;
import 'household_status.dart' as _imk37xix;
import 'meals/meal_slot.dart' as _irc89x16;

/// A family. All feature data is scoped to a household.
abstract class Household
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Household._({
    this.id,
    required this.name,
    _imk37xix.HouseholdStatus? status,
    required this.enabledFeatures,
    this.mealSlots,
    this.inviteCode,
    this.inviteExpiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : status = status ?? _imk37xix.HouseholdStatus.active,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Household({
    int? id,
    required String name,
    _imk37xix.HouseholdStatus? status,
    required List<_idhxy0am.HouseholdFeature> enabledFeatures,
    List<_irc89x16.MealSlot>? mealSlots,
    String? inviteCode,
    DateTime? inviteExpiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _HouseholdImpl;

  factory Household.fromJson(Map<String, dynamic> jsonSerialization) {
    return Household(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      status: jsonSerialization['status'] == null
          ? null
          : _imk37xix.HouseholdStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      enabledFeatures: _imc1swab.Protocol()
          .deserialize<List<_idhxy0am.HouseholdFeature>>(
            jsonSerialization['enabledFeatures'],
          ),
      mealSlots: jsonSerialization['mealSlots'] == null
          ? null
          : _imc1swab.Protocol().deserialize<List<_irc89x16.MealSlot>>(
              jsonSerialization['mealSlots'],
            ),
      inviteCode: jsonSerialization['inviteCode'] as String?,
      inviteExpiresAt: jsonSerialization['inviteExpiresAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['inviteExpiresAt'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = HouseholdTable();

  static const db = HouseholdRepository._();

  @override
  int? id;

  String name;

  _imk37xix.HouseholdStatus status;

  /// Features switched on for this household.
  List<_idhxy0am.HouseholdFeature> enabledFeatures;

  /// Meals planned besides dinner (breakfast, lunch); null or empty for
  /// dinner only.
  List<_irc89x16.MealSlot>? mealSlots;

  /// Current invite code; only returned to owners.
  String? inviteCode;

  DateTime? inviteExpiresAt;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Household]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Household copyWith({
    int? id,
    String? name,
    _imk37xix.HouseholdStatus? status,
    List<_idhxy0am.HouseholdFeature>? enabledFeatures,
    List<_irc89x16.MealSlot>? mealSlots,
    String? inviteCode,
    DateTime? inviteExpiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Household',
      if (id != null) 'id': id,
      'name': name,
      'status': status.toJson(),
      'enabledFeatures': enabledFeatures.toJson(valueToJson: (v) => v.toJson()),
      if (mealSlots != null)
        'mealSlots': mealSlots?.toJson(valueToJson: (v) => v.toJson()),
      if (inviteCode != null) 'inviteCode': inviteCode,
      if (inviteExpiresAt != null) 'inviteExpiresAt': inviteExpiresAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Household',
      if (id != null) 'id': id,
      'name': name,
      'status': status.toJson(),
      'enabledFeatures': enabledFeatures.toJson(valueToJson: (v) => v.toJson()),
      if (mealSlots != null)
        'mealSlots': mealSlots?.toJson(valueToJson: (v) => v.toJson()),
      if (inviteCode != null) 'inviteCode': inviteCode,
      if (inviteExpiresAt != null) 'inviteExpiresAt': inviteExpiresAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static HouseholdInclude include() {
    return HouseholdInclude._();
  }

  static HouseholdIncludeList includeList({
    _is.WhereExpressionBuilder<HouseholdTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<HouseholdTable>? orderBy,
    _is.OrderByListBuilder<HouseholdTable>? orderByList,
    HouseholdInclude? include,
  }) {
    return HouseholdIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Household.t),
      orderByList: orderByList?.call(Household.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _HouseholdImpl extends Household {
  _HouseholdImpl({
    int? id,
    required String name,
    _imk37xix.HouseholdStatus? status,
    required List<_idhxy0am.HouseholdFeature> enabledFeatures,
    List<_irc89x16.MealSlot>? mealSlots,
    String? inviteCode,
    DateTime? inviteExpiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         name: name,
         status: status,
         enabledFeatures: enabledFeatures,
         mealSlots: mealSlots,
         inviteCode: inviteCode,
         inviteExpiresAt: inviteExpiresAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Household]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Household copyWith({
    Object? id = _Undefined,
    String? name,
    _imk37xix.HouseholdStatus? status,
    List<_idhxy0am.HouseholdFeature>? enabledFeatures,
    Object? mealSlots = _Undefined,
    Object? inviteCode = _Undefined,
    Object? inviteExpiresAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Household(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      enabledFeatures:
          enabledFeatures ?? this.enabledFeatures.map((e0) => e0).toList(),
      mealSlots: mealSlots is List<_irc89x16.MealSlot>?
          ? mealSlots
          : this.mealSlots?.map((e0) => e0).toList(),
      inviteCode: inviteCode is String? ? inviteCode : this.inviteCode,
      inviteExpiresAt: inviteExpiresAt is DateTime?
          ? inviteExpiresAt
          : this.inviteExpiresAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class HouseholdUpdateTable extends _is.UpdateTable<HouseholdTable> {
  HouseholdUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<_imk37xix.HouseholdStatus, _imk37xix.HouseholdStatus> status(
    _imk37xix.HouseholdStatus value,
  ) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<
    List<_idhxy0am.HouseholdFeature>,
    List<_idhxy0am.HouseholdFeature>
  >
  enabledFeatures(List<_idhxy0am.HouseholdFeature> value) => _is.ColumnValue(
    table.enabledFeatures,
    value,
  );

  _is.ColumnValue<List<_irc89x16.MealSlot>, List<_irc89x16.MealSlot>> mealSlots(
    List<_irc89x16.MealSlot>? value,
  ) => _is.ColumnValue(
    table.mealSlots,
    value,
  );

  _is.ColumnValue<String, String> inviteCode(String? value) => _is.ColumnValue(
    table.inviteCode,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> inviteExpiresAt(DateTime? value) =>
      _is.ColumnValue(
        table.inviteExpiresAt,
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

class HouseholdTable extends _is.Table<int?> {
  HouseholdTable({super.tableRelation}) : super(tableName: 'household') {
    updateTable = HouseholdUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
    status = _is.ColumnEnum(
      'status',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    enabledFeatures = _is.ColumnSerializable<List<_idhxy0am.HouseholdFeature>>(
      'enabledFeatures',
      this,
    );
    mealSlots = _is.ColumnSerializable<List<_irc89x16.MealSlot>>(
      'mealSlots',
      this,
    );
    inviteCode = _is.ColumnString(
      'inviteCode',
      this,
    );
    inviteExpiresAt = _is.ColumnDateTime(
      'inviteExpiresAt',
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

  late final HouseholdUpdateTable updateTable;

  late final _is.ColumnString name;

  late final _is.ColumnEnum<_imk37xix.HouseholdStatus> status;

  /// Features switched on for this household.
  late final _is.ColumnSerializable<List<_idhxy0am.HouseholdFeature>>
  enabledFeatures;

  /// Meals planned besides dinner (breakfast, lunch); null or empty for
  /// dinner only.
  late final _is.ColumnSerializable<List<_irc89x16.MealSlot>> mealSlots;

  /// Current invite code; only returned to owners.
  late final _is.ColumnString inviteCode;

  late final _is.ColumnDateTime inviteExpiresAt;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    name,
    status,
    enabledFeatures,
    mealSlots,
    inviteCode,
    inviteExpiresAt,
    createdAt,
    updatedAt,
  ];
}

class HouseholdInclude extends _is.IncludeObject {
  HouseholdInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Household.t;
}

class HouseholdIncludeList extends _is.IncludeList {
  HouseholdIncludeList._({
    _is.WhereExpressionBuilder<HouseholdTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Household.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Household.t;
}

class HouseholdRepository {
  const HouseholdRepository._();

  /// Returns a list of [Household]s matching the given query parameters.
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
  Future<List<Household>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<HouseholdTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<HouseholdTable>? orderBy,
    _is.OrderByListBuilder<HouseholdTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Household>(
      where: where?.call(Household.t),
      orderBy: orderBy?.call(Household.t),
      orderByList: orderByList?.call(Household.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Household] matching the given query parameters.
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
  Future<Household?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<HouseholdTable>? where,
    int? offset,
    _is.OrderByBuilder<HouseholdTable>? orderBy,
    _is.OrderByListBuilder<HouseholdTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Household>(
      where: where?.call(Household.t),
      orderBy: orderBy?.call(Household.t),
      orderByList: orderByList?.call(Household.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Household] by its [id] or null if no such row exists.
  Future<Household?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Household>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Household]s in the list and returns the inserted rows.
  ///
  /// The returned [Household]s will have their `id` fields set.
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
  Future<List<Household>> insert(
    _is.DatabaseSession session,
    List<Household> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Household>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Household] and returns the inserted row.
  ///
  /// The returned [Household] will have its `id` field set.
  Future<Household> insertRow(
    _is.DatabaseSession session,
    Household row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Household>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Household]s in the list and returns the resulting rows.
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
  /// The returned [Household]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Household>> upsert(
    _is.DatabaseSession session,
    List<Household> rows, {
    required _is.ColumnSelections<HouseholdTable> conflictColumns,
    _is.ColumnSelections<HouseholdTable>? updateColumns,
    _is.WhereExpressionBuilder<HouseholdTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Household>(
      rows,
      conflictColumns: conflictColumns(Household.t),
      updateColumns: updateColumns?.call(Household.t),
      updateWhere: updateWhere?.call(Household.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Household] and returns the resulting row.
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
  /// The returned [Household] will have its `id` field set.
  Future<Household?> upsertRow(
    _is.DatabaseSession session,
    Household row, {
    required _is.ColumnSelections<HouseholdTable> conflictColumns,
    _is.ColumnSelections<HouseholdTable>? updateColumns,
    _is.WhereExpressionBuilder<HouseholdTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Household>(
      row,
      conflictColumns: conflictColumns(Household.t),
      updateColumns: updateColumns?.call(Household.t),
      updateWhere: updateWhere?.call(Household.t),
      transaction: transaction,
    );
  }

  /// Updates all [Household]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Household>> update(
    _is.DatabaseSession session,
    List<Household> rows, {
    _is.ColumnSelections<HouseholdTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Household>(
      rows,
      columns: columns?.call(Household.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Household]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Household> updateRow(
    _is.DatabaseSession session,
    Household row, {
    _is.ColumnSelections<HouseholdTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Household>(
      row,
      columns: columns?.call(Household.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Household] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Household?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<HouseholdUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Household>(
      id,
      columnValues: columnValues(Household.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Household]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Household>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<HouseholdUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<HouseholdTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<HouseholdTable>? orderBy,
    _is.OrderByListBuilder<HouseholdTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Household>(
      columnValues: columnValues(Household.t.updateTable),
      where: where(Household.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Household.t),
      orderByList: orderByList?.call(Household.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Household]s in the list and returns the deleted rows.
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
  Future<List<Household>> delete(
    _is.DatabaseSession session,
    List<Household> rows, {
    _is.OrderByBuilder<HouseholdTable>? orderBy,
    _is.OrderByListBuilder<HouseholdTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Household>(
      rows,
      orderBy: orderBy?.call(Household.t),
      orderByList: orderByList?.call(Household.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Household].
  Future<Household> deleteRow(
    _is.DatabaseSession session,
    Household row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Household>(
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
  Future<List<Household>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<HouseholdTable> where,
    _is.OrderByBuilder<HouseholdTable>? orderBy,
    _is.OrderByListBuilder<HouseholdTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Household>(
      where: where(Household.t),
      orderBy: orderBy?.call(Household.t),
      orderByList: orderByList?.call(Household.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<HouseholdTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Household>(
      where: where?.call(Household.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Household] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<HouseholdTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Household>(
      where: where(Household.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
