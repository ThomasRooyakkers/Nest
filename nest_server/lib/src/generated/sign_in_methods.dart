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

/// How the signed-in user can sign in: their own account's methods only.
abstract class SignInMethods
    implements _is.SerializableModel, _is.ProtocolSerialization {
  SignInMethods._({
    required this.email,
    required this.google,
    required this.apple,
  });

  factory SignInMethods({
    required bool email,
    required bool google,
    required bool apple,
  }) = _SignInMethodsImpl;

  factory SignInMethods.fromJson(Map<String, dynamic> jsonSerialization) {
    return SignInMethods(
      email: _is.BoolJsonExtension.fromJson(jsonSerialization['email']),
      google: _is.BoolJsonExtension.fromJson(jsonSerialization['google']),
      apple: _is.BoolJsonExtension.fromJson(jsonSerialization['apple']),
    );
  }

  /// Email and password.
  bool email;

  /// A linked Google account.
  bool google;

  /// A linked Apple ID.
  bool apple;

  /// Returns a shallow copy of this [SignInMethods]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SignInMethods copyWith({
    bool? email,
    bool? google,
    bool? apple,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SignInMethods',
      'email': email,
      'google': google,
      'apple': apple,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SignInMethods',
      'email': email,
      'google': google,
      'apple': apple,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _SignInMethodsImpl extends SignInMethods {
  _SignInMethodsImpl({
    required bool email,
    required bool google,
    required bool apple,
  }) : super._(
         email: email,
         google: google,
         apple: apple,
       );

  /// Returns a shallow copy of this [SignInMethods]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SignInMethods copyWith({
    bool? email,
    bool? google,
    bool? apple,
  }) {
    return SignInMethods(
      email: email ?? this.email,
      google: google ?? this.google,
      apple: apple ?? this.apple,
    );
  }
}
