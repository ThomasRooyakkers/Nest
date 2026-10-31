import 'package:flutter/foundation.dart';
import 'package:nest_client/nest_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'server_address.dart';
import 'server_compatibility.dart';
import 'web_config.dart';

part 'server_check.g.dart';

/// Result of checking an address the user typed.
sealed class ServerCheck {
  const ServerCheck();
}

/// A compatible Nest server.
class ServerFound extends ServerCheck {
  const ServerFound(this.address, this.ping);
  final ServerAddress address;
  final ServerPing ping;
}

/// A Nest server this app cannot work with.
class ServerIncompatible extends ServerCheck {
  const ServerIncompatible(this.compatibility, this.ping);
  final ServerCompatibility compatibility;
  final ServerPing ping;
}

/// Not an address.
class ServerInvalidAddress extends ServerCheck {
  const ServerInvalidAddress();
}

/// No Nest server answered at the address.
class ServerNotFound extends ServerCheck {
  const ServerNotFound();
}

typedef PingServer = Future<ServerPing> Function(Uri apiUrl);
typedef FetchWebAppApiUrl = Future<String?> Function(Uri webAddress);

/// Finds the Nest server behind an address and checks it is compatible.
///
/// The address may be the server's API (`nest-api.example.com`) or its web
/// address (`nest.example.com`); for the web address, the API address is
/// read from the config the Nest server serves there.
class ServerChecker {
  ServerChecker({PingServer? ping, FetchWebAppApiUrl? fetchWebAppApiUrl})
    : _ping = ping ?? _pingWithClient,
      _fetchWebAppApiUrl = fetchWebAppApiUrl ?? fetchWebAppApiUrlDefault;

  final PingServer _ping;
  final FetchWebAppApiUrl _fetchWebAppApiUrl;

  Future<ServerCheck> check(String input) async {
    final uri = parseServerInput(input);
    if (uri == null) return const ServerInvalidAddress();
    final label = labelFor(uri);

    var apiUrl = uri;
    var ping = await _tryPing(apiUrl);
    if (ping == null) {
      final fromWebApp = await _fetchWebAppApiUrl(uri);
      final parsed = fromWebApp == null ? null : parseServerInput(fromWebApp);
      if (parsed != null && parsed != uri) {
        apiUrl = parsed;
        ping = await _tryPing(apiUrl);
      }
    }
    if (ping == null) return const ServerNotFound();

    final compatibility = compatibilityOf(ping);
    if (compatibility != ServerCompatibility.compatible) {
      return ServerIncompatible(compatibility, ping);
    }
    return ServerFound(
      ServerAddress(label: label, apiUrl: apiUrl.toString()),
      ping,
    );
  }

  Future<ServerPing?> _tryPing(Uri apiUrl) async {
    try {
      return await _ping(apiUrl);
    } catch (e) {
      debugPrint('Nest server check: no answer from $apiUrl: $e');
      return null;
    }
  }

  static Future<ServerPing> _pingWithClient(Uri apiUrl) async {
    final client = Client(
      apiUrl.toString(),
      connectionTimeout: const Duration(seconds: 10),
    );
    try {
      return await client.health.ping();
    } finally {
      client.close();
    }
  }
}

@Riverpod(keepAlive: true)
ServerChecker serverChecker(Ref ref) => ServerChecker();
