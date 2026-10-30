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
import '../watchlist/watch_type.dart' as _ix3az44g;

/// A film or series found through the server's film data (TMDB, or the
/// fake fixtures in development).
abstract class TmdbTitle
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  TmdbTitle._({
    required this.tmdbId,
    required this.type,
    required this.title,
    this.posterPath,
    this.year,
    this.rating,
    String? overview,
  }) : overview = overview ?? '';

  factory TmdbTitle({
    required int tmdbId,
    required _ix3az44g.WatchType type,
    required String title,
    String? posterPath,
    int? year,
    double? rating,
    String? overview,
  }) = _TmdbTitleImpl;

  factory TmdbTitle.fromJson(Map<String, dynamic> jsonSerialization) {
    return TmdbTitle(
      tmdbId: jsonSerialization['tmdbId'] as int,
      type: _ix3az44g.WatchType.fromJson((jsonSerialization['type'] as String)),
      title: jsonSerialization['title'] as String,
      posterPath: jsonSerialization['posterPath'] as String?,
      year: jsonSerialization['year'] as int?,
      rating: (jsonSerialization['rating'] as num?)?.toDouble(),
      overview: jsonSerialization['overview'] as String?,
    );
  }

  int tmdbId;

  _ix3az44g.WatchType type;

  String title;

  /// TMDB poster path, e.g. `/abc.jpg`; null without a poster.
  String? posterPath;

  int? year;

  /// TMDB's average vote, 0–10; null when nobody voted yet.
  double? rating;

  String overview;

  /// Returns a shallow copy of this [TmdbTitle]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TmdbTitle copyWith({
    int? tmdbId,
    _ix3az44g.WatchType? type,
    String? title,
    String? posterPath,
    int? year,
    double? rating,
    String? overview,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TmdbTitle',
      'tmdbId': tmdbId,
      'type': type.toJson(),
      'title': title,
      if (posterPath != null) 'posterPath': posterPath,
      if (year != null) 'year': year,
      if (rating != null) 'rating': rating,
      'overview': overview,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TmdbTitle',
      'tmdbId': tmdbId,
      'type': type.toJson(),
      'title': title,
      if (posterPath != null) 'posterPath': posterPath,
      if (year != null) 'year': year,
      if (rating != null) 'rating': rating,
      'overview': overview,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TmdbTitleImpl extends TmdbTitle {
  _TmdbTitleImpl({
    required int tmdbId,
    required _ix3az44g.WatchType type,
    required String title,
    String? posterPath,
    int? year,
    double? rating,
    String? overview,
  }) : super._(
         tmdbId: tmdbId,
         type: type,
         title: title,
         posterPath: posterPath,
         year: year,
         rating: rating,
         overview: overview,
       );

  /// Returns a shallow copy of this [TmdbTitle]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TmdbTitle copyWith({
    int? tmdbId,
    _ix3az44g.WatchType? type,
    String? title,
    Object? posterPath = _Undefined,
    Object? year = _Undefined,
    Object? rating = _Undefined,
    String? overview,
  }) {
    return TmdbTitle(
      tmdbId: tmdbId ?? this.tmdbId,
      type: type ?? this.type,
      title: title ?? this.title,
      posterPath: posterPath is String? ? posterPath : this.posterPath,
      year: year is int? ? year : this.year,
      rating: rating is double? ? rating : this.rating,
      overview: overview ?? this.overview,
    );
  }
}
