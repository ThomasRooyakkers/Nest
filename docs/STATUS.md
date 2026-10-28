# Nest — Status

## Current phase

**Phase 3 — Bring your own backend: done, gate passed (2026-10-28).**
Thomas's Pi runs the published image; a second server set up from the
hosting guide alone works with the same app build, and the app switches
between the two. Waiting for Thomas before phase 4 (Tasks).

Phase 2 (Shopping List) is deployed at https://nest.g3cko.be (API
https://nest-api.g3cko.be); its gate ("Thomas's household can use it daily")
is with Thomas. The web shopping list bug is fixed in the source (see
"Web shopping list fix" below) but not yet released to the Pi.

**Plan change (2026-10-28, Thomas):** notifications are dropped from v1 and Nest
becomes *bring your own backend*. Phase 3 is now "Bring your own backend"; Tasks
(without reminders) moves to phase 4 and the later phases shift by one. CLAUDE.md
sections 1, 3 (rule 6), 4, 5, 6, 7, 9 and 10 were updated accordingly.

## Done

### Phase 0 — Setup (2026-10-27)

- Prerequisites: Flutter 3.47.8 (Dart 3.13.7), Serverpod CLI 4.0.4, Xcode 27.1,
  CocoaPods 1.17.0, Git.
- `serverpod create nest` (full-stack template, email auth, embedded Postgres, no Redis),
  moved to the repo root as a pub workspace.
- `nest_shared`: `NestColors` theme extension with all tokens, spacing/radius tokens,
  `buildNestTheme()`, bundled Nunito variable font (OFL), shared EN/NL strings,
  `NestCard`, `ConnectionBadge`, `NestAvatar`, `NestNotice`. Tests check WCAG contrast
  ≥ 4.5:1 for every text/background token pair, plus large-text layout.
- `nest_admin`: themed bilingual web placeholder with connection badge.
- `.gitignore` covers secrets; `config/passwords.yaml.example` committed. README.

### Phase 1 — Foundation (2026-10-27)

- Bundle/application id `be.g3cko.nest` (iOS, Android, macOS). Linux and Windows runners
  removed (not targets).
- **Models + migration:** `nest_user` (profile next to the auth module's user: name,
  locale, isSuperAdmin, disabledAt), `household` (status, enabledFeatures, invite code +
  expiry), `membership` (owner/member), `admin_audit_log`. `NestException` with a
  `NestErrorCode` that the app translates.
- **Guards:** `HouseholdGuard.require/requireOwner` (membership + active household; an
  unknown household id gives the same error as someone else's), `AdminGuard.require` +
  `AdminGuard.audit`. Disabled users are blocked everywhere.
- **Endpoints:** `household` (listMine, create, get, members, rename, setFeatures,
  createInvite, revokeInvite, join, leave), `profile` (me, updateMe),
  `adminHouseholds` (list, setStatus — metadata only, audited), `health.ping`.
- **Tests (50 server tests):** isolation test (user of household A gets `notAMember` from
  every household-scoped method for household B, signed-out callers get `notSignedIn`,
  B is unchanged afterwards), admin access test (normal and signed-out users get errors
  from every admin method), and `endpoint_registry_test`, which fails when a new endpoint
  method is not classified as household-scoped / admin / unscoped — so new endpoints
  cannot skip the isolation or admin tests. Plus household, invite, profile and audit tests.
- **Seed command:** `dart bin/seed.dart --apply-migrations` — households "Home" and
  "Test family", super-admin `thomas@nest.test` and four more users (Oma is in both),
  password from `seedPassword` in `passwords.yaml`. Idempotent; refuses production; runs
  next to a running `serverpod start`.
- **App:** own bilingual sign-in UI on top of Serverpod's `EmailAuthController` (sign in,
  register with email code, password reset); app gate + go_router redirects (sign in →
  name → create/join household → home); home placeholder with greeting and household
  switcher (bottom sheet); settings with name, language (stored in the profile and used
  for the UI), members with roles, invite code create/copy/renew/stop (owners only),
  rename, leave, list of households, add/join another household, sign out. All server
  errors map to EN/NL messages. 14 app widget tests (flows, both languages, text scale 2).
