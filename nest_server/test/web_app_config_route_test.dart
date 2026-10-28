import 'package:nest_server/src/web/web_app_config_route.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

void main() {
  test('the public API address leaves out default ports', () {
    expect(
      publicApiUrl(
        ServerConfig(
          port: 8080,
          publicScheme: 'https',
          publicHost: 'nest-api.example.com',
          publicPort: 443,
        ),
      ),
      'https://nest-api.example.com/',
    );
    expect(
      publicApiUrl(
        ServerConfig(
          port: 8080,
          publicScheme: 'http',
          publicHost: 'localhost',
          publicPort: 8080,
        ),
      ),
      'http://localhost:8080/',
    );
  });
}
