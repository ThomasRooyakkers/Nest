# Nest — Status

Keep this file short (under about 150 lines): the current state, what is
next and open questions only. When a piece of work is finished, add the
details to the top of the "Log" section in `docs/history/STATUS-HISTORY.md`
and leave one line here. Deviations from the spec go in `docs/DEVIATIONS.md`.
The backlog is in Jira (`docs/JIRA.md`).

## Current state (2026-11-07)

- **Phase 9 (Dashboard + release) in progress.** Phases 0–8 are done and
  released. The dashboard is built; Google and Apple sign-in are live.
- **Server:** 0.17.0 (API level 12) on Thomas's Pi at `nest.g3cko.be` /
  `nest-api.g3cko.be`. Includes the admin portal packages A (management),
  B (logs, security events) and C (Overview metrics, admin alert emails).
  Resend is on for the Pi; a real alert email has not been seen yet.
  `UPTIME_PING_URL` is not set (needs Thomas's healthchecks.io account).
- **App Store:** record "Hoomly" exists, build 1.0.0 (1) uploaded; Thomas
  still has to finish the listing items and submit for review.
- **Google Play:** paused (iOS first). A closed test was submitted
  2026-11-02; personal account needs 12 testers × 14 days. Family gets the
  signed release APK directly (home-screen name "Hoomly" since 2026-11-04).
- **NEST-23:** iOS Google sign-in now reuses the last Google account
  silently, so Google's "shared data" mail no longer comes on every sign-in;
  not yet checked on a real iPhone.
- **Open bug:** Google sign-in fails on Thomas's old Android phone ("Something
  went wrong", never reaches the server); cause not confirmed.

Details for every item: `docs/history/STATUS-HISTORY.md`.

## Next

1. **Thomas:** create the family's accounts at https://nest.g3cko.be (codes in
   `docker compose logs nest` until Resend is set up) and use the list daily.
   For the iPhone, build with `--dart-define=SERVER_URL=https://nest-api.g3cko.be/`.
2. Resend is on for the Pi (2026-11-01, domain `mailing.g3cko.be`); a real
   delivery is still to be confirmed (Send test email on the Server page).
3. **Thomas:** remove the second server when no longer needed
   (`cd ~/nest-test && docker compose down -v`, then delete the "Nest test"
   tunnel and its two hostnames in Cloudflare, and the folder).
4. **Thomas:** try Tasks, Recipes and the meal plan on the web and on the
   iPhone build (taking a photo needs the phone).
5. **Thomas:** try the watchlist at https://nest.g3cko.be (search, real
   posters, tonight's pick) and on the iPhone build.
6. **Thomas:** copy `RESTIC_PASSWORD` from `~/nest/deploy/.env` on the Pi
   into your password manager. In the Cloudflare tunnel "Nest", add
   `nest-admin.g3cko.be` → `http://nest:8082` and protect it with a
   Cloudflare Access application (your email only). Then sign in and press
   Back up now.
7. **Repeat the restore test once the family's real data is on the Pi**
   (with recipe photos) before the phase 9 gate, and add a second backup target (NFS share and/or OneDrive
   via `~/nest/deploy/rclone/rclone.conf`).
8. Phase 9 — Dashboard + release (CLAUDE.md section 10).
9. **1.1 in progress** (Jira release 1.1). Done: the app signs out on a
   dead sign-in instead of retrying forever (NEST-38); Android back, tab
   bar gap and + tooltip fixes, recipe Edit/Delete buttons (NEST-35/36/37/33,
   checked on the emulator; a phone check is still open). Own grocery
   icons, 25 new catalog items and icons for typed items (NEST-24); items
   added with a store selected go to that store (NEST-25); a default store
   per household and brighter store colours. Server 0.17.0 is deployed;
   the new app build is on Thomas's and Iris's iPhones (other devices need
   a new build).

## Open questions

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

