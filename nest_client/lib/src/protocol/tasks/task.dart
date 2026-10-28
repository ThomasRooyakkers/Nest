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
import 'package:nest_client/src/protocol/protocol.dart' as _ilcqbmdc;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../household.dart' as _iaj5kvsg;
import '../nest_user.dart' as _ihr4yuyc;
import '../tasks/task_recurrence.dart' as _irx5q63y;

/// A household task (chore or to-do).
abstract class Task
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
          : _ilcqbmdc.Protocol().deserialize<_iaj5kvsg.Household>(
              jsonSerialization['household'],
            ),
      title: jsonSerialization['title'] as String,
      notes: jsonSerialization['notes'] as String?,
      assigneeId: jsonSerialization['assigneeId'] as int?,
      assignee: jsonSerialization['assignee'] == null
          ? null
          : _ilcqbmdc.Protocol().deserialize<_ihr4yuyc.NestUser>(
              jsonSerialization['assignee'],
            ),
      dueDate: jsonSerialization['dueDate'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['dueDate']),
      dueMinutes: jsonSerialization['dueMinutes'] as int?,
      recurrence: jsonSerialization['recurrence'] == null
          ? null
          : _irx5q63y.TaskRecurrence.fromJson(
              (jsonSerialization['recurrence'] as String),
            ),
      doneAt: jsonSerialization['doneAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['doneAt']),
      doneById: jsonSerialization['doneById'] as int?,
      doneBy: jsonSerialization['doneBy'] == null
          ? null
          : _ilcqbmdc.Protocol().deserialize<_ihr4yuyc.NestUser>(
              jsonSerialization['doneBy'],
            ),
      nextTaskId: jsonSerialization['nextTaskId'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
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

  /// Returns a shallow copy of this [Task]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
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
  @_isc.useResult
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
