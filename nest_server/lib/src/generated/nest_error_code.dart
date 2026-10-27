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

enum NestErrorCode implements _is.SerializableModel {
  notSignedIn,
  userDisabled,
  notAMember,
  notAnOwner,
  householdSuspended,
  notAdmin,
  invalidInput,
  invalidInviteCode,
  inviteExpired,
  alreadyMember,
  lastOwner,
  notFound;

  static NestErrorCode fromJson(String name) {
    switch (name) {
      case 'notSignedIn':
        return NestErrorCode.notSignedIn;
      case 'userDisabled':
        return NestErrorCode.userDisabled;
      case 'notAMember':
        return NestErrorCode.notAMember;
      case 'notAnOwner':
        return NestErrorCode.notAnOwner;
      case 'householdSuspended':
        return NestErrorCode.householdSuspended;
      case 'notAdmin':
        return NestErrorCode.notAdmin;
      case 'invalidInput':
        return NestErrorCode.invalidInput;
      case 'invalidInviteCode':
        return NestErrorCode.invalidInviteCode;
      case 'inviteExpired':
        return NestErrorCode.inviteExpired;
      case 'alreadyMember':
        return NestErrorCode.alreadyMember;
      case 'lastOwner':
        return NestErrorCode.lastOwner;
      case 'notFound':
        return NestErrorCode.notFound;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "NestErrorCode"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
