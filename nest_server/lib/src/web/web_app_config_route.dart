import 'dart:convert';

import 'package:serverpod/serverpod.dart';

/// Serves the web app's `assets/config.json` with this server's public API
/// address, so one web app build works on every Nest server. The mobile app
/// reads it too, to find the API when a user types the web address.
class WebAppConfigRoute extends Route {
  WebAppConfigRoute(this.apiServer) : super(methods: {Method.get, Method.head});

  final ServerConfig apiServer;

  /// Where the web app is served from (Flutter puts assets under `assets/`).
  static const servedAt = '/assets/assets/config.json';

  @override
  Future<Result> handleCall(Session session, Request request) async {
    return Response.ok(
      body: Body.fromString(
        jsonEncode({'apiUrl': publicApiUrl(apiServer)}),
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
