# Nest

Private, bilingual (English + Dutch) family app for iOS, Android and web, built
with Flutter and a self-hosted Serverpod backend. See `CLAUDE.md` for the full
specification and `docs/STATUS.md` for where the project stands.

## Packages

| Folder | What it is |
| --- | --- |
| `nest_server` | Serverpod 4 backend (endpoints, models, migrations, tests) |
| `nest_client` | Generated client. Never edit by hand |
| `nest_shared` | Design system (theme, colours, Nunito), shared widgets and strings |
| `nest_flutter` | The family app (iOS, Android, web) |
| `nest_admin` | Admin portal (Flutter web) |

All packages are part of one Dart pub workspace (root `pubspec.yaml`).

## Prerequisites

- Flutter 3.44.4 or later (stable), with its bundled Dart
- Serverpod CLI 4.x: `dart install serverpod_cli`, then put
  `$HOME/Library/Application Support/Dart/install/bin` on your `PATH`
- For iOS: Xcode and CocoaPods. For web: Chrome

No Docker or database setup is needed: Serverpod downloads and runs an
embedded PostgreSQL for development and tests.

## First-time setup

```bash
cp nest_server/config/passwords.yaml.example nest_server/config/passwords.yaml
```

Fill in random values for every `CHANGE_ME` (for example with
`openssl rand -base64 32`). `passwords.yaml` is git-ignored. Then:

```bash
flutter pub get
```

## Sample data

Set `seedPassword` under `development:` in `nest_server/config/passwords.yaml`,
then:

```bash
cd nest_server && dart bin/seed.dart --apply-migrations
```

This creates the households "Home" and "Test family" and the users
`thomas@nest.test` (super-admin), `sarah@`, `emma@`, `oma@` (in both
households) and `jan@nest.test`, all with the `seedPassword`, plus sample
shopping lists, stores and items, tasks, recipes and a meal plan for both
households. It can run while
`serverpod start` is running and skips every part that already exists, so it
can be run again after a new feature adds fixtures. The built-in shopping
catalog is not seed data: the server syncs it at every start.

New accounts: in development the registration and password-reset codes are
printed in the server log instead of being emailed.

## Run everything (recommended)

```bash
cd nest_server && serverpod start
```

This starts the embedded database, applies migrations, runs the server on
http://localhost:8080 and launches the Nest app in the browser. It watches for
changes, regenerates code and hot reloads. Press `Ctrl+R` there to launch the
admin portal too (port 8083).

## Run parts by hand

```bash
cd nest_server && dart bin/main.dart --apply-migrations
```

```bash
cd nest_flutter && flutter run -d chrome
```

```bash
cd nest_admin && flutter run -d chrome
```

To run the app on a physical phone, point it at your Mac:
`flutter run --dart-define=SERVER_URL=http://<your-mac-ip>:8080/`.

## Production (Raspberry Pi)

Nest runs on the Pi with Docker Compose behind a Cloudflare Tunnel: the app at
https://nest.g3cko.be, the API at https://nest-api.g3cko.be. Secrets live in
`~/nest/deploy/.env` on the Pi (see `deploy/.env.example`). To deploy the
current checkout:

```bash
deploy/deploy.sh
```

Logs (including sign-up codes while Resend is not set up), on the Pi:

```bash
cd ~/nest/deploy && docker compose logs -f nest
```

## Tests

```bash
cd nest_server && dart test
```

```bash
cd nest_shared && flutter test
```

```bash
cd nest_flutter && flutter test
```

```bash
cd nest_admin && flutter test
```

## Code generation

- Server models/endpoints changed: `cd nest_server && serverpod generate`
  (`serverpod start` does this automatically), and
  `serverpod create-migration` when a table changed.
- Riverpod providers or drift tables changed:
  `cd nest_flutter && dart run build_runner build`.
- After upgrading drift, refresh the web database files, which must match the
  drift version:
  `cp ~/.pub-cache/hosted/pub.dev/drift-<version>/drift_worker.js
  ~/.pub-cache/hosted/pub.dev/drift-<version>/extension/devtools/build/sqlite3.wasm
  nest_flutter/web/`.
- Strings changed (ARB files): `flutter gen-l10n` in the package that owns
  them. Every string must exist in both `*_en.arb` and `*_nl.arb`.
