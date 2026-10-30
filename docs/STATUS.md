# Nest — Status

## Current phase

**Phase 7 — Watchlist: built (2026-10-30), not released yet.** Server 0.6.0 /
API level 6 (local). Waiting for Thomas: release to the Pi with a TMDB key,
then phase 8 (Admin + backups).

Phase 6 (Meal Planning) is done and released as 0.5.0.

Phase 5 (Recipes) is done and released as 0.4.0.

Phase 4 (Tasks) is done and released as 0.3.0.

Phase 3 (Bring your own backend) is done and its gate passed (2026-10-28).

Phase 2 (Shopping List) is deployed at https://nest.g3cko.be (API
https://nest-api.g3cko.be); its gate ("Thomas's household can use it daily")
is with Thomas. The web shopping list bug is fixed and released in 0.2.1
(see "Web shopping list fix" below).

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
- **Released (2026-10-28, with Thomas's OK):** server version 0.2.1, tag
  `v0.2.1`; the tag push triggered the "Server image" workflow this time and
  published `ghcr.io/thomasrooyakkers/nest-server:0.2.1` and `:latest`.
  Pi: `NEST_VERSION=0.2.1` in `~/nest/deploy/.env` (backup `.env.bak-*` next
  to it), `deploy/deploy.sh` (dump `nest-pre-update-20261028-164608.sql.gz`).
  Verified over https: health 0.2.1, no COOP/COEP headers, and the live web
  app opens its database as `sharedIndexedDb` in headless Brave. The
  shopping screen itself was not opened on production (no account used).
- Browsers that already opened https://nest.g3cko.be may have a stuck OPFS
  database; the app opens a different storage after the fix, so no clean-up
  is expected, but check once after the release.

### Phase 4 — Tasks (2026-10-28)

- **Model + migration `20261028165035809`:** `task` (household, title,
  notes, assignee, `dueDate` + `dueMinutes`, recurrence none/daily/weekly/
  monthly, `doneAt`, `doneBy`, `nextTaskId`), enum `TaskRecurrence`,
  `TaskEvent` (live updates).
- **Endpoint `task`** (all guarded with `HouseholdGuard.require(...,
  feature: tasks)`, in `endpoint_registry.dart`): `tasks` (open tasks plus
  those done in the last 30 days), `save` (create or update; trims and
  validates, assignee must be a member, a time needs a date, a recurring
  task needs a date), `setDone` (check off or reopen; returns a
  `TaskEvent`), `remove`, and the streaming `watch`.
- **Recurrence** (`services/task_recurrence.dart`): completing a recurring
  task creates the next occurrence on the server, due on the first step
  after both its due date and the day it was done (the app sends its own
  calendar day), so a task done late never comes back overdue. Monthly
  keeps the day of the month where it exists, else the month's last day.
  Reopening removes the next occurrence again unless that was done too. No
  future call is needed.
- **Leaving a household** unassigns that member's tasks there.
- **API level 3**, server version 0.3.0. The app (API level 3) hides the
  Tasks tab on servers below level 3 (rule 6); while the server has not
  answered, the tab stays visible so cached tasks work offline.
- **Tests:** isolation test covers every task method for household B plus
  "household A's id with B's task" and "assigned to a member of B";
  16 task endpoint tests and 8 recurrence unit tests. 172 server tests.
- **Seed:** eight tasks per seed household around today (overdue, today
  with a time, tomorrow, recurring daily/weekly/monthly, undated, one done).
- **App:** Tasks tab with title, filter chips Mine / Everyone / Overdue (with
  a count) / Done (remembered on the device; Everyone by default), one card
  with a row per task: round check-off box (own semantics node), title, due
  label ("Today · 8:00 PM", "Overdue · Yesterday"; overdue as a warning
  badge), repeat icon, assignee avatar; done tasks show "Done by …".
  Checking off shows a snack bar with Undo. "+" opens a sheet with title,
  notes, who (Anyone + members), when (No date / Today / Tomorrow / pick a
  date, optional time) and repeat. Tap a task to edit or delete it. Strings
  in EN and NL. "Tasks" left the home screen's "Coming soon" card.
- **Offline + realtime:** `TaskRepository` like shopping: cache in drift,
  changes applied locally and queued, temp ids for tasks created offline,
  refused changes dropped and the cache restored. The reconnect loop is now
  shared (`core/backend/live_sync.dart`, used by shopping and tasks).
  The queue of pending changes has a `feature` column (drift schema 2,
  migration keeps old queued changes as shopping changes), so the two
  syncs never send or drop each other's changes.
- **App tests (91):** task logic (overdue, due kinds, filters, order),
  repository (offline queue, temp ids, edit of an offline task, recurring
  next occurrence, refused change, live events, separate queues, drift
  migration from schema 1), screen (labels, filters, check-off with next
  occurrence and Undo, create, edit/delete, live add, offline notice, tab
  hidden on API level 2, Dutch with text scale 2).
- **Verified** against the local server (migration applied, seed run):
  signed in as seed user Jan over the API, the seeded tasks load;
  completing the weekly "Take out the bins" (due today) created the next one
  on 4 November and reopening removed it; Jan gets `notAMember` for
  household "Home". The Tasks screen layout was checked in the in-app
  browser (release web build): chips, offline notice, "+" above the tab
  bar. **Not verified on a device:** the in-app browser cannot open the
  web database (known, see the web fix below) and driving the simulator
  sign-in was unreliable; the widget tests cover the screen flows.
- **Released (2026-10-28, with Thomas's OK):** tag `v0.3.0`; CI (analyze,
  format, tests) passed and the "Server image" workflow published
  `ghcr.io/thomasrooyakkers/nest-server:0.3.0` and `:latest`. Pi:
  `NEST_VERSION=0.3.0` in `~/nest/deploy/.env` (backup `.env.bak-*` next to
  it), `deploy/deploy.sh` (dump `nest-pre-update-20261028-174424.sql.gz`).
  Verified over https: health 0.3.0 / API 3, migration `20261028165035809`
  applied, `task.tasks` answers `notSignedIn` without a login, web app and
  served config OK. The Tasks screen itself was not opened on production
  (no account used).

### Phase 5 — Recipes (2026-10-28)

- **Decisions (Thomas, 2026-10-28):** photos are stored in Postgres
  (Serverpod's database file storage), so the nightly dump backs them up
  and hosts need no extra volume; new app dependencies `image_picker` 1.2.4
  and `wakelock_plus` 1.8.2.
- **Models + migration `20261028180741556`:** `recipe` (household, title,
  description, `photoPath`, servings, prep/cook minutes, tags, favourite,
  created by), `recipe_ingredient` (position, quantity, unit, name, note)
  and `recipe_step` (position, text), both cascading with their recipe;
  `RecipeEvent` (live updates) and `AddedShoppingItems`.
- **Endpoint `recipe`** (all guarded with `HouseholdGuard.require(...,
  feature: recipes)`): `recipes` (with ingredients and steps), `save`
  (create or update; trims, drops empty rows, renumbers, replaces
  ingredients and steps; leaves photo and favourite alone), `setFavorite`
  (shared by the household), `setPhoto` (JPEG/PNG/WebP by magic bytes, at
  most 1 MB, random path per photo, old file deleted; null removes it),
  `photo` (bytes only through the guard, no public URLs), `remove` (also
  deletes the photo) and the streaming `watch`.
- **`shopping.addItems`** adds several items in one transaction, skips those
  already to buy (matched through the catalog in both languages) and notes
  `sourceRecipeId` (must be the household's recipe). `addItem` shares the
  same code.
- **Server config:** file storage is registered explicitly as
  `DatabaseCloudStorage` (the template's Serverpod Cloud wrapper and the
  `serverpod_cloud_storage` dependency are gone); `maxRequestSize` is 2 MB
  in development, staging and production so a 1 MB photo fits.
- **API level 4**, server version 0.4.0. The app (API level 4) shows
  recipes only on servers with level 4 and the recipes feature switched on.
- **Tests:** isolation test covers every recipe method and `addItems` for
  household B, plus "household A's id with B's recipe" and "A's list with
  B's recipe"; 10 recipe endpoint tests, 3 `addItems` tests. 216 server
  tests.
- **Seed:** three recipes per seed household (Pancakes, Spaghetti
  bolognese, Pumpkin soup) with ingredients and steps, no photos.
- **App:**
  - **Home** gets a Recipes card (rose) that opens the library; Recipes
    left the "Coming soon" card. Recipes have no tab (CLAUDE.md section 8).
  - **Library** (`/recipes`): search (title, tags, ingredients,
    description), Favourites chip and a chip per tag, cards with photo,
    total time, servings, tags and a favourite heart, "+" for a new recipe.
  - **Recipe** (`/recipes/:id`): photo, description, prep/cook time, tags,
    servings stepper that rescales the amounts (kitchen fractions such as
    ½ and ¾ for small amounts, locale number format), "Add to list",
    numbered steps, "Start cooking", menu with Edit and Delete.
  - **Editor** (full screen): photo (camera or library where available,
    resized in the app to at most 1600 px, JPEG quality 80), title,
    description, servings, minutes, tags, ingredients (name, amount, unit,
    note; amounts accept "1,5", "1.5", "½" and "1 1/2"), steps (add, move
    up, remove). Asks before discarding changes.
  - **Cooking mode** (full screen): one step at a time in large text,
    progress bar, Previous/Next, the scaled ingredients in a sheet, screen
    kept awake (`wakelock_plus`; ignored where unsupported).
  - **Add to list** sheet: pick the list, ingredients already to buy there
    are unticked ("On the list"), amounts at the chosen servings become
    the item spec (the note when there is no amount).
- **Offline + realtime:** recipes and photos (by path) are cached in drift
  and readable offline, including cooking mode; changes need a connection
  (like list and store edits), with an offline notice on the screens.
  Live updates through the shared `LiveSyncLoop`.
- **iOS/macOS:** camera and photo library texts in English and Dutch
  (`InfoPlist.strings`), and the user-selected-files entitlement on macOS.
- **App tests (122):** scaling, fractions, parsing amounts, shopping spec,
  catalog-aware "on the list", filtering; repository (cache, offline read,
  failed change offline, live events, photo cache by path); screens
  (library search and filters, favourite, stepper, Add to list, create,
  discard, cooking mode, delete, hidden on API level 3, Dutch with text
  scale 2).
- **Verified** against the local server (migration applied, seed run,
  release web build served on 8082): over HTTP as seed user Jan, a 280 KB
  JPEG round-trips through Postgres, a 1.1 MB upload is refused by the size
  check (so the larger request limit works), `addItems` skips what is
  already to buy and Jan gets `notAMember` for household "Home". In
  headless Brave at phone size, signed in as Jan (Dutch): Home card,
  library with photo and favourite, recipe screen, stepper (6 servings:
  375 g, ¾ l, 3), Add to list (skipping, snack bar), cooking mode with
  scaled ingredients, editor, saving an edit. This found that the
  add-to-list preview missed items named in the other language, now fixed.
  **Not verified:** picking a photo through the file or camera picker (the
  upload path itself was verified over HTTP), and the app on a phone.
- **Released (2026-10-28, with Thomas's OK):** tag `v0.4.0`; CI (analyze,
  format, tests) passed and the "Server image" workflow published
  `ghcr.io/thomasrooyakkers/nest-server:0.4.0` and `:latest`. Pi:
  `NEST_VERSION=0.4.0` in `~/nest/deploy/.env` (backup `.env.bak-*` next to
  it), `deploy/deploy.sh` (dump `nest-pre-update-20261028-192459.sql.gz`).
  Verified over https: health 0.4.0 / API 4, migration `20261028180741556`
  applied (no recipes yet), `recipe.recipes` answers `notSignedIn` without
  a login, web app and served config OK. The recipe screens were not opened
  on production (no account used).

### Phase 6 — Meal Planning (2026-10-30)

- **Models + migration `20261030092904205`:** `meal_plan_entry` (household,
  `date` as 00:00 UTC like task due dates, `slot` breakfast/lunch/dinner,
  optional recipe with `onDelete=SetNull`, `freeText`, optional `servings`,
  `prepAheadNote`, created by; unique per household, day and slot), enum
  `MealSlot`, `MealPlanEvent` (live updates), and `household.mealSlots`
  (meals planned besides dinner; null = dinner only).
- **Endpoint `mealPlan`** (all guarded with `HouseholdGuard.require(...,
  feature: mealPlanning)`): `entries` (a date range, at most 93 days),
  `save` (create or change, including moving to another day; a meal already
  planned on that day and slot is replaced; checks the slot is switched on,
  the recipe belongs to the household and the lengths; with a recipe the
  server stores its title in `freeText`), `remove` and the streaming
  `watch`. **`household.setMealSlots`** (owners) switches breakfast and lunch
  on or off. Deleting a recipe keeps its planned meals as free text with the
  title and tells meal plan watchers.
- **API level 5**, server version 0.5.0. The app (API level 5) hides the
  Meals tab on servers below level 5.
- **Tests:** isolation test covers every meal plan method and
  `setMealSlots` for household B, plus "household A's id with B's meal" and
  "with B's recipe"; 13 meal plan endpoint tests. 247 server tests.
- **Seed:** per seed household, yesterday "Leftovers", the seeded recipes
  today, tomorrow (with a prep-ahead note) and in five days, "Pizza night"
  and next week "Dinner at grandma's".
- **App:**
  - **Meals tab** (`/meals`): title with (owners) a "Meals to plan" button
    for breakfast and lunch, previous/next week with "This week", "Next
    week", "Last week" or the dates and "Back to this week", a strip of the
    seven days (today in honey, a dot on planned days; tapping scrolls to
    that day) and a card per day. Title, week and strip stay put; the days
    scroll, and this week opens at today. Weeks start on Monday for
    everyone.
  - **Day card:** each planned slot (labels only when more than dinner is
    planned) as a honey tile with title, servings, the prep-ahead note and
    "Open recipe" (`/meals/recipes/:id`, at the meal's servings), or a
    dashed "+ Plan dinner".
  - **Meal sheet:** Recipe or Something else, a recipe list (with search
    from six recipes), servings stepper, day (date picker, moves the meal),
    prep-ahead note, Save and Remove from the plan; errors show in the
    sheet.
  - The dashed "add" outline moved to `nest_shared` (`DashedPillPainter`);
    Meals left the home screen's "Coming soon" card.
- **Offline + realtime:** planned meals are cached in drift per week shown
  and readable offline; changes need a connection (like recipes). Live
  updates through `LiveSyncLoop`, one sync per shown week.
- **App tests (146):** week logic (Monday start, month/year end, time
  change), slots, titles and servings; repository (cache per week, offline
  read, replace on the same day, failed change offline); screen (week,
  open at today, strip scroll, previous/next, plan free text, plan recipe
  with servings, open recipe at servings, move and remove, live add, lunch
  for owners only, offline notice, failed save, hidden on API level 4,
  Dutch with text scale 2).
- **Verified** against the local server (migration applied, seed run,
  release web build served on 8082) in the in-app browser at phone size,
  signed in as seed user Jan (Dutch): the week opens at today with the
  seeded meals, the strip scrolls to a day, planning Pumpkin soup with a
  note on Sunday saves and shows, "Recept openen" opens the recipe at 6
  servings inside the Meals tab, and switching Lunch on adds a lunch slot to
  every day (switched off again). This found that the lazy list could not
  scroll the strip to days not yet built and that the strip scrolled away;
  both fixed. **Not verified:** the app on a phone, and the 10 px gap under
  the strip added after the browser check (covered by the widget tests).
- **Released (2026-10-30, with Thomas's OK):** tag `v0.5.0`; CI (analyze,
  format, tests) passed on `5f07198` and the "Server image" workflow
  published `ghcr.io/thomasrooyakkers/nest-server:0.5.0` and `:latest`
  (arm64 + amd64). Pi: `NEST_VERSION=0.5.0` in `~/nest/deploy/.env` (backup
  `.env.bak-*` next to it), `deploy/deploy.sh` (dump
  `nest-pre-update-20261030-100839.sql.gz`). Verified over https: health
  0.5.0 / API 5, migration `20261030092904205` applied (no meals planned
  yet), `mealPlan.entries` answers `notSignedIn` without a login, web app and
  served config OK. The Meals screen was not opened on production (no
  account used).

### Phase 7 — Watchlist (2026-10-30)

- **Models + migration `20261030101948724`:** `watchlist_item` (household,
  `tmdbId`, `type` movie/series, title, posterPath, year, TMDB `rating`,
  `status` want/watching/watched, added by, `householdRating` 1–5; unique
  per household, type and TMDB id), enums `WatchType` and `WatchStatus`,
  `TmdbTitle` (a search result), `WatchlistEvent` (live updates), error
  code `filmDataUnavailable`.
- **Film data (`services/tmdb_service.dart`):** `TmdbService` with
  `HttpTmdbService` (TMDB API v3 `search/multi` and details, in the
  caller's language en-US/nl-NL; takes a v3 API key or a v4 read access
  token; uses `dart:io`, no new dependency) and `FakeTmdbService` (20 films
  and series, some with Dutch titles, no posters). The host setting
  `tmdbApiKey` (`TMDB_API_KEY` in `deploy/.env`) picks the real one;
  without it the server uses the fake.
- **Endpoint `watchlist`** (all guarded with `HouseholdGuard.require(...,
  feature: watchlist)`): `items`, `search` (1–100 characters), `add` (by
  type and TMDB id; the server fetches the details itself instead of
  trusting the app; a title already on the list is returned as it is),
  `setStatus`, `setRating` (1–5 or null), `remove` and the streaming
  `watch`. TMDB failures become `filmDataUnavailable`.
- **API level 6**, server version 0.6.0. The app (API level 6) hides the
  Watch tab on servers below level 6.
- **Tests:** isolation test covers every watchlist method for household B
  plus "household A's id with B's item"; 11 watchlist endpoint tests (with
  an unreachable TMDB) and 4 TMDB parsing tests. 286 server tests.
- **Seed:** per seed household 8 titles from the fake film data (4 to
  watch, 2 watching, 2 watched with a rating), added by different members.
- **App:**
  - **Watch tab** (`/watch`): "Find a film or series" button, status chips
    Want to watch / Watching / Watched with counts (remembered on the
    device), "Pick something for tonight" on Want to watch, and a
    three-column grid of 2:3 posters (lavender placeholder with a film or
    TV icon when there is no poster) with title, type · year, TMDB rating
    (or our hearts when rated) and the avatar of who added it. The TMDB
    attribution line is under the grid, on the search screen and on About.
  - **Search** (`/watch/search`): searches 400 ms after typing, rows with
    poster, title, type · year, rating and overview, "+" to add or "On the
    list".
  - **Item sheet:** status, our rating (five hearts, tap again or "Clear
    rating" to clear) and Remove from the watchlist.
  - **Tonight:** a random title from Want to watch, "Pick another" (never
    the same one twice in a row) and "Start watching" (moves it to
    Watching).
  - Posters load from `image.tmdb.org` (w342) directly; on the web with
    the `<img>` fallback, as TMDB's images may not allow cross-origin reads.
  - The home screen's "Coming soon" card and the `ComingSoonScreen`
    placeholder are gone (every tab now has its feature).
- **Offline + realtime:** the watchlist is cached in drift and readable
  offline; searching and changes need a connection (like recipes and
  meals). Live updates through `LiveSyncLoop` while the tab is open.
- **App tests (169):** logic (per status, newest first, counts, tonight's
  pick and pick another, on the list, poster urls), repository (cache,
  offline read, add/change/remove, failed change, live events) and screen
  (grid with details and attribution, status tabs, search and add, no
  results, film data error, status and rating in the sheet, remove,
  tonight's pick, live add, offline notice, hidden on API level 5, Dutch
  with text scale 2).
- **Hosting:** `TMDB_API_KEY` in `deploy/.env.example`, the Compose file
  and `passwords.yaml.example`; "Film data" section in the hosting guide
  (EN/NL).
- **Verified** against the local server (migration applied, seed run,
  release web build served on 8082) in the in-app browser at phone size,
  signed in as seed user Jan (Dutch): the seeded watchlist with counts,
  searching "planeet" found the Dutch titles, adding "Planeet Aarde" put
  it first on Wil ik zien and showed "Op de lijst", tonight's pick,
  setting Bluey to Gezien with 4 hearts moved it to the Gezien tab with
  the counts updated. A chip of the current status looked disabled in the
  sheet; fixed after the browser check (covered by the widget tests).
  **Not verified:** the real TMDB service (no key on this Mac) and real
  posters; the app on a phone.

## Next

1. **Thomas:** create the family's accounts at https://nest.g3cko.be (codes in
   `docker compose logs nest` until Resend is set up) and use the list daily.
   For the iPhone, build with `--dart-define=SERVER_URL=https://nest-api.g3cko.be/`.
2. Resend: account + domain `g3cko.be` (DNS records can be added in Cloudflare),
   then `RESEND_API_KEY` in `~/nest/deploy/.env` and `docker compose up -d nest`.
3. **Thomas:** remove the second server when no longer needed
   (`cd ~/nest-test && docker compose down -v`, then delete the "Nest test"
   tunnel and its two hostnames in Cloudflare, and the folder).
4. **Thomas:** try Tasks, Recipes and the meal plan on the web and on the
   iPhone build (taking a photo needs the phone).
5. **Thomas:** create a TMDB API key (themoviedb.org → Settings → API) and
   decide on releasing 0.6.0. Releasing: tag `v0.6.0`, let CI publish the
   image, set `NEST_VERSION=0.6.0` and `TMDB_API_KEY` in `~/nest/deploy/.env`
   on the Pi, run `deploy/deploy.sh`, then check a real search.
6. Phase 8 — Admin + backups (CLAUDE.md section 10).

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

- **TMDB is picked by the key, not a `tmdb: fake|tmdb` setting:** with
  `tmdbApiKey` set the server uses TMDB, without it the fake film data. A
  host without a key gets sample titles instead of an error.
- **`householdRating` is 1–5 hearts**, shared by the household; the grid
  shows it instead of TMDB's rating once set.
- **"Pick something for tonight" picks from Want to watch only.**

- **Tasks store `dueDate` + `dueMinutes` instead of `dueAt`:** the due day is
  a calendar day (00:00 UTC, the same for everyone in the household) and the
  time is optional wall-clock minutes, so recurrence never shifts across
  daylight saving changes and "due some time today" is possible.
- **Next occurrences are created when a task is checked off** (in the
  `setDone` call), not by a future call.
- **Mine shows only tasks assigned to me**, not unassigned ones.
- **Recipes store `photoPath` instead of `photoUrl`:** photos are private
  files served through the guarded `recipe.photo` method, not public URLs.
- **Recipe changes need a connection** (reading and cooking work offline);
  queuing photo uploads offline was not worth the complexity.
- **Favourites are per household** (as in section 6), not per member.
- **Meal plan weeks start on Monday** for everyone, so members with
  different languages see the same weeks.
- **A recipe meal also stores the recipe's title** (`freeText`), so it keeps
  its name when the recipe is deleted; the app shows the recipe's current
  title while it exists.
- **Breakfast and lunch are switched on by owners on the meal plan screen**
  (`household.setMealSlots`), not in settings: there is no feature toggle UI
  yet.
- **Add to list lets the user untick ingredients** before adding; items
  already to buy start unticked and the server skips them anyway.

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
