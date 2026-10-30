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

/// A user as the admin portal sees them. No household content.
abstract class AdminUserSummary
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AdminUserSummary._({
    required this.id,
    required this.name,
    this.email,
    required this.locale,
    required this.isSuperAdmin,
    this.disabledAt,
    required this.householdCount,
    required this.createdAt,
  });

  factory AdminUserSummary({
    required int id,
    required String name,
    String? email,
    required String locale,
    required bool isSuperAdmin,
    DateTime? disabledAt,
    required int householdCount,
    required DateTime createdAt,
  }) = _AdminUserSummaryImpl;

  factory AdminUserSummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminUserSummary(
      id: jsonSerialization['id'] as int,
      name: jsonSerialization['name'] as String,
      email: jsonSerialization['email'] as String?,
      locale: jsonSerialization['locale'] as String,
      isSuperAdmin: _is.BoolJsonExtension.fromJson(
        jsonSerialization['isSuperAdmin'],
      ),
      disabledAt: jsonSerialization['disabledAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['disabledAt']),
      householdCount: jsonSerialization['householdCount'] as int,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  int id;

  String name;

  String? email;

  String locale;

  bool isSuperAdmin;

  DateTime? disabledAt;

  int householdCount;

  DateTime createdAt;

  /// Returns a shallow copy of this [AdminUserSummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AdminUserSummary copyWith({
    int? id,
    String? name,
    String? email,
    String? locale,
    bool? isSuperAdmin,
    DateTime? disabledAt,
    int? householdCount,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminUserSummary',
      'id': id,
      'name': name,
      if (email != null) 'email': email,
      'locale': locale,
      'isSuperAdmin': isSuperAdmin,
      if (disabledAt != null) 'disabledAt': disabledAt?.toJson(),
      'householdCount': householdCount,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminUserSummary',
      'id': id,
      'name': name,
      if (email != null) 'email': email,
      'locale': locale,
      'isSuperAdmin': isSuperAdmin,
      if (disabledAt != null) 'disabledAt': disabledAt?.toJson(),
      'householdCount': householdCount,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminUserSummaryImpl extends AdminUserSummary {
  _AdminUserSummaryImpl({
    required int id,
    required String name,
    String? email,
    required String locale,
    required bool isSuperAdmin,
    DateTime? disabledAt,
    required int householdCount,
    required DateTime createdAt,
  }) : super._(
         id: id,
         name: name,
         email: email,
         locale: locale,
         isSuperAdmin: isSuperAdmin,
         disabledAt: disabledAt,
         householdCount: householdCount,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AdminUserSummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AdminUserSummary copyWith({
    int? id,
    String? name,
    Object? email = _Undefined,
    String? locale,
    bool? isSuperAdmin,
    Object? disabledAt = _Undefined,
    int? householdCount,
    DateTime? createdAt,
  }) {
    return AdminUserSummary(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email is String? ? email : this.email,
      locale: locale ?? this.locale,
      isSuperAdmin: isSuperAdmin ?? this.isSuperAdmin,
      disabledAt: disabledAt is DateTime? ? disabledAt : this.disabledAt,
      householdCount: householdCount ?? this.householdCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
