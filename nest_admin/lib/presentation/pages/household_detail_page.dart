import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../core/formatting.dart';
import '../../data/admin_repository.dart';
import '../../l10n/admin_localizations.dart';
import '../widgets/admin_widgets.dart';

/// One household: members and their roles, invite code, features and how
/// much data it holds (counts only).
class HouseholdDetailPage extends ConsumerWidget {
  const HouseholdDetailPage({super.key, required this.householdId});

  final int householdId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AdminLocalizations.of(context);
    final provider = householdDetailProvider(householdId);
    final detail = ref.watch(provider);
    final name = detail.value?.summary.name;

    return AdminPage(
      title: name ?? l10n.navHouseholds,
      onBack: () => context.go('/households'),
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

  final AdminHouseholdDetail detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AdminLocalizations.of(context);
    final colors = NestColors.of(context);
    final format = AdminFormat(l10n);
    final summary = detail.summary;
    final notifier = ref.read(householdDetailProvider(summary.id).notifier);
    final active = summary.status == HouseholdStatus.active;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton.tonalIcon(
              onPressed: () async {
                final name = await askText(
                  context,
                  title: l10n.renameTitle,
                  label: l10n.householdName,
                  confirmLabel: l10n.save,
                  initialValue: summary.name,
                );
                if (name == null || !context.mounted) return;
                await runWithFeedback(context, () => notifier.rename(name));
              },
              icon: const Icon(LucideIcons.pencil, size: 18),
              label: Text(l10n.rename),
            ),
            FilledButton.tonalIcon(
              onPressed: () async {
                final confirmed = await confirmAction(
                  context,
                  title: active
                      ? l10n.suspendTitle(summary.name)
                      : l10n.reactivateTitle(summary.name),
                  message: active
                      ? l10n.suspendMessage
                      : l10n.reactivateMessage,
                  confirmLabel: active ? l10n.suspend : l10n.reactivate,
                );
                if (!confirmed || !context.mounted) return;
                await runWithFeedback(
                  context,
                  () => notifier.setStatus(
                    active ? HouseholdStatus.suspended : HouseholdStatus.active,
                  ),
                );
              },
              icon: Icon(
                active ? LucideIcons.pause : LucideIcons.play,
                size: 18,
              ),
              label: Text(active ? l10n.suspend : l10n.reactivate),
            ),
          ],
        ),
        const SizedBox(height: NestSpacing.gap),
        CardGrid(
          children: [
            SummaryCard(
              icon: active ? LucideIcons.circleCheck : LucideIcons.circlePause,
              label: l10n.columnStatus,
              value: active ? l10n.statusActive : l10n.statusSuspended,
              tint: active ? colors.accentTint : colors.warning,
              ink: active ? colors.accentDark : colors.warningInk,
            ),
            SummaryCard(
              icon: LucideIcons.users,
              label: l10n.columnMembers,
              value: format.number(summary.memberCount),
              detail: summary.ownerNames.isEmpty
                  ? null
                  : summary.ownerNames.join(', '),
            ),
            SummaryCard(
              icon: LucideIcons.clock,
              label: l10n.columnLastActivity,
              value: format.maybeDateTime(summary.lastActivityAt),
              detail:
                  '${l10n.columnCreated}: ${format.date(summary.createdAt)}',
            ),
          ],
        ),
        const SizedBox(height: NestSpacing.gap),
        _InviteCard(detail: detail),
        const SizedBox(height: NestSpacing.gap),
        _MembersTable(detail: detail),
        const SizedBox(height: NestSpacing.gap),
        _FeaturesCard(detail: detail),
        const SizedBox(height: NestSpacing.gap),
        _DataCard(counts: detail.counts),
      ],
    );
  }
}

class _InviteCard extends ConsumerWidget {
  const _InviteCard({required this.detail});

  final AdminHouseholdDetail detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AdminLocalizations.of(context);
    final colors = NestColors.of(context);
    final format = AdminFormat(l10n);
    final notifier = ref.read(
      householdDetailProvider(detail.summary.id).notifier,
    );
    final code = detail.inviteCode;
    final expiresAt = detail.inviteExpiresAt;
    final expired = expiresAt != null && expiresAt.isBefore(DateTime.now());
    final usable = code != null && !expired;

    return SectionCard(
      title: l10n.sectionInvite,
      actions: [
        FilledButton.icon(
          onPressed: () async {
            if (usable) {
              final confirmed = await confirmAction(
                context,
                title: l10n.newCodeTitle,
                message: l10n.newCodeMessage,
                confirmLabel: l10n.newCode,
              );
              if (!confirmed || !context.mounted) return;
            }
            await runWithFeedback(context, notifier.createInvite);
          },
          icon: const Icon(LucideIcons.ticket, size: 18),
          label: Text(l10n.newCode),
        ),
        if (code != null) ...[
          FilledButton.tonalIcon(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: code));
              if (context.mounted) showMessage(context, l10n.copied);
            },
            icon: const Icon(LucideIcons.copy, size: 18),
            label: Text(l10n.copyCode),
          ),
          FilledButton.tonalIcon(
            onPressed: () async {
              final confirmed = await confirmAction(
                context,
                title: l10n.revokeCodeTitle,
                message: l10n.revokeCodeMessage,
                confirmLabel: l10n.revokeCode,
              );
              if (!confirmed || !context.mounted) return;
              await runWithFeedback(context, notifier.revokeInvite);
            },
            icon: const Icon(LucideIcons.ban, size: 18),
            label: Text(l10n.revokeCode),
          ),
        ],
      ],
      child: code == null
          ? CellText(l10n.inviteNone, muted: true)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  code,
                  style: nunito(
                    size: 28,
                    weight: 800,
                    letterSpacing: 3,
                    color: usable ? colors.ink : colors.inkMuted,
                  ),
                ),
                if (expiresAt != null)
                  Text(
                    expired
                        ? l10n.inviteExpiredOn(format.dateTime(expiresAt))
                        : l10n.inviteValidUntil(format.dateTime(expiresAt)),
                    style: nunito(
                      size: 13,
                      weight: 600,
                      color: expired ? colors.warningInk : colors.inkMuted,
                    ),
                  ),
              ],
            ),
    );
  }
}

