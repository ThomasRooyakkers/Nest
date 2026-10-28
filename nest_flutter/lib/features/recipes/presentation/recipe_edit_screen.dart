import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../../app/router.dart';
import '../../../core/backend/error_messages.dart';
import '../../../core/household/household_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../data/recipe_repository.dart';
import '../domain/recipe_logic.dart';
import 'recipe_providers.dart';
import 'recipe_screen.dart';
import 'recipe_style.dart';

/// Largest photo the server accepts (`RecipeEndpoint.maxPhotoBytes`).
const _maxPhotoBytes = 1024 * 1024;

/// Creates a recipe, or edits the recipe [recipeId]: photo, title,
/// description, servings, times, tags, ingredients and steps.
class RecipeEditScreen extends ConsumerStatefulWidget {
  const RecipeEditScreen({super.key, this.recipeId});

  final int? recipeId;

  @override
  ConsumerState<RecipeEditScreen> createState() => _RecipeEditScreenState();
}

/// The fields of one ingredient row.
class _IngredientDraft {
  _IngredientDraft(RecipeIngredient? ingredient, String locale)
    : quantity = TextEditingController(
        text: ingredient?.quantity == null
            ? ''
            : formatQuantity(ingredient!.quantity!, locale),
      ),
      unit = TextEditingController(text: ingredient?.unit),
      name = TextEditingController(text: ingredient?.name),
      note = TextEditingController(text: ingredient?.note);

  final key = UniqueKey();
  final TextEditingController quantity;
  final TextEditingController unit;
  final TextEditingController name;
  final TextEditingController note;

  Iterable<TextEditingController> get controllers => [
    quantity,
    unit,
    name,
    note,
  ];

  bool get quantityValid =>
      quantity.text.trim().isEmpty || parseQuantity(quantity.text) != null;

  void dispose() {
    for (final c in controllers) {
      c.dispose();
    }
  }
}

class _StepDraft {
  _StepDraft(String text) : text = TextEditingController(text: text);

  final key = UniqueKey();
  final TextEditingController text;
}

class _RecipeEditScreenState extends ConsumerState<RecipeEditScreen> {
  static const _maxWidth = 640.0;

  final _title = TextEditingController();
  final _description = TextEditingController();
  final _prep = TextEditingController();
  final _cook = TextEditingController();
  final _newTag = TextEditingController();
  var _servings = 4;
  var _tags = <String>[];
  final _ingredients = <_IngredientDraft>[];
  final _steps = <_StepDraft>[];

  /// A newly picked photo, not yet saved.
  Uint8List? _photo;
  var _removePhoto = false;

  Recipe? _original;
  var _initialized = false;
  var _dirty = false;
  var _saving = false;

