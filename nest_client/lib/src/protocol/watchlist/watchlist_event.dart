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
import '../watchlist/watchlist_item.dart' as _il0tzadi;

/// A change in a household's watchlist, sent to everyone watching.
abstract class WatchlistEvent
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  WatchlistEvent._({
    required this.householdId,
    this.items,
    this.removedItemIds,
  });

  factory WatchlistEvent({
    required int householdId,
    List<_il0tzadi.WatchlistItem>? items,
    List<int>? removedItemIds,
  }) = _WatchlistEventImpl;

  factory WatchlistEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return WatchlistEvent(
      householdId: jsonSerialization['householdId'] as int,
      items: jsonSerialization['items'] == null
          ? null
          : _ilcqbmdc.Protocol().deserialize<List<_il0tzadi.WatchlistItem>>(
              jsonSerialization['items'],
            ),
      removedItemIds: jsonSerialization['removedItemIds'] == null
          ? null
          : _ilcqbmdc.Protocol().deserialize<List<int>>(
              jsonSerialization['removedItemIds'],
            ),
    );
  }

  int householdId;

  List<_il0tzadi.WatchlistItem>? items;

  List<int>? removedItemIds;

  /// Returns a shallow copy of this [WatchlistEvent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  WatchlistEvent copyWith({
    int? householdId,
    List<_il0tzadi.WatchlistItem>? items,
    List<int>? removedItemIds,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WatchlistEvent',
      'householdId': householdId,
      if (items != null) 'items': items?.toJson(valueToJson: (v) => v.toJson()),
      if (removedItemIds != null) 'removedItemIds': removedItemIds?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WatchlistEvent',
      'householdId': householdId,
      if (items != null)
        'items': items?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (removedItemIds != null) 'removedItemIds': removedItemIds?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WatchlistEventImpl extends WatchlistEvent {
  _WatchlistEventImpl({
    required int householdId,
    List<_il0tzadi.WatchlistItem>? items,
    List<int>? removedItemIds,
  }) : super._(
         householdId: householdId,
         items: items,
         removedItemIds: removedItemIds,
       );

  /// Returns a shallow copy of this [WatchlistEvent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  WatchlistEvent copyWith({
    int? householdId,
    Object? items = _Undefined,
    Object? removedItemIds = _Undefined,
  }) {
    return WatchlistEvent(
      householdId: householdId ?? this.householdId,
      items: items is List<_il0tzadi.WatchlistItem>?
          ? items
          : this.items?.map((e0) => e0.copyWith()).toList(),
      removedItemIds: removedItemIds is List<int>?
          ? removedItemIds
          : this.removedItemIds?.map((e0) => e0).toList(),
    );
  }
}
