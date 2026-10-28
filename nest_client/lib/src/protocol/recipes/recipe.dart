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
import '../nest_user.dart' as _ihr4yuyc;
import '../recipes/recipe_ingredient.dart' as _i86ex859;
import '../recipes/recipe_step.dart' as _ifnvjxdn;

/// A recipe in the household's library.
abstract class Recipe
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Recipe._({
    this.id,
    required this.householdId,
    this.household,
    required this.title,
    String? description,
    this.photoPath,
    int? servings,
    this.prepMinutes,
    this.cookMinutes,
    required this.tags,
    bool? isFavorite,
    this.createdById,
    this.createdBy,
    this.ingredients,
    this.steps,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : description = description ?? '',
       servings = servings ?? 4,
       isFavorite = isFavorite ?? false,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Recipe({
    int? id,
    required int householdId,
    _iaj5kvsg.Household? household,
    required String title,
    String? description,
    String? photoPath,
    int? servings,
    int? prepMinutes,
    int? cookMinutes,
    required List<String> tags,
    bool? isFavorite,
    int? createdById,
    _ihr4yuyc.NestUser? createdBy,
    List<_i86ex859.RecipeIngredient>? ingredients,
    List<_ifnvjxdn.RecipeStep>? steps,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _RecipeImpl;

  factory Recipe.fromJson(Map<String, dynamic> jsonSerialization) {
    return Recipe(
      id: jsonSerialization['id'] as int?,
      householdId: jsonSerialization['householdId'] as int,
      household: jsonSerialization['household'] == null
          ? null
          : _ilcqbmdc.Protocol().deserialize<_iaj5kvsg.Household>(
              jsonSerialization['household'],
            ),
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String?,
      photoPath: jsonSerialization['photoPath'] as String?,
      servings: jsonSerialization['servings'] as int?,
      prepMinutes: jsonSerialization['prepMinutes'] as int?,
      cookMinutes: jsonSerialization['cookMinutes'] as int?,
      tags: _ilcqbmdc.Protocol().deserialize<List<String>>(
        jsonSerialization['tags'],
      ),
      isFavorite: jsonSerialization['isFavorite'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['isFavorite']),
      createdById: jsonSerialization['createdById'] as int?,
      createdBy: jsonSerialization['createdBy'] == null
          ? null
          : _ilcqbmdc.Protocol().deserialize<_ihr4yuyc.NestUser>(
              jsonSerialization['createdBy'],
            ),
      ingredients: jsonSerialization['ingredients'] == null
          ? null
          : _ilcqbmdc.Protocol().deserialize<List<_i86ex859.RecipeIngredient>>(
              jsonSerialization['ingredients'],
            ),
      steps: jsonSerialization['steps'] == null
          ? null
          : _ilcqbmdc.Protocol().deserialize<List<_ifnvjxdn.RecipeStep>>(
              jsonSerialization['steps'],
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

  String title;

  String description;

  /// Path of the photo in the server's private file storage (Postgres);
  /// null without a photo. A new photo gets a new path, so the app can
  /// cache photos by path.
  String? photoPath;

  /// Number of servings the ingredient amounts are for.
  int servings;

  int? prepMinutes;

  int? cookMinutes;

  List<String> tags;

  bool isFavorite;

  int? createdById;

  _ihr4yuyc.NestUser? createdBy;

  /// In order of [RecipeIngredient.position]; always included by the
  /// recipe endpoint.
  List<_i86ex859.RecipeIngredient>? ingredients;

  /// In order of [RecipeStep.position]; always included by the recipe
  /// endpoint.
  List<_ifnvjxdn.RecipeStep>? steps;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [Recipe]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Recipe copyWith({
    int? id,
    int? householdId,
    _iaj5kvsg.Household? household,
    String? title,
    String? description,
    String? photoPath,
    int? servings,
    int? prepMinutes,
    int? cookMinutes,
    List<String>? tags,
    bool? isFavorite,
    int? createdById,
    _ihr4yuyc.NestUser? createdBy,
    List<_i86ex859.RecipeIngredient>? ingredients,
    List<_ifnvjxdn.RecipeStep>? steps,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Recipe',
      if (id != null) 'id': id,
      'householdId': householdId,
      if (household != null) 'household': household?.toJson(),
      'title': title,
      'description': description,
      if (photoPath != null) 'photoPath': photoPath,
      'servings': servings,
      if (prepMinutes != null) 'prepMinutes': prepMinutes,
      if (cookMinutes != null) 'cookMinutes': cookMinutes,
      'tags': tags.toJson(),
      'isFavorite': isFavorite,
      if (createdById != null) 'createdById': createdById,
      if (createdBy != null) 'createdBy': createdBy?.toJson(),
      if (ingredients != null)
        'ingredients': ingredients?.toJson(valueToJson: (v) => v.toJson()),
      if (steps != null) 'steps': steps?.toJson(valueToJson: (v) => v.toJson()),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Recipe',
      if (id != null) 'id': id,
      'householdId': householdId,
      if (household != null) 'household': household?.toJsonForProtocol(),
      'title': title,
      'description': description,
      if (photoPath != null) 'photoPath': photoPath,
      'servings': servings,
      if (prepMinutes != null) 'prepMinutes': prepMinutes,
      if (cookMinutes != null) 'cookMinutes': cookMinutes,
      'tags': tags.toJson(),
      'isFavorite': isFavorite,
      if (createdById != null) 'createdById': createdById,
      if (createdBy != null) 'createdBy': createdBy?.toJsonForProtocol(),
      if (ingredients != null)
        'ingredients': ingredients?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
      if (steps != null)
        'steps': steps?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
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

class _RecipeImpl extends Recipe {
  _RecipeImpl({
    int? id,
    required int householdId,
    _iaj5kvsg.Household? household,
    required String title,
    String? description,
    String? photoPath,
    int? servings,
    int? prepMinutes,
    int? cookMinutes,
    required List<String> tags,
    bool? isFavorite,
    int? createdById,
    _ihr4yuyc.NestUser? createdBy,
    List<_i86ex859.RecipeIngredient>? ingredients,
    List<_ifnvjxdn.RecipeStep>? steps,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         householdId: householdId,
         household: household,
         title: title,
         description: description,
         photoPath: photoPath,
         servings: servings,
         prepMinutes: prepMinutes,
         cookMinutes: cookMinutes,
         tags: tags,
         isFavorite: isFavorite,
         createdById: createdById,
         createdBy: createdBy,
         ingredients: ingredients,
         steps: steps,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Recipe]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Recipe copyWith({
    Object? id = _Undefined,
    int? householdId,
    Object? household = _Undefined,
    String? title,
    String? description,
    Object? photoPath = _Undefined,
    int? servings,
    Object? prepMinutes = _Undefined,
    Object? cookMinutes = _Undefined,
    List<String>? tags,
    bool? isFavorite,
    Object? createdById = _Undefined,
    Object? createdBy = _Undefined,
    Object? ingredients = _Undefined,
    Object? steps = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Recipe(
      id: id is int? ? id : this.id,
      householdId: householdId ?? this.householdId,
      household: household is _iaj5kvsg.Household?
          ? household
          : this.household?.copyWith(),
      title: title ?? this.title,
      description: description ?? this.description,
      photoPath: photoPath is String? ? photoPath : this.photoPath,
      servings: servings ?? this.servings,
      prepMinutes: prepMinutes is int? ? prepMinutes : this.prepMinutes,
      cookMinutes: cookMinutes is int? ? cookMinutes : this.cookMinutes,
      tags: tags ?? this.tags.map((e0) => e0).toList(),
      isFavorite: isFavorite ?? this.isFavorite,
      createdById: createdById is int? ? createdById : this.createdById,
      createdBy: createdBy is _ihr4yuyc.NestUser?
          ? createdBy
          : this.createdBy?.copyWith(),
      ingredients: ingredients is List<_i86ex859.RecipeIngredient>?
          ? ingredients
          : this.ingredients?.map((e0) => e0.copyWith()).toList(),
      steps: steps is List<_ifnvjxdn.RecipeStep>?
          ? steps
          : this.steps?.map((e0) => e0.copyWith()).toList(),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
