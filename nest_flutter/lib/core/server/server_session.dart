import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'server_address.dart';

part 'server_session.g.dart';

/// Switches the app to another server: signs out, clears this device's
/// cached data, remembers the server and restarts the app on it.
abstract interface class ServerSwitcher {
  /// [locale] keeps the language on screen after the restart.
  Future<void> switchTo(ServerAddress server, {Locale? locale});
}

/// The server the app is connected to. Overridden by `NestRoot`.
@Riverpod(keepAlive: true)
ServerAddress currentServer(Ref ref) =>
    throw UnimplementedError('currentServerProvider must be overridden');

/// Overridden by `NestRoot`.
@Riverpod(keepAlive: true)
ServerSwitcher serverSwitcher(Ref ref) =>
    throw UnimplementedError('serverSwitcherProvider must be overridden');
