# CLAUDE.md — Nest

This file tells Claude Code everything it needs to build **Nest**, a family household app, starting from an empty folder. Read it at the start of every session, then read `docs/STATUS.md` (short: current state, next steps, open questions) to see where the project stands. Details live in `docs/spec/` and `docs/history/`; open them only when the task needs them.

---

## 1. What Nest is

Nest is a private, bilingual (English + Dutch) family app for iOS and Android, built with Flutter. Only the admin portal is a web application; the family app has no web version (decided 2026-10-31: a mobile-only experience). It is **bring your own backend**: anyone can host a Nest server for their own family, and one app connects to whichever server the user chooses. Thomas hosts one for his family and relatives at `nest.g3cko.be`. Each server is multi-tenant: it serves several households, and each household sees only its own data. A separate admin portal lets each server's super-admin manage households, users, backups and system health.

**v1 features:** Dashboard, Shopping List (Bring!-style tiles, multiple lists, manually added stores), Recipes, Meal Planning, Tasks, Watchlist (TMDB), admin portal, and a self-hosting kit (published server image and hosting guide) so others can run their own server.

**Out of scope for v1:** notifications of any kind (push, reminders, daily summary; removed 2026-10-28, may return later; the one exception, decided 2026-11-04, is alert emails about server problems to the server's own super-admin), expenses, notes, calendar, general file storage, recipe import from websites, sending a whole week's meal plan to the shopping list, paid subscriptions.

**Production:** Thomas's server runs on a Raspberry Pi at home with Docker Compose, reachable through a Cloudflare Tunnel at `nest.g3cko.be` (the address users type in the app; serves a short page pointing to the app, the privacy policy and the config the app uses to find the API), `nest-api.g3cko.be` (API) and, later, `nest-admin.g3cko.be` (admin portal, behind Cloudflare Access). Other hosts use the same image and Compose file with their own domain, either behind a Cloudflare Tunnel or their own HTTPS proxy.

---

## 2. How to work in this repo

- **Local-first.** Everything must run on a Mac with no external accounts or API keys. External services (Google sign-in, Apple sign-in, Resend mail, TMDB, OneDrive, Cloudflare) sit behind interfaces with a **fake implementation** used by default in development. Real implementations are added later and switched on by configuration.
- **Work phase by phase** (`docs/spec/roadmap.md`). Finish a phase, meet its gate, update `docs/STATUS.md`, then stop and summarize for Thomas before starting the next phase. Never skip a gate.
- **Small steps, always green.** After each meaningful change: run `serverpod generate` if models or endpoints changed, run the tests, fix failures, then commit with a short conventional message (`feat:`, `fix:`, `test:`, `chore:`, `docs:`).
- **Ask before** adding a dependency that is not listed in section 4, changing a decision in this file, or deleting data or migrations. When something is ambiguous, ask one clear question rather than guessing.
- **Keep `docs/STATUS.md` short and current** (under about 150 lines): current state, what is next, open questions. Write the details of finished work at the top of the Log in `docs/history/STATUS-HISTORY.md`, and deviations from the spec in `docs/DEVIATIONS.md`.
- **Keep token use down:** search (`grep`) before reading whole files, read large files in parts, run targeted tests and show failures only, and never read `build/`, `.dart_tool/` or generated code unless needed.
- **Backlog and tasks live in Jira** (project `NEST`, decided 2026-11-07): follow `docs/JIRA.md` for components, the `claude`/`thomas` labels, releases and the workflow. Pick up work from the Claude queue, create an item for new work, and move items as you go. `docs/history/STATUS-HISTORY.md` stays the detailed history.
- **Verify versions.** Use the latest stable Flutter and Serverpod 4.x releases (decided 2026-10-27, replacing 3.x). Check the official Serverpod documentation for the exact CLI install command, auth module and APIs of the installed version rather than relying on memory, and pin versions in `pubspec.yaml`.

---

## 3. Non-negotiable rules

1. **Tenant isolation is enforced on the server.** Every household-scoped endpoint method starts with `HouseholdGuard.require(session, householdId)`, which verifies that the signed-in user has a membership in that household and throws otherwise. Every query filters on `householdId`. On create/update, the server sets `householdId` itself; never trust the value sent by the client.
2. **Admin endpoints** live under `endpoints/admin/` and start with `AdminGuard.require(session)`, which checks `isSuperAdmin` on the server. Admin endpoints return metadata and counts only, never household content (no list items, recipe text, task titles). Every admin action writes an `admin_audit_log` row.
3. **Isolation tests come first.** Before any feature exists, there is a test that creates two households and asserts that a user of household A gets nothing back, and an error, from every endpoint for household B. Every new endpoint is added to this test. A second test asserts that a normal user gets an error from every admin endpoint.
4. **No secrets in Git.** Passwords, API keys, service-account files, restic passwords and rclone tokens live in untracked env files (`.env`, `config/passwords.yaml`); commit only `*.example` versions. Make sure `.gitignore` covers them from the first commit.
5. **Bilingual from the first screen.** No hard-coded user-facing strings. All text goes through gen-l10n ARB files (`app_en.arb`, `app_nl.arb`) with both languages filled in. Dates, weekdays and numbers are formatted per locale with `intl`. User content (recipes, items, tasks) is shown as entered, never translated. Emails sent by the server (sign-up and reset codes) are in both languages.
6. **No server is hard-coded.** The app connects to the server the user chose (default `nest.g3cko.be`), checks it is a compatible Nest server first, and keeps working against older servers within the supported range: new features must be optional on servers that do not have them yet. Everything that differs per host (domain, allowed web origins, mail, super-admin, TMDB key, backup targets) is server configuration, never code. Nothing in the server or the deploy kit may depend on Thomas's accounts.
7. **Accessibility:** touch targets at least 44×44, text contrast at least 4.5:1, semantic labels on icon-only buttons, support for system text scaling.

---

## 4. Tech stack

| Layer | Choice |
| --- | --- |
| App | Flutter (stable), Dart |
| State | Riverpod with code generation (`flutter_riverpod`, `riverpod_annotation`, `riverpod_generator`) |
| Navigation | `go_router` (deep links; auth redirects) |
| Localization | `flutter_localizations`, gen-l10n (ARB), `intl` |
| Local cache / offline | `drift` (SQLite) for shopping list, tasks and recipes |
| Backend | Serverpod 4.x (Dart): endpoints, generated client, ORM, migrations |
| Database | PostgreSQL 16+ (Serverpod's embedded Postgres locally and in tests, no Docker needed; Postgres in Docker on the Pi in production) |
| Realtime | Serverpod streaming (WebSockets) for shopping list and tasks |
| Scheduling | Serverpod future calls where needed (e.g. creating the next occurrence of recurring tasks) |
| Auth | Serverpod's official auth module: email + password now; Google sign-in, and Sign in with Apple on iOS, later |
| Film data (later) | TMDB API, called from the server only. Fake service with fixtures in development |
| Backups (later) | `pg_dump` + restic to an NFS share and to OneDrive (via rclone) |
| Mail | Resend (HTTPS API) when a key is configured; codes in the server log otherwise |
| Admin portal | Flutter web app in the same repo |
| Self-hosting | Multi-arch (arm64 + amd64) server image with the admin portal and a small static site built in, Docker Compose file, hosting guide |
| CI (later) | GitHub Actions: tests, arm64 server image |

Use the models Serverpod generates in the data layer. Use `freezed` only for UI-only state classes if they become complex.

---

## 5. Repository layout

```
nest/
  CLAUDE.md
  docs/STATUS.md
  nest_server/
    lib/src/
      models/          # .spy.yaml model definitions
      endpoints/       # one endpoint per feature, all household-scoped
        admin/         # super-admin endpoints (AdminGuard)
      future_calls/    # scheduled work (e.g. recurring tasks)
      services/        # HouseholdGuard, AdminGuard, mail, tmdb (fake + real)
    migrations/
    config/            # development.yaml, test.yaml, production.yaml (+ passwords.yaml, untracked)
    test/              # integration tests incl. isolation tests
  nest_client/         # generated, never edit by hand
  nest_shared/         # shared Flutter package: theme, design tokens, common widgets, l10n
  nest_flutter/        # the mobile app (iOS, Android; runs on macOS for development)
    lib/
      main.dart
      app/             # app widget, theme wiring, go_router config
      l10n/            # app_en.arb, app_nl.arb
      core/
        backend/       # Serverpod client, session, connection state
        database/      # drift cache
        household/     # active household, feature toggles
        server/        # chosen server address, compatibility check
      features/
        auth/ dashboard/ shopping_list/ recipes/ meal_planning/ tasks/ watchlist/ settings/
          data/          # repository + remote/local data sources
          presentation/  # screens, widgets, providers
    test/
  nest_admin/          # Flutter web admin portal
  deploy/              # (later) docker-compose.yml, cloudflared, backup container
```

The UI never calls the generated client directly; it goes through a repository per feature.

---

## 6–8, 10. Spec documents (read only what the task needs)

The detailed spec lives in `docs/spec/`. Open the file for the area you are working on; do not read them all up front.

| Topic | File |
| --- | --- |
| Data model (tables, fields) | `docs/spec/data-model.md` |
| Feature specifications (per screen / feature) | `docs/spec/features.md` |
| Design system (colour tokens, type, shape, controls) | `docs/spec/design-system.md` |
| Roadmap and gates (phases 0–9) | `docs/spec/roadmap.md` |
| Agreed deviations from the spec | `docs/DEVIATIONS.md` |
| Full history of what was built and released | `docs/history/STATUS-HISTORY.md` (search it, don't read it whole) |

Changing what a spec file says is changing a decision: ask Thomas first.

---

## 9. Local development without keys

| Service | Development default | Production (later) |
| --- | --- | --- |
| Auth | email + password | + Google sign-in, Sign in with Apple on iOS |
| Mail | codes written to the server log | Resend, with the host's own API key |
| TMDB | `FakeTmdbService`: fixtures with placeholder posters | `TmdbService` with API key on the server |
| Backups | restic to a local folder | restic to NFS + OneDrive via rclone |
| Network | `localhost` | Cloudflare Tunnel or the host's own HTTPS proxy |

Select implementations through server config (e.g. `tmdb: fake|tmdb`). Provide a seed command that creates two households ("Home" and "Test family"), a super-admin and a few users, sample catalog items, stores, recipes, tasks and watchlist fixtures, so every screen has data.

---

## 11. Definition of done (per feature)

- Endpoints guarded, scoped by `householdId`, and added to the isolation test.
- Repository + providers + screens built to the design system and mockups.
- All strings in both ARB files; layout checked in Dutch (longer words) and with large text.
- Works offline where specified; realtime updates where specified.
- Unit tests for logic (e.g. scaling, recurrence, store filtering) and integration tests for endpoints.
- `docs/STATUS.md` (one line) and `docs/history/STATUS-HISTORY.md` (details) updated; changes committed.

