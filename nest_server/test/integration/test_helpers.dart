import 'package:nest_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

/// Creates an auth user and returns a session builder signed in as that user.
Future<TestSessionBuilder> signedInUser(
  TestSessionBuilder sessionBuilder, {
  String name = 'Test user',
  bool superAdmin = false,
}) async {
  final session = sessionBuilder.build();
  final authUser = await AuthUser.db.insertRow(
    session,
    AuthUser(scopeNames: {}),
  );
  await NestUser.db.insertRow(
    session,
    NestUser(authUserId: authUser.id!, name: name, isSuperAdmin: superAdmin),
  );
  return sessionBuilder.copyWith(
    authentication: AuthenticationOverride.authenticationInfo(
      authUser.id!.uuid,
      <Scope>{},
    ),
  );
}

/// Matches a [NestException] with the given [code].
Matcher throwsNest(NestErrorCode code) => throwsA(
  isA<NestException>().having((e) => e.code, 'code', code),
);
