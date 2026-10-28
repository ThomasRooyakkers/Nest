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
import 'package:serverpod/serverpod.dart' as _is;

/// How new accounts can be created on a Nest server.
enum SignUpMode implements _is.SerializableModel {
  /// Only with a valid household invite code (and the super-admin email).
  inviteOnly,

  /// Anyone who can reach the server.
  open;

  static SignUpMode fromJson(String name) {
    switch (name) {
      case 'inviteOnly':
        return SignUpMode.inviteOnly;
      case 'open':
        return SignUpMode.open;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "SignUpMode"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
