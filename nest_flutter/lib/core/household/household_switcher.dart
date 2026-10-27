import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    return PopupMenuButton<int>(
      tooltip: l10n.switchHousehold,
      position: PopupMenuPosition.under,
      onSelected: ref.read(selectedHouseholdIdProvider.notifier).select,
      itemBuilder: (context) => [
        for (final h in households)
          CheckedPopupMenuItem(
            value: h.household.id!,
            checked: h.household.id == active.household.id,
            child: Text(h.household.name),
          ),
      ],
      child: pill,
    );
  }
}
