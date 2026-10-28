import 'package:flutter/foundation.dart';

/// A Nest server the app talks to.
@immutable
class ServerAddress {
  const ServerAddress({required this.label, required this.apiUrl});

  /// What the user typed or sees, e.g. `nest.g3cko.be`.
  final String label;

  /// The server's API, e.g. `https://nest-api.g3cko.be/`.
  final String apiUrl;

  /// Thomas's server, the default for release builds.
  static const g3cko = ServerAddress(
    label: 'nest.g3cko.be',
    apiUrl: 'https://nest-api.g3cko.be/',
  );

  /// A server identified only by its API address.
  factory ServerAddress.fromApiUrl(String apiUrl) {
    final uri = parseServerInput(apiUrl);
    return ServerAddress(
      label: uri == null ? apiUrl : labelFor(uri),
      apiUrl: uri?.toString() ?? apiUrl,
    );
  }

  factory ServerAddress.fromJson(Map<String, dynamic> json) => ServerAddress(
    label: json['label'] as String,
    apiUrl: json['apiUrl'] as String,
  );

  Map<String, dynamic> toJson() => {'label': label, 'apiUrl': apiUrl};

  @override
  bool operator ==(Object other) =>
      other is ServerAddress && other.label == label && other.apiUrl == apiUrl;

  @override
  int get hashCode => Object.hash(label, apiUrl);

  @override
  String toString() => 'ServerAddress($label, $apiUrl)';
}

/// Turns what a user typed (`nest.example.com`, `http://10.0.0.5:8080`) into
/// a base URL with a trailing slash, or `null` if it is not an address.
/// Without a scheme, https is assumed.
Uri? parseServerInput(String input) {
  var text = input.trim();
  if (text.isEmpty || text.contains(' ')) return null;
  if (!text.contains('://')) text = 'https://$text';
  final uri = Uri.tryParse(text);
  if (uri == null ||
      !(uri.isScheme('http') || uri.isScheme('https')) ||
      uri.host.isEmpty ||
      !uri.host.contains(RegExp(r'^[a-zA-Z0-9.\-\[\]:]+$'))) {
    return null;
  }
  final path = uri.path.endsWith('/') ? uri.path : '${uri.path}/';
  return Uri(
    scheme: uri.scheme,
    host: uri.host,
    port: uri.hasPort ? uri.port : null,
    path: path,
  );
}

/// Short form of a server URL for display: host, port when not the default,
/// and path, without the scheme.
String labelFor(Uri uri) {
  final port = uri.hasPort ? ':${uri.port}' : '';
  final path = uri.path == '/' ? '' : uri.path.replaceFirst(RegExp(r'/$'), '');
  return '${uri.host}$port$path';
}
