import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../data/admin_repository.dart';
import '../../l10n/admin_localizations.dart';
import 'admin_widgets.dart';

/// Holiday decorations in the apps: automatic (each theme on its dates),
/// one theme all the time, or off. Shown on the Server page.
class SeasonalSection extends ConsumerWidget {
  const SeasonalSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AdminLocalizations.of(context);
    final settings = ref.watch(seasonalSettingsProvider);
    return SectionCard(
      title: l10n.sectionSeasonal,
      child: AsyncContent(
        value: settings,
        onRetry: () => ref.invalidate(seasonalSettingsProvider),
        // A new form when the saved setting changes.
        builder: (value) => _SeasonalForm(
          key: ValueKey(value.toJson().toString()),
          settings: value,
        ),
      ),
    );
  }
}

/// Name of a theme key; null for keys this portal does not know.
String? seasonalThemeName(AdminLocalizations l10n, String key) => switch (key) {
  'christmas' => l10n.seasonalThemeChristmas,
  'newYear' => l10n.seasonalThemeNewYear,
  _ => null,
};

/// "7 – 28 December" or "31 December – 2 January", in the portal's
/// language. A leap year, so 29 February can be shown.
String seasonalDatesText(String locale, SeasonalThemeDates d) {
  final start = DateTime(2000, d.startMonth, d.startDay);
  final end = DateTime(2000, d.endMonth, d.endDay);
  final dayMonth = DateFormat('d MMMM', locale);
  if (d.startMonth == d.endMonth && d.startDay <= d.endDay) {
    return '${DateFormat.d(locale).format(start)} – ${dayMonth.format(end)}';
  }
  return '${dayMonth.format(start)} – ${dayMonth.format(end)}';
}

/// Days in [month] in any year (29 February allowed).
int _daysIn(int month) => DateTime(2000, month + 1, 0).day;

class _SeasonalForm extends ConsumerStatefulWidget {
  const _SeasonalForm({super.key, required this.settings});

  final AdminSeasonalSettings settings;

  @override
  ConsumerState<_SeasonalForm> createState() => _SeasonalFormState();
}

class _SeasonalFormState extends ConsumerState<_SeasonalForm> {
  late SeasonalMode _mode = widget.settings.mode;
  late final Set<String> _enabled = widget.settings.enabledThemes.toSet();
  late String _always =
      widget.settings.alwaysTheme ?? widget.settings.availableThemes.first;
  late final Map<String, SeasonalThemeDates> _dates = {
    for (final d in widget.settings.themeDates) d.theme: d,
  };

  Future<void> _editDates(String name, SeasonalThemeDates dates) async {
    final changed = await showDialog<SeasonalThemeDates>(
      context: context,
      builder: (context) => _DatesDialog(name: name, dates: dates),
    );
    if (changed != null) setState(() => _dates[changed.theme] = changed);
  }

  Future<void> _save() => runWithFeedback(context, () async {
    final l10n = AdminLocalizations.of(context);
    await ref
        .read(adminRepositoryProvider)
        .saveSeasonal(
          _mode,
          [
            for (final key in widget.settings.availableThemes)
              if (_enabled.contains(key)) key,
          ],
          _mode == SeasonalMode.always ? _always : null,
          [for (final key in widget.settings.availableThemes) ?_dates[key]],
        );
    ref.invalidate(seasonalSettingsProvider);
    if (mounted) showMessage(context, l10n.seasonalSaved);
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AdminLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final colors = NestColors.of(context);
    final themes = [
      for (final key in widget.settings.availableThemes)
        if ((seasonalThemeName(l10n, key), _dates[key]) case (
          final String name,
          final SeasonalThemeDates dates,
        ))
          (key, name, dates),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.seasonalNote,
          style: textTheme.bodyMedium?.copyWith(color: colors.inkMuted),
        ),
        const SizedBox(height: NestSpacing.gap),
        SegmentedButton<SeasonalMode>(
          showSelectedIcon: false,
          segments: [
            ButtonSegment(
              value: SeasonalMode.automatic,
              label: Text(l10n.seasonalAutomatic),
              tooltip: l10n.seasonalAutomaticHint,
            ),
            ButtonSegment(
              value: SeasonalMode.always,
              label: Text(l10n.seasonalAlways),
              tooltip: l10n.seasonalAlwaysHint,
            ),
            ButtonSegment(
              value: SeasonalMode.off,
              label: Text(l10n.seasonalOff),
              tooltip: l10n.seasonalOffHint,
            ),
          ],
          selected: {_mode},
          onSelectionChanged: (s) => setState(() => _mode = s.single),
        ),
        const SizedBox(height: NestSpacing.gapSmall),
        Text(switch (_mode) {
          SeasonalMode.automatic => l10n.seasonalAutomaticHint,
          SeasonalMode.always => l10n.seasonalAlwaysHint,
          SeasonalMode.off => l10n.seasonalOffHint,
        }, style: textTheme.bodySmall?.copyWith(color: colors.inkMuted)),
        const SizedBox(height: NestSpacing.gap),
        if (_mode == SeasonalMode.automatic)
          for (final (key, name, dates) in themes)
            // Ink of the tile paints on this Material, above the card.
            Material(
              type: MaterialType.transparency,
              child: SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                value: _enabled.contains(key),
                onChanged: (on) => setState(
                  () => on ? _enabled.add(key) : _enabled.remove(key),
                ),
                title: Row(
                  children: [
                    Flexible(child: Text(name)),
                    if (widget.settings.activeTheme == key) ...[
                      const SizedBox(width: 8),
                      StatusBadge(l10n.seasonalNow, tone: BadgeTone.good),
                    ],
                  ],
                ),
                subtitle: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  children: [
                    Text(seasonalDatesText(l10n.localeName, dates)),
                    TextButton.icon(
                      onPressed: () => _editDates(name, dates),
                      icon: const Icon(Icons.edit_calendar_outlined, size: 18),
                      label: Text(l10n.seasonalChangeDates),
                    ),
                  ],
                ),
              ),
            ),
        if (_mode == SeasonalMode.always)
          DropdownMenu<String>(
            label: Text(l10n.seasonalShowTheme),
            initialSelection: _always,
            onSelected: (key) {
              if (key != null) setState(() => _always = key);
            },
            dropdownMenuEntries: [
              for (final (key, name, _) in themes)
                DropdownMenuEntry(value: key, label: name),
            ],
          ),
        const SizedBox(height: NestSpacing.gap),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: FilledButton(onPressed: _save, child: Text(l10n.save)),
        ),
      ],
    );
  }
}