  int get _householdId => ref.read(activeHouseholdProvider)!.household.id!;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final recipe = widget.recipeId == null
        ? null
        : ref.read(recipeProvider(_householdId, widget.recipeId!));
    _original = recipe;
    _title.text = recipe?.title ?? '';
    _description.text = recipe?.description ?? '';
    _prep.text = recipe?.prepMinutes?.toString() ?? '';
    _cook.text = recipe?.cookMinutes?.toString() ?? '';
    _servings = recipe?.servings ?? 4;
    _tags = [...?recipe?.tags];
    for (final ingredient in recipe?.ingredients ?? const []) {
      _addIngredient(ingredient, locale);
    }
    if (_ingredients.isEmpty) _addIngredient(null, locale);
    for (final step in recipe?.steps ?? const []) {
      _addStep(step.text);
    }
    if (_steps.isEmpty) _addStep('');
    for (final c in [_title, _description, _prep, _cook]) {
      c.addListener(_changed);
    }
    _dirty = false;
  }

  @override
  void dispose() {
    for (final c in [_title, _description, _prep, _cook, _newTag]) {
      c.dispose();
    }
    for (final i in _ingredients) {
      i.dispose();
    }
    for (final s in _steps) {
      s.text.dispose();
    }
    super.dispose();
  }

  /// Rebuilds on every edit, so Save and the amount errors follow along.
  void _changed() => setState(() => _dirty = true);

  void _addIngredient(RecipeIngredient? ingredient, String locale) {
    final draft = _IngredientDraft(ingredient, locale);
    for (final c in draft.controllers) {
      c.addListener(_changed);
    }
    _ingredients.add(draft);
  }

  void _addStep(String text) {
    final draft = _StepDraft(text)..text.addListener(_changed);
    _steps.add(draft);
  }

  void _edit(VoidCallback change) => setState(() {
    change();
    _dirty = true;
  });

  void _addTag() {
    final tag = _newTag.text.trim();
    if (tag.isEmpty) return;
    _edit(() {
      if (!_tags.any((t) => t.toLowerCase() == tag.toLowerCase())) {
        _tags.add(tag);
      }
      _newTag.clear();
    });
  }

  Future<void> _pickPhoto() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final picker = ImagePicker();
    var source = ImageSource.gallery;
    if (picker.supportsImageSource(ImageSource.camera)) {
      final picked = await showModalBottomSheet<ImageSource>(
        context: context,
        showDragHandle: true,
        backgroundColor: NestColors.of(context).surface,
        builder: (context) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(LucideIcons.camera),
                title: Text(l10n.recipePhotoCamera),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(LucideIcons.image),
                title: Text(l10n.recipePhotoGallery),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        ),
      );
      if (picked == null) return;
      source = picked;
    }
    final file = await picker.pickImage(
      source: source,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 80,
    );
    if (file == null) return;
    final bytes = await file.readAsBytes();
    if (bytes.length > _maxPhotoBytes) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.errorInvalidInput)),
      );
      return;
    }
    _edit(() {
      _photo = bytes;
      _removePhoto = false;
    });
  }

  bool get _valid =>
      _title.text.trim().isNotEmpty &&
      _ingredients.every((i) => i.quantityValid);

  Future<void> _save() async {
    if (!_valid || _saving) return;
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final repository = ref.read(recipeRepositoryProvider);
    final householdId = _householdId;
    final original = _original;
    final fields = Recipe(
      id: original?.id,
      householdId: householdId,
      title: _title.text.trim(),
      description: _description.text.trim(),
      servings: _servings,
      prepMinutes: int.tryParse(_prep.text.trim()),
      cookMinutes: int.tryParse(_cook.text.trim()),
      tags: _tags,
      ingredients: [
        for (final (index, i) in _ingredients.indexed)
          if (i.name.text.trim().isNotEmpty)
            RecipeIngredient(
              recipeId: original?.id ?? 0,
              position: index,
              quantity: parseQuantity(i.quantity.text),
              unit: i.unit.text.trim(),
              name: i.name.text.trim(),
              note: i.note.text.trim(),
            ),
      ],
      steps: [
        for (final (index, s) in _steps.indexed)
          if (s.text.text.trim().isNotEmpty)
            RecipeStep(
              recipeId: original?.id ?? 0,
              position: index,
              text: s.text.text.trim(),
            ),
      ],
    );

    setState(() => _saving = true);
    final Recipe saved;
    try {
      saved = await repository.save(householdId, fields);
    } on Exception catch (e) {
      if (mounted) setState(() => _saving = false);
      messenger.showSnackBar(SnackBar(content: Text(errorMessage(l10n, e))));
      return;
    }
    try {
      if (_photo != null) {
        await repository.setPhoto(householdId, saved, _photo);
      } else if (_removePhoto && saved.photoPath != null) {
        await repository.setPhoto(householdId, saved, null);
      }
    } on Exception {
      messenger.showSnackBar(SnackBar(content: Text(l10n.recipePhotoFailed)));
    }
    if (!mounted) return;
    _dirty = false;
    if (original == null) {
      context.go(Routes.recipe(saved.id!));
    } else {
      context.pop();
    }
  }

  Future<bool> _confirmDiscard() async {
    final l10n = AppLocalizations.of(context);
    final discard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l10n.recipeDiscardChanges),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancelButton),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.recipeDiscardButton),
          ),
        ],
      ),
    );
    return discard ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (widget.recipeId != null && _original == null) {
      // Not in the cache (removed meanwhile): saving would create a copy.
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text(l10n.recipeNotFound, style: textTheme.bodyLarge),
        ),
      );
    }
    final width = MediaQuery.sizeOf(context).width;
    final side = width > _maxWidth + 2 * NestSpacing.screen
        ? (width - _maxWidth) / 2
        : NestSpacing.screen;

    Widget section(String label) => Padding(
      padding: const EdgeInsets.only(top: NestSpacing.screen, bottom: 8),
      child: Text(label, style: textTheme.titleMedium),
    );

    // Multi-line fields look odd as pills.
    final boxBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(NestRadii.tile),
      borderSide: BorderSide(color: colors.borderStrong),
    );
    final boxDecoration = InputDecoration(
      border: boxBorder,
      enabledBorder: boxBorder,
      focusedBorder: boxBorder.copyWith(
        borderSide: BorderSide(color: colors.accent, width: 2),
      ),
      counterText: '',
    );

    return PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _confirmDiscard() && context.mounted) {
          setState(() => _dirty = false);
          context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
            icon: const Icon(LucideIcons.x),
            onPressed: () => Navigator.maybePop(context),
          ),
          title: Text(_original == null ? l10n.recipeNew : l10n.recipeEdit),
          actions: [
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 12),
              child: FilledButton(
                onPressed: _valid && !_saving ? _save : null,
                child: Text(l10n.saveButton),
              ),
            ),
          ],
        ),
        body: ListView(
          padding: EdgeInsets.fromLTRB(
            side,
            8,
            side,
            NestSpacing.screen + MediaQuery.paddingOf(context).bottom,
          ),
          children: [
            _PhotoField(
              householdId: _householdId,
              original: _removePhoto ? null : _original,
              photo: _photo,
              onPick: _pickPhoto,
              onRemove: () => _edit(() {
                _photo = null;
                _removePhoto = true;
              }),
            ),
            const SizedBox(height: NestSpacing.gap),
            TextField(
              controller: _title,
              autofocus: _original == null,
              maxLength: 120,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.recipeTitleLabel,
                counterText: '',
              ),
            ),
            const SizedBox(height: NestSpacing.gapSmall),
            TextField(
              controller: _description,
              maxLength: 2000,
              minLines: 2,
              maxLines: 6,
              textCapitalization: TextCapitalization.sentences,
              decoration: boxDecoration.copyWith(
                labelText: l10n.recipeDescriptionLabel,
              ),
            ),
            section(l10n.recipeServingsLabel),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: ServingsStepper(
                servings: _servings,
                onChanged: (value) => _edit(() => _servings = value),
              ),
            ),
            const SizedBox(height: NestSpacing.gap),
            Row(
              children: [
                Expanded(
                  child: _MinutesField(
                    controller: _prep,
                    label: l10n.recipePrepMinutesLabel,
                  ),
                ),
                const SizedBox(width: NestSpacing.gapSmall),
                Expanded(
                  child: _MinutesField(
                    controller: _cook,
                    label: l10n.recipeCookMinutesLabel,
                  ),
                ),
              ],
            ),
            section(l10n.recipeTagsLabel),
            if (_tags.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final tag in _tags)
                    InputChip(
                      label: Text(tag),
                      deleteIcon: const Icon(LucideIcons.x, size: 16),
                      deleteButtonTooltipMessage: l10n.recipeRemoveTag(tag),
                      onDeleted: () => _edit(() => _tags.remove(tag)),
                    ),
                ],
              ),
              const SizedBox(height: NestSpacing.gapSmall),
            ],
            TextField(
              controller: _newTag,
              maxLength: 30,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _addTag(),
              decoration: InputDecoration(
                hintText: l10n.recipeTagHint,
                counterText: '',
                suffixIcon: IconButton(
                  tooltip: l10n.recipeAddTag,
                  icon: const Icon(LucideIcons.plus),
                  onPressed: _addTag,
                ),
              ),
            ),
            section(l10n.recipeIngredients),
            for (final (index, draft) in _ingredients.indexed)
              _IngredientFields(
                key: draft.key,
                draft: draft,
                decoration: boxDecoration,
                onRemove: _ingredients.length == 1 && index == 0
                    ? null
                    : () => _edit(() => _ingredients.removeAt(index).dispose()),
              ),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton.icon(
                icon: const Icon(LucideIcons.plus, size: 18),
                label: Text(l10n.recipeAddIngredient),
                onPressed: () => _edit(() => _addIngredient(null, locale)),
              ),
            ),
            section(l10n.recipeSteps),
            for (final (index, draft) in _steps.indexed)
              Padding(
                key: draft.key,
                padding: const EdgeInsets.only(bottom: NestSpacing.gapSmall),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      margin: const EdgeInsets.only(top: 14),
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
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: draft.text,
                        maxLength: 2000,
                        minLines: 2,
                        maxLines: 8,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: boxDecoration.copyWith(
                          labelText: l10n.recipeStepNumber(index + 1),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        IconButton(
                          tooltip: l10n.recipeMoveStepUp,
                          icon: const Icon(LucideIcons.arrowUp, size: 18),
                          onPressed: index == 0
                              ? null
                              : () => _edit(
                                  () => _steps.insert(
                                    index - 1,
                                    _steps.removeAt(index),
                                  ),
                                ),
                        ),
                        IconButton(
                          tooltip: l10n.recipeRemoveStep,
                          icon: const Icon(LucideIcons.trash2, size: 18),
                          onPressed: _steps.length == 1
                              ? null
                              : () => _edit(
                                  () => _steps.removeAt(index).text.dispose(),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton.icon(
                icon: const Icon(LucideIcons.plus, size: 18),
                label: Text(l10n.recipeAddStep),
                onPressed: () => _edit(() => _addStep('')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Photo preview with Add / Change / Remove.
class _PhotoField extends StatelessWidget {
  const _PhotoField({
    required this.householdId,
    required this.original,
    required this.photo,
    required this.onPick,
    required this.onRemove,
  });

  final int householdId;

  /// The saved recipe, when its photo is still kept.
  final Recipe? original;
  final Uint8List? photo;
  final VoidCallback onPick;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final original = this.original;
    final photo = this.photo;
    final hasPhoto = photo != null || original?.photoPath != null;

    if (!hasPhoto) {
      return OutlinedButton.icon(
        icon: const Icon(LucideIcons.imagePlus),
        label: Text(l10n.recipePhotoAdd),
        onPressed: onPick,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(NestRadii.cardLarge),
          child: AspectRatio(
            aspectRatio: 4 / 3,
            child: photo != null
                ? Image.memory(photo, fit: BoxFit.cover)
                : RecipePhoto(householdId: householdId, recipe: original!),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            TextButton.icon(
              icon: const Icon(LucideIcons.image, size: 18),
              label: Text(l10n.recipePhotoChange),
              onPressed: onPick,
            ),
            TextButton.icon(
              icon: const Icon(LucideIcons.trash2, size: 18),
              style: TextButton.styleFrom(foregroundColor: colors.warningInk),
              label: Text(l10n.recipePhotoRemove),
              onPressed: onRemove,
            ),
          ],
        ),
      ],
    );
  }
}

class _MinutesField extends StatelessWidget {
  const _MinutesField({required this.controller, required this.label});

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(5),
    ],
    decoration: InputDecoration(labelText: label),
  );
}

/// Amount, unit, name and note of one ingredient, in a light card.
class _IngredientFields extends StatelessWidget {
  const _IngredientFields({
    super.key,
    required this.draft,
    required this.decoration,
    required this.onRemove,
  });

  final _IngredientDraft draft;
  final InputDecoration decoration;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final compact = decoration.copyWith(isDense: true);
    return Container(
      margin: const EdgeInsets.only(bottom: NestSpacing.gapSmall),
      padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(NestRadii.tile),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                TextField(
                  controller: draft.name,
                  maxLength: 80,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: compact.copyWith(
                    labelText: l10n.recipeIngredientLabel,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: draft.quantity,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: compact.copyWith(
                          labelText: l10n.recipeQuantityLabel,
                          errorText: draft.quantityValid
                              ? null
                              : l10n.recipeQuantityInvalid,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: draft.unit,
                        maxLength: 20,
                        decoration: compact.copyWith(
                          labelText: l10n.recipeUnitLabel,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: draft.note,
                  maxLength: 120,
                  decoration: compact.copyWith(labelText: l10n.recipeNoteLabel),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: l10n.recipeRemoveIngredient,
            icon: const Icon(LucideIcons.trash2, size: 18),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}
