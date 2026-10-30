import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nest_shared/nest_shared.dart';

import '../data/admin_repository.dart';
import '../l10n/admin_localizations.dart';
import 'widgets/admin_widgets.dart';

/// A page in the side menu.
typedef AdminDestination = ({String path, IconData icon, String label});

List<AdminDestination> adminDestinations(AdminLocalizations l10n) => [
  (path: '/households', icon: LucideIcons.house, label: l10n.navHouseholds),
  (path: '/users', icon: LucideIcons.users, label: l10n.navUsers),
  (path: '/backups', icon: LucideIcons.databaseBackup, label: l10n.navBackups),
  (path: '/health', icon: LucideIcons.activity, label: l10n.navHealth),
  (path: '/audit', icon: LucideIcons.scrollText, label: l10n.navAudit),
];

/// The portal frame: side menu on wide screens, a menu button and drawer on
/// narrow ones. Only super-admins get past it.
class AdminShell extends ConsumerWidget {
  const AdminShell({super.key, required this.location, required this.child});

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AdminLocalizations.of(context);
    final colors = NestColors.of(context);
    final user = ref.watch(currentUserProvider);

    if (user case AsyncData(:final value) when !value.isSuperAdmin) {
      return const _NotAdminScreen();
    }
    if (user is AsyncLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    final menu = _SideMenu(location: location, userName: user.value?.name);
    if (isWide(context)) {
      return Scaffold(
        body: Row(
          children: [
            SizedBox(width: 260, child: menu),
            Expanded(child: SafeArea(child: child)),
          ],
        ),
      );
    }
    final current = adminDestinations(
      l10n,
    ).where((d) => location.startsWith(d.path)).firstOrNull;
    return Scaffold(
      appBar: AppBar(
        title: Text(current?.label ?? l10n.adminTitle),
        backgroundColor: colors.background,
      ),
      drawer: Drawer(backgroundColor: colors.surfaceAlt, child: menu),
      body: SafeArea(child: child),
    );
  }
}

class _SideMenu extends ConsumerWidget {
  const _SideMenu({required this.location, required this.userName});

  final String location;
  final String? userName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AdminLocalizations.of(context);
    final colors = NestColors.of(context);
    return ColoredBox(
      color: colors.surfaceAlt,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(NestSpacing.gap),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
                child: Text(
                  l10n.adminTitle,
                  style: nunito(
                    size: 22,
                    weight: 800,
                    color: colors.ink,
                    letterSpacing: -0.4,
                  ),
                ),
              ),
              for (final destination in adminDestinations(l10n))
                _MenuItem(
                  destination: destination,
                  selected: location.startsWith(destination.path),
                ),
              const Spacer(),
              if (userName != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    l10n.signedInAs(userName!),
                    style: nunito(
                      size: 13,
                      weight: 600,
                      color: colors.inkMuted,
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () => ref.read(adminRepositoryProvider).signOut(),
                icon: const Icon(LucideIcons.logOut, size: 18),
                label: Text(l10n.signOut),
                style: TextButton.styleFrom(
                  alignment: AlignmentDirectional.centerStart,
                  minimumSize: const Size.fromHeight(NestSizes.minTouchTarget),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({required this.destination, required this.selected});

  final AdminDestination destination;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = NestColors.of(context);
    final foreground = selected ? colors.accentDark : colors.ink;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Semantics(
        selected: selected,
        button: true,
        child: Material(
          color: selected ? colors.accentTint : Colors.transparent,
          borderRadius: BorderRadius.circular(NestRadii.pill),
          child: InkWell(
            borderRadius: BorderRadius.circular(NestRadii.pill),
            onTap: () {
              Scaffold.maybeOf(context)?.closeDrawer();
              context.go(destination.path);
            },
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: NestSizes.minTouchTarget,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    Icon(destination.icon, size: 20, color: foreground),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        destination.label,
                        style: nunito(size: 15, weight: 750, color: foreground),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NotAdminScreen extends ConsumerWidget {
  const _NotAdminScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AdminLocalizations.of(context);
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(NestSpacing.screen),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                NestNotice(l10n.errorNotAdmin),
                const SizedBox(height: NestSpacing.gap),
                FilledButton(
                  onPressed: () => ref.read(adminRepositoryProvider).signOut(),
                  child: Text(l10n.signOut),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
