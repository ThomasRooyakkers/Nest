import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../core/formatting.dart';
import '../../data/admin_repository.dart';
import '../../l10n/admin_localizations.dart';
import 'admin_widgets.dart';

/// Open alerts (warning cards), where alert emails go, and alerts resolved
/// in the last 30 days. Shown at the top of the Overview page.
class AlertsSection extends ConsumerWidget {
  const AlertsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AdminLocalizations.of(context);
    final colors = NestColors.of(context);
    final format = AdminFormat(l10n);
    final overview = ref.watch(alertsProvider).value;
    if (overview == null) return const SizedBox.shrink();

    final open = [
      for (final a in overview.alerts)
        if (a.resolvedAt == null) a,
    ];
    final resolved = [
      for (final a in overview.alerts)
        if (a.resolvedAt != null) a,
    ];
    final emailStatus = !overview.enabled
        ? l10n.alertsEmailOff
        : !overview.mailConfigured
        ? l10n.alertsNoMail
        : overview.recipient == null
        ? l10n.alertsNoRecipient
        : l10n.alertsEmailTo(overview.recipient!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final alert in open) ...[
          NestCard(
            color: colors.warning,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(LucideIcons.bellRing, size: 20, color: colors.warningInk),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        format.alertTitle(alert.kind),
                        style: nunito(
                          size: 17,
                          weight: 800,
                          color: colors.warningInk,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        [
                          ?format.alertDetail(alert.kind, alert.details),
                          l10n.alertSince(format.dateTime(alert.openedAt)),
                        ].join(' · '),
                        style: nunito(
                          size: 13,
                          weight: 600,
                          color: colors.warningInk,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: NestSpacing.gapSmall),
        ],
        CellText(emailStatus, muted: true),
        if (resolved.isNotEmpty) ...[
          const SizedBox(height: NestSpacing.gap),
          AdminTable(
            columns: [
              AdminColumn(l10n.alertsRecent, flex: 3),
              AdminColumn(l10n.columnWhen, flex: 3),
            ],
            rows: [
              for (final a in resolved)
                [
                  CellText(format.alertTitle(a.kind), bold: true),
                  CellText(
                    l10n.alertResolvedAt(
                      format.dateTime(a.openedAt),
                      format.dateTime(a.resolvedAt!),
                    ),
                    muted: true,
                  ),
                ],
            ],
          ),
        ],
      ],
    );
  }
}