- **Verified in the browser** against the local server: seeded sign-in (UI switched to
  Thomas's Dutch), invite code created, Jan joined Home with the code (typed lower case
  with a space), switcher, leave, and full registration of a new user through the name
  and household steps.

### Phase 2 — Shopping List (2026-10-28)

- **Icons:** Lucide (`lucide_icons_flutter` 4.0.1, ISC), chosen by Thomas, for the
  catalog and the app's new UI (tab bar, shopping screens). Items without their
  own glyph show their category icon.
- **Models + migration:** `shopping_list` (memberIds), `store` (colour, address,
  categoryOrder), `catalog_item` (built-in when `householdId` is null, stable
  `builtInKey`, EN/NL names, Lucide `iconKey`, category), `shopping_item`
  (toBuy/recent, spec, storeIds, category and icon copied from the catalog,
  addedBy, sourceRecipeId for phase 4). Enums `ShoppingCategory` (15 aisles),
  `ShoppingItemStatus`, `StoreColor`. New error code `featureDisabled`.
- **Built-in catalog:** ~130 items in EN/NL (`services/built_in_catalog.dart`),
  synced into the database at every server start (insert/update by key, never
  deleted), so it also reaches production.
- **Endpoint `shopping`** (all guarded with `HouseholdGuard.require(...,
  feature: shopping)`, listed in `endpoint_registry.dart`): lists, saveList,
  deleteList (not the last one), stores, saveStore, deleteStore (frees its
  items), catalog, items, addItem (catalog item or typed name; a typed name
  matches the catalog in either language, otherwise becomes a household catalog
  item; an item already on the list moves back to To buy instead of being
  duplicated), updateItem, setItemStatus, removeItem, and the streaming method
  `watch` (Serverpod message channel per household) for live updates.
- **Tests:** isolation test covers every new method for household B, plus
  "household A's id with household B's row ids" (lists, stores, items, own
  catalog items, store ids) and list members from another household;
  17 shopping endpoint tests (catalog sync, matching, dedupe, store order,
  delete store, last list, validation, feature switch, live events).
  118 server tests in total.
- **Seed:** stores (Delhaize, Aldi, Kruidvat with aisle orders), lists "Weekly
  shop" and "DIY store" and sample items for both seed households. The seed now
  skips each part that exists, so it adds shopping data to an existing database.
- **App:** floating bottom tab bar (Home, Shopping, Meals, Tasks, Watch; tabs of
  switched-off features are hidden; Meals/Tasks/Watch are placeholders).
  Shopping screen: list switcher with member avatars (bottom sheet to switch,
  create, rename, choose members, delete), search "What do you need?" over the
  catalog in both languages plus "Add “…”" for own items, store chips (All
  stores + stores + dashed "Add store") with the store's aisle order and a
  hidden-items hint, To buy (sage tiles) and Recently used (light tiles) 3-column
  grids, tap to move, long-press to edit details/stores or remove, store editor
  with colour and drag-to-reorder aisles, pull to refresh, offline notice with
  the number of waiting changes. Content width is capped at 560 on wide screens.
- **Offline + realtime:** drift database (`core/database/nest_database.dart`):
  server rows cached as JSON per household, an outbox of pending changes, and
  local settings. Item changes (add, tap, edit, remove) apply locally at once and
  are sent in order; items created offline get a temporary negative id that is
  replaced by the server's. Lists and stores need a connection. `ShoppingSync`
  loads everything, listens to `watch`, and reconnects with backoff (2–30 s),
  sending queued changes first. The cache is cleared on sign-out.
- **Active household is now remembered** on the device (open question from
  phase 1 resolved), as is the picked shopping list.
