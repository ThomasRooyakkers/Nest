/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:nest_client/src/protocol/protocol.dart' as _ilcqbmdc;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../household.dart' as _iaj5kvsg;
import '../meals/meal_slot.dart' as _izm7s29y;
import '../nest_user.dart' as _ihr4yuyc;
import '../recipes/recipe.dart' as _ieuwfnog;

/// A planned meal: a recipe from the library or free text, for one meal
/// of one day. There is at most one entry per day and meal.
abstract class MealPlanEntry
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  MealPlanEntry._({
    this.id,
    required this.householdId,
    this.household,
    required this.date,
    _izm7s29y.MealSlot? slot,
    this.recipeId,
    this.recipe,
    String? freeText,
    this.servings,
    String? prepAheadNote,
    this.createdById,
    this.createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : slot = slot ?? _izm7s29y.MealSlot.dinner,
       freeText = freeText ?? '',
       prepAheadNote = prepAheadNote ?? '',
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory MealPlanEntry({
    int? id,
    required int householdId,
    _iaj5kvsg.Household? household,
    required DateTime date,
    _izm7s29y.MealSlot? slot,
    int? recipeId,
    _ieuwfnog.Recipe? recipe,
    String? freeText,
    int? servings,
    String? prepAheadNote,
    int? createdById,
    _ihr4yuyc.NestUser? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _MealPlanEntryImpl;

  factory MealPlanEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return MealPlanEntry(
      id: jsonSerialization['id'] as int?,
      householdId: jsonSerialization['householdId'] as int,
      household: jsonSerialization['household'] == null
          ? null
          : _ilcqbmdc.Protocol().deserialize<_iaj5kvsg.Household>(
              jsonSerialization['household'],
            ),
      date: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      slot: jsonSerialization['slot'] == null
          ? null
          : _izm7s29y.MealSlot.fromJson((jsonSerialization['slot'] as String)),
      recipeId: jsonSerialization['recipeId'] as int?,
      recipe: jsonSerialization['recipe'] == null
          ? null
          : _ilcqbmdc.Protocol().deserialize<_ieuwfnog.Recipe>(
              jsonSerialization['recipe'],
            ),
      freeText: jsonSerialization['freeText'] as String?,
      servings: jsonSerialization['servings'] as int?,
      prepAheadNote: jsonSerialization['prepAheadNote'] as String?,
      createdById: jsonSerialization['createdById'] as int?,
      createdBy: jsonSerialization['createdBy'] == null
          ? null
          : _ilcqbmdc.Protocol().deserialize<_ihr4yuyc.NestUser>(
              jsonSerialization['createdBy'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int householdId;

  _iaj5kvsg.Household? household;

  /// Calendar day, as 00:00 UTC of that day (no time zone): the day is
  /// the same for everyone in the household.
  DateTime date;

  _izm7s29y.MealSlot slot;

  int? recipeId;

  /// The recipe to cook; null for a free-text meal.
  _ieuwfnog.Recipe? recipe;

  /// What to eat, e.g. "Pizza night". With a recipe, the server puts the
  /// recipe's title here, so the meal keeps its name when the recipe is
  /// deleted.
  String freeText;

  /// Servings to cook; null for the recipe's own servings.
  int? servings;

  /// Something to do in advance, e.g. "Take the chicken out of the freezer".
  String prepAheadNote;

  int? createdById;

  _ihr4yuyc.NestUser? createdBy;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [MealPlanEntry]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  MealPlanEntry copyWith({
    int? id,
    int? householdId,
    _iaj5kvsg.Household? household,
    DateTime? date,
    _izm7s29y.MealSlot? slot,
    int? recipeId,
    _ieuwfnog.Recipe? recipe,
    String? freeText,
    int? servings,
    String? prepAheadNote,
    int? createdById,
    _ihr4yuyc.NestUser? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MealPlanEntry',
      if (id != null) 'id': id,
      'householdId': householdId,
      if (household != null) 'household': household?.toJson(),
      'date': date.toJson(),
      'slot': slot.toJson(),
      if (recipeId != null) 'recipeId': recipeId,
      if (recipe != null) 'recipe': recipe?.toJson(),
      'freeText': freeText,
      if (servings != null) 'servings': servings,
      'prepAheadNote': prepAheadNote,
      if (createdById != null) 'createdById': createdById,
      if (createdBy != null) 'createdBy': createdBy?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MealPlanEntry',
      if (id != null) 'id': id,
      'householdId': householdId,
      if (household != null) 'household': household?.toJsonForProtocol(),
      'date': date.toJson(),
      'slot': slot.toJson(),
      if (recipeId != null) 'recipeId': recipeId,
      if (recipe != null) 'recipe': recipe?.toJsonForProtocol(),
      'freeText': freeText,
      if (servings != null) 'servings': servings,
      'prepAheadNote': prepAheadNote,
      if (createdById != null) 'createdById': createdById,
      if (createdBy != null) 'createdBy': createdBy?.toJsonForProtocol(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MealPlanEntryImpl extends MealPlanEntry {
  _MealPlanEntryImpl({
    int? id,
    required int householdId,
    _iaj5kvsg.Household? household,
    required DateTime date,
    _izm7s29y.MealSlot? slot,
    int? recipeId,
    _ieuwfnog.Recipe? recipe,
    String? freeText,
    int? servings,
    String? prepAheadNote,
    int? createdById,
    _ihr4yuyc.NestUser? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         householdId: householdId,
         household: household,
         date: date,
         slot: slot,
         recipeId: recipeId,
         recipe: recipe,
         freeText: freeText,
         servings: servings,
         prepAheadNote: prepAheadNote,
         createdById: createdById,
         createdBy: createdBy,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [MealPlanEntry]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  MealPlanEntry copyWith({
    Object? id = _Undefined,
    int? householdId,
    Object? household = _Undefined,
    DateTime? date,
    _izm7s29y.MealSlot? slot,
    Object? recipeId = _Undefined,
    Object? recipe = _Undefined,
    String? freeText,
    Object? servings = _Undefined,
    String? prepAheadNote,
    Object? createdById = _Undefined,
    Object? createdBy = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MealPlanEntry(
      id: id is int? ? id : this.id,
      householdId: householdId ?? this.householdId,
      household: household is _iaj5kvsg.Household?
          ? household
          : this.household?.copyWith(),
      date: date ?? this.date,
      slot: slot ?? this.slot,
      recipeId: recipeId is int? ? recipeId : this.recipeId,
      recipe: recipe is _ieuwfnog.Recipe? ? recipe : this.recipe?.copyWith(),
      freeText: freeText ?? this.freeText,
      servings: servings is int? ? servings : this.servings,
      prepAheadNote: prepAheadNote ?? this.prepAheadNote,
      createdById: createdById is int? ? createdById : this.createdById,
      createdBy: createdBy is _ihr4yuyc.NestUser?
          ? createdBy
          : this.createdBy?.copyWith(),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
