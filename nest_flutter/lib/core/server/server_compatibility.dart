import 'package:nest_client/nest_client.dart';

/// API level of this app. Raise it together with the server's
/// `nestApiVersion` when the app starts using new endpoints.
const appApiVersion = 2;

/// Oldest server API level this app works with. Features a server does not
/// have yet must stay optional (CLAUDE.md rule 6) instead of raising this.
const minServerApiVersion = 1;

/// Version of the app, shown on the About screen. Keep in step with
/// `version` in pubspec.yaml.
const appVersion = '1.0.0';

enum ServerCompatibility {
  compatible,

  /// The server is older than this app supports.
  serverTooOld,

  /// The server needs a newer app.
  appTooOld,
}

/// The server's API level; servers from before levels existed are level 1.
int serverApiVersion(ServerPing ping) => ping.apiVersion ?? 1;

/// Whether this app can work with the server that answered [ping].
ServerCompatibility compatibilityOf(ServerPing ping) {
  if (serverApiVersion(ping) < minServerApiVersion) {
    return ServerCompatibility.serverTooOld;
  }
  if (appApiVersion < (ping.minClientApiVersion ?? 1)) {
    return ServerCompatibility.appTooOld;
  }
  return ServerCompatibility.compatible;
}
