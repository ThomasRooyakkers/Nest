import 'dart:convert';
import 'dart:io';

import '../generated/protocol.dart';
import 'host_settings.dart';

/// Film and series data for the watchlist. Only the server talks to TMDB,
/// with the host's own key.
///
/// [instance] is the real [HttpTmdbService] when the host set `tmdbApiKey`,
/// and [FakeTmdbService] otherwise (development, or before a key is set).
abstract class TmdbService {
  /// Films and series matching [query], in [locale] (`en` or `nl`) where
  /// TMDB has a translation. People and other results are left out.
  Future<List<TmdbTitle>> search(String query, {required String locale});

  /// One title, or null when TMDB does not know it.
  Future<TmdbTitle?> details(
    WatchType type,
    int tmdbId, {
    required String locale,
  });

  /// For tests: replaces [instance].
  static TmdbService? override;

  static TmdbService get instance {
    if (override case final service?) return service;
    final key = HostSettings.tmdbApiKey;
    return key == null ? FakeTmdbService() : HttpTmdbService(key);
  }
}

/// Thrown when the film data cannot be reached; the endpoint turns it into
/// [NestErrorCode.filmDataUnavailable].
class TmdbUnavailable implements Exception {
  TmdbUnavailable(this.message);

  final String message;

  @override
  String toString() => 'TmdbUnavailable: $message';
}

/// TMDB's API (v3). The key may be a v3 API key or a v4 read access token.
class HttpTmdbService implements TmdbService {
  HttpTmdbService(this._key);

  final String _key;

  static const _host = 'api.themoviedb.org';

  @override
  Future<List<TmdbTitle>> search(String query, {required String locale}) async {
    final body = await _get('/3/search/multi', {
      'query': query,
      'include_adult': 'false',
      'language': _language(locale),
    });
    return [
      for (final result in (body['results'] as List? ?? const []))
        ?parseTitle(result as Map<String, dynamic>),
    ];
  }

  @override
  Future<TmdbTitle?> details(
    WatchType type,
    int tmdbId, {
    required String locale,
  }) async {
    final kind = type == WatchType.movie ? 'movie' : 'tv';
    final Map<String, dynamic> body;
    try {
      body = await _get('/3/$kind/$tmdbId', {'language': _language(locale)});
    } on _NotFound {
      return null;
    }
    return parseTitle(body, type: type);
  }

  /// A TMDB result as a [TmdbTitle]; null for people and other kinds.
  /// Search results carry their kind in `media_type`; details pass [type].
  static TmdbTitle? parseTitle(Map<String, dynamic> json, {WatchType? type}) {
    type ??= switch (json['media_type']) {
      'movie' => WatchType.movie,
      'tv' => WatchType.series,
      _ => null,
    };
    final id = json['id'];
    if (type == null || id is! int) return null;
    final title =
        (type == WatchType.movie ? json['title'] : json['name']) as String?;
    if (title == null || title.trim().isEmpty) return null;
    final date =
        (type == WatchType.movie
                ? json['release_date']
                : json['first_air_date'])
            as String?;
    final votes = json['vote_count'];
    final rating = json['vote_average'];
    return TmdbTitle(
      tmdbId: id,
      type: type,
      title: title.trim(),
      posterPath: json['poster_path'] as String?,
      year: date == null || date.length < 4
          ? null
          : int.tryParse(date.substring(0, 4)),
      rating: rating is num && (votes is! num || votes > 0)
          ? rating.toDouble()
          : null,
      overview: (json['overview'] as String? ?? '').trim(),
    );
  }

  static String _language(String locale) => locale == 'nl' ? 'nl-NL' : 'en-US';

  Future<Map<String, dynamic>> _get(
    String path,
    Map<String, String> query,
  ) async {
    // A v4 read access token is a JWT; a v3 key goes in the query.
    final bearer = _key.startsWith('eyJ');
    final uri = Uri.https(_host, path, {
      ...query,
      if (!bearer) 'api_key': _key,
    });
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 10);
    try {
      final request = await client.getUrl(uri);
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      if (bearer) {
        request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $_key');
      }
      final response = await request.close().timeout(
        const Duration(seconds: 15),
      );
      final body = await response.transform(utf8.decoder).join();
      if (response.statusCode == 404) throw _NotFound();
      if (response.statusCode != 200) {
        throw TmdbUnavailable('TMDB answered ${response.statusCode}');
      }
      return jsonDecode(body) as Map<String, dynamic>;
    } on TmdbUnavailable {
      rethrow;
    } on _NotFound {
      rethrow;
    } catch (e) {
      throw TmdbUnavailable('$e');
    } finally {
      client.close();
    }
  }
}

class _NotFound implements Exception {}

/// Fixtures for development and tests, so the watchlist works without a
/// TMDB key. The app shows a placeholder for the missing posters.
class FakeTmdbService implements TmdbService {
  static const _titles = [
    (1, WatchType.movie, 'Paddington 2', null, 2017, 7.6),
    (2, WatchType.movie, 'Spirited Away', 'De reis van Chihiro', 2001, 8.5),
    (3, WatchType.movie, 'The Grand Budapest Hotel', null, 2014, 8.0),
    (4, WatchType.movie, 'Up', 'Op', 2009, 7.9),
    (5, WatchType.movie, 'Inside Out', 'Binnenstebuiten', 2015, 7.9),
    (6, WatchType.movie, 'Amélie', null, 2001, 7.9),
    (7, WatchType.movie, 'The Intouchables', 'Intouchables', 2011, 8.3),
    (8, WatchType.movie, 'Coco', null, 2017, 8.2),
    (9, WatchType.movie, 'Knives Out', null, 2019, 7.8),
    (10, WatchType.movie, 'Dune', null, 2021, 7.8),
    (
      11,
      WatchType.movie,
      'My Neighbor Totoro',
      'Mijn buurman Totoro',
      1988,
      8.1,
    ),
    (12, WatchType.series, 'The Great British Bake Off', null, 2010, 7.5),
    (13, WatchType.series, 'Planet Earth', 'Planeet Aarde', 2006, 8.6),
    (14, WatchType.series, 'Bluey', null, 2018, 8.7),
    (15, WatchType.series, 'Ted Lasso', null, 2020, 8.2),
    (16, WatchType.series, 'The Crown', null, 2016, 8.2),
    (17, WatchType.series, 'Flikken Maastricht', null, 2007, 6.9),
    (18, WatchType.series, 'De Luizenmoeder', null, 2018, 7.4),
    (19, WatchType.series, 'Only Murders in the Building', null, 2021, 8.0),
    (20, WatchType.series, 'Planet Earth II', 'Planeet Aarde II', 2016, 8.8),
  ];

  @override
  Future<List<TmdbTitle>> search(String query, {required String locale}) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];
    return [
      for (final t in _titles)
        if (t.$3.toLowerCase().contains(q) ||
            (t.$4?.toLowerCase().contains(q) ?? false))
          _title(t, locale),
    ];
  }

  @override
  Future<TmdbTitle?> details(
    WatchType type,
    int tmdbId, {
    required String locale,
  }) async {
    for (final t in _titles) {
      if (t.$1 == tmdbId && t.$2 == type) return _title(t, locale);
    }
    return null;
  }

  static TmdbTitle _title(
    (int, WatchType, String, String?, int, double) t,
    String locale,
  ) => TmdbTitle(
    tmdbId: t.$1,
    type: t.$2,
    title: locale == 'nl' ? (t.$4 ?? t.$3) : t.$3,
    year: t.$5,
    rating: t.$6,
  );
}
