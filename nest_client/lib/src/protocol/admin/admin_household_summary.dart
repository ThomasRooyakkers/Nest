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
import '../household_feature.dart' as _im1kgcet;
import '../household_status.dart' as _iq0kpv8c;

/// Household metadata for the admin portal. Never contains household content.
abstract class AdminHouseholdSummary
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AdminHouseholdSummary._({
    required this.id,
    required this.name,
    required this.status,
    required this.memberCount,
    required this.ownerNames,
    required this.enabledFeatures,
    required this.createdAt,
    this.lastActivityAt,
  });

  factory AdminHouseholdSummary({
    required int id,
    required String name,
    required _iq0kpv8c.HouseholdStatus status,
    required int memberCount,
    required List<String> ownerNames,
    required List<_im1kgcet.HouseholdFeature> enabledFeatures,
    required DateTime createdAt,
    DateTime? lastActivityAt,
  }) = _AdminHouseholdSummaryImpl;

  factory AdminHouseholdSummary.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AdminHouseholdSummary(
      id: jsonSerialization['id'] as int,
      name: jsonSerialization['name'] as String,
      status: _iq0kpv8c.HouseholdStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      memberCount: jsonSerialization['memberCount'] as int,
      ownerNames: _ilcqbmdc.Protocol().deserialize<List<String>>(
        jsonSerialization['ownerNames'],
      ),
      enabledFeatures: _ilcqbmdc.Protocol()
          .deserialize<List<_im1kgcet.HouseholdFeature>>(
            jsonSerialization['enabledFeatures'],
          ),
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      lastActivityAt: jsonSerialization['lastActivityAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastActivityAt'],
            ),
    );
  }

  int id;

  String name;

  _iq0kpv8c.HouseholdStatus status;

  int memberCount;

  List<String> ownerNames;

  List<_im1kgcet.HouseholdFeature> enabledFeatures;

  DateTime createdAt;

  /// Newest change to the household or its data (time only).
  DateTime? lastActivityAt;

  /// Returns a shallow copy of this [AdminHouseholdSummary]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AdminHouseholdSummary copyWith({
    int? id,
    String? name,
    _iq0kpv8c.HouseholdStatus? status,
    int? memberCount,
    List<String>? ownerNames,
    List<_im1kgcet.HouseholdFeature>? enabledFeatures,
    DateTime? createdAt,
    DateTime? lastActivityAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminHouseholdSummary',
      'id': id,
      'name': name,
      'status': status.toJson(),
      'memberCount': memberCount,
      'ownerNames': ownerNames.toJson(),
      'enabledFeatures': enabledFeatures.toJson(valueToJson: (v) => v.toJson()),
      'createdAt': createdAt.toJson(),
      if (lastActivityAt != null) 'lastActivityAt': lastActivityAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminHouseholdSummary',
      'id': id,
      'name': name,
      'status': status.toJson(),
      'memberCount': memberCount,
      'ownerNames': ownerNames.toJson(),
      'enabledFeatures': enabledFeatures.toJson(valueToJson: (v) => v.toJson()),
      'createdAt': createdAt.toJson(),
      if (lastActivityAt != null) 'lastActivityAt': lastActivityAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminHouseholdSummaryImpl extends AdminHouseholdSummary {
  _AdminHouseholdSummaryImpl({
    required int id,
    required String name,
    required _iq0kpv8c.HouseholdStatus status,
    required int memberCount,
    required List<String> ownerNames,
    required List<_im1kgcet.HouseholdFeature> enabledFeatures,
    required DateTime createdAt,
    DateTime? lastActivityAt,
  }) : super._(
         id: id,
         name: name,
         status: status,
         memberCount: memberCount,
         ownerNames: ownerNames,
         enabledFeatures: enabledFeatures,
         createdAt: createdAt,
         lastActivityAt: lastActivityAt,
       );

  /// Returns a shallow copy of this [AdminHouseholdSummary]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AdminHouseholdSummary copyWith({
    int? id,
    String? name,
    _iq0kpv8c.HouseholdStatus? status,
    int? memberCount,
    List<String>? ownerNames,
    List<_im1kgcet.HouseholdFeature>? enabledFeatures,
    DateTime? createdAt,
    Object? lastActivityAt = _Undefined,
  }) {
    return AdminHouseholdSummary(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      memberCount: memberCount ?? this.memberCount,
      ownerNames: ownerNames ?? this.ownerNames.map((e0) => e0).toList(),
      enabledFeatures:
          enabledFeatures ?? this.enabledFeatures.map((e0) => e0).toList(),
      createdAt: createdAt ?? this.createdAt,
      lastActivityAt: lastActivityAt is DateTime?
          ? lastActivityAt
          : this.lastActivityAt,
    );
  }
}
