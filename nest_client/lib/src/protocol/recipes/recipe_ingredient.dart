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
import '../recipes/recipe.dart' as _ieuwfnog;

/// An ingredient of a recipe. Only reachable through its recipe, after the
/// guard checked the recipe's household.
abstract class RecipeIngredient
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  RecipeIngredient._({
    this.id,
    required this.recipeId,
    this.recipe,
    required this.position,
    this.quantity,
    String? unit,
    required this.name,
    String? note,
  }) : unit = unit ?? '',
       note = note ?? '';

  factory RecipeIngredient({
    int? id,
    required int recipeId,
    _ieuwfnog.Recipe? recipe,
    required int position,
    double? quantity,
    String? unit,
    required String name,
    String? note,
  }) = _RecipeIngredientImpl;

  factory RecipeIngredient.fromJson(Map<String, dynamic> jsonSerialization) {
    return RecipeIngredient(
      id: jsonSerialization['id'] as int?,
      recipeId: jsonSerialization['recipeId'] as int,
      recipe: jsonSerialization['recipe'] == null
          ? null
          : _ilcqbmdc.Protocol().deserialize<_ieuwfnog.Recipe>(
              jsonSerialization['recipe'],
            ),
      position: jsonSerialization['position'] as int,
      quantity: (jsonSerialization['quantity'] as num?)?.toDouble(),
      unit: jsonSerialization['unit'] as String?,
      name: jsonSerialization['name'] as String,
      note: jsonSerialization['note'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int recipeId;

  _ieuwfnog.Recipe? recipe;

  int position;

  /// Amount for the recipe's servings; null for "to taste" and the like.
  double? quantity;

  /// Free text such as "g", "tbsp" or "cloves"; may be empty.
  String unit;

  String name;

  /// Free text such as "finely chopped".
  String note;

  /// Returns a shallow copy of this [RecipeIngredient]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  RecipeIngredient copyWith({
    int? id,
    int? recipeId,
    _ieuwfnog.Recipe? recipe,
    int? position,
    double? quantity,
    String? unit,
    String? name,
    String? note,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RecipeIngredient',
      if (id != null) 'id': id,
      'recipeId': recipeId,
      if (recipe != null) 'recipe': recipe?.toJson(),
      'position': position,
      if (quantity != null) 'quantity': quantity,
      'unit': unit,
      'name': name,
      'note': note,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RecipeIngredient',
      if (id != null) 'id': id,
      'recipeId': recipeId,
      if (recipe != null) 'recipe': recipe?.toJsonForProtocol(),
      'position': position,
      if (quantity != null) 'quantity': quantity,
      'unit': unit,
      'name': name,
      'note': note,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RecipeIngredientImpl extends RecipeIngredient {
  _RecipeIngredientImpl({
    int? id,
    required int recipeId,
    _ieuwfnog.Recipe? recipe,
    required int position,
    double? quantity,
    String? unit,
    required String name,
    String? note,
  }) : super._(
         id: id,
         recipeId: recipeId,
         recipe: recipe,
         position: position,
         quantity: quantity,
         unit: unit,
         name: name,
         note: note,
       );

  /// Returns a shallow copy of this [RecipeIngredient]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  RecipeIngredient copyWith({
    Object? id = _Undefined,
    int? recipeId,
    Object? recipe = _Undefined,
    int? position,
    Object? quantity = _Undefined,
    String? unit,
    String? name,
    String? note,
  }) {
    return RecipeIngredient(
      id: id is int? ? id : this.id,
      recipeId: recipeId ?? this.recipeId,
      recipe: recipe is _ieuwfnog.Recipe? ? recipe : this.recipe?.copyWith(),
      position: position ?? this.position,
      quantity: quantity is double? ? quantity : this.quantity,
      unit: unit ?? this.unit,
      name: name ?? this.name,
      note: note ?? this.note,
    );
  }
}
