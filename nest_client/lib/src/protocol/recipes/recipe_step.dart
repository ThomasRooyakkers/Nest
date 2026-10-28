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

/// A numbered step of a recipe. Only reachable through its recipe.
abstract class RecipeStep
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  RecipeStep._({
    this.id,
    required this.recipeId,
    this.recipe,
    required this.position,
    required this.text,
  });

  factory RecipeStep({
    int? id,
    required int recipeId,
    _ieuwfnog.Recipe? recipe,
    required int position,
    required String text,
  }) = _RecipeStepImpl;

  factory RecipeStep.fromJson(Map<String, dynamic> jsonSerialization) {
    return RecipeStep(
      id: jsonSerialization['id'] as int?,
      recipeId: jsonSerialization['recipeId'] as int,
      recipe: jsonSerialization['recipe'] == null
          ? null
          : _ilcqbmdc.Protocol().deserialize<_ieuwfnog.Recipe>(
              jsonSerialization['recipe'],
            ),
      position: jsonSerialization['position'] as int,
      text: jsonSerialization['text'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int recipeId;

  _ieuwfnog.Recipe? recipe;

  int position;

  String text;

  /// Returns a shallow copy of this [RecipeStep]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  RecipeStep copyWith({
    int? id,
    int? recipeId,
    _ieuwfnog.Recipe? recipe,
    int? position,
    String? text,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RecipeStep',
      if (id != null) 'id': id,
      'recipeId': recipeId,
      if (recipe != null) 'recipe': recipe?.toJson(),
      'position': position,
      'text': text,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RecipeStep',
      if (id != null) 'id': id,
      'recipeId': recipeId,
      if (recipe != null) 'recipe': recipe?.toJsonForProtocol(),
      'position': position,
      'text': text,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RecipeStepImpl extends RecipeStep {
  _RecipeStepImpl({
    int? id,
    required int recipeId,
    _ieuwfnog.Recipe? recipe,
    required int position,
    required String text,
  }) : super._(
         id: id,
         recipeId: recipeId,
         recipe: recipe,
         position: position,
         text: text,
       );

  /// Returns a shallow copy of this [RecipeStep]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  RecipeStep copyWith({
    Object? id = _Undefined,
    int? recipeId,
    Object? recipe = _Undefined,
    int? position,
    String? text,
  }) {
    return RecipeStep(
      id: id is int? ? id : this.id,
      recipeId: recipeId ?? this.recipeId,
      recipe: recipe is _ieuwfnog.Recipe? ? recipe : this.recipe?.copyWith(),
      position: position ?? this.position,
      text: text ?? this.text,
    );
  }
}
