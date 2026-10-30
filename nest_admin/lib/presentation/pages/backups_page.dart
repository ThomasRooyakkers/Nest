import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../core/formatting.dart';
import '../../data/admin_repository.dart';
import '../../l10n/admin_localizations.dart';
import '../widgets/admin_widgets.dart';
import 'health_page.dart';

/// The command line that restores [run]'s snapshot (see the hosting guide).
String restoreCommand(BackupRun run) =>
    'docker compose stop nest\n'
    'docker compose run --rm backup restore ${run.target} ${run.snapshotId}\n'
    'docker compose start nest';

/// Backups: recent runs, "Back up now", and how to restore.
class BackupsPage extends ConsumerWidget {
  const BackupsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AdminLocalizations.of(context);
    final format = AdminFormat(l10n);
    final backups = ref.watch(backupsProvider);
    final pending = backups.value?.pendingRequest;

    return AdminPage(
      title: l10n.navBackups,
      onRefresh: () async {
        ref.invalidate(backupsProvider);
        await ref.read(backupsProvider.future);
      },
      actions: [
        FilledButton.icon(
          onPressed: backups.hasValue && pending == null
              ? () => runWithFeedback(
                  context,
                  () => ref.read(backupsProvider.notifier).requestBackup(),
                )
              : null,
          icon: const Icon(LucideIcons.cloudUpload, size: 18),
          label: Text(l10n.backUpNow),
        ),
      ],
      children: [
        if (pending != null)
          NestNotice(
            l10n.backupRequested(format.dateTime(pending.requestedAt)),
            tone: NestNoticeTone.info,
          ),
        AsyncContent(
          value: backups,
          onRetry: () => ref.invalidate(backupsProvider),
          builder: (backups) {
            final lastGood = backups.runs
                .where(
                  (r) =>
                      r.status == BackupRunStatus.succeeded &&
                      r.snapshotId != null,
                )
                .firstOrNull;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AdminTable(
                  emptyText: l10n.backupsEmpty,
                  columns: [
                    AdminColumn(l10n.columnStarted, flex: 3),
                    AdminColumn(l10n.columnTarget, flex: 2),
                    AdminColumn(l10n.columnStatus, flex: 2),
                    AdminColumn(l10n.columnSize, flex: 2),
                    AdminColumn(l10n.columnSnapshot, flex: 2),
                    AdminColumn(l10n.columnDetails, flex: 4),
                  ],
                  rows: [
                    for (final run in backups.runs)
                      [
                        CellText(format.dateTime(run.startedAt)),
                        CellText(run.target, bold: true),
                        BackupStatusBadge(status: run.status),
                        CellText(format.bytes(run.sizeBytes), muted: true),
                        SelectableText(
                          run.snapshotId ?? '–',
                          style: nunito(size: 13, weight: 700),
                        ),
                        CellText(
                          run.error ??
                              (run.finishedAt == null
                                  ? ''
                                  : format.duration(
                                      run.finishedAt!.difference(run.startedAt),
                                    )),
                          muted: true,
                        ),
                      ],
                  ],
                ),
                const SizedBox(height: NestSpacing.gap),
                _RestoreCard(run: lastGood),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _RestoreCard extends StatelessWidget {
  const _RestoreCard({required this.run});

  final BackupRun? run;

  @override
  Widget build(BuildContext context) {
    final l10n = AdminLocalizations.of(context);
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final run = this.run;
    return NestCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.restoreTitle, style: textTheme.titleLarge),
          const SizedBox(height: 6),
          Text(
            l10n.restoreBody,
            style: nunito(size: 14, weight: 600, color: colors.inkMuted),
          ),
          const SizedBox(height: 14),
          if (run == null)
            Text(l10n.restoreNoSnapshot, style: textTheme.bodyMedium)
          else ...[
            Text(
              l10n.restoreSnapshot(
                run.snapshotId!,
                run.target,
                AdminFormat(l10n).dateTime(run.startedAt),
              ),
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.chip,
                borderRadius: BorderRadius.circular(NestRadii.input),
              ),
              child: SelectableText(
                restoreCommand(run),
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  height: 1.5,
                  color: colors.ink,
                ),
              ),
            ),
            const SizedBox(height: 10),
            FilledButton.tonalIcon(
              onPressed: () async {
                await Clipboard.setData(
                  ClipboardData(text: restoreCommand(run)),
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(l10n.copied)));
                }
              },
              icon: const Icon(LucideIcons.copy, size: 18),
              label: Text(l10n.copyCommand),
            ),
          ],
        ],
      ),
    );
  }
}
