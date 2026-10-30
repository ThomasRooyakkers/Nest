import 'package:nest_client/nest_client.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';

import '../l10n/admin_localizations.dart';

/// Localized text for an error thrown by the server.
String errorMessage(AdminLocalizations l10n, Object error) => switch (error) {
  NestException(code: NestErrorCode.notSignedIn) => l10n.errorNotSignedIn,
  NestException(code: NestErrorCode.userDisabled) => l10n.errorUserDisabled,
  NestException(code: NestErrorCode.notAdmin) => l10n.errorNotAdmin,
  NestException(code: NestErrorCode.notFound) => l10n.errorNotFound,
  NestException(code: NestErrorCode.invalidInput) => l10n.errorInvalidInput,
  EmailAccountLoginException(
    reason: EmailAccountLoginExceptionReason.invalidCredentials,
  ) =>
    l10n.errorInvalidCredentials,
  EmailAccountLoginException(
    reason: EmailAccountLoginExceptionReason.tooManyAttempts,
  ) =>
    l10n.errorTooManyAttempts,
  ServerpodClientNetworkException() => l10n.errorNetwork,
  _ => l10n.errorUnknown,
};
