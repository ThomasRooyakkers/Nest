import 'package:nest_server/src/endpoints/health_endpoint.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given the health endpoint', (sessionBuilder, endpoints) {
    test('when pinging then it returns the server version and time', () async {
      final before = DateTime.now().toUtc();
      final ping = await endpoints.health.ping(sessionBuilder);

      expect(ping.version, nestServerVersion);
      expect(
        ping.serverTime.isAfter(before.subtract(const Duration(seconds: 5))),
        isTrue,
      );
    });

    test('when pinging then it reports the API levels', () async {
      final ping = await endpoints.health.ping(sessionBuilder);

      expect(ping.apiVersion, nestApiVersion);
      expect(ping.minClientApiVersion, nestMinClientApiVersion);
      expect(nestMinClientApiVersion, lessThanOrEqualTo(nestApiVersion));
    });
  });
}
