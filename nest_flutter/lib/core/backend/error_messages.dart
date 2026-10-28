import 'package:nest_client/nest_client.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../l10n/app_localizations.dart';

/// Localized, user-facing text for an error thrown by the backend.
String errorMessage(AppLocalizations l10n, Object error) {
  return switch (error) {
    NestException(:final code) => switch (code) {
      NestErrorCode.notSignedIn => l10n.errorNotSignedIn,
      NestErrorCode.userDisabled => l10n.errorUserDisabled,
      NestErrorCode.notAMember => l10n.errorNotAMember,
      NestErrorCode.notAnOwner => l10n.errorNotAnOwner,
      NestErrorCode.householdSuspended => l10n.errorHouseholdSuspended,
      NestErrorCode.notAdmin => l10n.errorNotAdmin,
      NestErrorCode.invalidInput => l10n.errorInvalidInput,
      NestErrorCode.invalidInviteCode => l10n.errorInvalidInviteCode,
      NestErrorCode.inviteExpired => l10n.errorInviteExpired,
      NestErrorCode.alreadyMember => l10n.errorAlreadyMember,
      NestErrorCode.lastOwner => l10n.errorLastOwner,
      NestErrorCode.notFound => l10n.errorNotFound,
      NestErrorCode.featureDisabled => l10n.errorFeatureDisabled,
    },
    EmailAccountLoginException(:final reason) => switch (reason) {
      EmailAccountLoginExceptionReason.invalidCredentials =>
        l10n.authErrorInvalidCredentials,
      EmailAccountLoginExceptionReason.tooManyAttempts =>
        l10n.authErrorTooManyAttempts,
      EmailAccountLoginExceptionReason.unknown => l10n.errorUnknown,
    },
    EmailAccountRequestException(:final reason) => switch (reason) {
      EmailAccountRequestExceptionReason.tooManyAttempts =>
        l10n.authErrorTooManyAttempts,
      EmailAccountRequestExceptionReason.expired => l10n.authErrorCodeExpired,
      EmailAccountRequestExceptionReason.invalid => l10n.authErrorCodeInvalid,
      EmailAccountRequestExceptionReason.policyViolation =>
        l10n.passwordRequirement,
      EmailAccountRequestExceptionReason.unknown => l10n.errorUnknown,
    },
    EmailAccountPasswordResetException(:final reason) => switch (reason) {
      EmailAccountPasswordResetExceptionReason.tooManyAttempts =>
        l10n.authErrorTooManyAttempts,
      EmailAccountPasswordResetExceptionReason.expired =>
        l10n.authErrorCodeExpired,
      EmailAccountPasswordResetExceptionReason.invalid =>
        l10n.authErrorCodeInvalid,
      EmailAccountPasswordResetExceptionReason.policyViolation =>
        l10n.passwordRequirement,
      EmailAccountPasswordResetExceptionReason.unknown => l10n.errorUnknown,
    },
    InvalidEmailException() => l10n.authErrorInvalidEmail,
    ServerpodClientNetworkException() => l10n.errorNetwork,
    _ => l10n.errorUnknown,
  };
}