- **App tests (41):** board logic (store filter, aisle order, hidden count,
  recent order), catalog search, every built-in icon key maps to a Lucide icon,
  repository with an in-memory server and database (offline queue, temp ids,
  refused changes, live events, store delete, sign-out clear), sync reconnect
  with real timers, and shopping screen widget tests (grids, tap, Dutch search,
  own item, store filter, live change, offline, long-press edit, Dutch + text
  scale 2). Existing flow tests updated for the tab bar.
- **Verified** in the browser (new test account `claude-test@nest.test` with its
  own household "Claude test": search/add, own item, tap to Recently used, store
  editor with aisle reordering, store filter, and live sync between two browser
  tabs) and in the iOS simulator (iPhone 18 Pro, signed in as Thomas: seeded
  Home lists, item sheet, pull to refresh, store filter with hidden hint).

### Deployment (2026-10-28)

- **Pi** (`10.1.1.215`, Ubuntu 25.10 arm64, Docker 28): the claudecraft containers
  and network were removed (their volume `world-of-claudecraft_eastbrook_pgdata`
  was kept); Scrypted untouched. SSH deploy key `~/.ssh/id_ed25519_nest_pi` on the Mac.
- **Stack** in `~/nest/deploy` (`deploy/docker-compose.yml`, project `nest`):
  `postgres` (16-alpine, volume `nest_pgdata`), `nest` (server image built on the
  Pi; applies migrations at start, serves the web app from `web/app` on 8082 and
  the API on 8080, no published ports), `cloudflared` (tunnel "Nest"), and
  `backup` (interim nightly `pg_dump`, last 14 in `~/nest/deploy/backups`; restic is
  phase 7). Secrets were generated on the Pi into `~/nest/deploy/.env`.
- **Cloudflare Tunnel "Nest"**: `nest.g3cko.be` → `http://nest:8082` (web app),
  `nest-api.g3cko.be` → `http://nest:8080` (API). The admin portal hostname
  `nest-admin.g3cko.be` (behind Cloudflare Access) comes in phase 7.
- **Deploying:** `deploy/deploy.sh` builds the web app for the production API,
  copies the repository to `~/nest` with rsync (no secrets or build output) and
  runs `docker compose up -d --build` on the Pi.
- **Mail:** codes are sent through Resend when `RESEND_API_KEY` is set in `.env`
  (sender `MAIL_FROM`, default `Nest <nest@g3cko.be>`); until then they are
  written to the server log (`docker compose logs nest`). Cloudflare's own Email
  Sending needs the paid Workers plan.
- **Verified:** web app and API over https, health ping, browser CORS from the
  web origin, the live-update WebSocket through the tunnel, the web database
  files, migrations applied, first backup written. No production account was
  created yet.

### Phase 3 — Bring your own backend (2026-10-28)

- **Health and compatibility:** `health.ping` also reports `apiVersion` (now
  2), `minClientApiVersion` (1) and `signUpMode`; all three are nullable so
  older servers (API level 1) still parse. Server version 0.2.0. The app has
  `appApiVersion` 2 and `minServerApiVersion` 1
  (`core/server/server_compatibility.dart`) and refuses servers outside that
  range with a clear message ("server too old" / "update the app").
- **Server choice in the app:** sign-in shows "Server: …" with "Change
  server" (not on the web); Settings has a server card (address, connection,
  version, API level, Change server) and an About screen (app version,
  server, licences). The address may be the API (`nest-api.example.com`) or
  the web app (`nest.example.com`): the app then reads the API address from
  the web app's `config.json`. Without a scheme, https is used. The choice is
  kept in drift (`device.server`; `device.` keys survive sign-out). Switching
  signs out (locally even when the old server is unreachable), clears the
  cache and restarts the app on the new server (`NestRoot`, a fresh
  `ProviderScope`), keeping the language on screen. Defaults: release builds
  use `nest.g3cko.be`, debug builds the local server, `SERVER_URL` still
  overrides. The web app always uses the server it was loaded from.
- **Served web config:** the server generates the web app's
  `assets/assets/config.json` (`WebAppConfigRoute`) with its public API
  address and `cookieAuth`, so one web build works on every host
  (`SERVER_URL` is no longer baked into the web build).
