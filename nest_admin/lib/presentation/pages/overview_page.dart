import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../core/formatting.dart';
import '../../data/admin_repository.dart';
import '../../l10n/admin_localizations.dart';
import '../widgets/admin_widgets.dart';
import '../widgets/trend_chart.dart';
import 'health_page.dart';

/// Real server errors in an hour from which the card turns to a warning.
const serverErrorWarning = 1;

/// The portal's start page: is everything all right, and how has the server
/// been doing over the last day, week or month.
class OverviewPage extends ConsumerWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AdminLocalizations.of(context);
    final health = ref.watch(systemHealthProvider);
    final metrics = ref.watch(metricsProvider);
    final range = ref.watch(metricsRangeChoiceProvider);

    return AdminPage(
      title: l10n.navOverview,
      onRefresh: () async {
        ref
          ..invalidate(systemHealthProvider)
          ..invalidate(metricsProvider);
        await ref.read(metricsProvider.future);
      },
      children: [
        AsyncContent(
          value: health,
          onRetry: () => ref.invalidate(systemHealthProvider),
          builder: (health) =>
              _StatusCards(health: health, metrics: metrics.value),
        ),
        FilterChips<MetricsRange>(
          selected: range,
          options: {
            MetricsRange.day: l10n.range24h,
            MetricsRange.week: l10n.range7d,
            MetricsRange.month: l10n.range30d,
          },
          onSelected: ref.read(metricsRangeChoiceProvider.notifier).set,
        ),
        CellText(l10n.chartsNote, muted: true),
        AsyncContent(
          value: metrics,
          onRetry: () => ref.invalidate(metricsProvider),
          builder: (metrics) => _Charts(metrics: metrics),
        ),
      ],
    );
  }
}

class _StatusCards extends StatelessWidget {
  const _StatusCards({required this.health, required this.metrics});

  final AdminSystemHealth health;
  final AdminMetrics? metrics;

  @override
  Widget build(BuildContext context) {
    final l10n = AdminLocalizations.of(context);
    final colors = NestColors.of(context);
    final format = AdminFormat(l10n);
    final backupLate = backupIsLate(health);
    final diskLow = diskIsLow(health);
    final errors = metrics?.serverErrorsLastHour;
    final errorsHigh = errors != null && errors >= serverErrorWarning;

    return CardGrid(
      minWidth: 180,
      children: [
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
          icon: LucideIcons.triangleAlert,
          label: l10n.statusErrors,
          value: errors == null ? '–' : format.number(errors),
          detail: metrics == null
              ? null
              : l10n.refusedCalls(metrics!.refusedLastHour),
          tint: errorsHigh ? colors.warning : null,
          ink: errorsHigh ? colors.warningInk : null,
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
          icon: LucideIcons.mail,
          label: l10n.healthMail,
          value: health.mailConfigured
              ? l10n.healthConfigured
              : l10n.mailNotSetUp,
          detail: health.mailConfigured ? null : l10n.mailCodesInLog,
        ),
      ],
    );
  }
}

class _Charts extends StatelessWidget {
  const _Charts({required this.metrics});

  final AdminMetrics metrics;

  @override
  Widget build(BuildContext context) {
    final l10n = AdminLocalizations.of(context);
    final format = AdminFormat(l10n);
    final locale = l10n.localeName;
    final percent = NumberFormat.percentPattern(locale);
    final decimal = NumberFormat('#,##0.#', locale);
    final whole = NumberFormat('#,##0', locale);
    final edge = DateFormat.MMMd(locale).add_Hm();
    final time = metrics.range == MetricsRange.day
        ? DateFormat.Hm(locale)
        : DateFormat.MMMd(locale).add_Hm();

    List<AdminMetricPoint> of(String name) =>
        metrics.series.where((s) => s.name == name).firstOrNull?.points ??
        const [];

    TrendChart chart(
      String title,
      String series,
      String Function(double) value, {
      TrendKind kind = TrendKind.line,
      double? maxValue,
    }) => TrendChart(
      title: title,
      points: of(series),
      from: metrics.from,
      to: metrics.to,
      bucketMinutes: metrics.bucketMinutes,
      formatValue: value,
      formatTime: (at) => time.format(at.toLocal()),
      formatEdge: (at) => edge.format(at.toLocal()),
      kind: kind,
      maxValue: maxValue,
    );

    return CardGrid(
      minWidth: 300,
      children: [
        chart(l10n.chartCpu, 'cpu', percent.format, maxValue: 1),
        chart(l10n.chartMemory, 'memory', percent.format, maxValue: 1),
        chart(
          l10n.chartServerErrors,
          'serverErrors',
          whole.format,
          kind: TrendKind.bars,
        ),
        chart(
          l10n.chartSlowCalls,
          'slowCalls',
          whole.format,
          kind: TrendKind.bars,
        ),
        chart(
          l10n.chartDatabase,
          'databaseMs',
          (v) => l10n.milliseconds(decimal.format(v)),
        ),
        chart(l10n.chartConnections, 'connections', decimal.format),
        chart(l10n.chartDiskFree, 'diskFree', percent.format, maxValue: 1),
        chart(
          l10n.chartDatabaseSize,
          'databaseSize',
          (v) => format.bytes(v.round()),
        ),
      ],
    );
  }
}
