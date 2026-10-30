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
import '../meals/meal_plan_entry.dart' as _iyo7z7wz;

/// A change in a household's meal plan, sent to everyone watching.
abstract class MealPlanEvent
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  MealPlanEvent._({
    required this.householdId,
    this.entries,
    this.removedEntryIds,
  });

  factory MealPlanEvent({
    required int householdId,
    List<_iyo7z7wz.MealPlanEntry>? entries,
    List<int>? removedEntryIds,
  }) = _MealPlanEventImpl;

  factory MealPlanEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return MealPlanEvent(
      householdId: jsonSerialization['householdId'] as int,
      entries: jsonSerialization['entries'] == null
          ? null
          : _ilcqbmdc.Protocol().deserialize<List<_iyo7z7wz.MealPlanEntry>>(
              jsonSerialization['entries'],
            ),
      removedEntryIds: jsonSerialization['removedEntryIds'] == null
          ? null
          : _ilcqbmdc.Protocol().deserialize<List<int>>(
              jsonSerialization['removedEntryIds'],
            ),
    );
  }

  int householdId;

  List<_iyo7z7wz.MealPlanEntry>? entries;

  List<int>? removedEntryIds;

  /// Returns a shallow copy of this [MealPlanEvent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  MealPlanEvent copyWith({
    int? householdId,
    List<_iyo7z7wz.MealPlanEntry>? entries,
    List<int>? removedEntryIds,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MealPlanEvent',
      'householdId': householdId,
      if (entries != null)
        'entries': entries?.toJson(valueToJson: (v) => v.toJson()),
      if (removedEntryIds != null) 'removedEntryIds': removedEntryIds?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MealPlanEvent',
      'householdId': householdId,
      if (entries != null)
        'entries': entries?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (removedEntryIds != null) 'removedEntryIds': removedEntryIds?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MealPlanEventImpl extends MealPlanEvent {
  _MealPlanEventImpl({
    required int householdId,
    List<_iyo7z7wz.MealPlanEntry>? entries,
    List<int>? removedEntryIds,
  }) : super._(
         householdId: householdId,
         entries: entries,
         removedEntryIds: removedEntryIds,
       );

  /// Returns a shallow copy of this [MealPlanEvent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  MealPlanEvent copyWith({
    int? householdId,
    Object? entries = _Undefined,
    Object? removedEntryIds = _Undefined,
  }) {
    return MealPlanEvent(
      householdId: householdId ?? this.householdId,
      entries: entries is List<_iyo7z7wz.MealPlanEntry>?
          ? entries
          : this.entries?.map((e0) => e0.copyWith()).toList(),
      removedEntryIds: removedEntryIds is List<int>?
          ? removedEntryIds
          : this.removedEntryIds?.map((e0) => e0).toList(),
    );
  }
}
