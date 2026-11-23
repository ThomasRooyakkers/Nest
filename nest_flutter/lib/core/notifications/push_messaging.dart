import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart' as fcm;
import 'package:flutter/foundation.dart';
import 'package:nest_client/nest_client.dart';

/// Where the token registered with the server is kept, so signing out can
/// remove it there. A `device.` key: it belongs to this install.
const pushTokenKey = 'device.pushToken';

/// The phone side of push notifications (2.0, NEST-50).
///
/// Firebase is only started when the build carries the publisher's Firebase
/// config (`--dart-define-from-file=firebase.json`, see
/// `firebase.json.example`). Without it (development, tests, other builds)
/// [NoPushMessaging] is used and the app works as before.
abstract class PushMessaging {
  /// The implementation chosen in `main`.
  static PushMessaging instance = NoPushMessaging();

  /// Whether this build can receive pushes at all.
  bool get available;

  PushPlatform get platform =>
      Platform.isIOS ? PushPlatform.ios : PushPlatform.android;

  /// Asks for permission (the system shows its dialog only the first time).
  Future<bool> requestPermission();

  /// Whether pushes may be shown right now, without asking.
  Future<bool> permissionGranted();

  /// This install's FCM token, or null when there is none (yet).
  Future<String?> token();

  Stream<String> get tokenRefresh;

  /// The data of notifications the user tapped while the app was running
  /// in the background.
  Stream<Map<String, String>> get opened;

  /// The data of the notification that started the app, if any.
  Future<Map<String, String>?> initialOpened();

  /// Starts Firebase when the build has its config.
  static Future<void> init() async {
    final options = firebaseOptionsFromEnvironment();
    if (options == null) return;
    try {
      await Firebase.initializeApp(options: options);
      instance = FirebasePushMessaging();
    } catch (e) {
      debugPrint('Push not available: $e');
    }
  }
}

/// Firebase options passed at build time, or null when they are missing.
FirebaseOptions? firebaseOptionsFromEnvironment() {
  // Firebase creates one API key per platform.
  const iosApiKey = String.fromEnvironment('FIREBASE_IOS_API_KEY');
  const androidApiKey = String.fromEnvironment('FIREBASE_ANDROID_API_KEY');
  const projectId = String.fromEnvironment('FIREBASE_PROJECT_ID');
  const senderId = String.fromEnvironment('FIREBASE_SENDER_ID');
  const iosAppId = String.fromEnvironment('FIREBASE_IOS_APP_ID');
  const androidAppId = String.fromEnvironment('FIREBASE_ANDROID_APP_ID');
  if (kIsWeb || projectId.isEmpty || senderId.isEmpty) return null;
  final apiKey = Platform.isIOS ? iosApiKey : androidApiKey;
  final appId = Platform.isIOS ? iosAppId : androidAppId;
  if (apiKey.isEmpty || appId.isEmpty) return null;
  return FirebaseOptions(
    apiKey: apiKey,
    appId: appId,
    messagingSenderId: senderId,
    projectId: projectId,
    iosBundleId: Platform.isIOS ? 'be.g3cko.nest' : null,
  );
}

class NoPushMessaging extends PushMessaging {
  @override
  bool get available => false;

  @override
  Future<bool> requestPermission() async => false;

  @override
  Future<bool> permissionGranted() async => false;

  @override
  Future<String?> token() async => null;

  @override
  Stream<String> get tokenRefresh => const Stream.empty();

  @override
  Stream<Map<String, String>> get opened => const Stream.empty();

  @override
  Future<Map<String, String>?> initialOpened() async => null;
}

class FirebasePushMessaging extends PushMessaging {
  fcm.FirebaseMessaging get _messaging => fcm.FirebaseMessaging.instance;

  @override
  bool get available => true;

  static bool _allowed(fcm.NotificationSettings settings) =>
      settings.authorizationStatus == fcm.AuthorizationStatus.authorized ||
      settings.authorizationStatus == fcm.AuthorizationStatus.provisional;

  @override
  Future<bool> requestPermission() async =>
      _allowed(await _messaging.requestPermission());

  @override
  Future<bool> permissionGranted() async =>
      _allowed(await _messaging.getNotificationSettings());

  @override
  Future<String?> token() async {
    try {
      // On iOS the FCM token needs the APNs token first.
      if (Platform.isIOS && await _messaging.getAPNSToken() == null) {
        return null;
      }
      // The classic FCM registration token, which the server targets with
      // the HTTP v1 `message.token` field. firebase_messaging 17 deprecates
      // it for Installation-ID registration (`register()`); moving to that
      // needs a matching server change, so it is a later step.
      // ignore: deprecated_member_use
      return await _messaging.getToken();
    } catch (e) {
      debugPrint('No push token: $e');
      return null;
    }
  }

  @override
  // See [token] for why the classic token stream is used.
  // ignore: deprecated_member_use
  Stream<String> get tokenRefresh => _messaging.onTokenRefresh;

  @override
  Stream<Map<String, String>> get opened =>
      fcm.FirebaseMessaging.onMessageOpenedApp.map(_data);

  @override
  Future<Map<String, String>?> initialOpened() async {
    final message = await _messaging.getInitialMessage();
    return message == null ? null : _data(message);
  }

  static Map<String, String> _data(fcm.RemoteMessage message) => {
    for (final e in message.data.entries) e.key: '${e.value}',
  };
}
