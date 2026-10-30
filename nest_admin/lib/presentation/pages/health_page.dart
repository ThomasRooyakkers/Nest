import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../core/formatting.dart';
import '../../data/admin_repository.dart';
import '../../l10n/admin_localizations.dart';
import '../widgets/admin_widgets.dart';

/// A backup counts as late when the newest successful one is older than
/// this (a day plus some slack for a slow run).
const backupLateAfter = Duration(hours: 26);

bool backupIsLate(AdminSystemHealth health) {
  final last = health.lastSuccessfulBackupAt;
  return last == null || health.serverTime.difference(last) > backupLateAfter;
}

/// Less than 10 % of the disk free.
bool diskIsLow(AdminSystemHealth health) {
  final free = health.diskFreeBytes;
  final total = health.diskTotalBytes;
  return free != null && total != null && total > 0 && free / total < 0.1;
}

/// System health: server, database, disk, accounts, configuration and the
/// last backup of each target.
class HealthPage extends ConsumerWidget {
  const HealthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AdminLocalizations.of(context);
    final colors = NestColors.of(context);
    final format = AdminFormat(l10n);
    final health = ref.watch(systemHealthProvider);

    return AdminPage(
      title: l10n.navHealth,
      onRefresh: () async {
        ref.invalidate(systemHealthProvider);
        await ref.read(systemHealthProvider.future);
      },
      children: [
        AsyncContent(
          value: health,
          onRetry: () => ref.invalidate(systemHealthProvider),
          builder: (health) {
            final diskLow = diskIsLow(health);
            final backupLate = backupIsLate(health);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CardGrid(
                  children: [
                    SummaryCard(
                      icon: LucideIcons.server,
                      label: l10n.healthServer,
                      value: health.version,
                      detail: l10n.healthServerDetail(
                        health.apiVersion,
                        format.duration(
                          health.serverTime.difference(health.startedAt),
                        ),
                      ),
                    ),
                    SummaryCard(
                      icon: LucideIcons.database,
                      label: l10n.healthDatabase,
                      value: health.databaseOk
                          ? l10n.healthOk
                          : l10n.healthDatabaseDown,
                      detail: l10n.healthDatabaseSize(
                        format.bytes(health.databaseSizeBytes),
                      ),
                      tint: health.databaseOk ? null : colors.warning,
                      ink: health.databaseOk ? null : colors.warningInk,
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
                    SummaryCard(
                      icon: LucideIcons.house,
                      label: l10n.navHouseholds,
                      value: format.number(health.householdCount),
                      detail: l10n.healthActive(
                        format.number(health.activeHouseholdCount),
                      ),
                    ),
                    SummaryCard(
                      icon: LucideIcons.users,
                      label: l10n.navUsers,
                      value: format.number(health.userCount),
                      detail: l10n.healthDisabled(
                        format.number(health.disabledUserCount),
                      ),
                    ),
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
                  ],
                ),
                const SizedBox(height: NestSpacing.gap),
                AdminTable(
                  columns: [
                    AdminColumn(l10n.healthSetting, flex: 2),
                    AdminColumn(l10n.healthValue, flex: 3),
                  ],
                  rows: [
                    [
                      CellText(l10n.healthSignUpMode, bold: true),
                      CellText(
                        health.signUpMode == SignUpMode.open
                            ? l10n.signUpOpen
                            : l10n.signUpInviteOnly,
                      ),
                    ],
                    [
                      CellText(l10n.healthMail, bold: true),
                      _ConfiguredBadge(
                        configured: health.mailConfigured,
                        notConfigured: l10n.healthMailLog,
                      ),
                    ],
                    [
                      CellText(l10n.healthFilmData, bold: true),
                      _ConfiguredBadge(
                        configured: health.filmDataConfigured,
                        notConfigured: l10n.healthFilmDataSample,
                      ),
                    ],
                    for (final run in health.lastBackups)
                      [
                        CellText(
                          l10n.healthBackupTarget(run.target),
                          bold: true,
                        ),
                        Wrap(
                          spacing: 8,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            BackupStatusBadge(status: run.status),
                            CellText(
                              format.dateTime(run.startedAt),
                              muted: true,
                            ),
                          ],
                        ),
                      ],
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _ConfiguredBadge extends StatelessWidget {
  const _ConfiguredBadge({
    required this.configured,
    required this.notConfigured,
  });

  final bool configured;
  final String notConfigured;

  @override
  Widget build(BuildContext context) {
    final l10n = AdminLocalizations.of(context);
    return configured
        ? StatusBadge(l10n.healthConfigured, tone: BadgeTone.good)
        : StatusBadge(notConfigured);
  }
}

/// The status of a backup run as a badge.
class BackupStatusBadge extends StatelessWidget {
  const BackupStatusBadge({super.key, required this.status});

  final BackupRunStatus status;

  @override
  Widget build(BuildContext context) {
    final format = AdminFormat(AdminLocalizations.of(context));
    return StatusBadge(
      format.backupStatus(status),
      tone: switch (status) {
        BackupRunStatus.succeeded => BadgeTone.good,
        BackupRunStatus.failed => BadgeTone.warning,
        BackupRunStatus.running => BadgeTone.neutral,
      },
    );
  }
}
