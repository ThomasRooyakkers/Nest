import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../../core/backend/error_messages.dart';
import '../../../core/household/household_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../data/watchlist_repository.dart';
import '../domain/watchlist_logic.dart';
import 'watchlist_providers.dart';
import 'watchlist_style.dart';

/// Finds films and series through the server and adds them to the
/// watchlist.
class WatchlistSearchScreen extends ConsumerStatefulWidget {
  const WatchlistSearchScreen({super.key});

  /// Wait after the last key press before searching.
  static const debounce = Duration(milliseconds: 400);

  @override
  ConsumerState<WatchlistSearchScreen> createState() =>
      _WatchlistSearchScreenState();
}

class _WatchlistSearchScreenState extends ConsumerState<WatchlistSearchScreen> {
  final _query = TextEditingController();
  Timer? _debounce;

  /// The query the shown results belong to.
  String _searched = '';
  List<TmdbTitle>? _results;
  String? _error;
  var _searching = false;

  /// Titles being added right now.
  final _adding = <(WatchType, int)>{};

  @override
  void dispose() {
    _debounce?.cancel();
    _query.dispose();
    super.dispose();
  }

  void _onChanged(String _) {
    _debounce?.cancel();
    _debounce = Timer(WatchlistSearchScreen.debounce, _search);
  }

  Future<void> _search() async {
    _debounce?.cancel();
    final l10n = AppLocalizations.of(context);
    final query = _query.text.trim();
    final householdId = ref.read(activeHouseholdProvider)?.household.id;
    if (householdId == null || query == _searched) return;
    if (query.isEmpty) {
      setState(() {
        _searched = '';
        _results = null;
        _error = null;
      });
      return;
    }
    setState(() => _searching = true);
    try {
      final results = await ref
          .read(watchlistRepositoryProvider)
          .search(householdId, query);
      if (!mounted || _query.text.trim() != query) return;
      setState(() {
        _searched = query;
        _results = results;
        _error = null;
        _searching = false;
      });
    } on Exception catch (e) {
      if (!mounted) return;
      setState(() {
        _error = errorMessage(l10n, e);
        _searching = false;
      });
    }
  }

  Future<void> _add(int householdId, TmdbTitle title) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final key = (title.type, title.tmdbId);
    setState(() => _adding.add(key));
    try {
      final item = await ref
          .read(watchlistRepositoryProvider)
          .add(householdId, title);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.watchAdded(item.title))));
    } on Exception catch (e) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(errorMessage(l10n, e))));
    } finally {
      if (mounted) setState(() => _adding.remove(key));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final householdId = ref.watch(activeHouseholdProvider)?.household.id;
    if (householdId == null) return const Scaffold();
    final onList =
        ref.watch(watchlistItemsProvider(householdId)).value ??
        const <WatchlistItem>[];
    final results = _results;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.watchSearchButton)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(NestSpacing.screen),
          children: [
            TextField(
              controller: _query,
              autofocus: true,
              textInputAction: TextInputAction.search,
              onChanged: _onChanged,
              onSubmitted: (_) => _search(),
              decoration: InputDecoration(
                hintText: l10n.watchSearchHint,
                prefixIcon: const Icon(LucideIcons.search, size: 20),
                suffixIcon: _searching
                    ? const Padding(
                        padding: EdgeInsets.all(14),
                        child: SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator.adaptive(
                            strokeWidth: 2,
                          ),
                        ),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: NestSpacing.gap),
            if (_error case final error?)
              NestNotice(error)
            else if (results == null)
              Text(l10n.watchSearchPrompt, style: textTheme.bodyMedium)
            else if (results.isEmpty)
              Text(
                l10n.watchSearchNoResults(_searched),
                style: textTheme.bodyMedium,
              )
            else
              NestCard(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  children: [
                    for (final (index, title) in results.indexed) ...[
                      if (index > 0)
                        Divider(
                          height: 1,
                          indent: 16,
                          endIndent: 16,
                          color: colors.divider,
                        ),
                      _ResultRow(
                        key: ValueKey((title.type, title.tmdbId)),
                        title: title,
                        onList: isOnWatchlist(onList, title),
                        adding: _adding.contains((title.type, title.tmdbId)),
                        onAdd: () => _add(householdId, title),
                      ),
                    ],
                  ],
                ),
              ),
            const SizedBox(height: NestSpacing.gap),
            const TmdbAttribution(),
          ],
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    super.key,
    required this.title,
    required this.onList,
    required this.adding,
    required this.onAdd,
  });

  final TmdbTitle title;
  final bool onList;
  final bool adding;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final rating = title.rating;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            child: PosterImage(
              posterPath: title.posterPath,
              type: title.type,
              radius: 8,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title.title, style: textTheme.bodyLarge),
                Text(
                  [
                    typeAndYear(l10n, title.type, title.year),
                    if (rating != null) '★ ${ratingText(context, rating)}',
                  ].join(' · '),
                  style: textTheme.bodySmall,
                ),
                if (title.overview.isNotEmpty)
                  Text(
                    title.overview,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall,
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (onList)
            Semantics(
              label: l10n.watchOnList,
              excludeSemantics: true,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: colors.accentTint,
                  borderRadius: BorderRadius.circular(NestRadii.badge),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.check, size: 14, color: colors.accentDark),
                    const SizedBox(width: 4),
                    Text(
                      l10n.watchOnList,
                      style: textTheme.labelMedium?.copyWith(
                        color: colors.accentDark,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            IconButton.filledTonal(
              tooltip: l10n.watchAdd(title.title),
              onPressed: adding ? null : onAdd,
              icon: adding
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                    )
                  : const Icon(LucideIcons.plus),
            ),
        ],
      ),
    );
  }
}
