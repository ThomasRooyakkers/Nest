import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../core/error_messages.dart';
import '../../l10n/admin_localizations.dart';

/// Width from which the portal shows its side menu and real tables.
const wideLayoutWidth = 840.0;

bool isWide(BuildContext context) =>
    MediaQuery.sizeOf(context).width >= wideLayoutWidth;

/// A portal page: large title, optional actions, and scrolling content.
class AdminPage extends StatelessWidget {
  const AdminPage({
    super.key,
    required this.title,
    required this.children,
    this.actions = const [],
    this.onRefresh,
  });

  final String title;
  final List<Widget> children;
  final List<Widget> actions;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final l10n = AdminLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final list = ListView(
      padding: const EdgeInsets.all(NestSpacing.screen),
      children: [
        Row(
          children: [
            Expanded(
              child: Semantics(
                header: true,
                child: Text(title, style: textTheme.headlineMedium),
              ),
            ),
            ...actions,
            if (onRefresh != null) ...[
              const SizedBox(width: NestSpacing.gapSmall),
              NestRoundButton(
                icon: LucideIcons.refreshCw,
                tooltip: l10n.refresh,
                onPressed: onRefresh,
              ),
            ],
          ],
        ),
        const SizedBox(height: NestSpacing.gap),
        for (final child in children) ...[
          child,
          const SizedBox(height: NestSpacing.gap),
        ],
      ],
    );
    return onRefresh == null
        ? list
        : RefreshIndicator.adaptive(onRefresh: onRefresh!, child: list);
  }
}

/// Shows loading, error (with retry) or the loaded value of [value].
class AsyncContent<T> extends ConsumerWidget {
  const AsyncContent({
    super.key,
    required this.value,
    required this.onRetry,
    required this.builder,
  });

  final AsyncValue<T> value;
  final VoidCallback onRetry;
  final Widget Function(T data) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AdminLocalizations.of(context);
    return switch (value) {
      AsyncValue(:final value?, hasValue: true) => builder(value),
      AsyncValue(:final error?) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NestNotice(errorMessage(l10n, error)),
          const SizedBox(height: NestSpacing.gapSmall),
          FilledButton.tonal(
            onPressed: onRetry,
            child: Text(NestSharedLocalizations.of(context).retry),
          ),
        ],
      ),
      _ => const Padding(
        padding: EdgeInsets.all(40),
        child: Center(child: CircularProgressIndicator.adaptive()),
      ),
    };
  }
}

/// A small summary card: label, big value, and a detail line.
class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.detail,
    this.tint,
    this.ink,
  });

  final IconData icon;
  final String label;
  final String value;
  final String? detail;

  /// Tinted background (flat card) and text colour, e.g. for warnings.
  final Color? tint;
  final Color? ink;

  @override
  Widget build(BuildContext context) {
    final colors = NestColors.of(context);
    final foreground = ink ?? colors.ink;
    return NestCard(
      color: tint,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: ink ?? colors.inkMuted),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: nunito(
                    size: 12,
                    weight: 800,
                    letterSpacing: 0.6,
                    color: ink ?? colors.inkMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: nunito(
              size: 22,
              weight: 800,
              color: foreground,
              letterSpacing: -0.4,
            ),
          ),
          if (detail != null) ...[
            const SizedBox(height: 4),
            Text(
              detail!,
              style: nunito(
                size: 13,
                weight: 600,
                color: ink ?? colors.inkMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Lays out [children] in as many equal columns as fit (at least 240 wide).
class CardGrid extends StatelessWidget {
  const CardGrid({super.key, required this.children, this.minWidth = 240});

  final List<Widget> children;
  final double minWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = NestSpacing.gap;
        final columns = ((constraints.maxWidth + gap) / (minWidth + gap))
            .floor()
            .clamp(1, children.length);
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final child in children) SizedBox(width: width, child: child),
          ],
        );
      },
    );
  }
}

enum BadgeTone { neutral, good, warning }

