import 'dart:convert';

import 'package:serverpod/serverpod.dart';

/// Serves `assets/config.json` with this server's public API address. On the
/// web domain, the mobile app reads it to find the API when a user types the
/// web address; on the admin domain ([host]), it lets one admin portal build
/// work on every Nest server.
///
/// `cookieAuth` tells the admin portal to keep its login in HttpOnly cookies,
/// which the server only supports when `authCookie` is configured.
class WebAppConfigRoute extends Route {
  WebAppConfigRoute(this.apiServer, {required this.cookieAuth, super.host})
    : super(methods: {Method.get, Method.head});

  final ServerConfig apiServer;
  final bool cookieAuth;

  /// Where the web app is served from (Flutter puts assets under `assets/`).
  static const servedAt = '/assets/assets/config.json';

  @override
  Future<Result> handleCall(Session session, Request request) async {
    return Response.ok(
      body: Body.fromString(
        jsonEncode({
          'apiUrl': publicApiUrl(apiServer),
          'cookieAuth': cookieAuth,
        }),
        mimeType: MimeType.json,
      ),
      headers: Headers.build(
        (h) => h.cacheControl = CacheControlHeader(noCache: true),
      ),
    );
  }
}

/// The API server's public address, e.g. `https://nest-api.example.com/`.
String publicApiUrl(ServerConfig apiServer) => Uri(
  scheme: apiServer.publicScheme,
  host: apiServer.publicHost,
  port: apiServer.publicPort,
  path: '/',
).toString();