class _MembersTable extends ConsumerWidget {
  const _MembersTable({required this.detail});

  final AdminHouseholdDetail detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AdminLocalizations.of(context);
    final format = AdminFormat(l10n);
    final members = detail.members;
    final owners = members.where((m) => m.role == MembershipRole.owner).length;

    return AdminTable(
      emptyText: l10n.noMembers,
      onRowTap: (i) => context.go('/users/${members[i].userId}'),
      columns: [
        AdminColumn(l10n.columnName, flex: 3),
        AdminColumn(l10n.columnEmail, flex: 4),
        AdminColumn(l10n.columnRole, flex: 2),
        AdminColumn(l10n.columnJoined, flex: 2),
        AdminColumn(l10n.columnAction, flex: 3),
      ],
      rows: [
        for (final m in members)
          [
            Wrap(
              spacing: 8,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                CellText(m.name.isEmpty ? l10n.noName : m.name, bold: true),
                if (m.disabled)
                  StatusBadge(l10n.statusDisabled, tone: BadgeTone.warning),
              ],
            ),
            CellText(m.email ?? '–', muted: true),
            StatusBadge(
              format.role(m.role),
              tone: m.role == MembershipRole.owner
                  ? BadgeTone.good
                  : BadgeTone.neutral,
            ),
            CellText(format.date(m.joinedAt), muted: true),
            m.role == MembershipRole.owner && owners <= 1
                ? const SizedBox.shrink()
                : _RoleButton(householdId: detail.summary.id, member: m),
          ],
      ],
    );
  }
}

class _RoleButton extends ConsumerWidget {
  const _RoleButton({required this.householdId, required this.member});

  final int householdId;
  final AdminHouseholdMember member;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AdminLocalizations.of(context);
    final toOwner = member.role == MembershipRole.member;
    final name = member.name.isEmpty
        ? (member.email ?? l10n.noName)
        : member.name;
    return TableButton(
      label: toOwner ? l10n.makeOwner : l10n.makeMember,
      onPressed: () async {
        final confirmed = await confirmAction(
          context,
          title: toOwner
              ? l10n.makeOwnerTitle(name)
              : l10n.makeMemberTitle(name),
          message: toOwner ? l10n.makeOwnerMessage : l10n.makeMemberMessage,
          confirmLabel: toOwner ? l10n.makeOwner : l10n.makeMember,
        );
        if (!confirmed || !context.mounted) return;
        await runWithFeedback(
          context,
          () => ref
              .read(householdDetailProvider(householdId).notifier)
              .setMemberRole(
                member.userId,
                toOwner ? MembershipRole.owner : MembershipRole.member,
              ),
        );
      },
    );
  }
}

class _FeaturesCard extends ConsumerWidget {
  const _FeaturesCard({required this.detail});

  final AdminHouseholdDetail detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AdminLocalizations.of(context);
    final format = AdminFormat(l10n);
    final enabled = detail.summary.enabledFeatures;
    return SectionCard(
      title: l10n.sectionFeatures,
      child: Column(
        children: [
          for (final feature in HouseholdFeature.values)
            MergeSemantics(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: NestSizes.minTouchTarget,
                ),
                child: Row(
                  children: [
                    Expanded(child: CellText(format.feature(feature))),
                    Switch.adaptive(
                      key: ValueKey('feature-${feature.name}'),
                      activeTrackColor: NestColors.of(context).accent,
                      value: enabled.contains(feature),
                      onChanged: (on) => runWithFeedback(
                        context,
                        () => ref
                            .read(
                              householdDetailProvider(
                                detail.summary.id,
                              ).notifier,
                            )
                            .setFeatures([
                              for (final f in HouseholdFeature.values)
                                if (f == feature ? on : enabled.contains(f)) f,
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DataCard extends StatelessWidget {
  const _DataCard({required this.counts});

  final AdminHouseholdCounts counts;

  @override
  Widget build(BuildContext context) {
    final l10n = AdminLocalizations.of(context);
    final format = AdminFormat(l10n);
    final rows = [
      (l10n.countShoppingLists, counts.shoppingLists),
      (l10n.countStores, counts.stores),
      (l10n.countShoppingItems, counts.shoppingItems),
      (l10n.countTasks, counts.tasks),
      (l10n.countRecipes, counts.recipes),
      (l10n.countMealPlan, counts.mealPlanEntries),
      (l10n.countWatchlist, counts.watchlistItems),
    ];
    return SectionCard(
      title: l10n.sectionData,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (label, count) in rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(child: CellText(label)),
                  CellText(format.number(count), bold: true),
                ],
              ),
            ),
          const SizedBox(height: NestSpacing.gapSmall),
          CellText(l10n.dataNote, muted: true),
        ],
      ),
    );
  }
}
