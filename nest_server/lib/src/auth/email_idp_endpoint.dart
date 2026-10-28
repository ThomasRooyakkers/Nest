import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import '../services/sign_up_policy.dart';

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
class EmailIdpEndpoint extends EmailIdpBaseEndpoint {
  /// On an invite-only server, registration needs a redeemed invite code
  /// (see [SignUpPolicy]).
  @override
  Future<UuidValue> startRegistration(
    Session session, {
    required String email,
  }) async {
    await SignUpPolicy.checkMayRegister(session, email);
    return super.startRegistration(session, email: email);
  }
}
