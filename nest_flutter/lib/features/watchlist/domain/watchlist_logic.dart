import 'dart:math';

import 'package:nest_client/nest_client.dart';

/// Base address of TMDB's poster images, at a width that suits a
/// three-column grid on a phone.
const tmdbPosterBase = 'https://image.tmdb.org/t/p/w342';

/// The full address of a TMDB poster path, or null without a poster.
String? posterUrl(String? posterPath) =>
    posterPath == null || posterPath.isEmpty
    ? null
    : '$tmdbPosterBase$posterPath';

/// The titles with [status], most recently added first.
List<WatchlistItem> itemsWithStatus(
  List<WatchlistItem> items,
  WatchStatus status,
) => items.where((i) => i.status == status).toList()
  ..sort(
    (a, b) => b.createdAt.compareTo(a.createdAt) != 0
        ? b.createdAt.compareTo(a.createdAt)
        : (b.id ?? 0).compareTo(a.id ?? 0),
  );

/// How many titles there are per status.
Map<WatchStatus, int> statusCounts(List<WatchlistItem> items) => {
  for (final status in WatchStatus.values)
    status: items.where((i) => i.status == status).length,
};

/// A random title to watch tonight from the ones the household wants to
/// watch; another than [previous] when there is a choice. Null when the
/// list is empty.
WatchlistItem? pickForTonight(
  List<WatchlistItem> items, {
  WatchlistItem? previous,
  Random? random,
}) {
  final wanted = items.where((i) => i.status == WatchStatus.want).toList();
  if (wanted.length > 1 && previous != null) {
    wanted.removeWhere((i) => i.id == previous.id);
  }
  if (wanted.isEmpty) return null;
  return wanted[(random ?? Random()).nextInt(wanted.length)];
}

/// Whether [title] is already on the watchlist.
bool isOnWatchlist(List<WatchlistItem> items, TmdbTitle title) => items.any(
  (i) => i.type == title.type && i.tmdbId == title.tmdbId,
);