/// Asks for the start and end day of a theme; returns the new dates, or
/// null when cancelled.
class _DatesDialog extends StatefulWidget {
  const _DatesDialog({required this.name, required this.dates});

  final String name;
  final SeasonalThemeDates dates;

  @override
  State<_DatesDialog> createState() => _DatesDialogState();
}

class _DatesDialogState extends State<_DatesDialog> {
  late SeasonalThemeDates _dates = widget.dates;

  @override
  Widget build(BuildContext context) {
    final l10n = AdminLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final colors = NestColors.of(context);
    final months = DateFormat.MMMM(l10n.localeName);

    Widget dayMonth({
      required String label,
      required int month,
      required int day,
      required void Function(int month, int day) onChanged,
    }) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.titleSmall),
        const SizedBox(height: NestSpacing.gapSmall),
        Row(
          children: [
            SizedBox(
              width: 96,
              child: DropdownButtonFormField<int>(
                initialValue: day,
                decoration: InputDecoration(labelText: l10n.seasonalDay),
                items: [
                  for (var d = 1; d <= _daysIn(month); d++)
                    DropdownMenuItem(value: d, child: Text('$d')),
                ],
                onChanged: (d) {
                  if (d != null) onChanged(month, d);
                },
              ),
            ),
            const SizedBox(width: NestSpacing.gapSmall),
            Expanded(
              child: DropdownButtonFormField<int>(
                initialValue: month,
                isExpanded: true,
                decoration: InputDecoration(labelText: l10n.seasonalMonth),
                items: [
                  for (var m = 1; m <= 12; m++)
                    DropdownMenuItem(
                      value: m,
                      child: Text(months.format(DateTime(2000, m))),
                    ),
                ],
                onChanged: (m) {
                  if (m != null) onChanged(m, day.clamp(1, _daysIn(m)));
                },
              ),
            ),
          ],
        ),
      ],
    );

    return AlertDialog(
      title: Text(l10n.seasonalDatesTitle(widget.name)),
      content: SizedBox(
        width: 360,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              dayMonth(
                label: l10n.seasonalStarts,
                month: _dates.startMonth,
                day: _dates.startDay,
                onChanged: (m, d) => setState(
                  () => _dates = _dates.copyWith(startMonth: m, startDay: d),
                ),
              ),
              const SizedBox(height: NestSpacing.gap),
              dayMonth(
                label: l10n.seasonalEnds,
                month: _dates.endMonth,
                day: _dates.endDay,
                onChanged: (m, d) => setState(
                  () => _dates = _dates.copyWith(endMonth: m, endDay: d),
                ),
              ),
              const SizedBox(height: NestSpacing.gap),
              Text(
                seasonalDatesText(l10n.localeName, _dates),
                style: textTheme.titleMedium,
              ),
              const SizedBox(height: NestSpacing.gapSmall),
              Text(
                l10n.seasonalDatesHint,
                style: textTheme.bodySmall?.copyWith(color: colors.inkMuted),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_dates),
          child: Text(l10n.seasonalDatesDone),
        ),
      ],
    );
  }
}
