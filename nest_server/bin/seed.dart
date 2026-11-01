import 'dart:io';

import 'package:nest_server/server.dart';
import 'package:nest_server/src/seed/seed.dart';

/// Seeds the development database with sample households and users.
///
///     dart bin/seed.dart --apply-migrations
///
/// The users' password is `seedPassword` in config/passwords.yaml. Runs on
/// free ports, so a server started with `serverpod start` can keep running.
Future<void> main(List<String> args) async {
  final pod = await createServerpod(args, configOverride: toolConfig);

  final password = pod.getPassword('seedPassword');
  if (password == null || password.length < 8) {
    stderr.writeln(
      'Set seedPassword (8+ characters) for this run mode in '
      'config/passwords.yaml first.',
    );
    exit(64);
  }

  await pod.start();
  final session = await pod.createSession();
  var exitCode = 0;
  try {
    await seed(session, password: password);
  } catch (e, stackTrace) {
    stderr.writeln('Seeding failed: $e\n$stackTrace');
    exitCode = 1;
  } finally {
    await session.close();
    await pod.shutdown(exitProcess: false);
  }
  exit(exitCode);
}
