import 'dart:convert';
import 'dart:io';

/// Reads the API address from the config a Nest server serves on its web
/// address [webAddress] (`assets/assets/config.json`).
/// Returns `null` when there is none.
Future<String?> fetchWebAppApiUrlDefault(Uri webAddress) async {
  final client = HttpClient()..connectionTimeout = const Duration(seconds: 10);
  try {
    final request = await client.getUrl(
      webAddress.resolve('assets/assets/config.json'),
    );
    final response = await request.close().timeout(
      const Duration(seconds: 10),
    );
    if (response.statusCode != 200) return null;
    final body = await response.transform(utf8.decoder).join();
    final json = jsonDecode(body);
    return json is Map && json['apiUrl'] is String
        ? json['apiUrl'] as String
        : null;
  } catch (_) {
    return null;
  } finally {
    client.close(force: true);
  }
}
