import 'package:serverpod/serverpod.dart';

import '../services/sign_up_policy.dart';

/// Sign-up with a household invite code, before the account exists. Not
/// household-scoped: access is granted by the invite code itself.
class SignUpEndpoint extends Endpoint {
  /// Lets [email] create an account and join the household of
  /// [inviteCode] once it exists. Returns the household's name.
  Future<String> redeemInvite(
    Session session,
    String email,
    String inviteCode,
  ) => SignUpPolicy.redeemInvite(
    session,
    email: email,
    inviteCode: inviteCode,
  );
}
