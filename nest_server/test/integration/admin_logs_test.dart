import 'package:nest_server/src/generated/protocol.dart';
import 'package:nest_server/src/services/nest_logging.dart';
import 'package:nest_server/src/services/security_events.dart';
import 'package:serverpod/protocol.dart' as sp;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import 'test_helpers.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given the Logs and Security pages', (
    sessionBuilder,
    endpoints,
  ) {
    const email = 'anna@example.com';
    const password = 'a-good-password';
    late TestSessionBuilder admin;
    late Session session;
    late int annaId;

    setUpAll(useTestAuthServices);

    setUp(() async {
      session = sessionBuilder.build();
      admin = await signedInUser(
        sessionBuilder,
        name: 'Thomas',
        superAdmin: true,
      );
      final anna = await signedInUser(sessionBuilder, name: 'Anna');
      final profile = await endpoints.profile.me(anna);
      annaId = profile.id!;
      await AuthServices.getIdentityProvider<EmailIdp>().admin
          .createEmailAuthentication(
            session,
            authUserId: profile.authUserId,
            email: email,
            password: password,
          );
    });

    Future<List<AdminSecurityEvent>> events() =>
        endpoints.adminLogs.securityEvents(admin);

    group('security events', () {
      test(
        'the list filters by type and drops events older than 30 days',
        () async {
          await SecurityEvent.db.insertRow(
            session,
            SecurityEvent(
              type: SecurityEventType.signIn,
              userId: annaId,
              at: DateTime.now().toUtc().subtract(const Duration(days: 31)),
            ),
          );
          await SecurityEvents.record(
            session,
            SecurityEventType.signInFailed,
            email: email,
          );
          await SecurityEvents.record(
            session,
            SecurityEventType.signIn,
            userId: annaId,
          );

          expect((await events()).map((e) => e.type), [
            SecurityEventType.signIn,
            SecurityEventType.signInFailed,
          ]);
          final failed = await endpoints.adminLogs.securityEvents(
            admin,
            type: SecurityEventType.signInFailed,
          );
          expect(failed, hasLength(1));
        },
      );

      test('deleting an account forgets its events', () async {
        final bob = await signedInUser(sessionBuilder, name: 'Bob');
        final bobId = (await endpoints.profile.me(bob)).id!;
        await SecurityEvents.record(
          session,
          SecurityEventType.signIn,
          userId: bobId,
        );
        await endpoints.profile.deleteMe(bob);

        final all = await events();
        expect(all.where((e) => e.userId == bobId), isEmpty);
        expect(all.first.type, SecurityEventType.accountDeleted);
        expect(all.first.userId, isNull);
      });
    });

    group('logged calls', () {
      Future<sp.SessionLogEntry> logCall({
        String endpoint = 'shopping',
        String method = 'items',
        String? error,
        bool slow = false,
        String? authUserId,
      }) => sp.SessionLogEntry.db.insertRow(
        session,
        sp.SessionLogEntry(
          serverId: 'default',
          time: DateTime.now().toUtc(),
          touched: DateTime.now().toUtc(),
          endpoint: endpoint,
          method: method,
          duration: slow ? 1.5 : 0.02,
          numQueries: 3,
          slow: slow,
          error: error,
          stackTrace: error == null ? null : '#0 main (file.dart:1)',
          userId: authUserId,
        ),
      );

      test('errors are listed redacted, newest first, with the user', () async {
        final anna = await NestUser.db.findById(session, annaId);
        await logCall(slow: true);
        final failed = await logCall(
          endpoint: 'emailIdp',
          method: 'login',
          error: 'Mail to anna@example.com failed, code <A1B2C3>\nmore',
          authUserId: anna!.authUserId.uuid,
        );
        await sp.LogEntry.db.insertRow(
          session,
          sp.LogEntry(
            sessionLogId: failed.id!,
            serverId: 'default',
            time: DateTime.now().toUtc(),
            logLevel: sp.LogLevel.warning,
            message: 'Registration code for anna@example.com: <XY12ZW>',
            order: 0,
          ),
        );

        final all = await endpoints.adminLogs.sessions(admin);
        expect(all.map((s) => s.call), ['emailIdp.login', 'shopping.items']);

        final errors = await endpoints.adminLogs.sessions(
          admin,
          errorsOnly: true,
        );
        final error = errors.single;
        expect(error.error, 'Mail to a***@example.com failed, code <code>');
        expect(error.userName, 'Anna');
        expect(error.messageCount, 1);

        final slow = await endpoints.adminLogs.sessions(admin, slowOnly: true);
        expect(slow.single.call, 'shopping.items');
        expect(slow.single.durationMs, 1500);

        final search = await endpoints.adminLogs.sessions(admin, call: 'LOGIN');
        expect(search.single.id, failed.id);

        final detail = await endpoints.adminLogs.session(admin, failed.id!);
        expect(detail.stackTrace, contains('file.dart'));
        expect(
          detail.messages.single.message,
          'Registration code for a***@example.com: <code>',
        );
        expect(detail.toJson().toString(), isNot(contains('anna@')));
        expect(detail.toJson().toString(), isNot(contains('XY12ZW')));
      });

      test('an unknown call is not found', () {
        expect(
          endpoints.adminLogs.session(admin, 999999),
          throwsNest(NestErrorCode.notFound),
        );
      });

      test('the summary counts the last 24 hours', () async {
        await logCall(error: 'boom');
        await logCall(slow: true);
        await SecurityEvents.record(
          session,
          SecurityEventType.signInFailed,
          email: email,
        );
        final summary = await endpoints.adminLogs.summary(admin);
        expect(summary.errors24h, 1);
        expect(summary.slow24h, 1);
        expect(summary.failedSignIns24h, 1);
        expect(summary.securityRetentionDays, 30);
      });

      test('a limit outside 1–200 is refused', () {
        expect(
          endpoints.adminLogs.sessions(admin, limit: 500),
          throwsNest(NestErrorCode.invalidInput),
        );
      });
    });

    test('production keeps no SQL text and no streaming messages', () {
      final settings = NestLogging.logSettings(development: false);
      expect(settings.logAllSessions, isFalse);
      expect(settings.logAllQueries, isFalse);
      expect(settings.logSlowQueries, isFalse);
      expect(settings.logFailedQueries, isFalse);
      expect(settings.logStreamingSessionsContinuously, isFalse);
      expect(settings.logFailedSessions, isTrue);
    });
  });

  // The auth module's rate limiter opens its own transaction, which the
  // default rollback mode does not allow. This group has its own database
  // and clears the events after each test instead.
  withServerpod(
    'Given email sign-in',
    rollbackDatabase: RollbackDatabase.disabled,
    (
      sessionBuilder,
      endpoints,
    ) {
      const email = 'anna@example.com';
      const password = 'a-good-password';
      late TestSessionBuilder admin;
      late Session session;
      late int annaId;

      setUpAll(() async {
        useTestAuthServices();
        session = sessionBuilder.build();
        admin = await signedInUser(
          sessionBuilder,
          name: 'Thomas',
          superAdmin: true,
        );
        final anna = await signedInUser(sessionBuilder, name: 'Anna');
        final profile = await endpoints.profile.me(anna);
        annaId = profile.id!;
        await AuthServices.getIdentityProvider<EmailIdp>().admin
            .createEmailAuthentication(
              session,
              authUserId: profile.authUserId,
              email: email,
              password: password,
            );
      });

      tearDown(
        () => SecurityEvent.db.deleteWhere(
          session,
          where: (t) => Constant.bool(true),
        ),
      );

      Future<List<AdminSecurityEvent>> events() =>
          endpoints.adminLogs.securityEvents(admin);

      test('a sign-in is recorded with the user, not the email', () async {
        await endpoints.emailIdp.login(
          sessionBuilder,
          email: email,
          password: password,
        );
        final event = (await events()).single;
        expect(event.type, SecurityEventType.signIn);
        expect(event.method, 'email');
        expect(event.userId, annaId);
        expect(event.userName, 'Anna');
        expect(event.emailHint, isNull);
      });

      test(
        'a failed sign-in keeps only a masked email and the reason',
        () async {
          await expectLater(
            endpoints.emailIdp.login(
              sessionBuilder,
              email: 'Stranger@Example.com',
              password: 'wrong',
            ),
            throwsA(isA<EmailAccountLoginException>()),
          );
          final event = (await events()).single;
          expect(event.type, SecurityEventType.signInFailed);
          expect(event.emailHint, 's***@example.com');
          expect(event.reason, 'invalidCredentials');
          expect(event.userId, isNull);
          final stored = await SecurityEvent.db.find(session);
          expect(stored.toString(), isNot(contains('stranger')));
        },
      );

      test(
        'a password reset request is recorded with a masked email',
        () async {
          await endpoints.emailIdp.startPasswordReset(
            sessionBuilder,
            email: email,
          );
          final event = (await events()).single;
          expect(event.type, SecurityEventType.passwordResetRequested);
          expect(event.emailHint, 'a***@example.com');
        },
      );
    },
  );
}
