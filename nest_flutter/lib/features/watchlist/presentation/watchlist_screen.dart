import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../../app/router.dart';
import '../../../core/backend/live_sync.dart';
import '../../../core/household/household_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../data/watchlist_repository.dart';
import '../domain/watchlist_logic.dart';
import 'tonight_pick_sheet.dart';
import 'watch_item_sheet.dart';
import 'watchlist_providers.dart';
import 'watchlist_style.dart';

/// The household's watchlist: a search button, status tabs (Want to watch,
/// Watching, Watched), "Pick something for tonight" and a three-column
/// poster grid. Readable offline and updated live.
class WatchlistScreen extends ConsumerWidget {
  const WatchlistScreen({super.key});

  static const _maxWidth = 560.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final household = ref.watch(activeHouseholdProvider);
    if (household == null) return const Scaffold();
    final householdId = household.household.id!;
    final syncState = ref.watch(watchlistSyncProvider(householdId));
    final items = ref.watch(watchlistItemsProvider(householdId)).value;
    final status = ref.watch(selectedWatchStatusProvider);
    final width = MediaQuery.sizeOf(context).width;
    final side = width > _maxWidth + 2 * NestSpacing.screen
        ? (width - _maxWidth) / 2
        : NestSpacing.screen;
    final shown = items == null ? null : itemsWithStatus(items, status);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () => ref
              .read(watchlistRepositoryProvider)
              .refresh(householdId)
              .catchError((_) {}),
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              side,
              NestSpacing.screen,
              side,
              // Room for the floating tab bar.
              NestSpacing.screen + MediaQuery.paddingOf(context).bottom,
            ),
            children: [
              Text(l10n.featureWatchlist, style: textTheme.headlineMedium),
              const SizedBox(height: NestSpacing.gap),
              _SearchButton(
                onTap: syncState == LiveSyncState.offline
                    ? null
                    : () => context.push(Routes.watchSearch),
              ),
              const SizedBox(height: NestSpacing.gapSmall),
              _StatusChips(
                selected: status,
                counts: statusCounts(items ?? const []),
              ),
              if (syncState == LiveSyncState.offline) ...[
                const SizedBox(height: NestSpacing.gapSmall),
                NestNotice(l10n.watchOffline, tone: NestNoticeTone.info),
              ],
              if (status == WatchStatus.want &&
                  shown != null &&
                  shown.isNotEmpty) ...[
                const SizedBox(height: NestSpacing.gapSmall),
                _PickButton(
                  onTap: () => showTonightPick(
                    context,
                    householdId: householdId,
                    items: items!,
                  ),
                ),
              ],
              const SizedBox(height: NestSpacing.gap),
              if (shown == null)
                const Center(child: CircularProgressIndicator.adaptive())
              else if (shown.isEmpty)
                _EmptyCard(status: status)
              else
                _PosterGrid(householdId: householdId, items: shown),
              const SizedBox(height: NestSpacing.gap),
              const TmdbAttribution(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchButton extends StatelessWidget {
  const _SearchButton({required this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Semantics(
      button: true,
      enabled: onTap != null,
      child: Material(
        // Looks like the other search fields; opens the search screen.
        color: colors.chip,
        shape: const StadiumBorder(),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 52),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  Icon(LucideIcons.search, size: 20, color: colors.inkMuted),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.watchSearchButton,
                      style: textTheme.bodyLarge?.copyWith(
                        color: colors.inkMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusChips extends ConsumerWidget {
  const _StatusChips({required this.selected, required this.counts});

  final WatchStatus selected;
  final Map<WatchStatus, int> counts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    Widget chip(WatchStatus status) {
      final isSelected = status == selected;
      final count = counts[status] ?? 0;
      return Padding(
        padding: const EdgeInsetsDirectional.only(end: 8),
        child: Semantics(
          selected: isSelected,
          button: true,
          child: Material(
            color: isSelected ? colors.ink : colors.surface,
            elevation: isSelected ? 0 : 1,
            shadowColor: colors.ink.withValues(alpha: 0.18),
            shape: const StadiumBorder(),
            child: InkWell(
              customBorder: const StadiumBorder(),
              onTap: () =>
                  ref.read(selectedWatchStatusProvider.notifier).select(status),
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: NestSizes.minTouchTarget,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      statusLabel(l10n, status),
                      style: textTheme.labelLarge?.copyWith(
                        fontSize: 14,
                        color: isSelected ? colors.surface : colors.ink,
                      ),
                    ),
                    if (count > 0) ...[
                      const SizedBox(width: 6),
                      Text(
                        '$count',
                        style: textTheme.labelLarge?.copyWith(
                          fontSize: 14,
                          color: isSelected ? colors.surface : colors.inkMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [for (final status in WatchStatus.values) chip(status)],
      ),
    );
  }
}

class _PickButton extends StatelessWidget {
  const _PickButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Semantics(
      button: true,
      child: Material(
        color: colors.lavender,
        borderRadius: BorderRadius.circular(NestRadii.tile),
        child: InkWell(
          borderRadius: BorderRadius.circular(NestRadii.tile),
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 56),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: Row(
                children: [
                  Icon(LucideIcons.dices, color: colors.lavenderInk),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.watchPickButton,
                      style: textTheme.titleSmall?.copyWith(
                        color: colors.lavenderInk,
                      ),
                    ),
                  ),
                  Icon(LucideIcons.chevronRight, color: colors.lavenderInk),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({required this.status});

  final WatchStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    return NestCard(
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colors.lavender,
              shape: BoxShape.circle,
            ),
            child: Icon(LucideIcons.clapperboard, color: colors.lavenderInk),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              switch (status) {
                WatchStatus.want => l10n.watchEmptyWant,
                WatchStatus.watching => l10n.watchEmptyWatching,
                WatchStatus.watched => l10n.watchEmptyWatched,
              },
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}

/// Three posters per row. Rows are built by hand (not a grid view), so
/// each row is as tall as its longest title, also with large text.
class _PosterGrid extends ConsumerWidget {
  const _PosterGrid({required this.householdId, required this.items});

  static const _columns = 3;
  static const _gap = 12.0;

  final int householdId;
  final List<WatchlistItem> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final members = {
      for (final m
          in ref.watch(householdMembersProvider(householdId)).value ??
              const <HouseholdMember>[])
        m.userId: m,
    };
    return Column(
      children: [
        for (var start = 0; start < items.length; start += _columns) ...[
          if (start > 0) const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = start; i < start + _columns; i++) ...[
                if (i > start) const SizedBox(width: _gap),
                Expanded(
                  child: i < items.length
                      ? _PosterTile(
                          key: ValueKey(items[i].id),
                          householdId: householdId,
                          item: items[i],
                          addedBy: members[items[i].addedById],
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }
}

class _PosterTile extends StatelessWidget {
  const _PosterTile({
    super.key,
    required this.householdId,
    required this.item,
    required this.addedBy,
  });

  final int householdId;
  final WatchlistItem item;
  final HouseholdMember? addedBy;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final rating = item.rating;
    final addedBy = this.addedBy;
    final ours = item.householdRating;
    final details = typeAndYear(l10n, item.type, item.year);

    return Semantics(
      button: true,
      label: [
        item.title,
        details,
        if (rating != null) l10n.watchRatingLabel(ratingText(context, rating)),
        if (ours != null) l10n.watchHouseholdRatingValue(ours),
        if (addedBy != null) l10n.watchAddedBy(addedBy.name),
      ].join(', '),
      excludeSemantics: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () =>
            showWatchItemSheet(context, householdId: householdId, item: item),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PosterImage(posterPath: item.posterPath, type: item.type),
            const SizedBox(height: 6),
            Text(
              item.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
            ),
            Text(details, style: textTheme.bodySmall),
            const SizedBox(height: 3),
            Row(
              children: [
                if (ours != null || rating != null) ...[
                  Icon(
                    ours != null ? LucideIcons.heart : LucideIcons.star,
                    size: 13,
                    color: ours != null ? colors.roseInk : colors.honeyInk,
                  ),
                  const SizedBox(width: 2),
                ],
                Expanded(
                  child: Text(
                    ours != null
                        ? '$ours'
                        : rating != null
                        ? ratingText(context, rating)
                        : '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.labelMedium,
                  ),
                ),
                if (addedBy != null) NestAvatar(name: addedBy.name, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
