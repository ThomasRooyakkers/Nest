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
import '../watchlist/watch_status.dart' as _ikkd49ke;
import '../watchlist/watch_type.dart' as _ix3az44g;

/// A film or series on the household's watchlist. The details are copied
/// from the film data when it is added.
abstract class WatchlistItem
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  WatchlistItem._({
    this.id,
    required this.householdId,
    this.household,
    required this.tmdbId,
    required this.type,
    required this.title,
    this.posterPath,
    this.year,
    this.rating,
    _ikkd49ke.WatchStatus? status,
    this.addedById,
    this.addedBy,
    this.householdRating,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : status = status ?? _ikkd49ke.WatchStatus.want,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory WatchlistItem({
    int? id,
    required int householdId,
    _iaj5kvsg.Household? household,
    required int tmdbId,
    required _ix3az44g.WatchType type,
    required String title,
    String? posterPath,
    int? year,
    double? rating,
    _ikkd49ke.WatchStatus? status,
    int? addedById,
    _ihr4yuyc.NestUser? addedBy,
    int? householdRating,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _WatchlistItemImpl;

  factory WatchlistItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return WatchlistItem(
      id: jsonSerialization['id'] as int?,
      householdId: jsonSerialization['householdId'] as int,
      household: jsonSerialization['household'] == null
          ? null
          : _imc1swab.Protocol().deserialize<_iaj5kvsg.Household>(
              jsonSerialization['household'],
            ),
      tmdbId: jsonSerialization['tmdbId'] as int,
      type: _ix3az44g.WatchType.fromJson((jsonSerialization['type'] as String)),
      title: jsonSerialization['title'] as String,
      posterPath: jsonSerialization['posterPath'] as String?,
      year: jsonSerialization['year'] as int?,
      rating: (jsonSerialization['rating'] as num?)?.toDouble(),
      status: jsonSerialization['status'] == null
          ? null
          : _ikkd49ke.WatchStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      addedById: jsonSerialization['addedById'] as int?,
      addedBy: jsonSerialization['addedBy'] == null
          ? null
          : _imc1swab.Protocol().deserialize<_ihr4yuyc.NestUser>(
              jsonSerialization['addedBy'],
            ),
      householdRating: jsonSerialization['householdRating'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = WatchlistItemTable();

  static const db = WatchlistItemRepository._();

  @override
  int? id;

  int householdId;

  _iaj5kvsg.Household? household;

  int tmdbId;

  _ix3az44g.WatchType type;

  String title;

  String? posterPath;

  int? year;

  /// TMDB's average vote, 0–10.
  double? rating;

  _ikkd49ke.WatchStatus status;

  int? addedById;

  _ihr4yuyc.NestUser? addedBy;

  /// The household's own rating, 1–5 stars; null when not rated.
  int? householdRating;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [WatchlistItem]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  WatchlistItem copyWith({
    int? id,
    int? householdId,
    _iaj5kvsg.Household? household,
    int? tmdbId,
    _ix3az44g.WatchType? type,
    String? title,
    String? posterPath,
    int? year,
    double? rating,
    _ikkd49ke.WatchStatus? status,
    int? addedById,
    _ihr4yuyc.NestUser? addedBy,
    int? householdRating,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WatchlistItem',
      if (id != null) 'id': id,
      'householdId': householdId,
      if (household != null) 'household': household?.toJson(),
      'tmdbId': tmdbId,
      'type': type.toJson(),
      'title': title,
      if (posterPath != null) 'posterPath': posterPath,
      if (year != null) 'year': year,
      if (rating != null) 'rating': rating,
      'status': status.toJson(),
      if (addedById != null) 'addedById': addedById,
      if (addedBy != null) 'addedBy': addedBy?.toJson(),
      if (householdRating != null) 'householdRating': householdRating,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WatchlistItem',
      if (id != null) 'id': id,
      'householdId': householdId,
      if (household != null) 'household': household?.toJsonForProtocol(),
      'tmdbId': tmdbId,
      'type': type.toJson(),
      'title': title,
      if (posterPath != null) 'posterPath': posterPath,
      if (year != null) 'year': year,
      if (rating != null) 'rating': rating,
      'status': status.toJson(),
      if (addedById != null) 'addedById': addedById,
      if (addedBy != null) 'addedBy': addedBy?.toJsonForProtocol(),
      if (householdRating != null) 'householdRating': householdRating,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static WatchlistItemInclude include({
    _iaj5kvsg.HouseholdInclude? household,
    _ihr4yuyc.NestUserInclude? addedBy,
  }) {
    return WatchlistItemInclude._(
      household: household,
      addedBy: addedBy,
    );
  }

  static WatchlistItemIncludeList includeList({
    _is.WhereExpressionBuilder<WatchlistItemTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<WatchlistItemTable>? orderBy,
    _is.OrderByListBuilder<WatchlistItemTable>? orderByList,
    WatchlistItemInclude? include,
  }) {
    return WatchlistItemIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(WatchlistItem.t),
      orderByList: orderByList?.call(WatchlistItem.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WatchlistItemImpl extends WatchlistItem {
  _WatchlistItemImpl({
    int? id,
    required int householdId,
    _iaj5kvsg.Household? household,
    required int tmdbId,
    required _ix3az44g.WatchType type,
    required String title,
    String? posterPath,
    int? year,
    double? rating,
    _ikkd49ke.WatchStatus? status,
    int? addedById,
    _ihr4yuyc.NestUser? addedBy,
    int? householdRating,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         householdId: householdId,
         household: household,
         tmdbId: tmdbId,
         type: type,
         title: title,
         posterPath: posterPath,
         year: year,
         rating: rating,
         status: status,
         addedById: addedById,
         addedBy: addedBy,
         householdRating: householdRating,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [WatchlistItem]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  WatchlistItem copyWith({
    Object? id = _Undefined,
    int? householdId,
    Object? household = _Undefined,
    int? tmdbId,
    _ix3az44g.WatchType? type,
    String? title,
    Object? posterPath = _Undefined,
    Object? year = _Undefined,
    Object? rating = _Undefined,
    _ikkd49ke.WatchStatus? status,
    Object? addedById = _Undefined,
    Object? addedBy = _Undefined,
    Object? householdRating = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WatchlistItem(
      id: id is int? ? id : this.id,
      householdId: householdId ?? this.householdId,
      household: household is _iaj5kvsg.Household?
          ? household
          : this.household?.copyWith(),
      tmdbId: tmdbId ?? this.tmdbId,
      type: type ?? this.type,
      title: title ?? this.title,
      posterPath: posterPath is String? ? posterPath : this.posterPath,
      year: year is int? ? year : this.year,
      rating: rating is double? ? rating : this.rating,
      status: status ?? this.status,
      addedById: addedById is int? ? addedById : this.addedById,
      addedBy: addedBy is _ihr4yuyc.NestUser?
          ? addedBy
          : this.addedBy?.copyWith(),
      householdRating: householdRating is int?
          ? householdRating
          : this.householdRating,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class WatchlistItemUpdateTable extends _is.UpdateTable<WatchlistItemTable> {
  WatchlistItemUpdateTable(super.table);

  _is.ColumnValue<int, int> householdId(int value) => _is.ColumnValue(
    table.householdId,
    value,
  );

  _is.ColumnValue<int, int> tmdbId(int value) => _is.ColumnValue(
    table.tmdbId,
    value,
  );

  _is.ColumnValue<_ix3az44g.WatchType, _ix3az44g.WatchType> type(
    _ix3az44g.WatchType value,
  ) => _is.ColumnValue(
    table.type,
    value,
  );

  _is.ColumnValue<String, String> title(String value) => _is.ColumnValue(
    table.title,
    value,
  );

  _is.ColumnValue<String, String> posterPath(String? value) => _is.ColumnValue(
    table.posterPath,
    value,
  );

  _is.ColumnValue<int, int> year(int? value) => _is.ColumnValue(
    table.year,
    value,
  );

  _is.ColumnValue<double, double> rating(double? value) => _is.ColumnValue(
    table.rating,
    value,
  );

  _is.ColumnValue<_ikkd49ke.WatchStatus, _ikkd49ke.WatchStatus> status(
    _ikkd49ke.WatchStatus value,
  ) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<int, int> addedById(int? value) => _is.ColumnValue(
    table.addedById,
    value,
  );

  _is.ColumnValue<int, int> householdRating(int? value) => _is.ColumnValue(
    table.householdRating,
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

class WatchlistItemTable extends _is.Table<int?> {
  WatchlistItemTable({super.tableRelation})
    : super(tableName: 'watchlist_item') {
    updateTable = WatchlistItemUpdateTable(this);
    householdId = _is.ColumnInt(
      'householdId',
      this,
    );
    tmdbId = _is.ColumnInt(
      'tmdbId',
      this,
    );
    type = _is.ColumnEnum(
      'type',
      this,
      _is.EnumSerialization.byName,
    );
    title = _is.ColumnString(
      'title',
      this,
    );
    posterPath = _is.ColumnString(
      'posterPath',
      this,
    );
    year = _is.ColumnInt(
      'year',
      this,
    );
    rating = _is.ColumnDouble(
      'rating',
      this,
    );
    status = _is.ColumnEnum(
      'status',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    addedById = _is.ColumnInt(
      'addedById',
      this,
    );
    householdRating = _is.ColumnInt(
      'householdRating',
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

  late final WatchlistItemUpdateTable updateTable;

  late final _is.ColumnInt householdId;

  _iaj5kvsg.HouseholdTable? _household;

  late final _is.ColumnInt tmdbId;

  late final _is.ColumnEnum<_ix3az44g.WatchType> type;

  late final _is.ColumnString title;

  late final _is.ColumnString posterPath;

  late final _is.ColumnInt year;

  /// TMDB's average vote, 0–10.
  late final _is.ColumnDouble rating;

  late final _is.ColumnEnum<_ikkd49ke.WatchStatus> status;

  late final _is.ColumnInt addedById;

  _ihr4yuyc.NestUserTable? _addedBy;

  /// The household's own rating, 1–5 stars; null when not rated.
  late final _is.ColumnInt householdRating;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  _iaj5kvsg.HouseholdTable get household {
    if (_household != null) return _household!;
    _household = _is.createRelationTable(
      relationFieldName: 'household',
      field: WatchlistItem.t.householdId,
      foreignField: _iaj5kvsg.Household.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iaj5kvsg.HouseholdTable(tableRelation: foreignTableRelation),
    );
    return _household!;
  }

  _ihr4yuyc.NestUserTable get addedBy {
    if (_addedBy != null) return _addedBy!;
    _addedBy = _is.createRelationTable(
      relationFieldName: 'addedBy',
      field: WatchlistItem.t.addedById,
      foreignField: _ihr4yuyc.NestUser.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ihr4yuyc.NestUserTable(tableRelation: foreignTableRelation),
    );
    return _addedBy!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    householdId,
    tmdbId,
    type,
    title,
    posterPath,
    year,
    rating,
    status,
    addedById,
    householdRating,
    createdAt,
    updatedAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'household') {
      return household;
    }
    if (relationField == 'addedBy') {
      return addedBy;
    }
    return null;
  }
}

class WatchlistItemInclude extends _is.IncludeObject {
  WatchlistItemInclude._({
    _iaj5kvsg.HouseholdInclude? household,
    _ihr4yuyc.NestUserInclude? addedBy,
  }) {
    _household = household;
    _addedBy = addedBy;
  }

  _iaj5kvsg.HouseholdInclude? _household;

  _ihr4yuyc.NestUserInclude? _addedBy;

  @override
  Map<String, _is.Include?> get includes => {
    'household': _household,
    'addedBy': _addedBy,
  };

  @override
  _is.Table<int?> get table => WatchlistItem.t;
}

class WatchlistItemIncludeList extends _is.IncludeList {
  WatchlistItemIncludeList._({
    _is.WhereExpressionBuilder<WatchlistItemTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(WatchlistItem.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => WatchlistItem.t;
}

class WatchlistItemRepository {
  const WatchlistItemRepository._();

  final attachRow = const WatchlistItemAttachRowRepository._();

  final detachRow = const WatchlistItemDetachRowRepository._();

  /// Returns a list of [WatchlistItem]s matching the given query parameters.
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
  Future<List<WatchlistItem>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<WatchlistItemTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<WatchlistItemTable>? orderBy,
    _is.OrderByListBuilder<WatchlistItemTable>? orderByList,
    _is.Transaction? transaction,
    WatchlistItemInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<WatchlistItem>(
      where: where?.call(WatchlistItem.t),
      orderBy: orderBy?.call(WatchlistItem.t),
      orderByList: orderByList?.call(WatchlistItem.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [WatchlistItem] matching the given query parameters.
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
  Future<WatchlistItem?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<WatchlistItemTable>? where,
    int? offset,
    _is.OrderByBuilder<WatchlistItemTable>? orderBy,
    _is.OrderByListBuilder<WatchlistItemTable>? orderByList,
    _is.Transaction? transaction,
    WatchlistItemInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<WatchlistItem>(
      where: where?.call(WatchlistItem.t),
      orderBy: orderBy?.call(WatchlistItem.t),
      orderByList: orderByList?.call(WatchlistItem.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [WatchlistItem] by its [id] or null if no such row exists.
  Future<WatchlistItem?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    WatchlistItemInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<WatchlistItem>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [WatchlistItem]s in the list and returns the inserted rows.
  ///
  /// The returned [WatchlistItem]s will have their `id` fields set.
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
  Future<List<WatchlistItem>> insert(
    _is.DatabaseSession session,
    List<WatchlistItem> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<WatchlistItem>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [WatchlistItem] and returns the inserted row.
  ///
  /// The returned [WatchlistItem] will have its `id` field set.
  Future<WatchlistItem> insertRow(
    _is.DatabaseSession session,
    WatchlistItem row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<WatchlistItem>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [WatchlistItem]s in the list and returns the resulting rows.
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
  /// The returned [WatchlistItem]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<WatchlistItem>> upsert(
    _is.DatabaseSession session,
    List<WatchlistItem> rows, {
    required _is.ColumnSelections<WatchlistItemTable> conflictColumns,
    _is.ColumnSelections<WatchlistItemTable>? updateColumns,
    _is.WhereExpressionBuilder<WatchlistItemTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<WatchlistItem>(
      rows,
      conflictColumns: conflictColumns(WatchlistItem.t),
      updateColumns: updateColumns?.call(WatchlistItem.t),
      updateWhere: updateWhere?.call(WatchlistItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [WatchlistItem] and returns the resulting row.
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
  /// The returned [WatchlistItem] will have its `id` field set.
  Future<WatchlistItem?> upsertRow(
    _is.DatabaseSession session,
    WatchlistItem row, {
    required _is.ColumnSelections<WatchlistItemTable> conflictColumns,
    _is.ColumnSelections<WatchlistItemTable>? updateColumns,
    _is.WhereExpressionBuilder<WatchlistItemTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<WatchlistItem>(
      row,
      conflictColumns: conflictColumns(WatchlistItem.t),
      updateColumns: updateColumns?.call(WatchlistItem.t),
      updateWhere: updateWhere?.call(WatchlistItem.t),
      transaction: transaction,
    );
  }

  /// Updates all [WatchlistItem]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<WatchlistItem>> update(
    _is.DatabaseSession session,
    List<WatchlistItem> rows, {
    _is.ColumnSelections<WatchlistItemTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<WatchlistItem>(
      rows,
      columns: columns?.call(WatchlistItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [WatchlistItem]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<WatchlistItem> updateRow(
    _is.DatabaseSession session,
    WatchlistItem row, {
    _is.ColumnSelections<WatchlistItemTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<WatchlistItem>(
      row,
      columns: columns?.call(WatchlistItem.t),
      transaction: transaction,
    );
  }

  /// Updates a single [WatchlistItem] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<WatchlistItem?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<WatchlistItemUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<WatchlistItem>(
      id,
      columnValues: columnValues(WatchlistItem.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [WatchlistItem]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<WatchlistItem>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<WatchlistItemUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<WatchlistItemTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<WatchlistItemTable>? orderBy,
    _is.OrderByListBuilder<WatchlistItemTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<WatchlistItem>(
      columnValues: columnValues(WatchlistItem.t.updateTable),
      where: where(WatchlistItem.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(WatchlistItem.t),
      orderByList: orderByList?.call(WatchlistItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [WatchlistItem]s in the list and returns the deleted rows.
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
  Future<List<WatchlistItem>> delete(
    _is.DatabaseSession session,
    List<WatchlistItem> rows, {
    _is.OrderByBuilder<WatchlistItemTable>? orderBy,
    _is.OrderByListBuilder<WatchlistItemTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<WatchlistItem>(
      rows,
      orderBy: orderBy?.call(WatchlistItem.t),
      orderByList: orderByList?.call(WatchlistItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [WatchlistItem].
  Future<WatchlistItem> deleteRow(
    _is.DatabaseSession session,
    WatchlistItem row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<WatchlistItem>(
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
  Future<List<WatchlistItem>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<WatchlistItemTable> where,
    _is.OrderByBuilder<WatchlistItemTable>? orderBy,
    _is.OrderByListBuilder<WatchlistItemTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<WatchlistItem>(
      where: where(WatchlistItem.t),
      orderBy: orderBy?.call(WatchlistItem.t),
      orderByList: orderByList?.call(WatchlistItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<WatchlistItemTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<WatchlistItem>(
      where: where?.call(WatchlistItem.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [WatchlistItem] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<WatchlistItemTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<WatchlistItem>(
      where: where(WatchlistItem.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class WatchlistItemAttachRowRepository {
  const WatchlistItemAttachRowRepository._();

  /// Creates a relation between the given [WatchlistItem] and [Household]
  /// by setting the [WatchlistItem]'s foreign key `householdId` to refer to the [Household].
  Future<void> household(
    _is.DatabaseSession session,
    WatchlistItem watchlistItem,
    _iaj5kvsg.Household household, {
    _is.Transaction? transaction,
  }) async {
    if (watchlistItem.id == null) {
      throw ArgumentError.notNull('watchlistItem.id');
    }
    if (household.id == null) {
      throw ArgumentError.notNull('household.id');
    }

    var $watchlistItem = watchlistItem.copyWith(householdId: household.id);
    await session.db.updateRow<WatchlistItem>(
      $watchlistItem,
      columns: [WatchlistItem.t.householdId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [WatchlistItem] and [NestUser]
  /// by setting the [WatchlistItem]'s foreign key `addedById` to refer to the [NestUser].
  Future<void> addedBy(
    _is.DatabaseSession session,
    WatchlistItem watchlistItem,
    _ihr4yuyc.NestUser addedBy, {
    _is.Transaction? transaction,
  }) async {
    if (watchlistItem.id == null) {
      throw ArgumentError.notNull('watchlistItem.id');
    }
    if (addedBy.id == null) {
      throw ArgumentError.notNull('addedBy.id');
    }

    var $watchlistItem = watchlistItem.copyWith(addedById: addedBy.id);
    await session.db.updateRow<WatchlistItem>(
      $watchlistItem,
      columns: [WatchlistItem.t.addedById],
      transaction: transaction,
    );
  }
}

class WatchlistItemDetachRowRepository {
  const WatchlistItemDetachRowRepository._();

  /// Detaches the relation between this [WatchlistItem] and the [NestUser] set in `addedBy`
  /// by setting the [WatchlistItem]'s foreign key `addedById` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> addedBy(
    _is.DatabaseSession session,
    WatchlistItem watchlistItem, {
    _is.Transaction? transaction,
  }) async {
    if (watchlistItem.id == null) {
      throw ArgumentError.notNull('watchlistItem.id');
    }

    var $watchlistItem = watchlistItem.copyWith(addedById: null);
    await session.db.updateRow<WatchlistItem>(
      $watchlistItem,
      columns: [WatchlistItem.t.addedById],
      transaction: transaction,
    );
  }
}
