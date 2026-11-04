import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../core/formatting.dart';
import '../../data/admin_repository.dart';
import '../../l10n/admin_localizations.dart';
import '../widgets/admin_widgets.dart';

/// One user: status, sign-in methods, signed-in devices and households.
class UserDetailPage extends ConsumerWidget {
  const UserDetailPage({super.key, required this.userId});

  final int userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AdminLocalizations.of(context);
    final provider = userDetailProvider(userId);
    final detail = ref.watch(provider);
    final summary = detail.value?.summary;

    return AdminPage(
      title: summary == null
          ? l10n.navUsers
          : (summary.name.isEmpty
                ? (summary.email ?? l10n.noName)
                : summary.name),
      onBack: () => context.go('/users'),
      onRefresh: () async {
        ref.invalidate(provider);
        await ref.read(provider.future);
      },
      children: [
        AsyncContent(
          value: detail,
          onRetry: () => ref.invalidate(provider),
          builder: (detail) => _Content(detail: detail),
        ),
      ],
    );
  }
}

class _Content extends ConsumerWidget {
  const _Content({required this.detail});

  final AdminUserDetail detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AdminLocalizations.of(context);
    final colors = NestColors.of(context);
    final format = AdminFormat(l10n);
    final user = detail.summary;
    final me = ref.watch(currentUserProvider).value;
    final isMe = user.id == me?.id;
    final notifier = ref.read(userDetailProvider(user.id).notifier);
    final disabled = user.disabledAt != null;
    final name = user.name.isEmpty ? (user.email ?? l10n.noName) : user.name;
    final methods = [
      if (detail.signInMethods.email) l10n.methodEmail,
      if (detail.signInMethods.google) l10n.methodGoogle,
      if (detail.signInMethods.apple) l10n.methodApple,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!isMe) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.tonalIcon(
                onPressed: detail.activeSessions == 0
                    ? null
                    : () async {
                        final confirmed = await confirmAction(
                          context,
                          title: l10n.signOutEverywhereTitle(name),
                          message: l10n.signOutEverywhereMessage,
                          confirmLabel: l10n.signOutEverywhere,
                        );
                        if (!confirmed || !context.mounted) return;
                        await runWithFeedback(
                          context,
                          notifier.signOutEverywhere,
                        );
                      },
                icon: const Icon(LucideIcons.logOut, size: 18),
                label: Text(l10n.signOutEverywhere),
              ),
              FilledButton.tonalIcon(
                onPressed: () async {
                  final confirmed = await confirmAction(
                    context,
                    title: disabled
                        ? l10n.enableTitle(name)
                        : l10n.disableTitle(name),
                    message: disabled
                        ? l10n.enableMessage
                        : l10n.disableMessage,
                    confirmLabel: disabled ? l10n.enable : l10n.disable,
                  );
                  if (!confirmed || !context.mounted) return;
                  await runWithFeedback(
                    context,
                    () => notifier.setDisabled(!disabled),
                  );
                },
                icon: Icon(
                  disabled ? LucideIcons.userCheck : LucideIcons.userX,
                  size: 18,
                ),
                label: Text(disabled ? l10n.enable : l10n.disable),
              ),
            ],
          ),
          const SizedBox(height: NestSpacing.gap),
        ],
        CardGrid(
          children: [
            SummaryCard(
              icon: disabled ? LucideIcons.userX : LucideIcons.userCheck,
              label: l10n.columnStatus,
              value: disabled ? l10n.statusDisabled : l10n.statusActive,
              detail: user.email,
              tint: disabled ? colors.warning : colors.accentTint,
              ink: disabled ? colors.warningInk : colors.accentDark,
            ),
            SummaryCard(
              icon: LucideIcons.keyRound,
              label: l10n.signInMethods,
              value: methods.isEmpty ? l10n.methodNone : methods.join(', '),
              detail:
                  '${l10n.columnSince}: ${format.date(user.createdAt)}'
                  ' · ${format.language(user.locale)}',
            ),
            SummaryCard(
              icon: LucideIcons.smartphone,
              label: l10n.devices,
              value: format.number(detail.activeSessions),
              detail: detail.lastSeenAt == null
                  ? l10n.lastSeenNever
                  : l10n.lastSeen(format.dateTime(detail.lastSeenAt!)),
            ),
          ],
        ),
        const SizedBox(height: NestSpacing.gap),
        AdminTable(
          emptyText: l10n.householdsEmpty,
          onRowTap: (i) =>
              context.go('/households/${detail.households[i].householdId}'),
          columns: [
            AdminColumn(l10n.navHouseholds, flex: 4),
            AdminColumn(l10n.columnRole, flex: 2),
            AdminColumn(l10n.columnStatus, flex: 2),
          ],
          rows: [
            for (final h in detail.households)
              [
                CellText(h.name, bold: true),
                StatusBadge(
                  format.role(h.role),
                  tone: h.role == MembershipRole.owner
                      ? BadgeTone.good
                      : BadgeTone.neutral,
                ),
                h.status == HouseholdStatus.active
                    ? StatusBadge(l10n.statusActive, tone: BadgeTone.good)
                    : StatusBadge(
                        l10n.statusSuspended,
                        tone: BadgeTone.warning,
                      ),
              ],
          ],
        ),
        const SizedBox(height: NestSpacing.gap),
        NestNotice(l10n.passwordHint, tone: NestNoticeTone.info),
      ],
    );
  }
}
