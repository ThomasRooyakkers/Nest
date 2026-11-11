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
import '../admin/admin_user_household.dart' as _if44ldo0;
import '../admin/admin_user_summary.dart' as _i1o1zq20;
import '../sign_in_methods.dart' as _i7kwc777;

/// One user in the admin portal: their households, sign-in methods and
/// sessions. No household content.
abstract class AdminUserDetail
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AdminUserDetail._({
    required this.summary,
    required this.households,
    required this.signInMethods,
    required this.activeSessions,
    this.lastSeenAt,
  });

  factory AdminUserDetail({
    required _i1o1zq20.AdminUserSummary summary,
    required List<_if44ldo0.AdminUserHousehold> households,
    required _i7kwc777.SignInMethods signInMethods,
    required int activeSessions,
    DateTime? lastSeenAt,
  }) = _AdminUserDetailImpl;

  factory AdminUserDetail.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminUserDetail(
      summary: _ilcqbmdc.Protocol().deserialize<_i1o1zq20.AdminUserSummary>(
        jsonSerialization['summary'],
      ),
      households: _ilcqbmdc.Protocol()
          .deserialize<List<_if44ldo0.AdminUserHousehold>>(
            jsonSerialization['households'],
          ),
      signInMethods: _ilcqbmdc.Protocol().deserialize<_i7kwc777.SignInMethods>(
        jsonSerialization['signInMethods'],
      ),
      activeSessions: jsonSerialization['activeSessions'] as int,
      lastSeenAt: jsonSerialization['lastSeenAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastSeenAt'],
            ),
    );
  }

  _i1o1zq20.AdminUserSummary summary;

  List<_if44ldo0.AdminUserHousehold> households;

  _i7kwc777.SignInMethods signInMethods;

  /// Devices that are signed in (refresh tokens).
  int activeSessions;

  /// Newest token refresh of any device: roughly when they last used Nest.
  DateTime? lastSeenAt;

  /// Returns a shallow copy of this [AdminUserDetail]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AdminUserDetail copyWith({
    _i1o1zq20.AdminUserSummary? summary,
    List<_if44ldo0.AdminUserHousehold>? households,
    _i7kwc777.SignInMethods? signInMethods,
    int? activeSessions,
    DateTime? lastSeenAt = const _isc.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminUserDetail',
      'summary': summary.toJson(),
      'households': households.toJson(valueToJson: (v) => v.toJson()),
      'signInMethods': signInMethods.toJson(),
      'activeSessions': activeSessions,
      if (lastSeenAt != null) 'lastSeenAt': lastSeenAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminUserDetail',
      'summary': summary.toJsonForProtocol(),
      'households': households.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'signInMethods': signInMethods.toJsonForProtocol(),
      'activeSessions': activeSessions,
      if (lastSeenAt != null) 'lastSeenAt': lastSeenAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _AdminUserDetailImpl extends AdminUserDetail {
  _AdminUserDetailImpl({
    required _i1o1zq20.AdminUserSummary summary,
    required List<_if44ldo0.AdminUserHousehold> households,
    required _i7kwc777.SignInMethods signInMethods,
    required int activeSessions,
    DateTime? lastSeenAt,
  }) : super._(
         summary: summary,
         households: households,
         signInMethods: signInMethods,
         activeSessions: activeSessions,
         lastSeenAt: lastSeenAt,
       );

  /// Returns a shallow copy of this [AdminUserDetail]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AdminUserDetail copyWith({
    _i1o1zq20.AdminUserSummary? summary,
    List<_if44ldo0.AdminUserHousehold>? households,
    _i7kwc777.SignInMethods? signInMethods,
    int? activeSessions,
    DateTime? lastSeenAt = const _isc.$UndefinedDateTime(),
  }) {
    return AdminUserDetail(
      summary: summary ?? this.summary.copyWith(),
      households:
          households ?? this.households.map((e0) => e0.copyWith()).toList(),
      signInMethods: signInMethods ?? this.signInMethods.copyWith(),
      activeSessions: activeSessions ?? this.activeSessions,
      lastSeenAt: lastSeenAt is _isc.UndefinedSentinel
          ? this.lastSeenAt
          : lastSeenAt,
    );
  }
}
