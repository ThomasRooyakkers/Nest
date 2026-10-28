import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../../app/router.dart';
import '../../../core/backend/error_messages.dart';
import '../../../core/backend/live_sync.dart';
import '../../../core/household/household_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../data/recipe_repository.dart';
import '../domain/recipe_logic.dart';
import 'add_to_list_sheet.dart';
import 'recipe_providers.dart';
import 'recipe_style.dart';

/// One recipe: photo, times, a servings stepper that rescales the
/// ingredients, "Add to list", the numbered steps and "Start cooking".
class RecipeScreen extends ConsumerStatefulWidget {
  const RecipeScreen({super.key, required this.recipeId});

  final int recipeId;

  @override
  ConsumerState<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends ConsumerState<RecipeScreen> {
  static const _maxWidth = 640.0;

  /// Servings picked with the stepper; null shows the recipe's own.
  int? _servings;

  Future<void> _delete(int householdId, Recipe recipe) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l10n.recipeDeleteConfirm(recipe.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancelButton),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.deleteButton),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      await ref.read(recipeRepositoryProvider).remove(householdId, recipe);
      if (mounted) context.pop();
    } on Exception catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(errorMessage(l10n, e))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final household = ref.watch(activeHouseholdProvider);
    if (household == null) return const Scaffold();
    final householdId = household.household.id!;
    final syncState = ref.watch(recipeSyncProvider(householdId));
    final loaded = ref.watch(recipesProvider(householdId)).hasValue;
    final recipe = ref.watch(recipeProvider(householdId, widget.recipeId));
    final shoppingOn = household.household.enabledFeatures.contains(
      HouseholdFeature.shopping,
    );

    if (recipe == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: loaded
              ? Padding(
                  padding: const EdgeInsets.all(NestSpacing.screen),
                  child: Text(l10n.recipeNotFound, style: textTheme.bodyLarge),
                )
              : const CircularProgressIndicator(),
        ),
      );
    }

    final servings = _servings ?? recipe.servings;
    final ingredients = recipe.ingredients ?? const <RecipeIngredient>[];
    final steps = recipe.steps ?? const <RecipeStep>[];
    final width = MediaQuery.sizeOf(context).width;
    final side = width > _maxWidth + 2 * NestSpacing.screen
        ? (width - _maxWidth) / 2
        : NestSpacing.screen;

    Widget sectionTitle(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(text, style: textTheme.titleLarge),
    );

    return Scaffold(
      appBar: AppBar(
        actions: [
          FavoriteButton(householdId: householdId, recipe: recipe),
          PopupMenuButton<void Function()>(
            tooltip: l10n.recipeMoreActions,
            icon: const Icon(LucideIcons.ellipsisVertical),
            onSelected: (action) => action(),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: () => context.push(Routes.editRecipe(recipe.id!)),
                child: Text(l10n.recipeEdit),
              ),
              PopupMenuItem(
                value: () => _delete(householdId, recipe),
                child: Text(l10n.recipeDelete),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          side,
          0,
          side,
          NestSpacing.screen + 72 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          if (syncState == LiveSyncState.offline) ...[
            const RecipeOfflineNotice(),
            const SizedBox(height: NestSpacing.gapSmall),
          ],
          if (recipe.photoPath != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(NestRadii.cardLarge),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: RecipePhoto(
                  householdId: householdId,
                  recipe: recipe,
                  iconSize: 48,
                ),
              ),
            ),
            const SizedBox(height: NestSpacing.gap),
          ],
          Text(recipe.title, style: textTheme.headlineMedium),
          if (recipe.description.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(recipe.description, style: textTheme.bodyMedium),
          ],
          const SizedBox(height: NestSpacing.gapSmall),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              if (recipe.prepMinutes case final minutes?)
                RecipeBadge(
                  icon: LucideIcons.clock,
                  label:
                      '${l10n.recipePrepTime} ${durationLabel(l10n, minutes)}',
                ),
              if (recipe.cookMinutes case final minutes?)
                RecipeBadge(
                  icon: LucideIcons.flame,
                  label:
                      '${l10n.recipeCookTime} ${durationLabel(l10n, minutes)}',
                ),
              for (final tag in recipe.tags) RecipeBadge(label: tag),
            ],
          ),
          const SizedBox(height: NestSpacing.gap),
          NestCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Wraps with large text instead of overflowing.
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 4,
                  children: [
                    sectionTitle(l10n.recipeIngredients),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ServingsStepper(
                        servings: servings,
                        onChanged: (value) => setState(() => _servings = value),
                      ),
                    ),
                  ],
                ),
                if (ingredients.isEmpty)
                  Text(l10n.recipeNoIngredients, style: textTheme.bodyMedium)
                else
                  for (final (index, ingredient) in ingredients.indexed) ...[
                    if (index > 0) const Divider(height: 1),
                    _IngredientRow(
                      amount: amountLabel(
                        ingredient,
                        recipe.servings,
                        servings,
                        locale,
                      ),
                      ingredient: ingredient,
                    ),
                  ],
                if (shoppingOn && ingredients.isNotEmpty) ...[
                  const SizedBox(height: NestSpacing.gapSmall),
                  OutlinedButton.icon(
                    icon: const Icon(LucideIcons.shoppingBasket, size: 18),
                    label: Text(l10n.recipeAddToList),
                    onPressed: () => showAddToListSheet(
                      context,
                      householdId: householdId,
                      recipe: recipe,
                      servings: servings,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: NestSpacing.gap),
          NestCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sectionTitle(l10n.recipeSteps),
                if (steps.isEmpty)
                  Text(l10n.recipeNoSteps, style: textTheme.bodyMedium)
                else
                  for (final (index, step) in steps.indexed)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Semantics(
                            label: l10n.recipeStepNumber(index + 1),
                            child: ExcludeSemantics(
                              child: Container(
                                width: 28,
                                height: 28,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: colors.rose,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${index + 1}',
                                  style: textTheme.labelLarge?.copyWith(
                                    color: colors.roseInk,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text(
                                step.text,
                                style: textTheme.bodyLarge,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              ],
            ),
          ),
          if (steps.isNotEmpty) ...[
            const SizedBox(height: NestSpacing.gap),
            FilledButton.icon(
              icon: const Icon(LucideIcons.chefHat, size: 20),
              label: Text(l10n.recipeStartCooking),
              onPressed: () => context.push(
                Routes.cookRecipe(recipe.id!),
                extra: servings,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _IngredientRow extends StatelessWidget {
  const _IngredientRow({required this.amount, required this.ingredient});

  final String amount;
  final RecipeIngredient ingredient;

  @override
  Widget build(BuildContext context) {
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 88,
            child: Text(
              amount,
              style: textTheme.bodyLarge?.copyWith(color: colors.accentDark),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text.rich(
              TextSpan(
                text: ingredient.name,
                children: [
                  if (ingredient.note.isNotEmpty)
                    TextSpan(
                      text: ', ${ingredient.note}',
                      style: textTheme.bodyMedium,
                    ),
                ],
              ),
              style: textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}

/// Minus / count / plus for servings (1–100), with 44×44 buttons.
class ServingsStepper extends StatelessWidget {
  const ServingsStepper({
    super.key,
    required this.servings,
    required this.onChanged,
  });

  final int servings;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    Widget button(IconData icon, String tooltip, int? next) => IconButton(
      tooltip: tooltip,
      constraints: const BoxConstraints(
        minWidth: NestSizes.minTouchTarget,
        minHeight: NestSizes.minTouchTarget,
      ),
      style: IconButton.styleFrom(backgroundColor: colors.chip),
      icon: Icon(icon, size: 18),
      onPressed: next == null ? null : () => onChanged(next),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        button(
          LucideIcons.minus,
          l10n.recipeServingsFewer,
          servings > 1 ? servings - 1 : null,
        ),
        // Wraps with large text instead of pushing the buttons out.
        Flexible(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 84),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                l10n.recipeServings(servings),
                textAlign: TextAlign.center,
                style: textTheme.labelLarge,
              ),
            ),
          ),
        ),
        button(
          LucideIcons.plus,
          l10n.recipeServingsMore,
          servings < 100 ? servings + 1 : null,
        ),
      ],
    );
  }
}
