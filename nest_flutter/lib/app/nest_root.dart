import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nest_client/nest_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../core/backend/nest_client.dart';
import '../core/database/nest_database.dart';
import '../core/server/server_address.dart';
import '../core/server/server_session.dart';
import '../core/server/server_store.dart';
import 'app_locale.dart';
import 'nest_app.dart';

/// Holds the connection to the chosen server and restarts the app (a fresh
/// [ProviderScope]) when the user switches to another server.
class NestRoot extends StatefulWidget {
  const NestRoot({
    super.key,
    required this.database,
    required this.server,
    required this.client,
  });

  final NestDatabase database;
  final ServerAddress server;
  final Client client;

  @override
  State<NestRoot> createState() => _NestRootState();
}

class _NestRootState extends State<NestRoot> implements ServerSwitcher {
  late ServerAddress _server = widget.server;
  late Client _client = widget.client;
  Locale? _locale;
  var _generation = 0;

  @override
  Future<void> switchTo(ServerAddress server, {Locale? locale}) async {
    final old = _client;
    // Signs out locally even when the old server cannot be reached.
    await old.auth.signOutDevice();
    await widget.database.clearAll();
    await writeChosenServer(widget.database, server);
    final client = await createNestClient(server.apiUrl);
    if (!mounted) return;
    setState(() {
      _server = server;
      _client = client;
      _locale = locale;
      _generation++;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => old.close());
  }

  @override
  void dispose() {
    _client.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      key: ValueKey(_generation),
      overrides: [
        nestClientProvider.overrideWithValue(_client),
        nestDatabaseProvider.overrideWithValue(widget.database),
        currentServerProvider.overrideWithValue(_server),
        serverSwitcherProvider.overrideWithValue(this),
        if (_locale != null)
          localeChoiceProvider.overrideWithBuild((ref, notifier) => _locale),
      ],
      child: const NestApp(),
    );
  }
}
