import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../core/formatting.dart';
import '../../data/admin_repository.dart';
import '../../l10n/admin_localizations.dart';
import '../widgets/admin_widgets.dart';
import 'health_page.dart';

/// Households: summary cards and the table with Suspend/Reactivate.
class HouseholdsPage extends ConsumerWidget {
  const HouseholdsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AdminLocalizations.of(context);
    final format = AdminFormat(l10n);
    final households = ref.watch(householdsProvider);
    final health = ref.watch(systemHealthProvider);

    return AdminPage(
      title: l10n.navHouseholds,
      onRefresh: () async {
        ref
          ..invalidate(householdsProvider)
          ..invalidate(systemHealthProvider);
        await ref.read(householdsProvider.future);
      },
      children: [
        if (health case AsyncData(:final value))
          HealthSummaryCards(health: value),
        AsyncContent(
          value: households,
          onRetry: () => ref.invalidate(householdsProvider),
          builder: (households) => AdminTable(
            emptyText: l10n.householdsEmpty,
            columns: [
              AdminColumn(l10n.columnName, flex: 3),
              AdminColumn(l10n.columnOwners, flex: 3),
              AdminColumn(l10n.columnMembers, flex: 2),
              AdminColumn(l10n.columnFeatures, flex: 4),
              AdminColumn(l10n.columnLastActivity, flex: 3),
              AdminColumn(l10n.columnStatus, flex: 2),
              AdminColumn(l10n.columnAction, flex: 3),
            ],
            rows: [
              for (final h in households)
                [
                  CellText(h.name, bold: true),
                  CellText(
                    h.ownerNames.isEmpty ? '–' : h.ownerNames.join(', '),
                  ),
                  CellText(format.number(h.memberCount)),
                  CellText(
                    h.enabledFeatures.isEmpty
                        ? '–'
                        : h.enabledFeatures.map(format.feature).join(', '),
                    muted: true,
                  ),
                  CellText(format.maybeDateTime(h.lastActivityAt), muted: true),
                  h.status == HouseholdStatus.active
                      ? StatusBadge(l10n.statusActive, tone: BadgeTone.good)
                      : StatusBadge(
                          l10n.statusSuspended,
                          tone: BadgeTone.warning,
                        ),
                  _StatusButton(household: h),
                ],
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusButton extends ConsumerWidget {
  const _StatusButton({required this.household});

  final AdminHouseholdSummary household;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AdminLocalizations.of(context);
    final suspend = household.status == HouseholdStatus.active;
    return TableButton(
      label: suspend ? l10n.suspend : l10n.reactivate,
      onPressed: () async {
        final confirmed = await confirmAction(
          context,
          title: suspend
              ? l10n.suspendTitle(household.name)
              : l10n.reactivateTitle(household.name),
          message: suspend ? l10n.suspendMessage : l10n.reactivateMessage,
          confirmLabel: suspend ? l10n.suspend : l10n.reactivate,
        );
        if (!confirmed || !context.mounted) return;
        await runWithFeedback(
          context,
          () => ref
              .read(householdsProvider.notifier)
              .setStatus(
                household.id,
                suspend ? HouseholdStatus.suspended : HouseholdStatus.active,
              ),
        );
      },
    );
  }
}

/// The three cards above the households table: last backup, server health
/// and free disk space.
class HealthSummaryCards extends StatelessWidget {
  const HealthSummaryCards({super.key, required this.health});

  final AdminSystemHealth health;

  @override
  Widget build(BuildContext context) {
    final l10n = AdminLocalizations.of(context);
    final colors = NestColors.of(context);
    final format = AdminFormat(l10n);
    final backupLate = backupIsLate(health);
    final diskLow = diskIsLow(health);

    return CardGrid(
      children: [
        SummaryCard(
          icon: LucideIcons.databaseBackup,
          label: l10n.summaryLastBackup,
          value: health.lastSuccessfulBackupAt == null
              ? l10n.backupNever
              : format.dateTime(health.lastSuccessfulBackupAt!),
          detail: backupLate ? l10n.backupLate : l10n.backupOnTime,
          tint: backupLate ? colors.warning : null,
          ink: backupLate ? colors.warningInk : null,
        ),
        SummaryCard(
          icon: LucideIcons.activity,
          label: l10n.summaryServer,
          value: health.databaseOk ? l10n.healthOk : l10n.healthDatabaseDown,
          detail: l10n.serverVersion(
            health.version,
            format.duration(health.serverTime.difference(health.startedAt)),
          ),
          tint: health.databaseOk ? colors.accentTint : colors.warning,
          ink: health.databaseOk ? colors.accentDark : colors.warningInk,
        ),
        SummaryCard(
          icon: LucideIcons.hardDrive,
          label: l10n.summaryDisk,
          value: health.diskFreeBytes == null
              ? l10n.unknown
              : l10n.diskFree(format.bytes(health.diskFreeBytes)),
          detail: health.diskTotalBytes == null
              ? null
              : l10n.diskOf(format.bytes(health.diskTotalBytes)),
          tint: diskLow ? colors.warning : null,
          ink: diskLow ? colors.warningInk : null,
        ),
      ],
    );
  }
}
