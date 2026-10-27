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
import 'dart:async' as _ida;
import 'package:http/http.dart' as _i85jenna;
import 'package:nest_client/src/protocol/admin_household_summary.dart'
    as _ipf5tkzm;
import 'package:nest_client/src/protocol/household_feature.dart' as _iejl7hre;
import 'package:nest_client/src/protocol/household_invite.dart' as _iidsgy2i;
import 'package:nest_client/src/protocol/household_member.dart' as _ihqqoxyh;
import 'package:nest_client/src/protocol/household_status.dart' as _iluf117q;
import 'package:nest_client/src/protocol/my_household.dart' as _itexq6j2;
import 'package:nest_client/src/protocol/nest_user.dart' as _i7k4hj0f;
import 'package:nest_client/src/protocol/server_ping.dart' as _i4l166nw;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'protocol.dart' as _il2as5qe;

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
/// {@category Endpoint}
class EndpointEmailIdp extends _iaic.EndpointEmailIdpBase {
  EndpointEmailIdp(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<_iacc.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _ida.Future<_isc.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _ida.Future<String> verifyRegistrationCode({
    required _isc.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _ida.Future<_iacc.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _ida.Future<_isc.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _ida.Future<String> verifyPasswordResetCode({
    required _isc.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );

  @override
  _ida.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailIdp',
    'hasAccount',
    {},
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _iacc.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// If [refreshToken] is omitted, cookie-mode web clients fall back to the
  /// configured HttpOnly refresh cookie. When neither source is present this
  /// throws [RefreshTokenNotFoundException], the same public "no usable refresh
  /// credential" exception used for unknown refresh tokens.
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _ida.Future<_iacc.AuthSuccess> refreshAccessToken({String? refreshToken}) =>
      caller.callServerEndpoint<_iacc.AuthSuccess>(
        'jwtRefresh',
        'refreshAccessToken',
        {'refreshToken': refreshToken},
        authenticated: false,
      );
}

/// Household management for the admin portal. Metadata and counts only.
/// {@category Endpoint}
class EndpointAdminHouseholds extends _isc.EndpointRef {
  EndpointAdminHouseholds(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'adminHouseholds';

  /// All households with member counts and owner names.
  _ida.Future<List<_ipf5tkzm.AdminHouseholdSummary>> list() =>
      caller.callServerEndpoint<List<_ipf5tkzm.AdminHouseholdSummary>>(
        'adminHouseholds',
        'list',
        {},
      );

  /// Suspends or reactivates a household.
  _ida.Future<_ipf5tkzm.AdminHouseholdSummary> setStatus(
    int householdId,
    _iluf117q.HouseholdStatus status,
  ) => caller.callServerEndpoint<_ipf5tkzm.AdminHouseholdSummary>(
    'adminHouseholds',
    'setStatus',
    {
      'householdId': householdId,
      'status': status,
    },
  );
}

/// Public health check. Not household-scoped and returns no household data.
/// {@category Endpoint}
class EndpointHealth extends _isc.EndpointRef {
  EndpointHealth(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'health';

  /// Returns the server time and version so the app can show it is connected.
  _ida.Future<_i4l166nw.ServerPing> ping() =>
      caller.callServerEndpoint<_i4l166nw.ServerPing>(
        'health',
        'ping',
        {},
      );
}

/// Households, memberships and invite codes.
/// {@category Endpoint}
class EndpointHousehold extends _isc.EndpointRef {
  EndpointHousehold(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'household';

  /// Active households the signed-in user belongs to, sorted by name.
  _ida.Future<List<_itexq6j2.MyHousehold>> listMine() =>
      caller.callServerEndpoint<List<_itexq6j2.MyHousehold>>(
        'household',
        'listMine',
        {},
      );

  /// Creates a household with the signed-in user as owner.
  _ida.Future<_itexq6j2.MyHousehold> create(String name) =>
      caller.callServerEndpoint<_itexq6j2.MyHousehold>(
        'household',
        'create',
        {'name': name},
      );

  /// A household the signed-in user belongs to.
  _ida.Future<_itexq6j2.MyHousehold> get(int householdId) =>
      caller.callServerEndpoint<_itexq6j2.MyHousehold>(
        'household',
        'get',
        {'householdId': householdId},
      );

  /// Members of a household, owners first, then by name.
  _ida.Future<List<_ihqqoxyh.HouseholdMember>> members(int householdId) =>
      caller.callServerEndpoint<List<_ihqqoxyh.HouseholdMember>>(
        'household',
        'members',
        {'householdId': householdId},
      );

  /// Renames a household. Owners only.
  _ida.Future<_itexq6j2.MyHousehold> rename(
    int householdId,
    String name,
  ) => caller.callServerEndpoint<_itexq6j2.MyHousehold>(
    'household',
    'rename',
    {
      'householdId': householdId,
      'name': name,
    },
  );

  /// Switches features on or off for a household. Owners only.
  _ida.Future<_itexq6j2.MyHousehold> setFeatures(
    int householdId,
    List<_iejl7hre.HouseholdFeature> features,
  ) => caller.callServerEndpoint<_itexq6j2.MyHousehold>(
    'household',
    'setFeatures',
    {
      'householdId': householdId,
      'features': features,
    },
  );

  /// Creates a new invite code, replacing any previous one. Owners only.
  _ida.Future<_iidsgy2i.HouseholdInvite> createInvite(int householdId) =>
      caller.callServerEndpoint<_iidsgy2i.HouseholdInvite>(
        'household',
        'createInvite',
        {'householdId': householdId},
      );

  /// Removes the current invite code. Owners only.
  _ida.Future<void> revokeInvite(int householdId) =>
      caller.callServerEndpoint<void>(
        'household',
        'revokeInvite',
        {'householdId': householdId},
      );

  /// Joins the household that owns [code] as a member.
  _ida.Future<_itexq6j2.MyHousehold> join(String code) =>
      caller.callServerEndpoint<_itexq6j2.MyHousehold>(
        'household',
        'join',
        {'code': code},
      );

  /// Leaves a household. The last owner cannot leave while others remain.
  _ida.Future<void> leave(int householdId) => caller.callServerEndpoint<void>(
    'household',
    'leave',
    {'householdId': householdId},
  );
}

/// The signed-in user's own profile. Not household-scoped.
/// {@category Endpoint}
class EndpointProfile extends _isc.EndpointRef {
  EndpointProfile(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'profile';

  /// Returns the signed-in user, creating the Nest profile on first use.
  _ida.Future<_i7k4hj0f.NestUser> me() =>
      caller.callServerEndpoint<_i7k4hj0f.NestUser>(
        'profile',
        'me',
        {},
      );

  /// Updates the signed-in user's name and language.
  _ida.Future<_i7k4hj0f.NestUser> updateMe(
    String name,
    String locale,
  ) => caller.callServerEndpoint<_i7k4hj0f.NestUser>(
    'profile',
    'updateMe',
    {
      'name': name,
      'locale': locale,
    },
  );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _iaic.Caller(client);
    serverpod_auth_core = _iacc.Caller(client);
  }

  late final _iaic.Caller serverpod_auth_idp;

  late final _iacc.Caller serverpod_auth_core;
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
         host,
         _il2as5qe.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
       ) {
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    adminHouseholds = EndpointAdminHouseholds(this);
    health = EndpointHealth(this);
    household = EndpointHousehold(this);
    profile = EndpointProfile(this);
    modules = Modules(this);
  }

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointAdminHouseholds adminHouseholds;

  late final EndpointHealth health;

  late final EndpointHousehold household;

  late final EndpointProfile profile;

  late final Modules modules;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'adminHouseholds': adminHouseholds,
    'health': health,
    'household': household,
    'profile': profile,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
