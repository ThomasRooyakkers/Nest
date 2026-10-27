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
- Riverpod providers changed: `cd nest_flutter && dart run build_runner build`.
- Strings changed (ARB files): `flutter gen-l10n` in the package that owns
  them. Every string must exist in both `*_en.arb` and `*_nl.arb`.
