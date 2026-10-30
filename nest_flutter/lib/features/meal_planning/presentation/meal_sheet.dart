import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../../core/backend/error_messages.dart';
import '../../../l10n/app_localizations.dart';
import '../../recipes/domain/recipe_logic.dart';
import '../../recipes/presentation/recipe_providers.dart';
import '../../recipes/presentation/recipe_screen.dart';
import '../../tasks/domain/task_logic.dart';
import '../../tasks/presentation/task_providers.dart';
import '../data/meal_plan_repository.dart';
import 'meal_plan_style.dart';

/// Bottom sheet to plan a meal for [slot] on [day], or to change, move or
/// remove [entry]. The meal is a recipe from the library or free text.
Future<void> showMealSheet(
  BuildContext context, {
  required int householdId,
  required DateTime day,
  required MealSlot slot,
  MealPlanEntry? entry,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  useRootNavigator: true,
  backgroundColor: NestColors.of(context).surface,
  builder: (context) => _MealSheet(
    householdId: householdId,
    day: day,
    slot: slot,
    entry: entry,
  ),
);

class _MealSheet extends ConsumerStatefulWidget {
  const _MealSheet({
    required this.householdId,
    required this.day,
    required this.slot,
    this.entry,
  });

  final int householdId;
  final DateTime day;
  final MealSlot slot;
  final MealPlanEntry? entry;

  @override
  ConsumerState<_MealSheet> createState() => _MealSheetState();
}

class _MealSheetState extends ConsumerState<_MealSheet> {
  late final _text = TextEditingController(
    text: widget.entry?.recipeId == null ? widget.entry?.freeText : null,
  );
  late final _note = TextEditingController(text: widget.entry?.prepAheadNote);
  final _search = TextEditingController();
  late DateTime _day = widget.day;
  late int? _recipeId = widget.entry?.recipeId;
  late int? _servings = widget.entry?.servings;

  /// Whether the meal is a recipe (else free text).
  late bool _fromRecipe =
      widget.entry?.recipeId != null ||
      (widget.entry == null && ref.read(recipesAvailableProvider));
  var _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _text.addListener(() => setState(() {}));
    _search.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _text.dispose();
    _note.dispose();
    _search.dispose();
    super.dispose();
  }

  Future<void> _pickDay() async {
    final today = localDay(ref.read(clockProvider)());
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(_day.year, _day.month, _day.day),
      firstDate: DateTime(today.year - 1),
      lastDate: DateTime(today.year + 2),
    );
    if (picked != null) {
      setState(
        () => _day = DateTime.utc(picked.year, picked.month, picked.day),
      );
    }
  }

  /// Saves the meal: [recipe] when the meal is a recipe, else the text.
  Future<void> _save(Recipe? recipe) async {
    final l10n = AppLocalizations.of(context);
    final entry = widget.entry;
    // Servings equal to the recipe's follow the recipe when it changes.
    final servings = recipe != null && _servings != recipe.servings
        ? _servings
        : null;
    final fields = (
      date: _day,
      recipeId: recipe?.id,
      freeText: recipe?.title ?? _text.text.trim(),
      servings: servings,
      prepAheadNote: _note.text.trim(),
    );
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref
          .read(mealPlanRepositoryProvider)
          .save(
            widget.householdId,
            entry == null
                ? MealPlanEntry(
                    householdId: widget.householdId,
                    date: fields.date,
                    slot: widget.slot,
                    recipeId: fields.recipeId,
                    freeText: fields.freeText,
                    servings: fields.servings,
                    prepAheadNote: fields.prepAheadNote,
                  )
                : entry.copyWith(
                    date: fields.date,
                    recipeId: fields.recipeId,
                    freeText: fields.freeText,
                    servings: fields.servings,
                    prepAheadNote: fields.prepAheadNote,
                  ),
          );
      if (mounted) Navigator.pop(context);
    } on Exception catch (e) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = errorMessage(l10n, e);
        });
      }
    }
  }

  Future<void> _remove() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref
          .read(mealPlanRepositoryProvider)
          .remove(widget.householdId, widget.entry!);
      if (mounted) Navigator.pop(context);
    } on Exception catch (e) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = errorMessage(l10n, e);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final recipesOn = ref.watch(recipesAvailableProvider);
    final recipes = recipesOn
        ? ref.watch(recipesProvider(widget.householdId)).value ??
              const <Recipe>[]
        : const <Recipe>[];
    final fromRecipe = recipesOn && _fromRecipe;
    final recipe = recipes.where((r) => r.id == _recipeId).firstOrNull;
    final query = _search.text.trim();
    final matches = filterRecipes(recipes, query: query);
    final canSave =
        !_saving &&
        (fromRecipe ? recipe != null : _text.text.trim().isNotEmpty);

    Widget section(String label) => Padding(
      padding: const EdgeInsets.only(top: NestSpacing.gap, bottom: 8),
      child: Text(label, style: textTheme.labelMedium),
    );

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          NestSpacing.screen,
          0,
          NestSpacing.screen,
          NestSpacing.screen + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${slotLabel(l10n, widget.slot)} · ${fullDayLabel(context, _day)}',
              style: textTheme.titleLarge,
            ),
            if (recipesOn) ...[
              const SizedBox(height: NestSpacing.gap),
              SegmentedButton<bool>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(
                    value: true,
                    icon: const Icon(LucideIcons.cookingPot, size: 18),
                    label: Text(l10n.mealFromRecipe),
                  ),
                  ButtonSegment(
                    value: false,
                    icon: const Icon(LucideIcons.pencil, size: 18),
                    label: Text(l10n.mealFromText),
                  ),
                ],
                selected: {fromRecipe},
                onSelectionChanged: (value) =>
                    setState(() => _fromRecipe = value.single),
              ),
            ],
            const SizedBox(height: NestSpacing.gap),
            if (fromRecipe) ...[
              if (recipes.isEmpty)
                Text(l10n.mealNoRecipes, style: textTheme.bodyMedium)
              else ...[
                if (recipes.length > 5) ...[
                  TextField(
                    controller: _search,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: l10n.recipesSearchHint,
                      prefixIcon: const Icon(LucideIcons.search, size: 20),
                    ),
                  ),
                  const SizedBox(height: NestSpacing.gapSmall),
                ],
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: colors.border),
                    borderRadius: BorderRadius.circular(NestRadii.tile),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      for (final (index, r) in matches.indexed) ...[
                        if (index > 0) const Divider(height: 1),
                        _RecipeOption(
                          recipe: r,
                          selected: r.id == _recipeId,
                          onTap: () => setState(() {
                            _recipeId = r.id;
                            _servings = r.servings;
                          }),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
              if (recipe != null) ...[
                section(l10n.mealServingsLabel),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: ServingsStepper(
                    servings: _servings ?? recipe.servings,
                    onChanged: (value) => setState(() => _servings = value),
                  ),
                ),
              ],
            ] else
              TextField(
                controller: _text,
                autofocus: widget.entry == null && !recipesOn,
                maxLength: 120,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: l10n.mealTextLabel,
                  counterText: '',
                ),
              ),
            section(l10n.mealDayLabel),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: ActionChip(
                avatar: const Icon(LucideIcons.calendar, size: 18),
                label: Text(fullDayLabel(context, _day)),
                onPressed: _pickDay,
              ),
            ),
            section(l10n.mealPrepAheadLabel),
            TextField(
              controller: _note,
              maxLength: 500,
              minLines: 1,
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: l10n.mealPrepAheadHint,
                counterText: '',
              ),
            ),
            if (_error case final error?) ...[
              const SizedBox(height: NestSpacing.gapSmall),
              NestNotice(error, tone: NestNoticeTone.warning),
            ],
            const SizedBox(height: NestSpacing.screen),
            FilledButton(
              onPressed: canSave
                  ? () => _save(fromRecipe ? recipe : null)
                  : null,
              child: Text(l10n.saveButton),
            ),
            if (widget.entry != null) ...[
              const SizedBox(height: 8),
              TextButton.icon(
                icon: const Icon(LucideIcons.trash2, size: 18),
                style: TextButton.styleFrom(foregroundColor: colors.warningInk),
                label: Text(l10n.mealRemove),
                onPressed: _saving ? null : _remove,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RecipeOption extends StatelessWidget {
  const _RecipeOption({
    required this.recipe,
    required this.selected,
    required this.onTap,
  });

  final Recipe recipe;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? colors.accentTint : colors.surface,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      recipe.title,
                      style: textTheme.bodyLarge?.copyWith(
                        color: selected ? colors.accentDark : colors.ink,
                      ),
                    ),
                  ),
                  if (selected)
                    Icon(LucideIcons.check, size: 20, color: colors.accentDark),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
