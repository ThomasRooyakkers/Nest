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

/// Outcome of a test the admin started (test email, film data).
abstract class AdminCheckResult
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AdminCheckResult._({
    required this.ok,
    this.detail,
  });

  factory AdminCheckResult({
    required bool ok,
    String? detail,
  }) = _AdminCheckResultImpl;

  factory AdminCheckResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminCheckResult(
      ok: _is.BoolJsonExtension.fromJson(jsonSerialization['ok']),
      detail: jsonSerialization['detail'] as String?,
    );
  }

  bool ok;

  /// Short technical detail on failure, e.g. the provider's status code.
  String? detail;

  /// Returns a shallow copy of this [AdminCheckResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AdminCheckResult copyWith({
    bool? ok,
    String? detail,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminCheckResult',
      'ok': ok,
      if (detail != null) 'detail': detail,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminCheckResult',
      'ok': ok,
      if (detail != null) 'detail': detail,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminCheckResultImpl extends AdminCheckResult {
  _AdminCheckResultImpl({
    required bool ok,
    String? detail,
  }) : super._(
         ok: ok,
         detail: detail,
       );

  /// Returns a shallow copy of this [AdminCheckResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AdminCheckResult copyWith({
    bool? ok,
    Object? detail = _Undefined,
  }) {
    return AdminCheckResult(
      ok: ok ?? this.ok,
      detail: detail is String? ? detail : this.detail,
    );
  }
}
