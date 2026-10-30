import 'package:intl/intl.dart';
import 'package:nest_client/nest_client.dart';

import '../l10n/admin_localizations.dart';

/// Locale-aware formatting for the admin portal.
class AdminFormat {
  AdminFormat(this.l10n) : _locale = l10n.localeName;

  final AdminLocalizations l10n;
  final String _locale;

  /// Date and time in the viewer's time zone, e.g. `30 Oct 2026, 14:05`.
  String dateTime(DateTime value) =>
      DateFormat.yMMMd(_locale).add_Hm().format(value.toLocal());

  String date(DateTime value) =>
      DateFormat.yMMMd(_locale).format(value.toLocal());

  /// Optional date and time; a dash when there is none.
  String maybeDateTime(DateTime? value) =>
      value == null ? '–' : dateTime(value);

  /// Bytes as KB, MB, GB or TB (powers of 1024) with one decimal.
  String bytes(int? value) {
    if (value == null) return '–';
    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    var size = value.toDouble();
    var unit = 0;
    while (size >= 1024 && unit < units.length - 1) {
      size /= 1024;
      unit++;
    }
    final number = NumberFormat(unit == 0 ? '0' : '0.0', _locale).format(size);
    return '$number ${units[unit]}';
  }

  String number(int value) =>
      NumberFormat.decimalPattern(_locale).format(value);

  /// A duration in days, hours or minutes, e.g. for uptime.
  String duration(Duration value) {
    if (value.inDays >= 1) return l10n.durationDays(value.inDays);
    if (value.inHours >= 1) return l10n.durationHours(value.inHours);
    return l10n.durationMinutes(value.inMinutes);
  }

  String feature(HouseholdFeature feature) => switch (feature) {
    HouseholdFeature.shopping => l10n.featureShopping,
    HouseholdFeature.recipes => l10n.featureRecipes,
    HouseholdFeature.mealPlanning => l10n.featureMeals,
    HouseholdFeature.tasks => l10n.featureTasks,
    HouseholdFeature.watchlist => l10n.featureWatchlist,
  };

  String language(String locale) => switch (locale) {
    'nl' => 'Nederlands',
    _ => 'English',
  };

  String backupStatus(BackupRunStatus status) => switch (status) {
    BackupRunStatus.running => l10n.backupStatusRunning,
    BackupRunStatus.succeeded => l10n.backupStatusSucceeded,
    BackupRunStatus.failed => l10n.backupStatusFailed,
  };

  /// What an audit log action means, or the action itself when unknown.
  String auditAction(String action, String? details) => switch (action) {
    'household.setStatus' when details == 'active -> suspended' =>
      l10n.auditHouseholdSuspended,
    'household.setStatus' when details == 'suspended -> active' =>
      l10n.auditHouseholdReactivated,
    'household.setStatus' => l10n.auditHouseholdStatus,
    'user.disable' => l10n.auditUserDisabled,
    'user.enable' => l10n.auditUserEnabled,
    'backup.request' => l10n.auditBackupRequested,
    _ => action,
  };
}
