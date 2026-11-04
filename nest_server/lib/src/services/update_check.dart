import 'dart:convert';
import 'dart:io';

import 'package:serverpod/serverpod.dart';

/// Compares this server's version with the newest published Nest release,
/// for the admin portal. Asked only when the admin opens the Server page,
/// and remembered for [cacheFor], so the release list is read rarely.
///
/// Host settings (server passwords): `updateCheck: off` switches it off;
/// `updateCheckUrl` replaces the release list, a GitHub tags API URL whose
/// tag names are versions like `v1.2.3`.
abstract final class UpdateCheck {
  static const defaultUrl =
      'https://api.github.com/repos/ThomasRooyakkers/Nest/tags?per_page=50';
  static const cacheFor = Duration(hours: 6);

  /// For tests: replaces reading the release list. Returns tag names.
  static Future<List<String>> Function()? fetchOverride;

  /// For tests: replaces the `updateCheck` setting.
  static bool? enabledOverride;

  static ({String? latest, DateTime at})? _cached;

  static bool get enabled {
    if (enabledOverride case final value?) return value;
    final value = Serverpod.instance.getPassword('updateCheck')?.trim();
    return value?.toLowerCase() != 'off';
  }

  static void clearCache() => _cached = null;

  /// The newest released version and when it was read, or a null version
  /// when the list could not be read.
  static Future<({String? latest, DateTime at})> latest() async {
    final cached = _cached;
    if (cached != null &&
        cached.latest != null &&
        DateTime.now().difference(cached.at) < cacheFor) {
      return cached;
    }
    String? latest;
    try {
      latest = newest(await (fetchOverride ?? _fetch)());
    } on Object {
      latest = null;
    }
    return _cached = (latest: latest, at: DateTime.now().toUtc());
  }

  /// The highest `x.y.z` version among [tags] (with or without a leading
  /// `v`; other tags are ignored), or null.
  static String? newest(Iterable<String> tags) {
    List<int>? best;
    for (final tag in tags) {
      final parsed = parse(tag);
      if (parsed != null && (best == null || compare(parsed, best) > 0)) {
        best = parsed;
      }
    }
    return best?.join('.');
  }

  /// `[major, minor, patch]` of `v1.2.3` or `1.2.3`, or null.
  static List<int>? parse(String version) {
    final match = RegExp(r'^v?(\d+)\.(\d+)\.(\d+)$').firstMatch(version.trim());
    if (match == null) return null;
    return [for (var i = 1; i <= 3; i++) int.parse(match.group(i)!)];
  }

  static int compare(List<int> a, List<int> b) {
    for (var i = 0; i < 3; i++) {
      if (a[i] != b[i]) return a[i].compareTo(b[i]);
    }
    return 0;
  }

  /// Whether [latest] is newer than [current].
  static bool isNewer(String latest, String current) {
    final l = parse(latest);
    final c = parse(current);
    return l != null && c != null && compare(l, c) > 0;
  }

  static Future<List<String>> _fetch() async {
    final configured = Serverpod.instance.getPassword('updateCheckUrl')?.trim();
    final url = configured == null || configured.isEmpty
        ? defaultUrl
        : configured;
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 10)
      ..userAgent = 'nest-server';
    try {
      final request = await client.getUrl(Uri.parse(url));
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      final response = await request.close().timeout(
        const Duration(seconds: 15),
      );
      final body = await response.transform(utf8.decoder).join();
      if (response.statusCode != 200) {
        throw HttpException('release list answered ${response.statusCode}');
      }
      return [
        for (final tag in jsonDecode(body) as List<dynamic>)
          (tag as Map<String, dynamic>)['name'] as String,
      ];
    } finally {
      client.close();
    }
  }
}
