# CLAUDE.md — Nest

This file tells Claude Code everything it needs to build **Nest**, a family household app, starting from an empty folder. Read it fully at the start of every session, then read `docs/STATUS.md` (create it if missing) to see where the project stands.

---

## 1. What Nest is

Nest is a private, bilingual (English + Dutch) family app for iOS, Android and web, built with Flutter. One self-hosted, multi-tenant backend serves several households (Thomas's family and relatives). Each household sees only its own data. A separate admin portal lets the super-admin (Thomas) manage households, users, backups and system health.

**v1 features:** Dashboard, Shopping List (Bring!-style tiles, multiple lists, manually added stores), Recipes, Meal Planning, Tasks, Watchlist (TMDB), opt-in push reminders and notifications, admin portal.

**Out of scope for v1:** expenses, notes, calendar, general file storage, recipe import from websites, sending a whole week's meal plan to the shopping list, paid subscriptions.

**Production target (later, not now):** a Raspberry Pi at home running Docker Compose, reachable through a Cloudflare Tunnel at `nest.g3cko.be` (app/API) and `nest-admin.g3cko.be` (admin portal, behind Cloudflare Access).

---

## 2. How to work in this repo

- **Local-first.** Everything must run on a Mac with no external accounts or API keys. External services (Google sign-in, Apple sign-in, FCM/APNs push, TMDB, OneDrive, Cloudflare) sit behind interfaces with a **fake implementation** used by default in development. Real implementations are added later and switched on by configuration.
- **Work phase by phase** (section 10). Finish a phase, meet its gate, update `docs/STATUS.md`, then stop and summarize for Thomas before starting the next phase. Never skip a gate.
- **Small steps, always green.** After each meaningful change: run `serverpod generate` if models or endpoints changed, run the tests, fix failures, then commit with a short conventional message (`feat:`, `fix:`, `test:`, `chore:`, `docs:`).
- **Ask before** adding a dependency that is not listed in section 4, changing a decision in this file, or deleting data or migrations. When something is ambiguous, ask one clear question rather than guessing.
- **Keep `docs/STATUS.md` current:** current phase, what is done, what is next, open questions, and any deviations from this file with the reason.
- **Verify versions.** Use the latest stable Flutter and Serverpod 3.x releases. Check the official Serverpod documentation for the exact CLI install command, auth module and APIs of the installed version rather than relying on memory, and pin versions in `pubspec.yaml`.

---

## 3. Non-negotiable rules

1. **Tenant isolation is enforced on the server.** Every household-scoped endpoint method starts with `HouseholdGuard.require(session, householdId)`, which verifies that the signed-in user has a membership in that household and throws otherwise. Every query filters on `householdId`. On create/update, the server sets `householdId` itself; never trust the value sent by the client.
2. **Admin endpoints** live under `endpoints/admin/` and start with `AdminGuard.require(session)`, which checks `isSuperAdmin` on the server. Admin endpoints return metadata and counts only, never household content (no list items, recipe text, task titles). Every admin action writes an `admin_audit_log` row.
3. **Isolation tests come first.** Before any feature exists, there is a test that creates two households and asserts that a user of household A gets nothing back, and an error, from every endpoint for household B. Every new endpoint is added to this test. A second test asserts that a normal user gets an error from every admin endpoint.
4. **No secrets in Git.** Passwords, API keys, service-account files, restic passwords and rclone tokens live in untracked env files (`.env`, `config/passwords.yaml`); commit only `*.example` versions. Make sure `.gitignore` covers them from the first commit.
5. **Bilingual from the first screen.** No hard-coded user-facing strings. All text goes through gen-l10n ARB files (`app_en.arb`, `app_nl.arb`) with both languages filled in. Dates, weekdays and numbers are formatted per locale with `intl`. User content (recipes, items, tasks) is shown as entered, never translated. Push message texts are localized on the server using the user's stored `locale`.
6. **Notifications are off by default.** The app asks for push permission only when a user switches on their first notification type.
7. **Accessibility:** touch targets at least 44×44, text contrast at least 4.5:1, semantic labels on icon-only buttons, support for system text scaling.

---

## 4. Tech stack

| Layer | Choice |
| --- | --- |
| App | Flutter (stable), Dart |
| State | Riverpod with code generation (`flutter_riverpod`, `riverpod_annotation`, `riverpod_generator`) |
| Navigation | `go_router` (deep links, also from notifications; auth redirects) |
| Localization | `flutter_localizations`, gen-l10n (ARB), `intl` |
| Local cache / offline | `drift` (SQLite) for shopping list, tasks and recipes |
| Backend | Serverpod 3.x (Dart): endpoints, generated client, ORM, migrations |
| Database | PostgreSQL (Docker locally, or Serverpod's embedded Postgres if the installed version offers it) |
| Realtime | Serverpod streaming (WebSockets) for shopping list and tasks |
| Scheduling | Serverpod future calls for reminders, overdue checks and the daily summary |
| Auth | Serverpod's official auth module: email + password now; Google sign-in, and Sign in with Apple on iOS, later |
| Push (later) | Firebase Cloud Messaging HTTP v1 (APNs via FCM). Fake service in development |
| Film data (later) | TMDB API, called from the server only. Fake service with fixtures in development |
| Backups (later) | `pg_dump` + restic to an NFS share and to OneDrive (via rclone) |
| Admin portal | Flutter web app in the same repo |
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
      future_calls/    # reminders, overdue checks, daily summary
      services/        # HouseholdGuard, AdminGuard, push, tmdb, notifications (fake + real)
    migrations/
    config/            # development.yaml, test.yaml, production.yaml (+ passwords.yaml, untracked)
    test/              # integration tests incl. isolation tests
  nest_client/         # generated, never edit by hand
  nest_shared/         # shared Flutter package: theme, design tokens, common widgets, l10n
  nest_flutter/        # the mobile/web app
    lib/
      main.dart
      app/             # app widget, theme wiring, go_router config
      l10n/            # app_en.arb, app_nl.arb
      core/
        backend/       # Serverpod client, session, connection state
        database/      # drift cache
        household/     # active household, feature toggles
        notifications/ # permission flow, token registration, deep links
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

## 6. Data model (Serverpod `.spy.yaml`)

All feature tables carry `householdId`. Timestamps (`createdAt`, `updatedAt`) on every table.

| Table | Key fields | Notes |
| --- | --- | --- |
| users (auth module) | name, email, locale (en/nl), isSuperAdmin, disabledAt | Extend via a profile table if the auth module's user table cannot be extended |
| households | name, status (active/suspended), enabledFeatures, inviteCode, inviteExpiresAt | Features toggle per household |
| memberships | userId, householdId, role (owner/member) | A user can belong to several households |
| shopping_lists | householdId, name, memberIds | Several lists per household (e.g. weekly shop, DIY store) |
| stores | householdId, name, color, address, categoryOrder | Added manually; category order follows the store's layout |
| catalog_items | householdId (null = built-in), nameEn, nameNl, iconKey, category | Built-in catalog plus household's own items |
| shopping_items | householdId, listId, catalogItemId, name, spec, storeIds (empty = any store), status (toBuy/recent), addedBy, sourceRecipeId | Tiles move between To buy and Recently used |
| recipes | householdId, title, description, photoUrl, servings, prepMinutes, cookMinutes, tags, isFavorite, createdBy | |
| recipe_ingredients | recipeId, position, quantity, unit, name, note | Structured so servings scale |
| recipe_steps | recipeId, position, text | |
| meal_plan_entries | householdId, date, slot (dinner; breakfast/lunch optional), recipeId or freeText, servings, prepAheadNote | |
| tasks | householdId, title, notes, assigneeId, dueAt, remindAt, recurrence (none/daily/weekly/monthly), doneAt | Completing a recurring task creates the next one |
| watchlist_items | householdId, tmdbId, type (movie/series), title, posterPath, year, rating, status (want/watching/watched), addedBy, householdRating | |
| devices | userId, fcmToken, platform, lastSeenAt | Stale tokens removed when FCM rejects them |
| notification_prefs | userId, householdId, per-type on/off (all off by default), quietHoursStart, quietHoursEnd | |
| backup_runs | startedAt, finishedAt, status, sizeBytes, snapshotId, target, error | Written by the backup job |
| backup_requests | requestedBy, requestedAt, pickedUpAt | "Back up now" from the admin portal |
| admin_audit_log | adminId, action, targetType, targetId, details, at | Append-only |

Child tables without `householdId` (recipe_ingredients, recipe_steps) are only reachable through their parent, after the guard has checked the parent's household.

---

## 7. Feature specifications

**Dashboard.** Greeting with today's date and a household switcher in the header. Tonight's dinner from the meal plan with "Open recipe". Two tiles: items to buy (opens Shopping) and tasks due today (opens Tasks). Today's tasks with check-off, reminder time and assignee avatar. Next item on the watchlist. Cards hide when a feature is disabled for the household.

**Shopping List (Bring!-style, own design and icons).** List switcher in the header with member avatars. Search field "What do you need?" that adds from the catalog or creates an own item. Store chips (All stores + each store + "Add store"): picking a store shows only items for that store or "any store", ordered by that store's category order, with a hint how many items are hidden. "To buy" grid of tiles (3 columns, icon, name, spec) in the accent colour; tapping a tile moves it to "Recently used". "Recently used" grid of light tiles; tapping adds it back. Live sync for everyone on the list, works offline. Optional "Going shopping" / "Done shopping" notifications. Later: photo per item.

**Recipes.** Create/edit with title, photo, servings, prep and cook time, tags, structured ingredients and numbered steps. Servings stepper that rescales amounts. Favourite toggle. Search and filter by tag and favourites. Cooking mode (large text, screen stays awake). "Add to list" adds the recipe's ingredients to the shopping list, skipping items already on it.

**Meal Planning.** Week strip of seven days with previous/next week buttons, one card per day showing dinner, "+ Plan dinner" on empty days. A day is filled from the recipe library or free text. Servings and a "prep ahead" note per meal. Breakfast and lunch slots can be switched on per household (off by default). There is deliberately no "add the week's ingredients to the list" feature.

**Tasks.** Filter chips: Mine, Everyone, Overdue, Done. Each task: check-off, title, due label (overdue highlighted), recurrence and reminder indicators, assignee avatar. Floating "+" button for a new task. Recurring tasks create their next occurrence on completion.

**Watchlist.** Search films and series via the server (TMDB). Status tabs: Want to watch, Watching, Watched. "Pick something for tonight" chooses a random title. Three-column poster grid (2:3 posters) with title, type, year, rating and who added it. Show the TMDB attribution line on the watchlist and the About screen: "This product uses the TMDB API but is not endorsed or certified by TMDB." IMDb is not used (no public API, scraping not allowed).

**Notifications** (all off by default, per user, per household, with quiet hours): task reminder at `remindAt`, task overdue (morning after), task assigned to you, meal prep reminder (evening before, if a prep-ahead note exists), daily summary, shopping list changed (bundled per 10 minutes), new on the watchlist. Tapping a notification deep-links to the right screen.

**Admin portal** (`nest_admin`, Flutter web). Side menu: Households, Users, Backups, System health, Notifications, Audit log; stacks on narrow screens. Households page: summary cards (last backup, server health, SSD free space), table with name, owner, members, enabled features, last activity, status, and a Suspend/Reactivate action. Backups: recent runs, "Back up now". Restores stay a documented command-line task; the portal only shows the command and the snapshot to use.

---

## 8. Design system ("warm and cozy")

Implement these tokens once in `nest_shared` as a `ThemeData` plus a `NestColors` theme extension. Bundle the Nunito font files as assets (do not fetch fonts at runtime).

| Token | Value | Use |
| --- | --- | --- |
| background | #FAF5EE | screen background (soft linen) |
| surface | #FFFFFF | cards, inputs, tab bar |
| surfaceAlt | #F6EFE5 | admin side menu |
| chip | #F3EADF | neutral buttons, inactive segments |
| border | #EDE3D6 | card and tab bar borders |
| borderStrong | #E3D7C7 | input borders |
| divider | #F2EBE1 | rows inside cards |
| checkboxIdle | #C9BBAA | unchecked boxes, dashed "add" buttons |
| ink | #2B2420 | primary text, dark buttons |
| inkMuted | #6B5E55 | secondary text |
| accent | #3F6B57 | primary actions, checked state, To buy tiles (sage) |
| accentDark | #2E5242 | text on accent tint |
| accentTint | #E4EEE6 | active tab, shopping tint |
| honey / honeyInk | #F8EBC8 / #6E5110 | meals |
| apricot / apricotInk | #FBE7D6 / #8A4A1C | tasks |
| lavender / lavenderInk | #E9E3F3 / #4B3D72 | watchlist |
| rose / roseInk | #F6E1DD / #7A3A30 | recipes |
| warning / warningInk | #FBE0CC / #8A3A12 | overdue, backup warnings |

- **Type:** Nunito. Screen titles 28/800, card titles 22/800, body 15/700, secondary 13–14/600, labels 11–12/800 with slight letter spacing.
- **Shape:** cards radius 22–28, tiles 22, buttons and inputs fully rounded (pill), small badges radius 8–10.
- **Spacing:** 20 px screen padding, 10–16 px gaps between cards.
- **Navigation:** floating bottom tab bar (white, radius 26, 16 px from the sides, 20 px from the bottom) with Home, Shopping, Meals, Tasks, Watch. Active tab: accentTint background, accentDark icon and label. Recipes open from the dashboard and meal plan.
- **Icons:** one outline icon set (stroke about 2 px, rounded caps), for example Lucide or Tabler. The shopping catalog needs openly licensed food icons or custom ones; never copy Bring!'s icons or layout assets.
- **No** gradients, emoji as icons or heavy shadows; a hairline border instead of shadows.
- Reference mockups (Thomas has them in Claude): Dashboard, Shopping, Meal plan, Recipe, Tasks, Watchlist, Admin portal. If a screen is unclear, ask Thomas for a screenshot of the mockup.

---

## 9. Local development without keys

| Service | Development default | Production (later) |
| --- | --- | --- |
| Auth | email + password | + Google sign-in, Sign in with Apple on iOS |
| Push | `FakePushService`: logs "would send X to Y" and stores it for tests | `FcmPushService` |
| TMDB | `FakeTmdbService`: fixtures with placeholder posters | `TmdbService` with API key on the server |
| Backups | restic to a local folder | restic to NFS + OneDrive via rclone |
| Network | `localhost` | Cloudflare Tunnel |

Select implementations through server config (e.g. `push: fake|fcm`, `tmdb: fake|tmdb`). Provide a seed command that creates two households ("Home" and "Test family"), a super-admin and a few users, sample catalog items, stores, recipes, tasks and watchlist fixtures, so every screen has data.

---

## 10. Roadmap and gates

Do the phases in order. At each gate, stop and report to Thomas.

0. **Setup** — check prerequisites (`flutter doctor`, Docker running, Serverpod CLI installed). Create the project with `serverpod create nest` in this folder, add `nest_shared` and `nest_admin`, wire gen-l10n (EN/NL) and the design tokens, set up `.gitignore`, `docs/STATUS.md`, and a README with run instructions. App shows a themed, bilingual placeholder screen connected to the local server.
1. **Foundation** — email/password sign-in, households, memberships, invite codes, household switcher, settings with language choice, `HouseholdGuard`, `AdminGuard`, seed command, isolation tests. **Gate: isolation tests pass.**
2. **Shopping List** — lists, catalog, stores, tiles, recently used, realtime sync, drift offline cache. **Gate: Thomas's household can use it daily (deployment to the Pi happens around here; ask first).**
3. **Tasks + push** — tasks, recurrence, notification preferences, future calls for reminders, fake push service, deep links.
4. **Recipes** — library, photos (stored via Serverpod file uploads), scaling, cooking mode, add to list.
5. **Meal Planning** — week strip, dinner per day, linked recipes, prep-ahead note.
6. **Watchlist** — fake TMDB first, status tabs, poster grid, random pick, attribution.
7. **Admin + backups** — admin portal pages, audit log, backup job and `backup_runs`/`backup_requests`.
8. **Dashboard + release** — dashboard, daily summary, real providers (Google, Apple, FCM, TMDB), TestFlight and Play internal testing. **Gate: a backup restore has been tested before other households are invited.**

---

## 11. Definition of done (per feature)

- Endpoints guarded, scoped by `householdId`, and added to the isolation test.
- Repository + providers + screens built to the design system and mockups.
- All strings in both ARB files; layout checked in Dutch (longer words) and with large text.
- Works offline where specified; realtime updates where specified.
- Unit tests for logic (e.g. scaling, recurrence, store filtering) and integration tests for endpoints.
- `docs/STATUS.md` updated; changes committed.

---

## 12. Start here (first session)

1. Read this file.
2. Check prerequisites and report anything missing to Thomas with the exact install step.
3. Create `docs/STATUS.md` with phase 0 as current.
4. Carry out phase 0, committing as you go.
5. Stop at the end of phase 0, summarize what was built and how to run it, and propose the first steps of phase 1.
