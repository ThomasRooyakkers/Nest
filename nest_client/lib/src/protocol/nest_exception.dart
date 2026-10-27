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
import 'nest_error_code.dart' as _i11cf01m;

/// Error returned to the app. The app shows a localized text per [code].
abstract class NestException
    implements
        _isc.SerializableException,
        _isc.SerializableModel,
        _isc.ProtocolSerialization {
  NestException._({required this.code});

  factory NestException({required _i11cf01m.NestErrorCode code}) =
      _NestExceptionImpl;

  factory NestException.fromJson(Map<String, dynamic> jsonSerialization) {
    return NestException(
      code: _i11cf01m.NestErrorCode.fromJson(
        (jsonSerialization['code'] as String),
      ),
    );
  }

  _i11cf01m.NestErrorCode code;

  /// Returns a shallow copy of this [NestException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  NestException copyWith({_i11cf01m.NestErrorCode? code});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NestException',
      'code': code.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NestException',
      'code': code.toJson(),
    };
  }

  @override
  String toString() {
    return 'NestException(code: $code)';
  }
}

class _NestExceptionImpl extends NestException {
  _NestExceptionImpl({required _i11cf01m.NestErrorCode code})
    : super._(code: code);

  /// Returns a shallow copy of this [NestException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  NestException copyWith({_i11cf01m.NestErrorCode? code}) {
    return NestException(code: code ?? this.code);
  }
}
