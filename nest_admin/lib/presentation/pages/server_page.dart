import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../data/admin_repository.dart';
import '../../l10n/admin_localizations.dart';
import '../widgets/admin_widgets.dart';

/// The settings this server runs with (read-only; they live in `.env`),
/// tests for mail and film data, and whether an update is available.
class ServerPage extends ConsumerWidget {
  const ServerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AdminLocalizations.of(context);
    final settings = ref.watch(serverSettingsProvider);

    return AdminPage(
      title: l10n.navServer,
      onRefresh: () async {
        ref
          ..invalidate(serverSettingsProvider)
          ..invalidate(updateStatusProvider);
        await ref.read(serverSettingsProvider.future);
      },
      children: [
        AsyncContent(
          value: settings,
          onRetry: () => ref.invalidate(serverSettingsProvider),
          builder: (settings) => _Content(settings: settings),
        ),
      ],
    );
  }
}

class _Content extends ConsumerWidget {
  const _Content({required this.settings});

  final AdminServerSettings settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AdminLocalizations.of(context);
    final repository = ref.read(adminRepositoryProvider);

    Widget onOff(bool on) => on
        ? StatusBadge(l10n.settingOn, tone: BadgeTone.good)
        : StatusBadge(l10n.settingOff);
    Widget value(String? text) =>
        text == null ? CellText(l10n.notSet, muted: true) : CellText(text);

    Future<void> runCheck(
      Future<AdminCheckResult> Function() check,
      String okMessage,
    ) => runWithFeedback(context, () async {
      final result = await check();
      if (!context.mounted) return;
      showMessage(
        context,
        result.ok
            ? okMessage
            : switch (result.detail) {
                'notConfigured' => l10n.testNotConfigured,
                'noAddress' => l10n.testNoAddress,
                final detail => l10n.testFailed(detail ?? l10n.unknown),
              },
      );
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NestNotice(l10n.settingsNote, tone: NestNoticeTone.info),
        const SizedBox(height: NestSpacing.gap),
        SectionCard(
          title: l10n.sectionVersion,
          child: _Rows([
            (l10n.settingVersion, CellText(settings.version)),
            (
              l10n.settingApi,
              CellText(
                l10n.apiLevels(
                  settings.apiVersion,
                  settings.minClientApiVersion,
                ),
              ),
            ),
            (l10n.settingUpdate, const _UpdateStatus()),
          ]),
        ),
        const SizedBox(height: NestSpacing.gap),
        SectionCard(
          title: l10n.sectionAddresses,
          child: _Rows([
            (l10n.settingApiAddress, value(settings.apiHost)),
            (l10n.settingWebAddress, value(settings.webHost)),
            (l10n.settingAdminAddress, value(settings.adminHost)),
            (
              l10n.settingOrigins,
              value(
                settings.allowedOrigins.isEmpty
                    ? null
                    : settings.allowedOrigins.join('\n'),
              ),
            ),
          ]),
        ),
        const SizedBox(height: NestSpacing.gap),
        SectionCard(
          title: l10n.sectionAccounts,
          child: _Rows([
            (
              l10n.healthSignUpMode,
              CellText(
                settings.signUpMode == SignUpMode.open
                    ? l10n.signUpOpen
                    : l10n.signUpInviteOnly,
              ),
            ),
            (l10n.settingSuperAdmin, value(settings.superAdminEmail)),
            (l10n.settingGoogle, onOff(settings.googleSignIn)),
            (l10n.settingApple, onOff(settings.appleSignIn)),
          ]),
        ),
        const SizedBox(height: NestSpacing.gap),
        SectionCard(
          title: l10n.sectionServices,
          actions: [
            FilledButton.tonalIcon(
              onPressed: () =>
                  runCheck(repository.sendTestMail, l10n.testMailSent),
              icon: const Icon(LucideIcons.mail, size: 18),
              label: Text(l10n.sendTestMail),
            ),
            FilledButton.tonalIcon(
              onPressed: () =>
                  runCheck(repository.testFilmData, l10n.filmDataOk),
              icon: const Icon(LucideIcons.clapperboard, size: 18),
              label: Text(l10n.testFilmData),
            ),
          ],
          child: _Rows([
            (
              l10n.healthMail,
              settings.mailConfigured
                  ? StatusBadge(l10n.healthConfigured, tone: BadgeTone.good)
                  : StatusBadge(l10n.healthMailLog),
            ),
            (l10n.settingMailFrom, value(settings.mailFrom)),
            (l10n.settingAlerts, onOff(settings.alertsEnabled)),
            (l10n.settingUptime, onOff(settings.uptimePing)),
            (
              l10n.healthFilmData,
              settings.filmDataConfigured
                  ? StatusBadge(l10n.healthConfigured, tone: BadgeTone.good)
                  : StatusBadge(l10n.healthFilmDataSample),
            ),
          ]),
        ),
      ],
    );
  }
}

/// Label/value rows inside a [SectionCard]; stacked on narrow screens.
class _Rows extends StatelessWidget {
  const _Rows(this.rows);

  final List<(String, Widget)> rows;

  @override
  Widget build(BuildContext context) {
    final colors = NestColors.of(context);
    final wide = isWide(context);
    return Column(
      children: [
        for (final (index, (label, value)) in rows.indexed) ...[
          if (index > 0)
            Divider(height: 1, thickness: 1, color: colors.divider),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: wide
                ? Row(
                    children: [
                      Expanded(flex: 2, child: CellText(label, bold: true)),
                      Expanded(
                        flex: 3,
                        child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: value,
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CellText(label, bold: true),
                      const SizedBox(height: 4),
                      value,
                    ],
                  ),
          ),
        ],
      ],
    );
  }
}

class _UpdateStatus extends ConsumerWidget {
  const _UpdateStatus();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AdminLocalizations.of(context);
    final status = ref.watch(updateStatusProvider);
    return switch (status) {
      AsyncData(:final value) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          switch (value) {
            AdminUpdateStatus(problem: 'off') => StatusBadge(l10n.updateOff),
            AdminUpdateStatus(updateAvailable: true, :final latestVersion?) =>
              StatusBadge(
                l10n.updateAvailable(latestVersion),
                tone: BadgeTone.warning,
              ),
            AdminUpdateStatus(latestVersion: null) => StatusBadge(
              l10n.updateUnreachable,
            ),
            _ => StatusBadge(l10n.upToDate, tone: BadgeTone.good),
          },
          if (value.updateAvailable) ...[
            const SizedBox(height: 4),
            CellText(l10n.updateHint, muted: true),
          ],
        ],
      ),
      AsyncError() => StatusBadge(l10n.updateUnreachable),
      _ => const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator.adaptive(strokeWidth: 2),
      ),
    };
  }
}
