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

/// An invite code that lets someone join a household.
abstract class HouseholdInvite
    implements _is.SerializableModel, _is.ProtocolSerialization {
  HouseholdInvite._({
    required this.code,
    required this.expiresAt,
  });

  factory HouseholdInvite({
    required String code,
    required DateTime expiresAt,
  }) = _HouseholdInviteImpl;

  factory HouseholdInvite.fromJson(Map<String, dynamic> jsonSerialization) {
    return HouseholdInvite(
      code: jsonSerialization['code'] as String,
      expiresAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
    );
  }

  String code;

  DateTime expiresAt;

  /// Returns a shallow copy of this [HouseholdInvite]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  HouseholdInvite copyWith({
    String? code,
    DateTime? expiresAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'HouseholdInvite',
      'code': code,
      'expiresAt': expiresAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'HouseholdInvite',
      'code': code,
      'expiresAt': expiresAt.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _HouseholdInviteImpl extends HouseholdInvite {
  _HouseholdInviteImpl({
    required String code,
    required DateTime expiresAt,
  }) : super._(
         code: code,
         expiresAt: expiresAt,
       );

  /// Returns a shallow copy of this [HouseholdInvite]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  HouseholdInvite copyWith({
    String? code,
    DateTime? expiresAt,
  }) {
    return HouseholdInvite(
      code: code ?? this.code,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}
