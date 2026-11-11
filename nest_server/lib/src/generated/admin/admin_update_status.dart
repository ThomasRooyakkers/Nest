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
import 'package:serverpod/serverpod.dart' as _is;

/// The running version against the newest published Nest release.
abstract class AdminUpdateStatus
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AdminUpdateStatus._({
    required this.currentVersion,
    this.latestVersion,
    required this.updateAvailable,
    this.checkedAt,
    this.problem,
  });

  factory AdminUpdateStatus({
    required String currentVersion,
    String? latestVersion,
    required bool updateAvailable,
    DateTime? checkedAt,
    String? problem,
  }) = _AdminUpdateStatusImpl;

  factory AdminUpdateStatus.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminUpdateStatus(
      currentVersion: jsonSerialization['currentVersion'] as String,
      latestVersion: jsonSerialization['latestVersion'] as String?,
      updateAvailable: _is.BoolJsonExtension.fromJson(
        jsonSerialization['updateAvailable'],
      ),
      checkedAt: jsonSerialization['checkedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['checkedAt']),
      problem: jsonSerialization['problem'] as String?,
    );
  }

  String currentVersion;

  /// Null when the check is off or the release list could not be read.
  String? latestVersion;

  bool updateAvailable;

  DateTime? checkedAt;

  /// Why there is no answer: `off` or `unreachable`.
  String? problem;

  /// Returns a shallow copy of this [AdminUpdateStatus]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AdminUpdateStatus copyWith({
    String? currentVersion,
    String? latestVersion,
    bool? updateAvailable,
    DateTime? checkedAt = const _is.$UndefinedDateTime(),
    String? problem,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminUpdateStatus',
      'currentVersion': currentVersion,
      if (latestVersion != null) 'latestVersion': latestVersion,
      'updateAvailable': updateAvailable,
      if (checkedAt != null) 'checkedAt': checkedAt?.toJson(),
      if (problem != null) 'problem': problem,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminUpdateStatus',
      'currentVersion': currentVersion,
      if (latestVersion != null) 'latestVersion': latestVersion,
      'updateAvailable': updateAvailable,
      if (checkedAt != null) 'checkedAt': checkedAt?.toJson(),
      if (problem != null) 'problem': problem,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminUpdateStatusImpl extends AdminUpdateStatus {
  _AdminUpdateStatusImpl({
    required String currentVersion,
    String? latestVersion,
    required bool updateAvailable,
    DateTime? checkedAt,
    String? problem,
  }) : super._(
         currentVersion: currentVersion,
         latestVersion: latestVersion,
         updateAvailable: updateAvailable,
         checkedAt: checkedAt,
         problem: problem,
       );

  /// Returns a shallow copy of this [AdminUpdateStatus]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AdminUpdateStatus copyWith({
    String? currentVersion,
    Object? latestVersion = _Undefined,
    bool? updateAvailable,
    DateTime? checkedAt = const _is.$UndefinedDateTime(),
    Object? problem = _Undefined,
  }) {
    return AdminUpdateStatus(
      currentVersion: currentVersion ?? this.currentVersion,
      latestVersion: latestVersion is String?
          ? latestVersion
          : this.latestVersion,
      updateAvailable: updateAvailable ?? this.updateAvailable,
      checkedAt: checkedAt is _is.UndefinedSentinel
          ? this.checkedAt
          : checkedAt,
      problem: problem is String? ? problem : this.problem,
    );
  }
}