- **Host settings from the environment** (`services/host_settings.dart`,
  read from `SERVERPOD_PASSWORD_*`): `signUpMode` (`invite-only` default, or
  `open`), `superAdminEmail`, `mailFrom`, `resendApiKey`. `production.yaml`
  no longer names g3cko.be: public hosts and allowed origins come from
  `SERVERPOD_API_SERVER_PUBLIC_HOST`, `SERVERPOD_WEB_SERVER_PUBLIC_HOST` and
  `SERVERPOD_ALLOWED_ORIGINS`, set by the Compose file from `.env`
  (`NEST_WEB_DOMAIN`, `NEST_API_DOMAIN`). No default mail sender any more.
- **Invite-only sign-up:** new endpoint `signUp.redeemInvite(email, code)`
  (unscoped, in the endpoint registry) checks a household invite code and
  stores a `sign_up_invite` ticket (1 day). `EmailIdpEndpoint` overrides
  `startRegistration` to refuse emails without a ticket (`inviteRequired`)
  unless the server is open or the email is the super-admin's. When the
  account is created, the Nest profile is created, the super-admin email
  gets `isSuperAdmin`, and a ticket joins its household as member. At every
  start, an existing account with `superAdminEmail` is made super-admin.
  App: "Create account" has an invite code field (required wording and hint
  on invite-only servers, "(optional)" on open ones) and says "You will join
  {household}". New migration `20261028113542280`.
- **Web login cookies:** `authCookie` (secure) in `production.yaml`; the web
  client sets `cookieAuth` when the served config says so. The refresh token
  lives only in an HttpOnly cookie; a page reload stays signed in.
- **Deep links:** redirects to start/sign-in/onboarding keep the original
  location in `?from=` and go there once the user is in (not after signing
  out; only in-app paths).
- **Published (2026-10-28):** repository https://github.com/ThomasRooyakkers/Nest
  (public, remote `origin`), tag `v0.2.0`, image
  `ghcr.io/thomasrooyakkers/nest-server:0.2.0` and `:latest`, public, for
  linux/arm64 and linux/amd64, built by the "Server image" workflow (run by
  hand: the tag push did not trigger it). CI (analyze, format, tests, image)
  runs on Flutter 3.47.8 and passes. The template's development passwords
  stay in the history (local-only values; Thomas chose not to scrub them).
  `deploy/deploy.sh` now updates the Pi from the published image instead of
  building on it.
