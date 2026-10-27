# Nest — Status

## Current phase

**Phase 0 — Setup: done (2026-10-27).** Waiting for Thomas before starting phase 1.

## Done

- Prerequisites: Flutter 3.47.8 (Dart 3.13.7), Serverpod CLI 4.0.4, Xcode 27.1,
  CocoaPods 1.17.0, Git.
- `serverpod create nest` (full-stack template, email auth, embedded Postgres, no Redis),
  moved to the repo root as a pub workspace.
- `nest_shared`: `NestColors` theme extension with all tokens, spacing/radius tokens,
  `buildNestTheme()`, bundled Nunito variable font (OFL), shared EN/NL strings,
  `NestCard` and `ConnectionBadge` widgets. Tests check WCAG contrast ≥ 4.5:1 for every
  text/background token pair, plus large-text layout.
- Server: public `health.ping` endpoint (replaces the template greeting example).
- `nest_flutter`: Riverpod (codegen) + go_router + gen-l10n wiring, folder layout from
  CLAUDE.md section 5, themed bilingual placeholder screen with locale-formatted date,
  live server connection badge and EN/NL switch. Health check goes through a repository.
- `nest_admin`: themed bilingual web placeholder with connection badge; registered in
  `nest_server/pubspec.yaml` so `serverpod start` can launch it.
- `.gitignore` covers `passwords.yaml`, `.env*`, service-account and restic/rclone files;
  `config/passwords.yaml.example` committed.
- README with run instructions.
- Verified: server tests, all Flutter tests, analyzers clean; app and admin built for web and
  connected to the local server in a browser, including the Dutch switch.

## Next (phase 1 — Foundation)

1. Models: `user_profile` (name, locale, isSuperAdmin, disabledAt, linked to the auth user),
   `household`, `membership`, `admin_audit_log`; first migration.
2. `HouseholdGuard` and `AdminGuard`, and the isolation tests (written before any feature
   endpoint).
3. Household endpoints: create, list mine, invite code generate/join, member list.
4. Seed command (two households, super-admin, a few users).
5. App: sign-in/sign-up (email + password), go_router auth redirect, household switcher,
   settings with language choice stored in the profile.

## Open questions

- Bundle/application IDs are still `com.example.nestFlutter`. Proposal: `be.g3cko.nest`.
  Needs to be decided before TestFlight / Play (phase 8), easiest to change early.
- Email verification codes are only logged to the server console in development
  (template's `ServerpodCloudEmailIdpConfig`). For production on the Pi we will need a
  real mail sender (SMTP) — to decide before phase 2 deployment.

## Deviations from CLAUDE.md

- **Serverpod 4.x instead of 3.x** (decided by Thomas, 2026-10-27). Serverpod 4.0.4 was the
  current stable release; its embedded PostgreSQL removes the need for Docker in development
  and tests. CLAUDE.md sections 2 and 4 updated.
- **Nunito is bundled as a variable font** (google/fonts only ships the variable version).
  Text styles set both `fontWeight` and the `wght` axis via the `nunito()` helper in
  `nest_shared`; use that helper for any custom text style.
- **Three sets of ARB files** instead of one: `nest_shared` (shared strings, e.g. connection
  state), `nest_flutter/lib/l10n` (`app_*.arb`) and `nest_admin/lib/l10n` (`admin_*.arb`).
  Generated localization Dart files are committed (Flutter no longer uses a synthetic package).
- The template's `AGENTS.md` (Serverpod MCP workflow) was not copied; CLAUDE.md stays the
  single instruction file.
