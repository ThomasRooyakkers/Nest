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
import 'household_feature.dart' as _idhxy0am;
import 'household_status.dart' as _imk37xix;

/// Household metadata for the admin portal. Never contains household content.
abstract class AdminHouseholdSummary
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AdminHouseholdSummary._({
    required this.id,
    required this.name,
    required this.status,
    required this.memberCount,
    required this.ownerNames,
    required this.enabledFeatures,
    required this.createdAt,
  });

  factory AdminHouseholdSummary({
    required int id,
    required String name,
    required _imk37xix.HouseholdStatus status,
    required int memberCount,
    required List<String> ownerNames,
    required List<_idhxy0am.HouseholdFeature> enabledFeatures,
    required DateTime createdAt,
  }) = _AdminHouseholdSummaryImpl;

  factory AdminHouseholdSummary.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AdminHouseholdSummary(
      id: jsonSerialization['id'] as int,
      name: jsonSerialization['name'] as String,
      status: _imk37xix.HouseholdStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      memberCount: jsonSerialization['memberCount'] as int,
      ownerNames: _imc1swab.Protocol().deserialize<List<String>>(
        jsonSerialization['ownerNames'],
      ),
      enabledFeatures: _imc1swab.Protocol()
          .deserialize<List<_idhxy0am.HouseholdFeature>>(
            jsonSerialization['enabledFeatures'],
          ),
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  int id;

  String name;

  _imk37xix.HouseholdStatus status;

  int memberCount;

  List<String> ownerNames;

  List<_idhxy0am.HouseholdFeature> enabledFeatures;

  DateTime createdAt;

  /// Returns a shallow copy of this [AdminHouseholdSummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AdminHouseholdSummary copyWith({
    int? id,
    String? name,
    _imk37xix.HouseholdStatus? status,
    int? memberCount,
    List<String>? ownerNames,
    List<_idhxy0am.HouseholdFeature>? enabledFeatures,
    DateTime? createdAt,
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
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _AdminHouseholdSummaryImpl extends AdminHouseholdSummary {
  _AdminHouseholdSummaryImpl({
    required int id,
    required String name,
    required _imk37xix.HouseholdStatus status,
    required int memberCount,
    required List<String> ownerNames,
    required List<_idhxy0am.HouseholdFeature> enabledFeatures,
    required DateTime createdAt,
  }) : super._(
         id: id,
         name: name,
         status: status,
         memberCount: memberCount,
         ownerNames: ownerNames,
         enabledFeatures: enabledFeatures,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AdminHouseholdSummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AdminHouseholdSummary copyWith({
    int? id,
    String? name,
    _imk37xix.HouseholdStatus? status,
    int? memberCount,
    List<String>? ownerNames,
    List<_idhxy0am.HouseholdFeature>? enabledFeatures,
    DateTime? createdAt,
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
    );
  }
}
