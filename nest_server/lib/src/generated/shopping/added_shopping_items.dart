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
import '../shopping/shopping_item.dart' as _ify8i7oo;

/// The answer of adding several items at once (e.g. a recipe's
/// ingredients).
abstract class AddedShoppingItems
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AddedShoppingItems._({
    required this.items,
    required this.skippedNames,
  });

  factory AddedShoppingItems({
    required List<_ify8i7oo.ShoppingItem> items,
    required List<String> skippedNames,
  }) = _AddedShoppingItemsImpl;

  factory AddedShoppingItems.fromJson(Map<String, dynamic> jsonSerialization) {
    return AddedShoppingItems(
      items: _imc1swab.Protocol().deserialize<List<_ify8i7oo.ShoppingItem>>(
        jsonSerialization['items'],
      ),
      skippedNames: _imc1swab.Protocol().deserialize<List<String>>(
        jsonSerialization['skippedNames'],
      ),
    );
  }

  /// Items added to To buy (new, or moved back from Recently used).
  List<_ify8i7oo.ShoppingItem> items;

  /// Names that were skipped because they were already to buy.
  List<String> skippedNames;

  /// Returns a shallow copy of this [AddedShoppingItems]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AddedShoppingItems copyWith({
    List<_ify8i7oo.ShoppingItem>? items,
    List<String>? skippedNames,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AddedShoppingItems',
      'items': items.toJson(valueToJson: (v) => v.toJson()),
      'skippedNames': skippedNames.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AddedShoppingItems',
      'items': items.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'skippedNames': skippedNames.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _AddedShoppingItemsImpl extends AddedShoppingItems {
  _AddedShoppingItemsImpl({
    required List<_ify8i7oo.ShoppingItem> items,
    required List<String> skippedNames,
  }) : super._(
         items: items,
         skippedNames: skippedNames,
       );

  /// Returns a shallow copy of this [AddedShoppingItems]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AddedShoppingItems copyWith({
    List<_ify8i7oo.ShoppingItem>? items,
    List<String>? skippedNames,
  }) {
    return AddedShoppingItems(
      items: items ?? this.items.map((e0) => e0.copyWith()).toList(),
      skippedNames: skippedNames ?? this.skippedNames.map((e0) => e0).toList(),
    );
  }
}
