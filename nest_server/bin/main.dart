import 'dart:io';

import 'package:nest_server/server.dart';
import 'package:nest_server/src/commands/set_admin_password.dart';

/// This is the starting point for your Serverpod server.
///
/// `set-admin-password` runs that command instead of the server (see
/// [setAdminPasswordCommand]); it lives here so the image needs one binary.
Future<void> main(List<String> args) async {
  if (args.firstOrNull == 'set-admin-password') {
    exit(await setAdminPasswordCommand(args.sublist(1)));
  }
  run(args);
}
