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
import '../household.dart' as _iaj5kvsg;
import '../nest_user.dart' as _ihr4yuyc;
import '../watchlist/watch_status.dart' as _ikkd49ke;
import '../watchlist/watch_type.dart' as _ix3az44g;

/// A film or series on the household's watchlist. The details are copied
/// from the film data when it is added.
abstract class WatchlistItem
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  WatchlistItem._({
    this.id,
    required this.householdId,
    this.household,
    required this.tmdbId,
    required this.type,
    required this.title,
    this.posterPath,
    this.year,
    this.rating,
    _ikkd49ke.WatchStatus? status,
    this.addedById,
    this.addedBy,
    this.householdRating,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : status = status ?? _ikkd49ke.WatchStatus.want,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory WatchlistItem({
    int? id,
    required int householdId,
    _iaj5kvsg.Household? household,
    required int tmdbId,
    required _ix3az44g.WatchType type,
    required String title,
    String? posterPath,
    int? year,
    double? rating,
    _ikkd49ke.WatchStatus? status,
    int? addedById,
    _ihr4yuyc.NestUser? addedBy,
    int? householdRating,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _WatchlistItemImpl;

  factory WatchlistItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return WatchlistItem(
      id: jsonSerialization['id'] as int?,
      householdId: jsonSerialization['householdId'] as int,
      household: jsonSerialization['household'] == null
          ? null
          : _ilcqbmdc.Protocol().deserialize<_iaj5kvsg.Household>(
              jsonSerialization['household'],
            ),
      tmdbId: jsonSerialization['tmdbId'] as int,
      type: _ix3az44g.WatchType.fromJson((jsonSerialization['type'] as String)),
      title: jsonSerialization['title'] as String,
      posterPath: jsonSerialization['posterPath'] as String?,
      year: jsonSerialization['year'] as int?,
      rating: (jsonSerialization['rating'] as num?)?.toDouble(),
      status: jsonSerialization['status'] == null
          ? null
          : _ikkd49ke.WatchStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      addedById: jsonSerialization['addedById'] as int?,
      addedBy: jsonSerialization['addedBy'] == null
          ? null
          : _ilcqbmdc.Protocol().deserialize<_ihr4yuyc.NestUser>(
              jsonSerialization['addedBy'],
            ),
      householdRating: jsonSerialization['householdRating'] as int?,
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

  int householdId;

  _iaj5kvsg.Household? household;

  int tmdbId;

  _ix3az44g.WatchType type;

  String title;

  String? posterPath;

  int? year;

  /// TMDB's average vote, 0–10.
  double? rating;

  _ikkd49ke.WatchStatus status;

  int? addedById;

  _ihr4yuyc.NestUser? addedBy;

  /// The household's own rating, 1–5 stars; null when not rated.
  int? householdRating;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [WatchlistItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  WatchlistItem copyWith({
    int? id,
    int? householdId,
    _iaj5kvsg.Household? household,
    int? tmdbId,
    _ix3az44g.WatchType? type,
    String? title,
    String? posterPath,
    int? year,
    double? rating,
    _ikkd49ke.WatchStatus? status,
    int? addedById,
    _ihr4yuyc.NestUser? addedBy,
    int? householdRating,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WatchlistItem',
      if (id != null) 'id': id,
      'householdId': householdId,
      if (household != null) 'household': household?.toJson(),
      'tmdbId': tmdbId,
      'type': type.toJson(),
      'title': title,
      if (posterPath != null) 'posterPath': posterPath,
      if (year != null) 'year': year,
      if (rating != null) 'rating': rating,
      'status': status.toJson(),
      if (addedById != null) 'addedById': addedById,
      if (addedBy != null) 'addedBy': addedBy?.toJson(),
      if (householdRating != null) 'householdRating': householdRating,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WatchlistItem',
      if (id != null) 'id': id,
      'householdId': householdId,
      if (household != null) 'household': household?.toJsonForProtocol(),
      'tmdbId': tmdbId,
      'type': type.toJson(),
      'title': title,
      if (posterPath != null) 'posterPath': posterPath,
      if (year != null) 'year': year,
      if (rating != null) 'rating': rating,
      'status': status.toJson(),
      if (addedById != null) 'addedById': addedById,
      if (addedBy != null) 'addedBy': addedBy?.toJsonForProtocol(),
      if (householdRating != null) 'householdRating': householdRating,
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

class _WatchlistItemImpl extends WatchlistItem {
  _WatchlistItemImpl({
    int? id,
    required int householdId,
    _iaj5kvsg.Household? household,
    required int tmdbId,
    required _ix3az44g.WatchType type,
    required String title,
    String? posterPath,
    int? year,
    double? rating,
    _ikkd49ke.WatchStatus? status,
    int? addedById,
    _ihr4yuyc.NestUser? addedBy,
    int? householdRating,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         householdId: householdId,
         household: household,
         tmdbId: tmdbId,
         type: type,
         title: title,
         posterPath: posterPath,
         year: year,
         rating: rating,
         status: status,
         addedById: addedById,
         addedBy: addedBy,
         householdRating: householdRating,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [WatchlistItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  WatchlistItem copyWith({
    Object? id = _Undefined,
    int? householdId,
    Object? household = _Undefined,
    int? tmdbId,
    _ix3az44g.WatchType? type,
    String? title,
    Object? posterPath = _Undefined,
    Object? year = _Undefined,
    Object? rating = _Undefined,
    _ikkd49ke.WatchStatus? status,
    Object? addedById = _Undefined,
    Object? addedBy = _Undefined,
    Object? householdRating = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WatchlistItem(
      id: id is int? ? id : this.id,
      householdId: householdId ?? this.householdId,
      household: household is _iaj5kvsg.Household?
          ? household
          : this.household?.copyWith(),
      tmdbId: tmdbId ?? this.tmdbId,
      type: type ?? this.type,
      title: title ?? this.title,
      posterPath: posterPath is String? ? posterPath : this.posterPath,
      year: year is int? ? year : this.year,
      rating: rating is double? ? rating : this.rating,
      status: status ?? this.status,
      addedById: addedById is int? ? addedById : this.addedById,
      addedBy: addedBy is _ihr4yuyc.NestUser?
          ? addedBy
          : this.addedBy?.copyWith(),
      householdRating: householdRating is int?
          ? householdRating
          : this.householdRating,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
