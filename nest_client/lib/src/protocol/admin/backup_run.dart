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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../admin/backup_run_status.dart' as _ithogegq;

/// One backup of the database to one target. Written by the backup job
/// (deploy/backup/backup.sh), read by the admin portal.
abstract class BackupRun
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  BackupRun._({
    this.id,
    required this.startedAt,
    this.finishedAt,
    required this.status,
    this.sizeBytes,
    this.snapshotId,
    required this.target,
    this.error,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory BackupRun({
    int? id,
    required DateTime startedAt,
    DateTime? finishedAt,
    required _ithogegq.BackupRunStatus status,
    int? sizeBytes,
    String? snapshotId,
    required String target,
    String? error,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _BackupRunImpl;

  factory BackupRun.fromJson(Map<String, dynamic> jsonSerialization) {
    return BackupRun(
      id: jsonSerialization['id'] as int?,
      startedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['startedAt'],
      ),
      finishedAt: jsonSerialization['finishedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['finishedAt'],
            ),
      status: _ithogegq.BackupRunStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      sizeBytes: jsonSerialization['sizeBytes'] as int?,
      snapshotId: jsonSerialization['snapshotId'] as String?,
      target: jsonSerialization['target'] as String,
      error: jsonSerialization['error'] as String?,
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

  DateTime startedAt;

  DateTime? finishedAt;

  _ithogegq.BackupRunStatus status;

  /// Size of the database dump in bytes.
  int? sizeBytes;

  /// The restic snapshot, used to restore.
  String? snapshotId;

  /// Name of the backup target, e.g. `local` or `onedrive`.
  String target;

  /// Short error message of a failed run.
  String? error;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [BackupRun]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  BackupRun copyWith({
    int? id,
    DateTime? startedAt,
    DateTime? finishedAt,
    _ithogegq.BackupRunStatus? status,
    int? sizeBytes,
    String? snapshotId,
    String? target,
    String? error,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BackupRun',
      if (id != null) 'id': id,
      'startedAt': startedAt.toJson(),
      if (finishedAt != null) 'finishedAt': finishedAt?.toJson(),
      'status': status.toJson(),
      if (sizeBytes != null) 'sizeBytes': sizeBytes,
      if (snapshotId != null) 'snapshotId': snapshotId,
      'target': target,
      if (error != null) 'error': error,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'BackupRun',
      if (id != null) 'id': id,
      'startedAt': startedAt.toJson(),
      if (finishedAt != null) 'finishedAt': finishedAt?.toJson(),
      'status': status.toJson(),
      if (sizeBytes != null) 'sizeBytes': sizeBytes,
      if (snapshotId != null) 'snapshotId': snapshotId,
      'target': target,
      if (error != null) 'error': error,
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

class _BackupRunImpl extends BackupRun {
  _BackupRunImpl({
    int? id,
    required DateTime startedAt,
    DateTime? finishedAt,
    required _ithogegq.BackupRunStatus status,
    int? sizeBytes,
    String? snapshotId,
    required String target,
    String? error,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         startedAt: startedAt,
         finishedAt: finishedAt,
         status: status,
         sizeBytes: sizeBytes,
         snapshotId: snapshotId,
         target: target,
         error: error,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [BackupRun]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  BackupRun copyWith({
    Object? id = _Undefined,
    DateTime? startedAt,
    Object? finishedAt = _Undefined,
    _ithogegq.BackupRunStatus? status,
    Object? sizeBytes = _Undefined,
    Object? snapshotId = _Undefined,
    String? target,
    Object? error = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BackupRun(
      id: id is int? ? id : this.id,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt is DateTime? ? finishedAt : this.finishedAt,
      status: status ?? this.status,
      sizeBytes: sizeBytes is int? ? sizeBytes : this.sizeBytes,
      snapshotId: snapshotId is String? ? snapshotId : this.snapshotId,
      target: target ?? this.target,
      error: error is String? ? error : this.error,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
