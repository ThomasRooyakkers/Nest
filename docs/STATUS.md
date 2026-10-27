# Nest — Status

## Current phase

**Phase 0 — Setup** (blocked on prerequisites)

## Done

- Prerequisite check (2026-10-27).

## Prerequisites (2026-10-27)

| Tool | State |
| --- | --- |
| Git | 2.54.0 installed |
| Xcode | 27.1 installed |
| Homebrew | installed |
| Docker Desktop | installed, not running |
| Flutter / Dart | **missing** |
| Serverpod CLI | **missing** (needs Dart) |
| CocoaPods | **missing** (needed for iOS builds) |
| Chrome | **missing** (needed for `flutter run -d chrome`) |
| Android Studio | missing (only needed for Android builds) |

## Next

1. Thomas installs Flutter (and optionally CocoaPods, Chrome).
2. Install the Serverpod CLI with `dart install serverpod_cli`.
3. `serverpod create nest`, add `nest_shared` and `nest_admin`, wire gen-l10n and design tokens.

## Open questions

- **Serverpod 3.x or 4.x?** CLAUDE.md says Serverpod 3.x. Serverpod 4.0 is now the current stable
  (4.0.4; latest 3.x is 3.4.13). Serverpod 4 ships an embedded PostgreSQL for new projects, so
  local development would not need Docker. Waiting for Thomas to decide.

## Deviations from CLAUDE.md

None yet.
