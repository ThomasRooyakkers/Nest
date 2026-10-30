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
import '../admin/backup_request.dart' as _i4av8j21;
import '../admin/backup_run.dart' as _i2211eyr;

/// Backups page of the admin portal.
abstract class AdminBackups
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AdminBackups._({
    required this.runs,
    this.pendingRequest,
  });

  factory AdminBackups({
    required List<_i2211eyr.BackupRun> runs,
    _i4av8j21.BackupRequest? pendingRequest,
  }) = _AdminBackupsImpl;

  factory AdminBackups.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminBackups(
      runs: _imc1swab.Protocol().deserialize<List<_i2211eyr.BackupRun>>(
        jsonSerialization['runs'],
      ),
      pendingRequest: jsonSerialization['pendingRequest'] == null
          ? null
          : _imc1swab.Protocol().deserialize<_i4av8j21.BackupRequest>(
              jsonSerialization['pendingRequest'],
            ),
    );
  }

  /// Most recent runs, newest first.
  List<_i2211eyr.BackupRun> runs;

  /// A "Back up now" that the backup job has not picked up yet.
  _i4av8j21.BackupRequest? pendingRequest;

  /// Returns a shallow copy of this [AdminBackups]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AdminBackups copyWith({
    List<_i2211eyr.BackupRun>? runs,
    _i4av8j21.BackupRequest? pendingRequest,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminBackups',
      'runs': runs.toJson(valueToJson: (v) => v.toJson()),
      if (pendingRequest != null) 'pendingRequest': pendingRequest?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminBackups',
      'runs': runs.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (pendingRequest != null)
        'pendingRequest': pendingRequest?.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminBackupsImpl extends AdminBackups {
  _AdminBackupsImpl({
    required List<_i2211eyr.BackupRun> runs,
    _i4av8j21.BackupRequest? pendingRequest,
  }) : super._(
         runs: runs,
         pendingRequest: pendingRequest,
       );

  /// Returns a shallow copy of this [AdminBackups]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AdminBackups copyWith({
    List<_i2211eyr.BackupRun>? runs,
    Object? pendingRequest = _Undefined,
  }) {
    return AdminBackups(
      runs: runs ?? this.runs.map((e0) => e0.copyWith()).toList(),
      pendingRequest: pendingRequest is _i4av8j21.BackupRequest?
          ? pendingRequest
          : this.pendingRequest?.copyWith(),
    );
  }
}
