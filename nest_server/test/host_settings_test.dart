import 'package:nest_server/src/services/host_settings.dart';
import 'package:test/test.dart';

void main() {
  group('Google client JSON', () {
    test('a web client without redirect URIs is accepted', () {
      final client = HostSettings.parseGoogleClient(
        '{"web":{"client_id":"id.apps.googleusercontent.com",'
        '"client_secret":"secret","project_id":"nest"}}',
      );
      expect(client?.clientId, 'id.apps.googleusercontent.com');
      expect(client?.redirectUris, isEmpty);
    });

    test('unreadable JSON gives null instead of failing', () {
      expect(HostSettings.parseGoogleClient('not json'), isNull);
      expect(HostSettings.parseGoogleClient('{"installed":{}}'), isNull);
    });
  });
}
