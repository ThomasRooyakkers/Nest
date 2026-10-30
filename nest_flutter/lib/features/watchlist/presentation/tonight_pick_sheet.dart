import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../../core/backend/error_messages.dart';
import '../../../l10n/app_localizations.dart';
import '../data/watchlist_repository.dart';
import '../domain/watchlist_logic.dart';
import 'watchlist_style.dart';

/// "Pick something for tonight": a random title the household wants to
/// watch, with Pick another and Start watching.
Future<void> showTonightPick(
  BuildContext context, {
  required int householdId,
  required List<WatchlistItem> items,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  useRootNavigator: true,
  backgroundColor: NestColors.of(context).surface,
  builder: (context) => _TonightPick(householdId: householdId, items: items),
);

class _TonightPick extends ConsumerStatefulWidget {
  const _TonightPick({required this.householdId, required this.items});

  final int householdId;
  final List<WatchlistItem> items;

  @override
  ConsumerState<_TonightPick> createState() => _TonightPickState();
}

class _TonightPickState extends ConsumerState<_TonightPick> {
  late WatchlistItem? _pick = pickForTonight(widget.items);
  var _busy = false;
  String? _error;

  Future<void> _startWatching(WatchlistItem item) async {
    final l10n = AppLocalizations.of(context);
    final navigator = Navigator.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(watchlistRepositoryProvider)
          .setStatus(widget.householdId, item, WatchStatus.watching);
      navigator.pop();
    } on Exception catch (e) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = errorMessage(l10n, e);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final pick = _pick;
    if (pick == null) return const SizedBox(height: 120);
    final wantCount = widget.items
        .where((i) => i.status == WatchStatus.want)
        .length;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          NestSpacing.screen,
          0,
          NestSpacing.screen,
          NestSpacing.screen,
        ),
        child: Column(
          children: [
            Text(
              l10n.watchPickTitle,
              style: textTheme.labelLarge?.copyWith(color: colors.lavenderInk),
            ),
            const SizedBox(height: NestSpacing.gapSmall),
            SizedBox(
              width: 140,
              child: PosterImage(posterPath: pick.posterPath, type: pick.type),
            ),
            const SizedBox(height: NestSpacing.gapSmall),
            Text(
              pick.title,
              textAlign: TextAlign.center,
              style: textTheme.titleLarge,
            ),
            Text(
              typeAndYear(l10n, pick.type, pick.year),
              style: textTheme.bodyMedium?.copyWith(color: colors.inkMuted),
            ),
            if (_error case final error?) ...[
              const SizedBox(height: NestSpacing.gapSmall),
              NestNotice(error),
            ],
            const SizedBox(height: NestSpacing.gap),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _busy ? null : () => _startWatching(pick),
                icon: const Icon(LucideIcons.play, size: 18),
                label: Text(l10n.watchStartWatching),
              ),
            ),
            if (wantCount > 1) ...[
              const SizedBox(height: NestSpacing.gapSmall),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _busy
                      ? null
                      : () => setState(
                          () => _pick = pickForTonight(
                            widget.items,
                            previous: pick,
                          ),
                        ),
                  icon: const Icon(LucideIcons.dices, size: 18),
                  label: Text(l10n.watchPickAnother),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
