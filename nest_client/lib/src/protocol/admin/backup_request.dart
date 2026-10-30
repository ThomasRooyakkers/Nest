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

/// "Back up now" from the admin portal. The backup job picks it up within a
/// minute and sets [pickedUpAt].
abstract class BackupRequest
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  BackupRequest._({
    this.id,
    required this.requestedBy,
    DateTime? requestedAt,
    this.pickedUpAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : requestedAt = requestedAt ?? DateTime.now(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory BackupRequest({
    int? id,
    required int requestedBy,
    DateTime? requestedAt,
    DateTime? pickedUpAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _BackupRequestImpl;

  factory BackupRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return BackupRequest(
      id: jsonSerialization['id'] as int?,
      requestedBy: jsonSerialization['requestedBy'] as int,
      requestedAt: jsonSerialization['requestedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['requestedAt'],
            ),
      pickedUpAt: jsonSerialization['pickedUpAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['pickedUpAt'],
            ),
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

  /// `NestUser.id` of the admin who asked.
  int requestedBy;

  DateTime requestedAt;

  DateTime? pickedUpAt;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [BackupRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  BackupRequest copyWith({
    int? id,
    int? requestedBy,
    DateTime? requestedAt,
    DateTime? pickedUpAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BackupRequest',
      if (id != null) 'id': id,
      'requestedBy': requestedBy,
      'requestedAt': requestedAt.toJson(),
      if (pickedUpAt != null) 'pickedUpAt': pickedUpAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'BackupRequest',
      if (id != null) 'id': id,
      'requestedBy': requestedBy,
      'requestedAt': requestedAt.toJson(),
      if (pickedUpAt != null) 'pickedUpAt': pickedUpAt?.toJson(),
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

class _BackupRequestImpl extends BackupRequest {
  _BackupRequestImpl({
    int? id,
    required int requestedBy,
    DateTime? requestedAt,
    DateTime? pickedUpAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         requestedBy: requestedBy,
         requestedAt: requestedAt,
         pickedUpAt: pickedUpAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [BackupRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  BackupRequest copyWith({
    Object? id = _Undefined,
    int? requestedBy,
    DateTime? requestedAt,
    Object? pickedUpAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BackupRequest(
      id: id is int? ? id : this.id,
      requestedBy: requestedBy ?? this.requestedBy,
      requestedAt: requestedAt ?? this.requestedAt,
      pickedUpAt: pickedUpAt is DateTime? ? pickedUpAt : this.pickedUpAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
