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
import '../tasks/task.dart' as _if91w2qc;

/// A change in a household's tasks, sent to everyone watching. Also the
/// answer of methods that change more than one task.
abstract class TaskEvent
    implements _is.SerializableModel, _is.ProtocolSerialization {
  TaskEvent._({
    required this.householdId,
    this.tasks,
    this.removedTaskIds,
  });

  factory TaskEvent({
    required int householdId,
    List<_if91w2qc.Task>? tasks,
    List<int>? removedTaskIds,
  }) = _TaskEventImpl;

  factory TaskEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return TaskEvent(
      householdId: jsonSerialization['householdId'] as int,
      tasks: jsonSerialization['tasks'] == null
          ? null
          : _imc1swab.Protocol().deserialize<List<_if91w2qc.Task>>(
              jsonSerialization['tasks'],
            ),
      removedTaskIds: jsonSerialization['removedTaskIds'] == null
          ? null
          : _imc1swab.Protocol().deserialize<List<int>>(
              jsonSerialization['removedTaskIds'],
            ),
    );
  }

  int householdId;

  List<_if91w2qc.Task>? tasks;

  List<int>? removedTaskIds;

  /// Returns a shallow copy of this [TaskEvent]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TaskEvent copyWith({
    int? householdId,
    List<_if91w2qc.Task>? tasks,
    List<int>? removedTaskIds,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TaskEvent',
      'householdId': householdId,
      if (tasks != null) 'tasks': tasks?.toJson(valueToJson: (v) => v.toJson()),
      if (removedTaskIds != null) 'removedTaskIds': removedTaskIds?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TaskEvent',
      'householdId': householdId,
      if (tasks != null)
        'tasks': tasks?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (removedTaskIds != null) 'removedTaskIds': removedTaskIds?.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TaskEventImpl extends TaskEvent {
  _TaskEventImpl({
    required int householdId,
    List<_if91w2qc.Task>? tasks,
    List<int>? removedTaskIds,
  }) : super._(
         householdId: householdId,
         tasks: tasks,
         removedTaskIds: removedTaskIds,
       );

  /// Returns a shallow copy of this [TaskEvent]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TaskEvent copyWith({
    int? householdId,
    Object? tasks = _Undefined,
    Object? removedTaskIds = _Undefined,
  }) {
    return TaskEvent(
      householdId: householdId ?? this.householdId,
      tasks: tasks is List<_if91w2qc.Task>?
          ? tasks
          : this.tasks?.map((e0) => e0.copyWith()).toList(),
      removedTaskIds: removedTaskIds is List<int>?
          ? removedTaskIds
          : this.removedTaskIds?.map((e0) => e0).toList(),
    );
  }
}
