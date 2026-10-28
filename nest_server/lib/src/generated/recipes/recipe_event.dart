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
import 'package:nest_server/src/generated/protocol.dart' as _imc1swab;
import 'package:serverpod/serverpod.dart' as _is;
import '../recipes/recipe.dart' as _ieuwfnog;

/// A change in a household's recipes, sent to everyone watching.
abstract class RecipeEvent
    implements _is.SerializableModel, _is.ProtocolSerialization {
  RecipeEvent._({
    required this.householdId,
    this.recipes,
    this.removedRecipeIds,
  });

  factory RecipeEvent({
    required int householdId,
    List<_ieuwfnog.Recipe>? recipes,
    List<int>? removedRecipeIds,
  }) = _RecipeEventImpl;

  factory RecipeEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return RecipeEvent(
      householdId: jsonSerialization['householdId'] as int,
      recipes: jsonSerialization['recipes'] == null
          ? null
          : _imc1swab.Protocol().deserialize<List<_ieuwfnog.Recipe>>(
              jsonSerialization['recipes'],
            ),
      removedRecipeIds: jsonSerialization['removedRecipeIds'] == null
          ? null
          : _imc1swab.Protocol().deserialize<List<int>>(
              jsonSerialization['removedRecipeIds'],
            ),
    );
  }

  int householdId;

  List<_ieuwfnog.Recipe>? recipes;

  List<int>? removedRecipeIds;

  /// Returns a shallow copy of this [RecipeEvent]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  RecipeEvent copyWith({
    int? householdId,
    List<_ieuwfnog.Recipe>? recipes,
    List<int>? removedRecipeIds,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RecipeEvent',
      'householdId': householdId,
      if (recipes != null)
        'recipes': recipes?.toJson(valueToJson: (v) => v.toJson()),
      if (removedRecipeIds != null)
        'removedRecipeIds': removedRecipeIds?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RecipeEvent',
      'householdId': householdId,
      if (recipes != null)
        'recipes': recipes?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (removedRecipeIds != null)
        'removedRecipeIds': removedRecipeIds?.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RecipeEventImpl extends RecipeEvent {
  _RecipeEventImpl({
    required int householdId,
    List<_ieuwfnog.Recipe>? recipes,
    List<int>? removedRecipeIds,
  }) : super._(
         householdId: householdId,
         recipes: recipes,
         removedRecipeIds: removedRecipeIds,
       );

  /// Returns a shallow copy of this [RecipeEvent]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  RecipeEvent copyWith({
    int? householdId,
    Object? recipes = _Undefined,
    Object? removedRecipeIds = _Undefined,
  }) {
    return RecipeEvent(
      householdId: householdId ?? this.householdId,
      recipes: recipes is List<_ieuwfnog.Recipe>?
          ? recipes
          : this.recipes?.map((e0) => e0.copyWith()).toList(),
      removedRecipeIds: removedRecipeIds is List<int>?
          ? removedRecipeIds
          : this.removedRecipeIds?.map((e0) => e0).toList(),
    );
  }
}
