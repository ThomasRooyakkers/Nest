# Nest — Status

Keep this file short (under about 150 lines): the current state, what is
next and open questions only. When a piece of work is finished, add the
details to the top of the "Log" section in `docs/history/STATUS-HISTORY.md`
and leave one line here. Deviations from the spec go in `docs/DEVIATIONS.md`.
The backlog is in Jira (`docs/JIRA.md`).

## Current state (2026-11-07)

- **Phase 9 (Dashboard + release) in progress.** Phases 0–8 are done and
  released. The dashboard is built; Google and Apple sign-in are live.
- **Server:** 0.18.0 (API level 13) on Thomas's Pi at `nest.g3cko.be` /
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
9. **1.1 in progress** (Jira release 1.1). Built and closed in Jira:
   NEST-23–27 and 32–41 (the Pi runs Ubuntu 26.04 LTS since 2026-11-08).
   NEST-22 Hoomly rebrand is built (`97ea5d5`), not released: needs server
   0.19.0 (images now `hoomly-server` / `hoomly-backup`, old names kept as
   aliases; make the new GitHub packages public if they come out private)
   and a new app build for iOS and Android. Left: NEST-42 (Android Google
   sign-in bug, needs phone logs).

## Open questions

- **Claudecraft volume** `world-of-claudecraft_eastbrook_pgdata` is still on the Pi:
  delete it or keep it.
- **Typing a local http server** (`localhost:8080`) in Change server tries
  https; type `http://localhost:8080`. Fine for production; could try http
  for local addresses later.
- **Test account in the dev database:** `claude-test@nest.test` (household
  "Claude test") was created while verifying phase 2; delete it or keep it for
  later checks.

