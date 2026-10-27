import 'package:nest_client/nest_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'nest_client.dart';

part 'server_health_repository.g.dart';

/// Talks to the public health endpoint.
class ServerHealthRepository {
  ServerHealthRepository(this._client);

  final Client _client;

  Future<ServerPing> ping() => _client.health.ping();
}

@Riverpod(keepAlive: true)
ServerHealthRepository serverHealthRepository(Ref ref) =>
    ServerHealthRepository(ref.watch(nestClientProvider));

/// Latest health check result. Invalidate it to check again.
@riverpod
Future<ServerPing> serverPing(Ref ref) =>
    ref.watch(serverHealthRepositoryProvider).ping();
