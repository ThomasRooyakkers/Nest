import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../../l10n/app_localizations.dart';
import '../domain/watchlist_logic.dart';

String statusLabel(AppLocalizations l10n, WatchStatus status) =>
    switch (status) {
      WatchStatus.want => l10n.watchStatusWant,
      WatchStatus.watching => l10n.watchStatusWatching,
      WatchStatus.watched => l10n.watchStatusWatched,
    };

String typeLabel(AppLocalizations l10n, WatchType type) => switch (type) {
  WatchType.movie => l10n.watchTypeMovie,
  WatchType.series => l10n.watchTypeSeries,
};

/// "Film · 2017".
String typeAndYear(AppLocalizations l10n, WatchType type, int? year) => [
  typeLabel(l10n, type),
  ?year?.toString(),
].join(' · ');

/// A TMDB rating with one decimal in the app's language, e.g. "7,6".
String ratingText(BuildContext context, double rating) {
  final locale = Localizations.localeOf(context).languageCode;
  final text = rating.toStringAsFixed(1);
  return locale == 'nl' ? text.replaceAll('.', ',') : text;
}

/// A 2:3 poster, or a lavender placeholder with the kind's icon when there
/// is none (or it does not load).
class PosterImage extends StatelessWidget {
  const PosterImage({
    super.key,
    required this.posterPath,
    required this.type,
    this.radius = 16,
  });

  final String? posterPath;
  final WatchType type;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final colors = NestColors.of(context);
    final placeholder = ColoredBox(
      color: colors.lavender,
      child: Center(
        child: Icon(
          type == WatchType.movie ? LucideIcons.clapperboard : LucideIcons.tv,
          size: 28,
          color: colors.lavenderInk,
        ),
      ),
    );
    final url = posterUrl(posterPath);
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: AspectRatio(
        aspectRatio: 2 / 3,
        child: url == null
            ? placeholder
            : Image.network(
                url,
                fit: BoxFit.cover,
                // TMDB's images may not allow cross-origin reads on the web.
                webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
                errorBuilder: (_, _, _) => placeholder,
                loadingBuilder: (context, child, progress) =>
                    progress == null ? child : placeholder,
              ),
      ),
    );
  }
}

/// The TMDB attribution line (required wherever TMDB data is shown).
class TmdbAttribution extends StatelessWidget {
  const TmdbAttribution({super.key});

  @override
  Widget build(BuildContext context) => Text(
    AppLocalizations.of(context).tmdbAttribution,
    style: Theme.of(context).textTheme.bodySmall,
  );
}