/// A small rounded label, e.g. a status.
class StatusBadge extends StatelessWidget {
  const StatusBadge(this.label, {super.key, this.tone = BadgeTone.neutral});

  final String label;
  final BadgeTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = NestColors.of(context);
    final (background, foreground) = switch (tone) {
      BadgeTone.neutral => (colors.chip, colors.inkMuted),
      BadgeTone.good => (colors.accentTint, colors.accentDark),
      BadgeTone.warning => (colors.warning, colors.warningInk),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(NestRadii.badge),
      ),
      child: Text(
        label,
        style: nunito(size: 12, weight: 800, color: foreground),
      ),
    );
  }
}

/// A column of [AdminTable].
class AdminColumn {
  const AdminColumn(this.label, {this.flex = 1});

  final String label;
  final int flex;
}

/// A table inside a card. On wide screens a header and one row per item;
/// on narrow screens each row stacks into label/value pairs.
class AdminTable extends StatelessWidget {
  const AdminTable({
    super.key,
    required this.columns,
    required this.rows,
    this.emptyText,
  });

  final List<AdminColumn> columns;

  /// One cell per column for each row.
  final List<List<Widget>> rows;
  final String? emptyText;

  @override
  Widget build(BuildContext context) {
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final labelStyle = nunito(
      size: 12,
      weight: 800,
      letterSpacing: 0.5,
      color: colors.inkMuted,
    );

    if (rows.isEmpty) {
      return NestCard(
        child: Text(emptyText ?? '', style: textTheme.bodyMedium),
      );
    }

    final wide = isWide(context);
    final divider = Divider(height: 1, thickness: 1, color: colors.divider);
    return NestCard(
      padding: const EdgeInsets.symmetric(horizontal: NestSpacing.screen),
      child: Column(
        children: [
          if (wide)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                children: [
                  for (final column in columns)
                    Expanded(
                      flex: column.flex,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(end: 8),
                        // One line that shrinks, so a long (Dutch) label
                        // never breaks mid-word.
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            column.label.toUpperCase(),
                            style: labelStyle,
                            maxLines: 1,
                            softWrap: false,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          for (final (index, row) in rows.indexed) ...[
            if (wide || index > 0) divider,
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: wide
                  ? Row(
                      children: [
                        for (final (i, cell) in row.indexed)
                          Expanded(
                            flex: columns[i].flex,
                            child: Padding(
                              padding: const EdgeInsetsDirectional.only(end: 8),
                              child: Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: cell,
                              ),
                            ),
                          ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final (i, cell) in row.indexed)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 120,
                                  child: Text(
                                    columns[i].label.toUpperCase(),
                                    style: labelStyle,
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: AlignmentDirectional.centerStart,
                                    child: cell,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Plain table text; muted for secondary values.
class CellText extends StatelessWidget {
  const CellText(this.text, {super.key, this.muted = false, this.bold = false});

  final String text;
  final bool muted;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final colors = NestColors.of(context);
    return Text(
      text,
      style: nunito(
        size: muted ? 13 : 15,
        weight: bold ? 800 : (muted ? 600 : 650),
        color: muted ? colors.inkMuted : colors.ink,
      ),
    );
  }
}

/// A compact button for a table row. Its label stays on one line and
/// shrinks when the column is narrow, instead of breaking mid-word.
class TableButton extends StatelessWidget {
  const TableButton({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      onPressed: onPressed,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(label, maxLines: 1, softWrap: false),
      ),
    );
  }
}

/// Asks to confirm an action; returns true when confirmed.
Future<bool> confirmAction(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
}) async {
  final l10n = AdminLocalizations.of(context);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}

/// Runs [action] and shows a localized snack bar when it fails.
Future<void> runWithFeedback(
  BuildContext context,
  Future<void> Function() action,
) async {
  final l10n = AdminLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  try {
    await action();
  } catch (error) {
    messenger.showSnackBar(SnackBar(content: Text(errorMessage(l10n, error))));
  }
}
