# Nest — Status

## Current phase

**Phase 1 — Foundation: done (2026-10-27). Gate met: isolation tests pass.**
Waiting for Thomas before starting phase 2 (Shopping List).

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

## Next (phase 2 — Shopping List)

1. Models: `shopping_list`, `store`, `catalog_item` (built-in + per household),
   `shopping_item`; seed built-in catalog (EN/NL names, categories) and sample stores.
2. Endpoints, all guarded and added to `endpoint_registry.dart` + isolation test.
3. Realtime sync via Serverpod streaming; drift offline cache.
4. Screens: list switcher, search/add, store chips with category order, To buy / Recently
   used tile grids, bottom tab bar.
5. **Ask Thomas** about icons for the catalog (openly licensed food icon set or custom) and
   about deploying to the Pi at the end of phase 2 (needs a real mail sender, see below).

## Open questions

- **Production email.** Verification and reset codes are only logged in development. The
  Pi deployment needs a real sender (e.g. SMTP via `EmailIdpConfigFromPasswords` with a
  custom send function). Needs a mail account/provider choice from Thomas before phase 2
  deployment.
- **Active household is not remembered** across app restarts (the app starts with the
  first household alphabetically). Planned to store it locally once drift is added in
  phase 2.

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
- The template's `AGENTS.md` (Serverpod MCP workflow) was not copied; CLAUDE.md stays the
  single instruction file.
