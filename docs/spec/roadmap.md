# Roadmap and gates

Moved out of `CLAUDE.md` on 2026-11-07 (it was section 10 there). Changing
what this file says is changing a decision: ask Thomas first. Deviations
already agreed are in `docs/DEVIATIONS.md`.


Do the phases in order. At each gate, stop and report to Thomas.

0. **Setup** — check prerequisites (`flutter doctor`, Docker running, Serverpod CLI installed). Create the project with `serverpod create nest` in this folder, add `nest_shared` and `nest_admin`, wire gen-l10n (EN/NL) and the design tokens, set up `.gitignore`, `docs/STATUS.md`, and a README with run instructions. App shows a themed, bilingual placeholder screen connected to the local server.
1. **Foundation** — email/password sign-in, households, memberships, invite codes, household switcher, settings with language choice, `HouseholdGuard`, `AdminGuard`, seed command, isolation tests. **Gate: isolation tests pass.**
2. **Shopping List** — lists, catalog, stores, tiles, recently used, realtime sync, drift offline cache, deployment to Thomas's Pi. **Gate: Thomas's household can use it daily.**
3. **Bring your own backend** — server choice in the app (sign-in, settings, About) with a version/compatibility check (`health` returns server and API version); everything host-specific moved to server configuration (domain, allowed origins, mail sender, super-admin by email, sign-up mode invite-only/open); login cookies for the web clients (since 2026-10-31 only the admin portal); published multi-arch server image; generic Compose file and `.env.example`; hosting guide (EN/NL); Thomas's Pi moved onto the published image. **Gate: a second server, set up from the guide alone on a clean machine, works with the same app build, and the app switches between the two.**
4. **Tasks** — tasks, recurrence, filters, assignees (no reminders).
5. **Recipes** — library, photos (stored via Serverpod file uploads), scaling, cooking mode, add to list.
6. **Meal Planning** — week strip, dinner per day, linked recipes, prep-ahead note.
7. **Watchlist** — fake TMDB first, status tabs, poster grid, random pick, attribution; each host uses their own TMDB key.
8. **Admin + backups** — admin portal pages, audit log, backup job and `backup_runs`/`backup_requests`, backups and restore described in the hosting guide.
9. **Dashboard + release** — dashboard, real providers (Google, Apple, TMDB), TestFlight and Play internal testing. **Gate: a backup restore has been tested before other households are invited.**

## First session (historical)


1. Read this file.
2. Check prerequisites and report anything missing to Thomas with the exact install step.
3. Create `docs/STATUS.md` with phase 0 as current.
4. Carry out phase 0, committing as you go.
5. Stop at the end of phase 0, summarize what was built and how to run it, and propose the first steps of phase 1.
