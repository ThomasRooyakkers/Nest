import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_shared/nest_shared.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../core/household/household_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/recipe_logic.dart';
import 'recipe_providers.dart';

/// Cooking mode: one step at a time in large text, the ingredients one tap
/// away, and the screen kept awake while it is open.
class CookingScreen extends ConsumerStatefulWidget {
  const CookingScreen({super.key, required this.recipeId, this.servings});

  final int recipeId;

  /// Servings picked on the recipe screen; null for the recipe's own.
  final int? servings;

  @override
  ConsumerState<CookingScreen> createState() => _CookingScreenState();
}

class _CookingScreenState extends ConsumerState<CookingScreen> {
  var _step = 0;

  @override
  void initState() {
    super.initState();
    unawaited(_keepAwake(true));
  }

  @override
  void dispose() {
    unawaited(_keepAwake(false));
    super.dispose();
  }

  /// Not every platform or browser can keep the screen on; cooking mode
  /// works without it.
  static Future<void> _keepAwake(bool on) async {
    try {
      await WakelockPlus.toggle(enable: on);
    } on Object catch (_) {}
  }

  void _showIngredients(Recipe recipe) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final servings = widget.servings ?? recipe.servings;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: NestColors.of(context).surface,
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        final textTheme = Theme.of(context).textTheme;
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(
              NestSpacing.screen,
              0,
              NestSpacing.screen,
              NestSpacing.screen,
            ),
            children: [
              Text(l10n.recipeIngredients, style: textTheme.titleLarge),
              Text(l10n.recipeServings(servings), style: textTheme.bodyMedium),
              const SizedBox(height: 8),
              for (final ingredient in recipe.ingredients ?? const [])
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    [
                      amountLabel(
                        ingredient,
                        recipe.servings,
                        servings,
                        locale,
                      ),
                      ingredient.name,
                      if (ingredient.note.isNotEmpty) '(${ingredient.note})',
                    ].where((part) => part.isNotEmpty).join(' '),
                    style: textTheme.titleMedium,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final household = ref.watch(activeHouseholdProvider);
    final recipe = household == null
        ? null
        : ref.watch(recipeProvider(household.household.id!, widget.recipeId));
    final steps = recipe?.steps ?? const <RecipeStep>[];

    if (recipe == null || steps.isEmpty) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.recipeNoSteps)),
      );
    }

    final step = _step.clamp(0, steps.length - 1);
    final isLast = step == steps.length - 1;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: l10n.cookingClose,
          icon: const Icon(LucideIcons.x),
          onPressed: () => context.pop(),
        ),
        title: Text(recipe.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          if ((recipe.ingredients ?? const []).isNotEmpty)
            TextButton.icon(
              icon: const Icon(LucideIcons.listChecks, size: 18),
              label: Text(l10n.recipeIngredients),
              onPressed: () => _showIngredients(recipe),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(NestSpacing.screen),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.cookingStepOf(step + 1, steps.length),
                style: textTheme.labelLarge?.copyWith(color: colors.roseInk),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(NestRadii.badge),
                child: LinearProgressIndicator(
                  value: (step + 1) / steps.length,
                  minHeight: 6,
                  color: colors.roseInk,
                  backgroundColor: colors.rose,
                ),
              ),
              const SizedBox(height: NestSpacing.screen),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    steps[step].text,
                    style: textTheme.headlineMedium?.copyWith(
                      fontSize: 30,
                      height: 1.35,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: NestSpacing.gap),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(LucideIcons.chevronLeft),
                      label: Text(l10n.cookingPrevious),
                      onPressed: step == 0
                          ? null
                          : () => setState(() => _step = step - 1),
                    ),
                  ),
                  const SizedBox(width: NestSpacing.gapSmall),
                  Expanded(
                    child: FilledButton.icon(
                      icon: Icon(
                        isLast ? LucideIcons.check : LucideIcons.chevronRight,
                      ),
                      iconAlignment: IconAlignment.end,
                      label: Text(isLast ? l10n.cookingDone : l10n.cookingNext),
                      onPressed: isLast
                          ? () => context.pop()
                          : () => setState(() => _step = step + 1),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
