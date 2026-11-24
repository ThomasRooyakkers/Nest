# Nest — Status

Keep this file short (under about 150 lines): the current state, what is
next and open questions only. When a piece of work is finished, add the
details to the top of the "Log" section in `docs/history/STATUS-HISTORY.md`
and leave one line here. Deviations from the spec go in `docs/DEVIATIONS.md`.
The backlog is in Jira (`docs/JIRA.md`).

## Current state (2026-11-11)

- **Phase 9 (Dashboard + release) in progress.** Phases 0–8 are done and
  released. The dashboard is built; Google and Apple sign-in are live.
- **Server:** 0.20.0 (Serverpod 4.1.1, API level 13, image `hoomly-server`) on Thomas's Pi at `nest.g3cko.be` /
  `nest-api.g3cko.be`. Includes the admin portal packages A (management),
  B (logs, security events) and C (Overview metrics, admin alert emails).
  Resend is on for the Pi; a real alert email has not been seen yet.
  `UPTIME_PING_URL` is not set (needs Thomas's healthchecks.io account).
- **App Store:** 1.0 is live (Ready for Distribution). Version 1.1 created
  2026-11-09 with What's New in English and Dutch, description says
  Hoomly; build 1.1.0 (2) uploaded and selected. Thomas still has to click
  Add for Review and submit (review notes updated for 1.1).
- **Google Play:** 1.1.0 (2) sent to Google for production review
  2026-11-09 (all 178 countries, full rollout, managed publishing off, so it
  goes live once approved). The account is an organisation account since
  2026-11-09, so no 12-tester rule.
- **NEST-23:** iOS Google sign-in now reuses the last Google account
  silently, so Google's "shared data" mail no longer comes on every sign-in;
  not yet checked on a real iPhone.
- **NEST-45 (2026-11-23):** shopping catalog grown from 152 to 599 built-in
  items (English + Dutch, Belgian staples), smarter word matching, own items
  start with a capital; existing own items tidied at start-up. Server part
  live in 0.19.4 and 0.19.5; the 22 new icons and the
  search changes in the app need a new app build.
- **Version 2.0 (decided 2026-11-23):** the next app release is 2.0 with
  dark mode (NEST-46) and push notifications (NEST-30: NEST-49 server,
  NEST-50 app, NEST-51 Firebase setup by Thomas). Push is built and tested
  locally (server API level 15, migration `20261123132228672`, additive);
  Server 0.21.0 deployed 2026-11-23 (dump
  `nest-pre-update-20261123-155223`; ping reports API 15 and push on).
  NEST-51 done: Firebase project `hoomly-ca9f3` with iOS and Android apps,
  APNs key uploaded, service account in the Pi's `.env`, `firebase.json`
  local. App 2.0.0 (4) IPA built with Firebase (push entitlement
  production) uploaded to App Store Connect 2026-11-23 via `xcodebuild
  -exportArchive`. TestFlight external group "Family" (public link, limit 10)
  with 2.0.0 (4) submitted for Beta App Review; the internal invite for Thomas
  never arrived. Test Information filled in (reviewer account as for 1.1).
  App Store version 2.0 (build 4) submitted for App Review 2026-11-23,
  automatic release after approval; What's New EN + NL, review notes mention
  push and Firebase. Server 0.21.1 deployed the same day (privacy policy
  covers push and Firebase; dump `nest-pre-update-20261123-165905`). Push
  tested end to end on the live server: task and shopping notifications
  arrived in the simulator and the Android emulator. Android 2.0.0 (4)
  (with notification icon) sent to Google Play review 2026-11-23: production,
  full rollout, release notes EN + NL, managed publishing off (goes live once
  approved).
- **NEST-46 (2026-11-23):** dark theme "Navy night" built (app only, no
  server change): follows the system, Settings → Appearance offers System /
  Light / Dark (saved on the device), holiday decorations adapted, Android launch
  screen dark (iOS launch screen still ivory, open). Checked on the iOS simulator; needs a new app build to ship.
- **NEST-47 (2026-11-23):** holiday decorations; server 0.20.0 live (API 14,
  dump `nest-pre-update-20261123-121104`). App 1.2.0 (3): iOS build uploaded
  to App Store Connect (version 1.2 not yet created or submitted); Android AAB
  built, not uploaded. Server API
  level 14 (`seasonal_setting` table, `adminSeasonal`, ping fields), a
  "Holiday decorations" card on the admin Server page, and Christmas (lights,
  snow, ribbon) and New Year (fireworks, popper, confetti) on the app's
  dashboard, with a switch in Settings. Needs a server release and a new app
  build that reaches the stores before 7 December.
- **Holiday dates on the server (2026-11-24, not yet released):** the
  super-admin sets each holiday's yearly dates on the admin Server page; the
  server (API level 16, migration `20261124171203562`, additive) decides by
  its `TZ` which theme shows, so the 2.0 app follows without a new build.
  Deploy needs the new image and the new `docker-compose.yml` (passes `TZ`).
  No Jira item yet (Jira site not reachable from that session).
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
   NEST-22 Hoomly rebrand: server part live in 0.19.2; the app part needs a
   new iOS and Android build. Left: NEST-42 (Android Google sign-in bug,
   needs phone logs).

## Open questions

- **Claudecraft volume** `world-of-claudecraft_eastbrook_pgdata` is still on the Pi:
  delete it or keep it.
- **Typing a local http server** (`localhost:8080`) in Change server tries
  https; type `http://localhost:8080`. Fine for production; could try http
  for local addresses later.
- **Test account in the dev database:** `claude-test@nest.test` (household
  "Claude test") was created while verifying phase 2; delete it or keep it for
  later checks.

