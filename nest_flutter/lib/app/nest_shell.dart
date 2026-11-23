import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_shared/nest_shared.dart';

import '../core/backend/server_health_repository.dart';
import '../core/household/household_repository.dart';
import '../core/server/server_compatibility.dart';
import '../features/seasonal/domain/seasonal_logic.dart';
import '../features/seasonal/presentation/seasonal_decor.dart';
import '../features/seasonal/presentation/seasonal_providers.dart';
import '../features/tasks/presentation/task_providers.dart';
import '../l10n/app_localizations.dart';

/// A tab of the bottom tab bar. [branch] is the index of its branch in the
/// router's shell route.
class _Tab {
  const _Tab(
    this.branch,
    this.icon,
    this.label, [
    this.feature,
    this.minServerApiVersion = 1,
  ]);

  final int branch;
  final IconData icon;
  final String Function(AppLocalizations l10n) label;

  /// The household feature the tab belongs to; hidden when switched off.
  final HouseholdFeature? feature;

  /// Server API level the tab needs; hidden on older servers.
  final int minServerApiVersion;
}

final _tabs = [
  _Tab(0, LucideIcons.house, (l10n) => l10n.tabHome),
  _Tab(
    1,
    LucideIcons.shoppingBasket,
    (l10n) => l10n.tabShopping,
    HouseholdFeature.shopping,
  ),
  _Tab(
    2,
    LucideIcons.utensils,
    (l10n) => l10n.tabMeals,
    HouseholdFeature.mealPlanning,
    mealPlanApiVersion,
  ),
  _Tab(
    3,
    LucideIcons.listChecks,
    (l10n) => l10n.tabTasks,
    HouseholdFeature.tasks,
    tasksApiVersion,
  ),
  _Tab(
    4,
    LucideIcons.clapperboard,
    (l10n) => l10n.tabWatch,
    HouseholdFeature.watchlist,
    watchlistApiVersion,
  ),
];

/// The main screens with the floating bottom tab bar. Tabs of features that
/// are switched off for the active household are hidden.
class NestShell extends ConsumerWidget {
  const NestShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final features =
        ref.watch(activeHouseholdProvider)?.household.enabledFeatures ??
        const <HouseholdFeature>[];
    final tabs = [
      for (final tab in _tabs)
        if ((tab.feature == null || features.contains(tab.feature)) &&
            ref.watch(serverSupportsProvider(tab.minServerApiVersion)))
          tab,
    ];
    if (!tabs.any((t) => t.branch == shell.currentIndex)) {
      // The feature of the open tab was switched off: go home.
      WidgetsBinding.instance.addPostFrameCallback((_) => shell.goBranch(0));
    }

    // Android back on another tab goes to Home first; on Home it leaves the
    // app. Screens opened within a tab still go back one step first.
    return PopScope(
      canPop: shell.currentIndex == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) shell.goBranch(0);
      },
      child: Scaffold(
        extendBody: true,
        body: shell,
        bottomNavigationBar: _TabBar(
          theme: ref.watch(seasonalThemeProvider(_today(ref))),
          tabs: tabs,
          current: shell.currentIndex,
          onSelect: (branch) => shell.goBranch(
            branch,
            // Tapping the open tab again returns to its first screen.
            initialLocation: branch == shell.currentIndex,
          ),
        ),
      ),
    );
  }
}

/// Space below the floating tab bar. On iOS the bar sits a little into the
/// home indicator area. On Android the system navigation bar (buttons or a
/// gesture handle) is kept clear, with the designed 20 px gap above it.
@visibleForTesting
double tabBarBottomGap(BuildContext context) {
  final inset = MediaQuery.viewPaddingOf(context).bottom;
  if (Theme.of(context).platform == TargetPlatform.android) return inset + 20;
  return inset > 20 ? inset - 6 : 20;
}

DateTime _today(WidgetRef ref) {
  final now = ref.watch(clockProvider)();
  return DateTime(now.year, now.month, now.day);
}

class _TabBar extends StatelessWidget {
  const _TabBar({
    required this.theme,
    required this.tabs,
    required this.current,
    required this.onSelect,
  });

  /// Holiday theme: snow or confetti lies on top of the bar.
  final SeasonalTheme? theme;
  final List<_Tab> tabs;
  final int current;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final radius = BorderRadius.circular(NestRadii.tabBar);

    final bar = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: NestShadows.floating(colors),
      ),
      // Frosted glass: content scrolling underneath stays faintly visible.
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: colors.surface.withValues(alpha: 0.82),
              borderRadius: radius,
              border: Border.all(
                color: colors.surface.withValues(alpha: 0.6),
              ),
            ),
            child: Row(
              children: [
                for (final tab in tabs)
                  Expanded(
                    child: _TabButton(
                      icon: tab.icon,
                      label: tab.label(l10n),
                      selected: tab.branch == current,
                      onTap: () {
                        if (tab.branch != current) {
                          HapticFeedback.selectionClick();
                        }
                        onSelect(tab.branch);
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, tabBarBottomGap(context)),
      child: theme == null
          ? bar
          : Stack(
              clipBehavior: Clip.none,
              children: [
                bar,
                Positioned(
                  top: -10,
                  left: 22,
                  right: 22,
                  height: 16,
                  child: SeasonalTabBarTop(theme: theme!),
                ),
              ],
            ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final color = selected ? colors.accentDark : colors.inkMuted;

    return Semantics(
      selected: selected,
      button: true,
      label: label,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          constraints: const BoxConstraints(minHeight: 54),
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 7),
          decoration: BoxDecoration(
            color: selected
                ? colors.accentTint
                : colors.accentTint.withValues(alpha: 0),
            borderRadius: BorderRadius.circular(NestRadii.tabBar - 6),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: selected ? 1.08 : 1,
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutBack,
                child: Icon(icon, size: 22, color: color),
              ),
              const SizedBox(height: 3),
              // Long Dutch labels shrink instead of being cut off.
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  maxLines: 1,
                  style: textTheme.labelSmall?.copyWith(
                    color: color,
                    fontSize: 10.5,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
