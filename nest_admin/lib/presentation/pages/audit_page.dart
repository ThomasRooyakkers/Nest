import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../core/formatting.dart';
import '../../data/admin_repository.dart';
import '../../l10n/admin_localizations.dart';
import '../widgets/admin_widgets.dart';

/// The audit log of admin actions, newest first.
class AuditPage extends ConsumerWidget {
  const AuditPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AdminLocalizations.of(context);
    final format = AdminFormat(l10n);
    final log = ref.watch(auditLogProvider);

    return AdminPage(
      title: l10n.navAudit,
      onRefresh: () async {
        ref.invalidate(auditLogProvider);
        await ref.read(auditLogProvider.future);
      },
      children: [
        AsyncContent(
          value: log,
          onRetry: () => ref.invalidate(auditLogProvider),
          builder: (log) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AdminTable(
                emptyText: l10n.auditEmpty,
                columns: [
                  AdminColumn(l10n.columnWhen, flex: 3),
                  AdminColumn(l10n.columnAdmin, flex: 2),
                  AdminColumn(l10n.columnActionDone, flex: 3),
                  AdminColumn(l10n.columnTarget, flex: 3),
                ],
                rows: [
                  for (final entry in log.entries)
                    [
                      CellText(format.dateTime(entry.at)),
                      CellText(entry.adminName, bold: true),
                      CellText(format.auditAction(entry.action, entry.details)),
                      CellText(
                        [entry.targetType, ?entry.targetId].join(' #'),
                        muted: true,
                      ),
                    ],
                ],
              ),
              if (log.hasMore) ...[
                const SizedBox(height: NestSpacing.gap),
                Center(
                  child: FilledButton.tonal(
                    onPressed: () => runWithFeedback(
                      context,
                      () => ref.read(auditLogProvider.notifier).loadMore(),
                    ),
                    child: Text(l10n.loadMore),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
