import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../../core/backend/error_messages.dart';
import '../../../core/household/household_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../data/watchlist_repository.dart';
import 'watchlist_providers.dart';
import 'watchlist_style.dart';

/// Details of a title on the watchlist: its status, the household's own
/// rating and Remove.
Future<void> showWatchItemSheet(
  BuildContext context, {
  required int householdId,
  required WatchlistItem item,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  useRootNavigator: true,
  backgroundColor: NestColors.of(context).surface,
  builder: (context) => _WatchItemSheet(householdId: householdId, item: item),
);

class _WatchItemSheet extends ConsumerStatefulWidget {
  const _WatchItemSheet({required this.householdId, required this.item});

  final int householdId;
  final WatchlistItem item;

  @override
  ConsumerState<_WatchItemSheet> createState() => _WatchItemSheetState();
}

class _WatchItemSheetState extends ConsumerState<_WatchItemSheet> {
  var _busy = false;
  String? _error;

  /// The title as it is now in the cache (it may change live).
  WatchlistItem get _item =>
      ref
          .watch(watchlistItemsProvider(widget.householdId))
          .value
          ?.where((i) => i.id == widget.item.id)
          .firstOrNull ??
      widget.item;

  Future<void> _run(Future<void> Function(WatchlistRepository r) change) async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await change(ref.read(watchlistRepositoryProvider));
      if (mounted) setState(() => _busy = false);
    } on Exception catch (e) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = errorMessage(l10n, e);
        });
      }
    }
  }

  Future<void> _remove() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final item = _item;
    await _run((r) => r.remove(widget.householdId, item));
    if (_error == null && mounted) {
      navigator.pop();
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.watchRemoved(item.title))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final item = _item;
    final rating = item.rating;
    final members =
        ref.watch(householdMembersProvider(widget.householdId)).value ??
        const <HouseholdMember>[];
    final addedBy = members
        .where((m) => m.userId == item.addedById)
        .firstOrNull;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          NestSpacing.screen,
          0,
          NestSpacing.screen,
          NestSpacing.screen + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 72,
                  child: PosterImage(
                    posterPath: item.posterPath,
                    type: item.type,
                    radius: 12,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title, style: textTheme.titleLarge),
                      const SizedBox(height: 4),
                      Text(
                        [
                          typeAndYear(l10n, item.type, item.year),
                          if (rating != null)
                            '★ ${ratingText(context, rating)}',
                        ].join(' · '),
                        style: textTheme.bodyMedium?.copyWith(
                          color: colors.inkMuted,
                        ),
                      ),
                      if (addedBy != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            NestAvatar(name: addedBy.name, size: 22),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                l10n.watchAddedBy(addedBy.name),
                                style: textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: NestSpacing.gap),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final status in WatchStatus.values)
                  ChoiceChip(
                    label: Text(statusLabel(l10n, status)),
                    selected: item.status == status,
                    // The current status stays enabled (a disabled chip is
                    // greyed out); tapping it again does nothing.
                    onSelected: _busy
                        ? null
                        : (_) {
                            if (item.status == status) return;
                            _run(
                              (r) =>
                                  r.setStatus(widget.householdId, item, status),
                            );
                          },
                  ),
              ],
            ),
            const SizedBox(height: NestSpacing.gap),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.watchHouseholdRating,
                    style: textTheme.labelLarge,
                  ),
                ),
                if (item.householdRating != null)
                  TextButton(
                    onPressed: _busy
                        ? null
                        : () => _run(
                            (r) => r.setRating(widget.householdId, item, null),
                          ),
                    child: Text(l10n.watchClearRating),
                  ),
              ],
            ),
            Row(
              children: [
                for (var stars = 1; stars <= 5; stars++)
                  Semantics(
                    button: true,
                    selected: item.householdRating == stars,
                    label: l10n.watchRateStars(stars),
                    excludeSemantics: true,
                    child: InkResponse(
                      radius: 24,
                      onTap: _busy
                          ? null
                          : () => _run(
                              (r) => r.setRating(
                                widget.householdId,
                                item,
                                // Tapping the current rating clears it.
                                item.householdRating == stars ? null : stars,
                              ),
                            ),
                      child: SizedBox(
                        width: NestSizes.minTouchTarget,
                        height: NestSizes.minTouchTarget,
                        child: Icon(
                          LucideIcons.heart,
                          size: 26,
                          color: (item.householdRating ?? 0) >= stars
                              ? colors.roseInk
                              : colors.checkboxIdle,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            if (_error case final error?) ...[
              const SizedBox(height: NestSpacing.gapSmall),
              NestNotice(error),
            ],
            const SizedBox(height: NestSpacing.gap),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _busy ? null : _remove,
                icon: const Icon(LucideIcons.trash2, size: 18),
                label: Text(l10n.watchRemove),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
