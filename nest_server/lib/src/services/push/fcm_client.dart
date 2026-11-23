import 'dart:convert';
import 'dart:io';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

/// What happened to one push message.
enum PushOutcome {
  /// FCM accepted the message.
  sent,

  /// The token no longer belongs to an app install; forget it.
  invalidToken,

  /// Something else went wrong (network, FCM, credentials). Logged only.
  failed,
}

/// The parts of a Firebase service account key that sending needs.
class FcmCredentials {
  const FcmCredentials({
    required this.projectId,
    required this.clientEmail,
    required this.privateKey,
  });

  final String projectId;
  final String clientEmail;
  final String privateKey;

  /// Reads the service account JSON, or returns null when it is not a usable
  /// key (the server then only logs pushes).
  static FcmCredentials? parse(String json) {
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      final projectId = map['project_id'] as String?;
      final clientEmail = map['client_email'] as String?;
      final privateKey = map['private_key'] as String?;
      if (projectId == null || clientEmail == null || privateKey == null) {
        return null;
      }
      return FcmCredentials(
        projectId: projectId,
        clientEmail: clientEmail,
        privateKey: privateKey.replaceAll(r'\n', '\n'),
      );
    } catch (_) {
      return null;
    }
  }
}

/// Sends messages through the FCM HTTP v1 API, which also delivers to iOS
/// (Firebase forwards to Apple with the APNs key uploaded to the project).
class FcmClient {
  FcmClient(this.credentials);

  final FcmCredentials credentials;

  static const _tokenUrl = 'https://oauth2.googleapis.com/token';
  static const _scope = 'https://www.googleapis.com/auth/firebase.messaging';

  String? _accessToken;
  DateTime _accessTokenExpiry = DateTime.fromMillisecondsSinceEpoch(0);

  /// Sends one notification to [token]. Never throws.
  Future<(PushOutcome, String?)> send({
    required String token,
    required String title,
    required String body,
    required Map<String, String> data,
  }) async {
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 10);
    try {
      final accessToken = await _token(client);
      final request = await client.postUrl(
        Uri.parse(
          'https://fcm.googleapis.com/v1/projects/'
          '${credentials.projectId}/messages:send',
        ),
      );
      request.headers
        ..set(HttpHeaders.authorizationHeader, 'Bearer $accessToken')
        ..contentType = ContentType.json;
      request.write(
        jsonEncode({
          'message': {
            'token': token,
            'notification': {'title': title, 'body': body},
            'data': data,
            'android': {
              'priority': 'high',
              'notification': {'channel_id': 'hoomly_default'},
            },
            'apns': {
              'payload': {
                'aps': {'sound': 'default'},
              },
            },
          },
        }),
      );
      final response = await request.close().timeout(
        const Duration(seconds: 15),
      );
      final text = await response.transform(utf8.decoder).join();
      if (response.statusCode < 300) return (PushOutcome.sent, null);
      if (isInvalidTokenResponse(response.statusCode, text)) {
        return (PushOutcome.invalidToken, null);
      }
      return (PushOutcome.failed, '${response.statusCode} $text');
    } catch (e) {
      return (PushOutcome.failed, '$e');
    } finally {
      client.close();
    }
  }

  /// Whether FCM's answer means the token is gone for good: the app was
  /// removed or the token was replaced (`UNREGISTERED`), or the token is not
  /// a registration token at all.
  static bool isInvalidTokenResponse(int statusCode, String body) {
    if (statusCode == 404) return true;
    if (body.contains('UNREGISTERED')) return true;
    return statusCode == 400 &&
        body.contains('INVALID_ARGUMENT') &&
        body.toLowerCase().contains('registration token');
  }

  Future<String> _token(HttpClient client) async {
    final now = DateTime.now();
    if (_accessToken != null && now.isBefore(_accessTokenExpiry)) {
      return _accessToken!;
    }
    final assertion =
        JWT({
          'iss': credentials.clientEmail,
          'scope': _scope,
          'aud': _tokenUrl,
        }).sign(
          RSAPrivateKey(credentials.privateKey),
          algorithm: JWTAlgorithm.RS256,
          expiresIn: const Duration(hours: 1),
        );
    final request = await client.postUrl(Uri.parse(_tokenUrl));
    request.headers.contentType = ContentType(
      'application',
      'x-www-form-urlencoded',
    );
    request.write(
      'grant_type=${Uri.encodeQueryComponent('urn:ietf:params:oauth:grant-type:jwt-bearer')}'
      '&assertion=$assertion',
    );
    final response = await request.close().timeout(
      const Duration(seconds: 15),
    );
    final text = await response.transform(utf8.decoder).join();
    if (response.statusCode >= 300) {
      throw StateError('token request ${response.statusCode}');
    }
    final map = jsonDecode(text) as Map<String, dynamic>;
    _accessToken = map['access_token'] as String;
    final seconds = (map['expires_in'] as num?)?.toInt() ?? 3600;
    // Renew a few minutes before Google's expiry.
    _accessTokenExpiry = now.add(Duration(seconds: seconds - 300));
    return _accessToken!;
  }
}
