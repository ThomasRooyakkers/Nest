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
import 'package:serverpod_client/serverpod_client.dart' as _isc;

/// Colour of a store chip, mapped to the design tokens in the app.
enum StoreColor implements _isc.SerializableModel {
  sage,
  honey,
  apricot,
  lavender,
  rose,
  neutral;

  static StoreColor fromJson(String name) {
    switch (name) {
      case 'sage':
        return StoreColor.sage;
      case 'honey':
        return StoreColor.honey;
      case 'apricot':
        return StoreColor.apricot;
      case 'lavender':
        return StoreColor.lavender;
      case 'rose':
        return StoreColor.rose;
      case 'neutral':
        return StoreColor.neutral;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "StoreColor"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
