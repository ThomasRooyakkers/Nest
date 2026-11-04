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

/// A sign-in failure count from which the card turns to a warning.
const failedSignInWarning = 10;

/// Sign-ins, failed sign-ins, new accounts and password resets.
class SecurityPage extends ConsumerWidget {
  const SecurityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AdminLocalizations.of(context);
    final colors = NestColors.of(context);
    final format = AdminFormat(l10n);
    final events = ref.watch(securityLogProvider);
    final summary = ref.watch(logSummaryProvider);
    final filter = ref.watch(securityFilterChoiceProvider);

    return AdminPage(
      title: l10n.navSecurity,
      onRefresh: () async {
        ref
          ..invalidate(securityLogProvider)
          ..invalidate(logSummaryProvider);
        await ref.read(securityLogProvider.future);
      },
      children: [
        if (summary case AsyncData(:final value))
          CardGrid(
            children: [
              SummaryCard(
                icon: LucideIcons.logIn,
                label: l10n.summarySignIns,
                value: format.number(value.signIns24h),
              ),
              SummaryCard(
                icon: LucideIcons.shieldAlert,
                label: l10n.summaryFailedSignIns,
                value: format.number(value.failedSignIns24h),
                tint: value.failedSignIns24h >= failedSignInWarning
                    ? colors.warning
                    : null,
                ink: value.failedSignIns24h >= failedSignInWarning
                    ? colors.warningInk
                    : null,
              ),
            ],
          ),
        NestNotice(
          l10n.securityNote(summary.value?.securityRetentionDays ?? 30),
          tone: NestNoticeTone.info,
        ),
        FilterChips<SecurityEventType?>(
          selected: filter,
          options: {
            null: l10n.filterAll,
            SecurityEventType.signIn: l10n.filterSignIns,
            SecurityEventType.signInFailed: l10n.filterFailed,
            SecurityEventType.signUp: l10n.filterSignUps,
            SecurityEventType.passwordResetRequested: l10n.filterResets,
          },
          onSelected: ref.read(securityFilterChoiceProvider.notifier).set,
        ),
        AsyncContent(
          value: events,
          onRetry: () => ref.invalidate(securityLogProvider),
          builder: (page) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AdminTable(
                emptyText: l10n.securityEmpty,
                onRowTap: (i) {
                  final userId = page.items[i].userId;
                  if (userId != null) context.go('/users/$userId');
                },
                columns: [
                  AdminColumn(l10n.columnWhen, flex: 3),
                  AdminColumn(l10n.columnEvent, flex: 3),
                  AdminColumn(l10n.columnWho, flex: 3),
                  AdminColumn(l10n.columnMethod, flex: 2),
                  AdminColumn(l10n.columnDetails, flex: 3),
                ],
                rows: [
                  for (final e in page.items)
                    [
                      CellText(format.dateTime(e.at)),
                      e.type == SecurityEventType.signInFailed
                          ? StatusBadge(
                              format.securityEvent(e.type),
                              tone: BadgeTone.warning,
                            )
                          : CellText(format.securityEvent(e.type), bold: true),
                      CellText(e.userName ?? e.emailHint ?? '–'),
                      CellText(format.signInMethod(e.method), muted: true),
                      CellText(
                        format.signInFailure(e.reason) ?? '–',
                        muted: true,
                      ),
                    ],
                ],
              ),
              if (page.hasMore) ...[
                const SizedBox(height: NestSpacing.gap),
                Center(
                  child: FilledButton.tonal(
                    onPressed: () => runWithFeedback(
                      context,
                      ref.read(securityLogProvider.notifier).loadMore,
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
