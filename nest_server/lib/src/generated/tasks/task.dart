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
import '../tasks/task_recurrence.dart' as _irx5q63y;

/// A household task (chore or to-do).
abstract class Task implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Task._({
    this.id,
    required this.householdId,
    this.household,
    required this.title,
    String? notes,
    this.assigneeId,
    this.assignee,
    this.dueDate,
    this.dueMinutes,
    _irx5q63y.TaskRecurrence? recurrence,
    this.doneAt,
    this.doneById,
    this.doneBy,
    this.nextTaskId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : notes = notes ?? '',
       recurrence = recurrence ?? _irx5q63y.TaskRecurrence.none,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Task({
    int? id,
    required int householdId,
    _iaj5kvsg.Household? household,
    required String title,
    String? notes,
    int? assigneeId,
    _ihr4yuyc.NestUser? assignee,
    DateTime? dueDate,
    int? dueMinutes,
    _irx5q63y.TaskRecurrence? recurrence,
    DateTime? doneAt,
    int? doneById,
    _ihr4yuyc.NestUser? doneBy,
    int? nextTaskId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _TaskImpl;

  factory Task.fromJson(Map<String, dynamic> jsonSerialization) {
    return Task(
      id: jsonSerialization['id'] as int?,
      householdId: jsonSerialization['householdId'] as int,
      household: jsonSerialization['household'] == null
          ? null
          : _imc1swab.Protocol().deserialize<_iaj5kvsg.Household>(
              jsonSerialization['household'],
            ),
      title: jsonSerialization['title'] as String,
      notes: jsonSerialization['notes'] as String?,
      assigneeId: jsonSerialization['assigneeId'] as int?,
      assignee: jsonSerialization['assignee'] == null
          ? null
          : _imc1swab.Protocol().deserialize<_ihr4yuyc.NestUser>(
              jsonSerialization['assignee'],
            ),
      dueDate: jsonSerialization['dueDate'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['dueDate']),
      dueMinutes: jsonSerialization['dueMinutes'] as int?,
      recurrence: jsonSerialization['recurrence'] == null
          ? null
          : _irx5q63y.TaskRecurrence.fromJson(
              (jsonSerialization['recurrence'] as String),
            ),
      doneAt: jsonSerialization['doneAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['doneAt']),
      doneById: jsonSerialization['doneById'] as int?,
      doneBy: jsonSerialization['doneBy'] == null
          ? null
          : _imc1swab.Protocol().deserialize<_ihr4yuyc.NestUser>(
              jsonSerialization['doneBy'],
            ),
      nextTaskId: jsonSerialization['nextTaskId'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = TaskTable();

  static const db = TaskRepository._();

  @override
  int? id;

  int householdId;

  _iaj5kvsg.Household? household;

  String title;

  String notes;

  int? assigneeId;

  /// Member the task is assigned to; null for anyone.
  _ihr4yuyc.NestUser? assignee;

  /// Calendar day the task is due, as 00:00 UTC of that day (no time
  /// zone): the day is the same for everyone in the household.
  DateTime? dueDate;

  /// Time of day it is due, in minutes after midnight on the household's
  /// clock; null when it is due some time that day. Only with [dueDate].
  int? dueMinutes;

  _irx5q63y.TaskRecurrence recurrence;

  DateTime? doneAt;

  int? doneById;

  _ihr4yuyc.NestUser? doneBy;

  /// The occurrence created when this recurring task was completed, so
  /// reopening the task can remove it again.
  int? nextTaskId;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Task]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Task copyWith({
    int? id,
    int? householdId,
    _iaj5kvsg.Household? household,
    String? title,
    String? notes,
    int? assigneeId,
    _ihr4yuyc.NestUser? assignee,
    DateTime? dueDate,
    int? dueMinutes,
    _irx5q63y.TaskRecurrence? recurrence,
    DateTime? doneAt,
    int? doneById,
    _ihr4yuyc.NestUser? doneBy,
    int? nextTaskId,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Task',
      if (id != null) 'id': id,
      'householdId': householdId,
      if (household != null) 'household': household?.toJson(),
      'title': title,
      'notes': notes,
      if (assigneeId != null) 'assigneeId': assigneeId,
      if (assignee != null) 'assignee': assignee?.toJson(),
      if (dueDate != null) 'dueDate': dueDate?.toJson(),
      if (dueMinutes != null) 'dueMinutes': dueMinutes,
      'recurrence': recurrence.toJson(),
      if (doneAt != null) 'doneAt': doneAt?.toJson(),
      if (doneById != null) 'doneById': doneById,
      if (doneBy != null) 'doneBy': doneBy?.toJson(),
      if (nextTaskId != null) 'nextTaskId': nextTaskId,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Task',
      if (id != null) 'id': id,
      'householdId': householdId,
      if (household != null) 'household': household?.toJsonForProtocol(),
      'title': title,
      'notes': notes,
      if (assigneeId != null) 'assigneeId': assigneeId,
      if (assignee != null) 'assignee': assignee?.toJsonForProtocol(),
      if (dueDate != null) 'dueDate': dueDate?.toJson(),
      if (dueMinutes != null) 'dueMinutes': dueMinutes,
      'recurrence': recurrence.toJson(),
      if (doneAt != null) 'doneAt': doneAt?.toJson(),
      if (doneById != null) 'doneById': doneById,
      if (doneBy != null) 'doneBy': doneBy?.toJsonForProtocol(),
      if (nextTaskId != null) 'nextTaskId': nextTaskId,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static TaskInclude include({
    _iaj5kvsg.HouseholdInclude? household,
    _ihr4yuyc.NestUserInclude? assignee,
    _ihr4yuyc.NestUserInclude? doneBy,
  }) {
    return TaskInclude._(
      household: household,
      assignee: assignee,
      doneBy: doneBy,
    );
  }

  static TaskIncludeList includeList({
    _is.WhereExpressionBuilder<TaskTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TaskTable>? orderBy,
    _is.OrderByListBuilder<TaskTable>? orderByList,
    TaskInclude? include,
  }) {
    return TaskIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Task.t),
      orderByList: orderByList?.call(Task.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TaskImpl extends Task {
  _TaskImpl({
    int? id,
    required int householdId,
    _iaj5kvsg.Household? household,
    required String title,
    String? notes,
    int? assigneeId,
    _ihr4yuyc.NestUser? assignee,
    DateTime? dueDate,
    int? dueMinutes,
    _irx5q63y.TaskRecurrence? recurrence,
    DateTime? doneAt,
    int? doneById,
    _ihr4yuyc.NestUser? doneBy,
    int? nextTaskId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         householdId: householdId,
         household: household,
         title: title,
         notes: notes,
         assigneeId: assigneeId,
         assignee: assignee,
         dueDate: dueDate,
         dueMinutes: dueMinutes,
         recurrence: recurrence,
         doneAt: doneAt,
         doneById: doneById,
         doneBy: doneBy,
         nextTaskId: nextTaskId,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Task]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Task copyWith({
    Object? id = _Undefined,
    int? householdId,
    Object? household = _Undefined,
    String? title,
    String? notes,
    Object? assigneeId = _Undefined,
    Object? assignee = _Undefined,
    Object? dueDate = _Undefined,
    Object? dueMinutes = _Undefined,
    _irx5q63y.TaskRecurrence? recurrence,
    Object? doneAt = _Undefined,
    Object? doneById = _Undefined,
    Object? doneBy = _Undefined,
    Object? nextTaskId = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id is int? ? id : this.id,
      householdId: householdId ?? this.householdId,
      household: household is _iaj5kvsg.Household?
          ? household
          : this.household?.copyWith(),
      title: title ?? this.title,
      notes: notes ?? this.notes,
      assigneeId: assigneeId is int? ? assigneeId : this.assigneeId,
      assignee: assignee is _ihr4yuyc.NestUser?
          ? assignee
          : this.assignee?.copyWith(),
      dueDate: dueDate is DateTime? ? dueDate : this.dueDate,
      dueMinutes: dueMinutes is int? ? dueMinutes : this.dueMinutes,
      recurrence: recurrence ?? this.recurrence,
      doneAt: doneAt is DateTime? ? doneAt : this.doneAt,
      doneById: doneById is int? ? doneById : this.doneById,
      doneBy: doneBy is _ihr4yuyc.NestUser? ? doneBy : this.doneBy?.copyWith(),
      nextTaskId: nextTaskId is int? ? nextTaskId : this.nextTaskId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class TaskUpdateTable extends _is.UpdateTable<TaskTable> {
  TaskUpdateTable(super.table);

  _is.ColumnValue<int, int> householdId(int value) => _is.ColumnValue(
    table.householdId,
    value,
  );

  _is.ColumnValue<String, String> title(String value) => _is.ColumnValue(
    table.title,
    value,
  );

  _is.ColumnValue<String, String> notes(String value) => _is.ColumnValue(
    table.notes,
    value,
  );

  _is.ColumnValue<int, int> assigneeId(int? value) => _is.ColumnValue(
    table.assigneeId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> dueDate(DateTime? value) =>
      _is.ColumnValue(
        table.dueDate,
        value,
      );

  _is.ColumnValue<int, int> dueMinutes(int? value) => _is.ColumnValue(
    table.dueMinutes,
    value,
  );

  _is.ColumnValue<_irx5q63y.TaskRecurrence, _irx5q63y.TaskRecurrence>
  recurrence(_irx5q63y.TaskRecurrence value) => _is.ColumnValue(
    table.recurrence,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> doneAt(DateTime? value) =>
      _is.ColumnValue(
        table.doneAt,
        value,
      );

  _is.ColumnValue<int, int> doneById(int? value) => _is.ColumnValue(
    table.doneById,
    value,
  );

  _is.ColumnValue<int, int> nextTaskId(int? value) => _is.ColumnValue(
    table.nextTaskId,
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

class TaskTable extends _is.Table<int?> {
  TaskTable({super.tableRelation}) : super(tableName: 'task') {
    updateTable = TaskUpdateTable(this);
    householdId = _is.ColumnInt(
      'householdId',
      this,
    );
    title = _is.ColumnString(
      'title',
      this,
    );
    notes = _is.ColumnString(
      'notes',
      this,
      hasDefault: true,
    );
    assigneeId = _is.ColumnInt(
      'assigneeId',
      this,
    );
    dueDate = _is.ColumnDateTime(
      'dueDate',
      this,
    );
    dueMinutes = _is.ColumnInt(
      'dueMinutes',
      this,
    );
    recurrence = _is.ColumnEnum(
      'recurrence',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    doneAt = _is.ColumnDateTime(
      'doneAt',
      this,
    );
    doneById = _is.ColumnInt(
      'doneById',
      this,
    );
    nextTaskId = _is.ColumnInt(
      'nextTaskId',
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

  late final TaskUpdateTable updateTable;

  late final _is.ColumnInt householdId;

  _iaj5kvsg.HouseholdTable? _household;

  late final _is.ColumnString title;

  late final _is.ColumnString notes;

  late final _is.ColumnInt assigneeId;

  /// Member the task is assigned to; null for anyone.
  _ihr4yuyc.NestUserTable? _assignee;

  /// Calendar day the task is due, as 00:00 UTC of that day (no time
  /// zone): the day is the same for everyone in the household.
  late final _is.ColumnDateTime dueDate;

  /// Time of day it is due, in minutes after midnight on the household's
  /// clock; null when it is due some time that day. Only with [dueDate].
  late final _is.ColumnInt dueMinutes;

  late final _is.ColumnEnum<_irx5q63y.TaskRecurrence> recurrence;

  late final _is.ColumnDateTime doneAt;

  late final _is.ColumnInt doneById;

  _ihr4yuyc.NestUserTable? _doneBy;

  /// The occurrence created when this recurring task was completed, so
  /// reopening the task can remove it again.
  late final _is.ColumnInt nextTaskId;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  _iaj5kvsg.HouseholdTable get household {
    if (_household != null) return _household!;
    _household = _is.createRelationTable(
      relationFieldName: 'household',
      field: Task.t.householdId,
      foreignField: _iaj5kvsg.Household.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iaj5kvsg.HouseholdTable(tableRelation: foreignTableRelation),
    );
    return _household!;
  }

  _ihr4yuyc.NestUserTable get assignee {
    if (_assignee != null) return _assignee!;
    _assignee = _is.createRelationTable(
      relationFieldName: 'assignee',
      field: Task.t.assigneeId,
      foreignField: _ihr4yuyc.NestUser.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ihr4yuyc.NestUserTable(tableRelation: foreignTableRelation),
    );
    return _assignee!;
  }

  _ihr4yuyc.NestUserTable get doneBy {
    if (_doneBy != null) return _doneBy!;
    _doneBy = _is.createRelationTable(
      relationFieldName: 'doneBy',
      field: Task.t.doneById,
      foreignField: _ihr4yuyc.NestUser.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ihr4yuyc.NestUserTable(tableRelation: foreignTableRelation),
    );
    return _doneBy!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    householdId,
    title,
    notes,
    assigneeId,
    dueDate,
    dueMinutes,
    recurrence,
    doneAt,
    doneById,
    nextTaskId,
    createdAt,
    updatedAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'household') {
      return household;
    }
    if (relationField == 'assignee') {
      return assignee;
    }
    if (relationField == 'doneBy') {
      return doneBy;
    }
    return null;
  }
}

class TaskInclude extends _is.IncludeObject {
  TaskInclude._({
    _iaj5kvsg.HouseholdInclude? household,
    _ihr4yuyc.NestUserInclude? assignee,
    _ihr4yuyc.NestUserInclude? doneBy,
  }) {
    _household = household;
    _assignee = assignee;
    _doneBy = doneBy;
  }

  _iaj5kvsg.HouseholdInclude? _household;

  _ihr4yuyc.NestUserInclude? _assignee;

  _ihr4yuyc.NestUserInclude? _doneBy;

  @override
  Map<String, _is.Include?> get includes => {
    'household': _household,
    'assignee': _assignee,
    'doneBy': _doneBy,
  };

  @override
  _is.Table<int?> get table => Task.t;
}

class TaskIncludeList extends _is.IncludeList {
  TaskIncludeList._({
    _is.WhereExpressionBuilder<TaskTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Task.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Task.t;
}

class TaskRepository {
  const TaskRepository._();

  final attachRow = const TaskAttachRowRepository._();

  final detachRow = const TaskDetachRowRepository._();

  /// Returns a list of [Task]s matching the given query parameters.
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
  Future<List<Task>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TaskTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TaskTable>? orderBy,
    _is.OrderByListBuilder<TaskTable>? orderByList,
    _is.Transaction? transaction,
    TaskInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Task>(
      where: where?.call(Task.t),
      orderBy: orderBy?.call(Task.t),
      orderByList: orderByList?.call(Task.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Task] matching the given query parameters.
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
  Future<Task?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TaskTable>? where,
    int? offset,
    _is.OrderByBuilder<TaskTable>? orderBy,
    _is.OrderByListBuilder<TaskTable>? orderByList,
    _is.Transaction? transaction,
    TaskInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Task>(
      where: where?.call(Task.t),
      orderBy: orderBy?.call(Task.t),
      orderByList: orderByList?.call(Task.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Task] by its [id] or null if no such row exists.
  Future<Task?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    TaskInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Task>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Task]s in the list and returns the inserted rows.
  ///
  /// The returned [Task]s will have their `id` fields set.
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
  Future<List<Task>> insert(
    _is.DatabaseSession session,
    List<Task> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Task>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Task] and returns the inserted row.
  ///
  /// The returned [Task] will have its `id` field set.
  Future<Task> insertRow(
    _is.DatabaseSession session,
    Task row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Task>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Task]s in the list and returns the resulting rows.
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
  /// The returned [Task]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Task>> upsert(
    _is.DatabaseSession session,
    List<Task> rows, {
    required _is.ColumnSelections<TaskTable> conflictColumns,
    _is.ColumnSelections<TaskTable>? updateColumns,
    _is.WhereExpressionBuilder<TaskTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Task>(
      rows,
      conflictColumns: conflictColumns(Task.t),
      updateColumns: updateColumns?.call(Task.t),
      updateWhere: updateWhere?.call(Task.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Task] and returns the resulting row.
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
  /// The returned [Task] will have its `id` field set.
  Future<Task?> upsertRow(
    _is.DatabaseSession session,
    Task row, {
    required _is.ColumnSelections<TaskTable> conflictColumns,
    _is.ColumnSelections<TaskTable>? updateColumns,
    _is.WhereExpressionBuilder<TaskTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Task>(
      row,
      conflictColumns: conflictColumns(Task.t),
      updateColumns: updateColumns?.call(Task.t),
      updateWhere: updateWhere?.call(Task.t),
      transaction: transaction,
    );
  }

  /// Updates all [Task]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Task>> update(
    _is.DatabaseSession session,
    List<Task> rows, {
    _is.ColumnSelections<TaskTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Task>(
      rows,
      columns: columns?.call(Task.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Task]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Task> updateRow(
    _is.DatabaseSession session,
    Task row, {
    _is.ColumnSelections<TaskTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Task>(
      row,
      columns: columns?.call(Task.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Task] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Task?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<TaskUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Task>(
      id,
      columnValues: columnValues(Task.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Task]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Task>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<TaskUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<TaskTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TaskTable>? orderBy,
    _is.OrderByListBuilder<TaskTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Task>(
      columnValues: columnValues(Task.t.updateTable),
      where: where(Task.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Task.t),
      orderByList: orderByList?.call(Task.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Task]s in the list and returns the deleted rows.
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
  Future<List<Task>> delete(
    _is.DatabaseSession session,
    List<Task> rows, {
    _is.OrderByBuilder<TaskTable>? orderBy,
    _is.OrderByListBuilder<TaskTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Task>(
      rows,
      orderBy: orderBy?.call(Task.t),
      orderByList: orderByList?.call(Task.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Task].
  Future<Task> deleteRow(
    _is.DatabaseSession session,
    Task row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Task>(
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
  Future<List<Task>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TaskTable> where,
    _is.OrderByBuilder<TaskTable>? orderBy,
    _is.OrderByListBuilder<TaskTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Task>(
      where: where(Task.t),
      orderBy: orderBy?.call(Task.t),
      orderByList: orderByList?.call(Task.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TaskTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Task>(
      where: where?.call(Task.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Task] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TaskTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Task>(
      where: where(Task.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class TaskAttachRowRepository {
  const TaskAttachRowRepository._();

  /// Creates a relation between the given [Task] and [Household]
  /// by setting the [Task]'s foreign key `householdId` to refer to the [Household].
  Future<void> household(
    _is.DatabaseSession session,
    Task task,
    _iaj5kvsg.Household household, {
    _is.Transaction? transaction,
  }) async {
    if (task.id == null) {
      throw ArgumentError.notNull('task.id');
    }
    if (household.id == null) {
      throw ArgumentError.notNull('household.id');
    }

    var $task = task.copyWith(householdId: household.id);
    await session.db.updateRow<Task>(
      $task,
      columns: [Task.t.householdId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [Task] and [NestUser]
  /// by setting the [Task]'s foreign key `assigneeId` to refer to the [NestUser].
  Future<void> assignee(
    _is.DatabaseSession session,
    Task task,
    _ihr4yuyc.NestUser assignee, {
    _is.Transaction? transaction,
  }) async {
    if (task.id == null) {
      throw ArgumentError.notNull('task.id');
    }
    if (assignee.id == null) {
      throw ArgumentError.notNull('assignee.id');
    }

    var $task = task.copyWith(assigneeId: assignee.id);
    await session.db.updateRow<Task>(
      $task,
      columns: [Task.t.assigneeId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [Task] and [NestUser]
  /// by setting the [Task]'s foreign key `doneById` to refer to the [NestUser].
  Future<void> doneBy(
    _is.DatabaseSession session,
    Task task,
    _ihr4yuyc.NestUser doneBy, {
    _is.Transaction? transaction,
  }) async {
    if (task.id == null) {
      throw ArgumentError.notNull('task.id');
    }
    if (doneBy.id == null) {
      throw ArgumentError.notNull('doneBy.id');
    }

    var $task = task.copyWith(doneById: doneBy.id);
    await session.db.updateRow<Task>(
      $task,
      columns: [Task.t.doneById],
      transaction: transaction,
    );
  }
}

class TaskDetachRowRepository {
  const TaskDetachRowRepository._();

  /// Detaches the relation between this [Task] and the [NestUser] set in `assignee`
  /// by setting the [Task]'s foreign key `assigneeId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> assignee(
    _is.DatabaseSession session,
    Task task, {
    _is.Transaction? transaction,
  }) async {
    if (task.id == null) {
      throw ArgumentError.notNull('task.id');
    }

    var $task = task.copyWith(assigneeId: null);
    await session.db.updateRow<Task>(
      $task,
      columns: [Task.t.assigneeId],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [Task] and the [NestUser] set in `doneBy`
  /// by setting the [Task]'s foreign key `doneById` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> doneBy(
    _is.DatabaseSession session,
    Task task, {
    _is.Transaction? transaction,
  }) async {
    if (task.id == null) {
      throw ArgumentError.notNull('task.id');
    }

    var $task = task.copyWith(doneById: null);
    await session.db.updateRow<Task>(
      $task,
      columns: [Task.t.doneById],
      transaction: transaction,
    );
  }
}
