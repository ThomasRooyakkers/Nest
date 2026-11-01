import 'dart:convert';
import 'dart:io';

import '../../server.dart';
import '../services/admin_password.dart';

/// `set-admin-password`: gives the super-admin (`superAdminEmail`) a
/// password for the admin portal. In the server image:
///
///     docker compose exec nest ./bin/server set-admin-password
///
/// The password is asked for twice without echo, or read as one line from
/// standard input when it is not a terminal. Never pass it as an argument,
/// where it would end up in the shell history.
Future<int> setAdminPasswordCommand(List<String> args) async {
  // The image sets the run mode in `runmode`, not on the command line.
  final runMode = Platform.environment['runmode'];
  if (runMode != null && !args.any((a) => a.startsWith('--mode'))) {
    args = ['--mode=$runMode', ...args];
  }

  final password = _readPassword();
  if (password == null) return 64;

  final pod = await createServerpod(args, configOverride: toolConfig);
  await pod.start();
  final session = await pod.createSession();
  var exitCode = 0;
  try {
    final result = await AdminPassword.set(session, password: password);
    stdout.writeln(switch (result) {
      AdminPasswordResult.changed => 'The super-admin password was changed.',
      AdminPasswordResult.added =>
        'Email sign-in was added to the super-admin account.',
    });
  } on AdminPasswordException catch (e) {
    stderr.writeln(e.message);
    exitCode = 1;
  } catch (e, stackTrace) {
    stderr.writeln('Setting the password failed: $e\n$stackTrace');
    exitCode = 1;
  } finally {
    await session.close();
    await pod.shutdown(exitProcess: false);
  }
  return exitCode;
}

String? _readPassword() {
  if (!stdin.hasTerminal) {
    return stdin.readLineSync(encoding: utf8);
  }
  stdin.echoMode = false;
  try {
    stdout.write('New admin portal password: ');
    final first = stdin.readLineSync(encoding: utf8);
    stdout.write('\nRepeat it: ');
    final second = stdin.readLineSync(encoding: utf8);
    stdout.writeln();
    if (first == null || first != second) {
      stderr.writeln('The passwords do not match.');
      return null;
    }
    return first;
  } finally {
    stdin.echoMode = true;
  }
}
