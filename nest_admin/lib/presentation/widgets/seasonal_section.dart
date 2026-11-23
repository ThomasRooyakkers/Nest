import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

/// Name and dates of a theme key; null for keys this portal does not know.
(String, String)? seasonalThemeLabels(AdminLocalizations l10n, String key) =>
    switch (key) {
      'christmas' => (l10n.seasonalThemeChristmas, l10n.seasonalDatesChristmas),
      'newYear' => (l10n.seasonalThemeNewYear, l10n.seasonalDatesNewYear),
      _ => null,
    };

/// Whether [key]'s dates include [date]. Keep in line with the app's
/// `seasonalThemeOn` (`nest_flutter/lib/features/seasonal`).
bool seasonalThemeIsOn(String key, DateTime date) => switch (key) {
  'christmas' => date.month == 12 && date.day >= 7 && date.day <= 28,
  'newYear' =>
    (date.month == 12 && date.day == 31) || (date.month == 1 && date.day <= 2),
  _ => false,
};

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

  Future<void> _save() => runWithFeedback(context, () async {
    final l10n = AdminLocalizations.of(context);
    await ref.read(adminRepositoryProvider).saveSeasonal(_mode, [
      for (final key in widget.settings.availableThemes)
        if (_enabled.contains(key)) key,
    ], _mode == SeasonalMode.always ? _always : null);
    ref.invalidate(seasonalSettingsProvider);
    if (mounted) showMessage(context, l10n.seasonalSaved);
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AdminLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final colors = NestColors.of(context);
    final now = DateTime.now();
    final themes = [
      for (final key in widget.settings.availableThemes)
        if (seasonalThemeLabels(l10n, key) case (final name, final dates))
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
                    if (seasonalThemeIsOn(key, now)) ...[
                      const SizedBox(width: 8),
                      StatusBadge(l10n.seasonalNow, tone: BadgeTone.good),
                    ],
                  ],
                ),
                subtitle: Text(dates),
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
