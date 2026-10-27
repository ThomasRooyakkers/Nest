import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../l10n/app_localizations.dart';
import 'household_repository.dart';

/// Pill with the active household's name. With more than one household it
/// opens a menu to switch.
class HouseholdSwitcher extends ConsumerWidget {
  const HouseholdSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final active = ref.watch(activeHouseholdProvider);
    final households = ref.watch(myHouseholdsProvider).value ?? const [];
    if (active == null) return const SizedBox.shrink();

    final canSwitch = households.length > 1;
    final pill = Container(
      constraints: const BoxConstraints(minHeight: NestSizes.minTouchTarget),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: colors.accentTint,
        borderRadius: BorderRadius.circular(NestRadii.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.home_outlined, size: 18, color: colors.accentDark),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              active.household.name,
              overflow: TextOverflow.ellipsis,
              style: textTheme.labelLarge?.copyWith(color: colors.accentDark),
            ),
          ),
          if (canSwitch) ...[
            const SizedBox(width: 4),
            Icon(Icons.expand_more, size: 20, color: colors.accentDark),
          ],
        ],
      ),
    );

    if (!canSwitch) return pill;

    return Semantics(
      button: true,
      label: l10n.switchHousehold,
      child: InkWell(
        borderRadius: BorderRadius.circular(NestRadii.pill),
        onTap: () => _showPicker(context, ref, households, active),
        child: pill,
      ),
    );
  }

  Future<void> _showPicker(
    BuildContext context,
    WidgetRef ref,
    List<MyHousehold> households,
    MyHousehold active,
  ) async {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    final picked = await showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      backgroundColor: colors.surface,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(
            NestSpacing.screen,
            0,
            NestSpacing.screen,
            NestSpacing.screen,
          ),
          children: [
            Text(l10n.switchHousehold, style: textTheme.titleLarge),
            const SizedBox(height: 8),
            for (final h in households)
              ListTile(
                contentPadding: EdgeInsets.zero,
                minTileHeight: NestSizes.minTouchTarget,
                title: Text(h.household.name, style: textTheme.bodyLarge),
                selected: h.household.id == active.household.id,
                trailing: h.household.id == active.household.id
                    ? Icon(Icons.check, color: colors.accent)
                    : null,
                onTap: () => Navigator.pop(context, h.household.id),
              ),
          ],
        ),
      ),
    );
    if (picked != null) {
      ref.read(selectedHouseholdIdProvider.notifier).select(picked);
    }
  }
}
