import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../core/formatting.dart';
import '../../data/admin_repository.dart';
import '../../l10n/admin_localizations.dart';
import '../widgets/admin_widgets.dart';

/// Failed and slow server calls, newest first. Text arrives redacted from
/// the server (emails masked, codes hidden).
class LogsPage extends ConsumerWidget {
  const LogsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AdminLocalizations.of(context);
    final format = AdminFormat(l10n);
    final sessions = ref.watch(logSessionsProvider);
    final summary = ref.watch(logSummaryProvider);
    final filter = ref.watch(logFilterChoiceProvider);

    return AdminPage(
      title: l10n.navLogs,
      onRefresh: () async {
        ref
          ..invalidate(logSessionsProvider)
          ..invalidate(logSummaryProvider);
        await ref.read(logSessionsProvider.future);
      },
      children: [
        if (summary case AsyncData(:final value)) _SummaryCards(summary: value),
        NestNotice(l10n.logsNote, tone: NestNoticeTone.info),
        FilterChips<LogFilter>(
          selected: filter,
          options: {
            LogFilter.all: l10n.filterAll,
            LogFilter.errors: l10n.filterErrors,
            LogFilter.slow: l10n.filterSlow,
          },
          onSelected: ref.read(logFilterChoiceProvider.notifier).set,
        ),
        AsyncContent(
          value: sessions,
          onRetry: () => ref.invalidate(logSessionsProvider),
          builder: (page) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AdminTable(
                emptyText: l10n.logsEmpty,
                onRowTap: (i) => showLogDetail(context, page.items[i].id),
                columns: [
                  AdminColumn(l10n.columnWhen, flex: 3),
                  AdminColumn(l10n.columnCall, flex: 4),
                  AdminColumn(l10n.columnDuration, flex: 2),
                  AdminColumn(l10n.columnUser, flex: 2),
                  AdminColumn(l10n.columnResult, flex: 5),
                ],
                rows: [
                  for (final s in page.items)
                    [
                      CellText(format.dateTime(s.time)),
                      CellText(s.call, bold: true),
                      CellText(format.millis(s.durationMs), muted: true),
                      CellText(s.userName ?? '–', muted: true),
                      _Result(session: s),
                    ],
                ],
              ),
              if (page.hasMore) ...[
                const SizedBox(height: NestSpacing.gap),
                Center(
                  child: FilledButton.tonal(
                    onPressed: () => runWithFeedback(
                      context,
                      ref.read(logSessionsProvider.notifier).loadMore,
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

class _SummaryCards extends StatelessWidget {
  const _SummaryCards({required this.summary});

  final AdminLogSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AdminLocalizations.of(context);
    final colors = NestColors.of(context);
    final format = AdminFormat(l10n);
    final errors = summary.errors24h > 0;
    final days = summary.logRetentionDays;
    return CardGrid(
      children: [
        SummaryCard(
          icon: LucideIcons.triangleAlert,
          label: l10n.summaryErrors,
          value: format.number(summary.errors24h),
          tint: errors ? colors.warning : null,
          ink: errors ? colors.warningInk : null,
        ),
        SummaryCard(
          icon: LucideIcons.timer,
          label: l10n.summarySlow,
          value: format.number(summary.slow24h),
        ),
        SummaryCard(
          icon: LucideIcons.archive,
          label: l10n.summaryRetention,
          value: days == null
              ? l10n.retentionForever
              : format.duration(Duration(days: days)),
        ),
      ],
    );
  }
}

class _Result extends StatelessWidget {
  const _Result({required this.session});

  final AdminLogSession session;

  @override
  Widget build(BuildContext context) {
    final l10n = AdminLocalizations.of(context);
    final error = session.error;
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (error != null)
          StatusBadge(l10n.resultError, tone: BadgeTone.warning)
        else if (session.slow)
          StatusBadge(l10n.resultSlow)
        else
          StatusBadge(l10n.resultOk, tone: BadgeTone.good),
        if (error != null) CellText(error, muted: true),
      ],
    );
  }
}

/// Shows one call's error, stack trace and messages in a dialog.
Future<void> showLogDetail(BuildContext context, int id) => showDialog<void>(
  context: context,
  builder: (context) => _LogDetailDialog(id: id),
);

class _LogDetailDialog extends ConsumerWidget {
  const _LogDetailDialog({required this.id});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AdminLocalizations.of(context);
    final format = AdminFormat(l10n);
    final detail = ref.watch(logSessionDetailProvider(id));
    final textTheme = Theme.of(context).textTheme;

    Widget section(String title, Widget child) => Padding(
      padding: const EdgeInsets.only(top: NestSpacing.gap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: textTheme.titleMedium),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );

    return AlertDialog(
      title: Text(l10n.logDetailTitle),
      content: SizedBox(
        width: 720,
        child: AsyncContent(
          value: detail,
          onRetry: () => ref.invalidate(logSessionDetailProvider(id)),
          builder: (detail) {
            final s = detail.session;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CellText(s.call, bold: true),
                  CellText(
                    [
                      format.dateTime(s.time),
                      format.millis(s.durationMs),
                      if (s.numQueries != null) l10n.queryCount(s.numQueries!),
                      ?s.userName,
                    ].join(' · '),
                    muted: true,
                  ),
                  if (detail.error != null)
                    section(l10n.logError, _Code(detail.error!)),
                  if (detail.stackTrace != null)
                    section(l10n.logStackTrace, _Code(detail.stackTrace!)),
                  if (detail.messages.isNotEmpty)
                    section(
                      l10n.logMessages,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (final m in detail.messages)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: _Code(
                                [
                                  '${m.level.toUpperCase()}  ${m.message}',
                                  ?m.error,
                                  ?m.stackTrace,
                                ].join('\n'),
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
      actions: [
        FilledButton.tonal(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.close),
        ),
      ],
    );
  }
}

/// Monospace, selectable text on a light chip background.
class _Code extends StatelessWidget {
  const _Code(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = NestColors.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.chip,
        borderRadius: BorderRadius.circular(NestRadii.badge),
      ),
      child: SelectableText(
        text,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 12.5,
          height: 1.4,
          color: colors.ink,
        ),
      ),
    );
  }
}
