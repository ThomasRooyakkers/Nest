import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nest_client/nest_client.dart';

import '../../../l10n/app_localizations.dart';

String slotLabel(AppLocalizations l10n, MealSlot slot) => switch (slot) {
  MealSlot.breakfast => l10n.mealSlotBreakfast,
  MealSlot.lunch => l10n.mealSlotLunch,
  MealSlot.dinner => l10n.mealSlotDinner,
};

String planSlotLabel(AppLocalizations l10n, MealSlot slot) => switch (slot) {
  MealSlot.breakfast => l10n.mealPlanBreakfast,
  MealSlot.lunch => l10n.mealPlanLunch,
  MealSlot.dinner => l10n.mealPlanDinner,
};

/// A day as "Wednesday 28 October" in the app's language.
String fullDayLabel(BuildContext context, DateTime day) {
  final locale = Localizations.localeOf(context).toLanguageTag();
  return DateFormat.MMMMEEEEd(locale).format(day.toUtc());
}

/// A week as "26 Oct – 1 Nov".
String weekRangeLabel(BuildContext context, DateTime weekStart) {
  final locale = Localizations.localeOf(context).toLanguageTag();
  final end = weekStart.add(const Duration(days: 6));
  final format = DateFormat.MMMd(locale);
  return '${format.format(weekStart)} – ${format.format(end)}';
}