- **Pi on the published image (2026-10-28, with Thomas's OK):** host
  settings added to `~/nest/deploy/.env` (backup `.env.bak-20261028-134453`
  next to it; super-admin `rooyakkers.thomas@gmail.com`, invite-only, tunnel
  profile, image 0.2.0); `deploy/deploy.sh` dumped the database
  (`backups/nest-pre-update-20261028-124529.sql.gz`) and switched to
  `ghcr.io/thomasrooyakkers/nest-server:0.2.0`. Verified over https: health
  0.2.0 / API 2 / invite-only, generated web config with `cookieAuth`, web
  app and deep link, migration `20261028113542280` applied. There were no
  accounts yet; Thomas's first sign-up with the super-admin email needs no
  invite code and becomes super-admin. To update later: raise
  `NEST_VERSION` in the Pi's `.env` (or keep `latest`) and run
  `deploy/deploy.sh`.
- **Gate (2026-10-28):** second server on Thomas's Mac in `~/nest-test`,
  set up only from `docs/hosting/hosting-guide.md`: files fetched with
  `curl` from GitHub, `.env` filled in (random secrets, ports 18080/18082),
  its own Cloudflare Tunnel "Nest test" (`nest-test.g3cko.be`,
  `nest-test-api.g3cko.be`), image pulled from GHCR. Over https: super-admin
  account created without invite code via the log code, name and household
  "Test family", web Home showing the server. Same app build (iOS
  simulator): remembered server across restarts; switched from the Pi to
  `nest-test.g3cko.be` by its web address (API found through the served
  config), signed in, Shopping list loaded natively; switched back to
  `nest.g3cko.be` with the sign-out confirmation. One gap found and added
  to the guide's troubleshooting: a router caches "name not found" for a
  new hostname for up to 30 minutes.
- **Self-hosting kit:** `deploy/build-image.sh` (web
  app + server image; `--push` builds arm64+amd64 with buildx), generic
  `deploy/docker-compose.yml` (published image via `NEST_IMAGE` /
  `NEST_VERSION`, ports bound to 127.0.0.1 for an own proxy, Cloudflare
  Tunnel as Compose profile `tunnel`, nightly dump), `deploy/.env.example`,
  `deploy/docker-compose.build.yml` (build from source), and the hosting
  guide in `docs/hosting/hosting-guide.md` and `hosting-guide.nl.md`.
  `deploy/deploy.sh` now builds through the build override.
- **Tests:** 130 server tests (health levels, 10 sign-up tests, registry),
  62 app tests (address parsing, compatibility, discovery, server screen
  flows in EN/NL, About, sign-up with invite code, deep-link redirects,
  cache clear keeps the server).
- **Verified:** a local server started from the generic Compose file (in a
  scratch folder, plain-http override): served config, health, invite-only
  refusal in the web app, super-admin sign-up without code (became
  super-admin), deep link `/shopping` kept through sign-up and onboarding,
  login kept after a full reload via the refresh cookie, nightly dump, and
  the guide's backup + restore commands. iOS simulator: sign-in shows the
  server, Change server to `nest-api.g3cko.be` (the live API-level-1 Pi)
  validated and switched.

### Web shopping list fix (2026-10-28)

- **Symptom:** in built web apps served by the Nest server, the shopping
  screen stayed on a spinner (also on https://nest.g3cko.be).
- **Cause:** Serverpod's `FlutterRoute` adds cross-origin isolation headers
  (COOP/COEP) for WASM builds by default. With them, drift picks its
  `opfsLocks` storage, which hangs in the app (a plain drift test page
  works, so it is something in how the app uses it). Without them, drift uses
  `sharedIndexedDb` through a shared worker and everything works. We ship a
  JS build, so the headers are not needed: `server.dart` now uses
  `FlutterRoute(webApp, enableWasmHeaders: false)`.
- **Not the cause:** the drift worker files. The ones that ship with drift
  2.34.4 work in a real browser; the README procedure stays. Earlier
  "Offline" results came from the in-app test browser, which blocks fetches
  from shared workers and is not usable for checking this.
- **Verified** in headless Brave, driven over the DevTools protocol: release
  web build served by the local Nest server (web server on 8082), signed in
  as seed user Jan, Shopping loads (Weekly shop, stores, 9 to buy), a tap
  moves Bananen to Recently used and survives a reload. The same build with
  the headers reproduces the spinner. 130 server tests pass.
- **To release:** new image version (0.2.1) through the "Server image"
  workflow, then `NEST_VERSION=0.2.1` in the Pi's `.env` and
  `deploy/deploy.sh`. Not done yet (needs Thomas's OK).
- Browsers that already opened https://nest.g3cko.be may have a stuck OPFS
  database; the app opens a different storage after the fix, so no clean-up
  is expected, but check once after the release.

## Next

1. **Thomas:** create the family's accounts at https://nest.g3cko.be (codes in
   `docker compose logs nest` until Resend is set up) and use the list daily.
   For the iPhone, build with `--dart-define=SERVER_URL=https://nest-api.g3cko.be/`.
2. Resend: account + domain `g3cko.be` (DNS records can be added in Cloudflare),
   then `RESEND_API_KEY` in `~/nest/deploy/.env` and `docker compose up -d nest`.
3. **Thomas:** remove the second server when no longer needed
   (`cd ~/nest-test && docker compose down -v`, then delete the "Nest test"
   tunnel and its two hostnames in Cloudflare, and the folder).
4. Release the web shopping list fix (0.2.1) to the Pi, with Thomas's OK.
5. Phase 4 — Tasks (CLAUDE.md section 10).

## Open questions

- **Production email:** Resend chosen; the account, domain verification and API key
  are still to do (codes are logged until then).
- **Claudecraft volume** `world-of-claudecraft_eastbrook_pgdata` is still on the Pi:
  delete it or keep it.
- **Ubuntu 25.10 on the Pi is end of life** and a reboot is pending; upgrading to
  26.04 LTS is Thomas's call (the Nest containers restart on their own).
- **Typing a local http server** (`localhost:8080`) in Change server tries
  https; type `http://localhost:8080`. Fine for production; could try http
  for local addresses later.
- **Test account in the dev database:** `claude-test@nest.test` (household
  "Claude test") was created while verifying phase 2; delete it or keep it for
  later checks.

## Deviations from CLAUDE.md

- **Serverpod 4.x instead of 3.x** (decided by Thomas, 2026-10-27). Embedded PostgreSQL in
  development and tests, no Docker. CLAUDE.md sections 2 and 4 updated.
- **Nunito is bundled as a variable font**; use the `nunito()` helper in `nest_shared` for
  custom text styles (sets the `wght` axis).
- **Three sets of ARB files**: `nest_shared` (shared strings), `nest_flutter/lib/l10n`
  (`app_*.arb`) and `nest_admin/lib/l10n` (`admin_*.arb`). Generated localization files are
  committed.
- **User table:** Serverpod 4's auth user table cannot be extended, so the user fields from
  section 6 live in `nest_user` (linked 1:1 to the auth user). Email stays in the auth
  module's profile.
- **`admin_audit_log` has `at` instead of `createdAt/updatedAt`** (append-only, as in
  section 6).
- **Sign-in UI is Nest's own**, not Serverpod's ready-made `SignInWidget`: that widget's
  error messages are hard-coded English, which conflicts with rule 5.
- **`serverpod_auth_idp_client` is a direct dependency of `nest_flutter`** (part of the
  auth module, pinned 4.0.4) so sign-in errors can be told apart and translated.
- **`nest_server/lib/server.dart`** exposes `createServerpod()` so the seed command can
  start the server on free ports.
- **List members do not restrict access:** every household member can see and edit
  every shopping list; `memberIds` says who uses a list (avatars, later "Going
  shopping" notifications). Tenant isolation stays per household.
- **Recently used is not filtered by store**, only To buy is (with the hidden-items
  hint), so anything bought before can be re-added from any store view.
- **Pure feature logic lives in `features/<feature>/domain/`** (e.g. shopping board
  sorting, catalog search), next to `data/` and `presentation/`.
- **Drift cache stores server rows as JSON** in one generic table per kind instead of
  a typed table per model, so later features (tasks, recipes) reuse it.
- **drift 2.34.4 / drift_dev 2.34.1+1** instead of the newest 2.35: newer drift_dev
  needs `sqlparser` 0.45, which conflicts with Serverpod 4.0.4 in the shared
  workspace. The web files `nest_flutter/web/sqlite3.wasm` and `drift_worker.js` are
  copied from that drift package (see README).
- **API on `nest-api.g3cko.be`** instead of sharing `nest.g3cko.be`: Serverpod serves
  the API and the web app on separate ports, and a one-level subdomain is covered by
  Cloudflare's free certificate (`api.nest.g3cko.be` would not be).
- **Sign-up codes go through Resend** (Thomas's choice), sent with a plain HTTPS call
  (no new package); `ServerpodCloudEmailIdpConfig` was replaced.
- **Invite-only sign-up uses a ticket** (`sign_up_invite`): the auth
  module's registration calls cannot carry an invite code, so the app first
  redeems the code for the email address, and registration checks the ticket.
- **Web app config is generated by the server** instead of baked in with
  `SERVER_URL`, so one web build (and one image) serves every host.
- **Sign-up mode is invite-only in development too** unless `signUpMode:
  'open'` is set in `passwords.yaml` (see the example file).
- The template's `AGENTS.md` (Serverpod MCP workflow) was not copied; CLAUDE.md stays the
  single instruction file.
