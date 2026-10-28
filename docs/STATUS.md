# Nest — Status

## Current phase

**Phase 2 — Shopping List: built (2026-10-28), at the gate.**
Gate: "Thomas's household can use it daily". Needs Thomas's go-ahead to deploy
to the Pi (and a mail provider for sign-up codes, see open questions) before
phase 3 (Tasks + push).

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

## Next

1. **Thomas:** use the shopping list at home; decide on the Pi deployment and a
   mail provider for sign-up/reset codes (see open questions).
2. Phase 3 — Tasks + push: tasks with recurrence, notification preferences,
   future calls for reminders, `FakePushService`, deep links.

## Open questions

- **Production email.** Verification and reset codes are only logged in development. The
  Pi deployment needs a real sender (e.g. SMTP via `EmailIdpConfigFromPasswords` with a
  custom send function). Needs a mail account/provider choice from Thomas before phase 2
  deployment.
- **Pi deployment** (phase 2 gate): not done yet; waiting for Thomas's go-ahead.
- **Deep links lost at app start:** opening the app on a URL such as `/#/shopping`
  lands on Home, because the start/sign-in redirect does not keep the original
  location. To fix in phase 3 together with notification deep links.
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
- The template's `AGENTS.md` (Serverpod MCP workflow) was not copied; CLAUDE.md stays the
  single instruction file.
