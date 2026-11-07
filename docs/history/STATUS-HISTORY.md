# Nest — Status history

The full log of what was built, released and decided, newest first under
"Log" and per phase under "Phases". Moved out of `docs/STATUS.md` on
2026-11-07 to keep that file short. Append new entries here when a piece of
work is finished; search this file rather than reading it whole.

## Log

**Grocery icons and store on add (2026-11-07, NEST-24 + NEST-25, release
1.1, commits `adfd70d`, `efd4e43`):**
- Own icons (NEST-24): 26 grocery icons Lucide lacks (tomato, potato,
  onion, garlic, bell pepper, cucumber, mushroom, broccoli, avocado,
  strawberry, pear, kiwi, cheese, bread loaf, pasta, rice, jar, oil bottle,
  sauce bottle, butter, yoghurt, sausage, tea, salt shaker, toilet roll,
  sponge), drawn in Lucide's style as SVGs in `tools/grocery_icons/svg/` and
  built into `nest_flutter/assets/fonts/NestGroceryIcons.ttf` (same metrics
  as Lucide) plus `grocery_icons.dart` by `tools/grocery_icons/build.py`
  (dev-only Python tools: picosvg, fontTools, skia-pathops, pinned in
  `requirements.txt`; codepoints fixed in `codepoints.json`). Preview:
  `node tools/grocery_icons/serve_preview.mjs`. No new app dependency.
- Catalog: 25 new built-in items (EN + NL, e.g. cherry tomatoes, feta,
  noodles, canned tuna, burgers, vitamins) and better icons for 48 existing
  ones, also using unused Lucide glyphs (can, soda can, wine bottle, cake
  slice, cupcake, doughnut, burger, pill bottle, paper bag, bird).
  Catalog sync now also updates the icon and category copied onto items
  already on a list.
- Typed items: `ItemMatcher` (server) picks the icon and category of a
  built-in item from the name's words, EN + NL: the match that ends last
  wins, Dutch compounds match on their ending ("trostomaten", "volkoren-
  brood"), longer wins at the same place ("pindakaas" = peanut butter).
  Own items without an icon are backfilled at server start. Older apps
  show the category icon for icon keys they do not know.
- Store on add (NEST-25): with a store chip selected, items added from the
  search (catalog or own) get that store; a Recently used item for any
  store put back gets it too (offline: a status and an update change are
  queued). Fixed on the way: the picked store reset to All stores while
  searching, because the chips (and the auto-dispose selection) were gone.
- Tests: matcher unit tests, shopping endpoint tests (own item icon,
  backfill, icon change reaching list items), app widget and repository
  tests; 205 app and 460 server tests pass. Also fixed: the
  `admin_alerts_test` "ten real server errors" case failed since
  2026-11-07 because it seeded the backup at a fixed date but checked
  against the real clock; it now uses the real clock for both.
  Icons checked as rendered by Flutter in a throwaway golden test; **not
  yet seen on a device** (needs a new server image and app build).

**Google "shared data" mail on every iOS sign-in (2026-11-07, NEST-23):**
- Cause: the mail is Google's "You shared some Google Account data with
  Nest by G3cko". On iOS Google sends it after every *interactive* Google
  sign-in (`GoogleSignIn.authenticate()`), also for an account that already
  gave access; Android (Credential Manager) does not (reported in
  google/GoogleSignIn-iOS#311). Nest always used the interactive flow and
  also told Google to forget the account on every Nest sign-out. Neither the
  app nor the server forces consent or revokes access.
- Fix (app only, Thomas's choice): on iOS "Continue with Google" first
  signs in silently with the Google account used last on the device
  (`attemptLightweightAuthentication`), and a Nest sign-out no longer
  forgets it. A new "Use another Google account" link under the Google
  button (iOS only) forgets it and runs the full flow (one mail, expected).
  Linking Google in Settings keeps the full flow. Android unchanged.
- Trade-off: on a shared iPad the next person signs in as the previous
  Google account unless they tap the link. New strings
  `useAnotherGoogleAccount` (en/nl); widget test for the link; 202 app
  tests pass. **Not verified on a real iPhone yet** (needs a real Google
  sign-in): sign out of Nest, Continue with Google, expect no mail.

**Android fixes and recipe buttons (2026-11-07, NEST-35/36/37/33, release
1.1, commit `4dfdc06`):**
- Back (NEST-35): on another tab Android back goes to Home; on Home it
  leaves the app; sheets and pushed screens still close first (`PopScope`
  in `NestShell`).
- Tab bar gap (NEST-36): on Android the floating tab bar keeps 20 px above
  the system navigation bar (`tabBarBottomGap`: inset + 20); iOS keeps
  inset − 6. Older Android versions (no edge-to-edge) report no inset and
  keep 20 px.
- + tooltip (NEST-37): new `ShellAddButton` for Tasks and Recipes. On Android
  it has no visual tooltip (it covered the tab bar after a long press); the
  icon carries the label for TalkBack. iOS keeps the tooltip. Other
  icon-only buttons are in the top header, where a tooltip covers nothing,
  so they are unchanged.
- Recipe screen (NEST-33): Edit and Delete are round header buttons next to
  the favourite button instead of a menu; Delete still confirms first. The
  unused `recipeMoreActions` string is removed from both ARB files.

New tests in `test/nest_shell_test.dart` and `test/router_test.dart`; all
201 app tests pass. Checked on the Android emulator (`nest_pixel`, debug
build against the local server) with gesture and 3-button navigation: the
gap shows in both, a long press on + shows no tooltip, Back goes sheet →
Tasks → Home → launcher, and Delete → Cancel keeps the recipe. Not yet
checked on a real phone or on iOS.

**Dead sign-in no longer loops (2026-11-07, NEST-38, release 1.1):** when
the server refuses a device's sign-in (`notSignedIn` or a 401), the live
sync (`LiveSyncLoop`) now asks `AuthRepository.checkSignIn()`, which calls
`client.auth.validateAuthentication()`. A dead sign-in (refresh token
expired or revoked) is signed out there, the cached data is cleared (as on
a normal sign-out), the router shows sign-in and the loop stops for good.
A sign-in that still holds, or a check that cannot reach the server,
retries as before (2–30 s). Concurrent checks from the five feature loops
share one call. The app also checks on resume (`NestApp`, via
`AppLifecycleListener`); on start `client.auth.initialize()` already
validates. New tests in `nest_flutter/test/live_sync_test.dart`; all 195
app tests pass. The optional server change (`requireLogin` so a rejected
token gets a 401) was not made. Checked end to end against the local dev
server: signed in as `sarah@nest.test`, revoked the device's refresh token
(Sign out all devices from a second sign-in) and made its access token dead;
the server answered `notSignedIn`, the check signed the device out, and the
loop made one attempt and stopped (two refusals in the server log, then
none). Reaches devices with the next app build.

**Android app name Hoomly (2026-11-04, Thomas's request):** the Android
home-screen name (`android:label`) is now "Hoomly", like the store
listings; the iOS home-screen name and in-app branding stay "Nest". New
family APK `nest_flutter/build/app/outputs/flutter-apk/app-release.apk`
(1.0.0+1, 72.6 MB, SHA-256 `0bc61fd0…a11f9cad`), signed with the upload key
(SHA-1 `BF:53:03:CA…F9:43`, checked with apksigner), so it installs over
the earlier APK. Open: Google sign-in on Thomas's old Android phone shows
"Something went wrong"; no attempt reached the server, so it fails on the
phone (likely no Google account on the device or outdated Play services);
cause not confirmed yet.

**0.16.0 released and deployed (2026-11-04):** Overview page with metrics
and admin alert emails (package C, below). CI passed on `05c2179`, tag
`v0.16.0`, images built; deployed by Claude with Thomas's OK using the
v0.16.0 deploy kit (`.env.bak-20261104-094424`). Verified: health 0.16.0 /
API 11, migration applied (`admin_alert`), only `notSignedIn` refusals in
the log. The first alert check opened nothing, which matches the state:
last successful backup (target `local`) 2026-11-04 02:00 UTC, disk about
67 % free, no real server errors. A real alert email has not been seen
yet; Send test email on the Server page checks the mail path.
`UPTIME_PING_URL` is not set on the Pi (needs Thomas's healthchecks.io or
similar account).

**Admin portal package C, part 2: alert emails (2026-11-04, released as
0.16.0; Thomas decided 2026-11-04 to allow admin-only alert emails, recorded
in CLAUDE.md section 1 as the one exception to "no notifications"):**
- `AdminAlerts` checks every 5 minutes (first check a minute after start):
  no successful backup in 26 hours (also "never"), the latest run of a
  target failed, less than 10 % free disk, 10+ real server errors in 15
  minutes (refusals such as `notSignedIn` do not count), and the database
  being unreachable (kept in memory, since it cannot be stored).
- A new problem opens an `admin_alert` row and sends one email; a reminder
  every 24 hours while it lasts; a "resolved" email when it clears.
  Emails are English + Dutch, carry only the kind and a measurement
  (stored language-neutral, worded per language), and go to
  `SUPER_ADMIN_EMAIL` or `ALERT_EMAIL`. `ALERTS=off` keeps alerts in the
  portal only. Resolved alerts are kept 90 days. New table `admin_alert`
  (migration `20261104082905546`).
- `UPTIME_PING_URL`: fetched after every successful check, for an outside
  dead-man's switch such as healthchecks.io (covers the Pi being down).
- Portal: open alerts as warning cards at the top of Overview (with the
  email status and alerts resolved in the last 30 days); the Server page
  shows whether alert emails and the uptime ping are on.
- Tests: 448 server tests (new: open, no repeat within 24 h, reminder,
  resolve, failed target, low disk, error burst vs. refusals, alerts off,
  database down and back, no personal data in emails) and 23 portal tests
  pass. Checked in the browser: on the local server the first check opened
  two real alerts (no backups, Mac disk 4 % free).
- **On the Pi after release:** with Resend configured, expect an email if
  any condition already holds. Setting up a healthchecks.io check and
  `UPTIME_PING_URL` is Thomas's choice (it needs an account there).

**Admin portal package C, part 1: Overview with metrics (2026-11-04,
released as 0.16.0):**
- The portal now opens on **Overview**: status cards (server and database,
  real server errors in the last hour with refused calls shown apart, last
  backup, free space, mail) and eight trend charts (processor load,
  memory, server errors, slow calls, database response time, open
  connections, free disk share, database size) for 24 hours, 7 or 30 days.
- Data: Serverpod's own health checks (every minute, rolled up per hour
  after 48 h and per day after 31 days) plus two Nest measures added
  through its `healthCheckHandler` (`NestMetrics`: free disk share,
  database size). Errors and slow calls per bucket come from the session
  logs, so they reach back as far as `LOG_RETENTION`. "Refused" calls
  (`NestException`, wrong password, expired tokens) are counted apart from
  real errors (`NestMetrics.refusedPatterns`). No new table, no migration.
- Charts are drawn with a `CustomPainter` (`TrendChart`), so no new
  dependency: one series each in the accent colour, recessive grid, hover
  and touch readout, a screen reader summary per chart.
- System health stays in the menu for the per-target backup rows and
  counts; the Server page has the configuration.
- Tests: 438 server tests (new: bucketing and averaging, refused vs. real
  errors, the health check hook) and 21 portal tests (new: overview cards,
  range chips, chart summary, hover readout, Dutch + large text on a phone)
  pass. Checked in the browser against the local server.
- Alert emails followed in part 2 (above).

**0.15.0 released and deployed (2026-11-04):** package B below. CI passed
on `d496aa5`, tag `v0.15.0`, images built; deployed by Claude with
Thomas's OK using the v0.15.0 deploy kit (`.env.bak-20261104-092347`, dump
`nest-pre-update-20261104-092350.sql.gz`, 71 KB instead of 816 KB now
that log rows are left out). Verified: health 0.15.0 / API 11, privacy
page 200, migration applied, only `notSignedIn` refusals in the log. The
23,536 old session-log rows stay until they are 14 days old (cleanup by
retention, so gone by 2026-11-18); deleting them sooner needs Thomas's OK.

**Admin portal package B: logs and security events (2026-11-04,
released as 0.15.0):**
- **Finding on the Pi:** Serverpod stores session logs in the database by
  default in production, with no cleanup unless retention is configured.
  Since 2026-10-28 the Pi collected 23,536 rows in `serverpod_session_log`
  (29 MB of the 41 MB database), mostly streaming (realtime) sessions, plus
  SQL text of slow queries, and all of it went into every backup.
- **Logging now** (`NestLogging`, applied at start): only failed and slow
  calls (all calls in development), no SQL text, no per-message streaming
  logs. `sessionLogs` keeps them 14 days (`retentionPeriod: 14d`, hourly
  cleanup); hosts change it with `LOG_RETENTION` in `.env`. The first
  cleanup after deploy removes nothing older than 14 days yet; the
  streaming noise stops.
- **Security events** (new table `security_event`, kept 30 days): sign-ins
  (admin sign-ins marked), failed sign-ins with a masked email and reason,
  new accounts, password reset requests, password changes, account
  deletions. No IP addresses. Deleting an account removes its events.
  Recorded in `EmailIdpEndpoint` and `SocialSignIn.run`.
- **Backups** (`deploy/backup/backup.sh`) and the pre-update dump
  (`deploy.sh`) leave out the rows of the log, health-metric and
  security-event tables (tables kept, data excluded). Needs the 0.15.0
  backup image.
- **Portal:** Logs page (errors / slow last 24 h, retention, filters, a
  detail dialog with error, stack trace and messages) and Security page
  (sign-ins and failed sign-ins last 24 h, filters, rows open the user).
  All text is redacted on the server (`LogRedaction`: emails masked,
  `<codes>` hidden); our own mail error log masks the address too.
- Privacy page (EN/NL) and hosting guide (EN/NL) describe logs, sign-in
  events, retention and that backups leave them out. To check when the app
  stores are next updated: whether the App Store privacy answers should
  list diagnostics (server logs linked to an account); the Play Data
  safety draft is unaffected (no IPs, not shared).
- Tests: 431 server tests (new: redaction, events from real email sign-in,
  failed sign-in, reset, expiry, account deletion, redacted logs, summary,
  production log settings) and 18 portal tests pass. Checked in the
  browser against the local server: a wrong password and a sign-in show up
  on Security; Logs and its detail dialog work.
- **Next:** release 0.15.0 and deploy to the Pi (needs Thomas's OK). Then
  package C (metrics, overview page, alerts), which still needs Thomas's
  decision on admin email alerts vs. "no notifications in v1".

**0.14.0 released and deployed (2026-11-04):** package A below. CI passed
on `4b332d5`, tag `v0.14.0`, images built; deployed by Claude with
Thomas's OK using the v0.14.0 deploy kit (`.env.bak-20261104-090708`, dump
`nest-pre-update-20261104-090725.sql.gz`). Verified: health 0.14.0 / API
11, web 200, no errors in the log.

**Admin portal management, package A (2026-11-04, released as 0.14.0):**
Thomas asked for a portal to properly manage the server, plus logging and
monitoring; the plan has three packages: A management, B logging, C
monitoring and alerts. Package A is built:
- **Households:** click a row for its detail page: status, members (name,
  email, role, joined) with Make owner / Make member (the last owner stays
  owner), invite code with New code / Copy / Revoke (expired codes marked),
  feature switches, and data counts per feature (counts only). Rename and
  Suspend/Reactivate there too. **New household** creates an empty household
  with all features and an invite code for a new family; the first person
  to join with it becomes its owner (`HouseholdRules.joinRole`, also in the
  invite sign-up path), later ones members.
- **Users:** click a row for status, sign-in methods (email/Google/Apple),
  signed-in devices (refresh tokens used in the last 14 days) and last seen,
  households with role, **Sign out everywhere**, Disable/Enable. Disabling
  now also signs the user out everywhere.
- **Server page** (new menu item): the settings the server runs with
  (version, API level, addresses, allowed origins, sign-up mode, super-admin
  email, Google/Apple, mail sender, mail and film data set or not; never
  secrets), **Send test email** (to the admin's own address), **Test film
  data**, and an update status against the newest `vX.Y.Z` tag of the public
  GitHub repo (cached 6 h, only while the page is open; `UPDATE_CHECK=off`
  in `.env` switches it off, `updateCheckUrl` can point elsewhere).
- Every new action is audit-logged without household names (rename keeps
  only the id). New endpoints are in `endpoint_registry.dart` and the admin
  access test. API level 11 (admin only; apps are unaffected).
- Dropped from the proposal: **admin-sent password reset**. The auth
  module's reset needs the request id the app keeps, so a code started from
  the portal could not be used; the user page says to use "Forgot password"
  in the app instead.
- Tests: 406 server tests and 15 portal widget tests pass (new: detail
  pages, create household, roles, invites, sign out everywhere, settings
  without secrets, test mail, update check, Dutch + large text on a phone).
  Checked in the browser against the local server with seed data (detail
  pages, New code, Server page with a real update check, user page); no
  console or server errors.
- **Next:** release as 0.14.0 and deploy to the Pi (needs Thomas's OK);
  try Send test email there (the first real Resend delivery). Then package
  B (database logs with retention, logs page, security events) and C
  (metrics, overview page, alerts); open decisions for those: admin email
  alerts vs. "no notifications in v1", deleting households from the portal,
  log retention (proposed 14 days logs, 30 days metrics; logs kept out of
  backups).

**Admin portal password (2026-11-01, released as 0.13.0):** Thomas's
super-admin account signs in with Google/Apple only, so it had no password
and could not use the admin portal (email + password only). New command
`./bin/server set-admin-password` (in the image: `docker compose exec nest
./bin/server set-admin-password`) asks for a password twice and gives it to
`superAdminEmail`: changes it when that email sign-in exists, otherwise adds
email sign-in to the single super-admin (refuses with none or several).
Audit-logged (`admin.setPassword`). Hosting guide EN/NL updated; seed and
the command share `toolConfig`. 6 new tests, 350 server tests pass. No API
change. CI passed on `0628c1b` (the first run failed: the test built the auth
module from passwords CI does not have; it now uses fixed test secrets), tag
`v0.13.0` on `adae5ec`, images published; deployed by Claude with Thomas's OK
(`NEST_VERSION=0.13.0`, `.env.bak-*` kept, dump
`nest-pre-update-20261101-110957.sql.gz`). Verified: health 0.13.0 / API 10,
web 200, the command is in the image (exit 64 on empty input); the log only
shows `notSignedIn` from reconnects. On the Pi it first failed: `toolConfig` moved the API and
Insights servers to free ports but not the web server (8082, busy). Fixed
in **0.13.1** (`fa29d8d`, CI and images passed, deployed by Claude with
Thomas's OK; dump `nest-pre-update-20261101-112540.sql.gz`, `.env.bak-*`
kept). Verified: health 0.13.1, web and admin 200, the plain command starts
and refuses a short password, no errors in the log. **Next:** Thomas runs
it and signs in to the admin portal. Same day: Resend
switched on for the Pi (container recreated to load `RESEND_API_KEY`;
domain `mailing.g3cko.be` verified); a real delivery is still untested.

**Google Play closed test submitted (2026-11-02):** track "Closed testing -
Alpha", all 178 countries, tester email list "Testing" (Thomas adds family
under Users and permissions → Tester groups), feedback to Thomas's Gmail.
Release "1.0.0 (1) first closed test" (AAB with the status-bar and back
fixes, 13 MB download) plus the listings and App content: 16 changes sent
to Google for review. Play app signing key SHA-1
`AC:7B:AA:0E:17:0E:60:56:38:06:6A:2F:89:EA:0A:5A:3D:7E:80:D5` (SHA-256
`90:5A:99:E8:…:4B:5B:4F`). Google Cloud project "Hoomly" (`nest-513307`):
Claude added the Android OAuth client "Hoomly Google login Android (Play)"
(`be.g3cko.nest` + Play SHA-1) next to the upload-key client, and, with
Thomas's OK, moved the OAuth consent screen from "Testing" (0 test users:
only the project owner could use Google sign-in) to "In production". Only
basic sign-in scopes and no logo, so no Google verification is needed.
Not yet verified with a non-owner account on a phone. **Next:** once approved,
share the opt-in link; after 12 testers × 14 days, apply for production.
Family who installed the sideloaded APK uninstall it first.

**Google Play paused (2026-11-02, Thomas's choice):** iOS comes first; no
testing tracks for now. Close family gets the release APK directly
(`flutter build apk --release`, signed with the upload key, SHA-1
BF:53:03:CA:…, so Google sign-in works; checked on the emulator against
nest.g3cko.be). When Play resumes: the Play build is re-signed with Play's
app signing key, so family must uninstall the sideloaded APK before
installing from Play (different signature), and the second Android OAuth
client (Play SHA-1) is still needed. Store listing graphics and the AAB are
still to upload.
Android developer verification (Play Console → Manage account): identity
comes from the developer account; `be.g3cko.nest` is registered with Play's
three keys (verified) and, added 2026-11-02, the upload key SHA-256
`91:1A:7C:89:…:79:10:E0` that signs the family APK (status "In review").

**Google Play Console (2026-11-02, in progress):** Thomas's account is a
*personal* developer account, so Google requires a **closed test with at
least 12 opted-in testers for 14 days in a row** before he can apply for
production; a public release is at least two weeks away. Thomas created the
app (name "Hoomly", package `be.g3cko.nest`, app ID 4973502857776228997,
free, default language en-GB; he accepted the declarations). Claude filled:
privacy policy (`https://nest.g3cko.be/privacy.html`), ads (none),
advertising ID (no; the merged manifest has no `AD_ID` permission),
government/financial/health (none), store settings (Lifestyle, contact
email, website `https://nest.g3cko.be/`), store listing text EN + NL
(draft; text in `docs/app-review/play-store-listing.md`), Data safety
(draft: name, email, user IDs, photos, search history (ephemeral), other
user content; collected for app functionality/account management, not
shared, encrypted in transit; deletion URL = the privacy page). Signed AAB
1.0.0+1 built (`flutter build appbundle --release`, upload key CN=Nest).
Play graphics in `store-screenshots/play-graphics` (icon 512, feature
graphic EN/NL 1024x500, same layout as the App Store header but with the
Android screens) and `play-en`/`play-nl`: real Android screenshots, 1080x1920
(`adb shell wm size 1080x1920` on AVD `nest_pixel`, profile build with
`SCREENSHOTS=true` and `SERVER_URL=http://10.0.2.2:8080/`, local seed data,
demo-mode 9:41 status bar, 24-hour clock), the same six screens as iOS:
EN as thomas@ in "Home", NL as jan@ with "Test family" briefly renamed
"Familie Janssens" (renamed back). Tonight's dinner was set to Pumpkin soup
(Home) and Spaghetti bolognese (Test family) in the local database.
Two Android bugs found and fixed on the way: the status bar icons were
white on ivory (now `SystemUiOverlayStyle` with dark icons in `main.dart`
and `windowLightStatusBar` in `styles.xml`), and Android's back button in
Settings closed the app (Home now pushes Settings; its back arrow pops).
Checked on the emulator; 190 app tests pass. AAB rebuilt with both fixes.
**With Thomas (done 2026-11-02):** Sign-in details, content rating.
**With Thomas:** upload the graphics and the AAB (the built-in browser can't
upload files), tester list.
**Then Claude:** content rating answers, target audience, submit Data
safety, internal + closed testing releases. **After Play signs the app:**
second Android OAuth client with Play's app signing SHA-1 (App integrity).
Consider a dedicated account-deletion page that names "Hoomly" (Play's
deletion link should name the app shown in the store).

**App Store Connect (2026-10-31):** the app record already existed (store
name "Hoomly", SKU/bundle `be.g3cko.nest`, Apple ID 6829200295). Claude
uploaded build 1.0.0 (1) via `xcodebuild -exportArchive` (destination
upload, Xcode's account) and attached it to version 1.0; filled the EN and
NL listing (promo text, description, keywords, support/marketing URL
`https://nest.g3cko.be/`, copyright), review notes, privacy policy URL,
App Privacy data types (name, email, user ID, photos, other user content;
app functionality, linked, no tracking; not yet published), categories
Lifestyle + Productivity, age rating (13+, from cautious answers for film
posters/titles), manual release. **With Thomas:** upload the screenshots,
reviewer demo account + sign-in and contact info, content rights, publish
App Privacy, EU trader status (DSA), store name vs. home-screen name
("Hoomly" vs "Nest"), then Add for Review and submit.

**App Store prep (2026-10-31, code side done):** at Thomas's request.
iPhone only (`TARGETED_DEVICE_FAMILY = 1`, iPad orientations removed; Thomas's
choice, so no iPad screenshots). App privacy manifest
`ios/Runner/PrivacyInfo.xcprivacy`: no tracking; name, email, user ID,
photos and other user content, linked, for app functionality (must match
the App Privacy answers in App Store Connect); file timestamp (C617.1) and
user defaults (CA92.1) reasons for the plugins without a manifest
(path_provider_foundation, sign_in_with_apple, flutter_web_auth_2) and
SQLite. Launch screen ivory instead of white. Version stays 1.0.0 (1)
(nothing uploaded yet; raise the build number for every upload). `flutter
build ipa` gives a signed App Store IPA in `nest_flutter/build/ios/ipa`
(27 MB, manifest included). `--dart-define=SCREENSHOTS=true` hides the
debug ribbon; 6.9" screenshots (iPhone 18 Pro Max, 1320x2868, 9:41 status
bar) in `store-screenshots/en` and `nl` (gitignored): home, shopping,
meals, tasks, watchlist, recipe. The seed now gives "Test family" Dutch
sample content (`SeedHousehold.locale`; "Home" stays English); the Dutch
set was taken as Jan with that household briefly renamed "Familie
Janssens" in the local database (renamed back). To refresh an existing dev
database, its Test family content rows were deleted locally and re-seeded. With Thomas: App Store Connect record, listing,
privacy answers, reviewer account, upload (Transporter), TestFlight.

**UI readability audit (2026-10-31, not released):** at Thomas's request,
checked every white-on-colour spot in the iOS Simulator. The real bug: the
chip theme set its label colour through a `WidgetStateTextStyle`, which
Flutter's chips do not resolve, so chip labels got no colour or weight of
their own (white on beige in the watchlist sheet's status chips). The
label colour is now a `WidgetStateColor` (new test
`nest_shared/test/nest_chip_theme_test.dart`, fails on the old theme).
Also: icons on selected (ink) chips are light, store dots use the light
tint on navy tiles and selected chips, To buy specs are bolder. Watchlist
ratings are full gold hearts (new `rating` token #F5B301, CLAUDE.md
section 8; filled heart is Material's, Lucide has none), TMDB ratings on
cards a filled gold star. App-only, no server or API change.

**Mobile only (2026-10-31, released as 0.12.1):** at Thomas's request the family
app no longer has a web version; only the admin portal is a web app
(CLAUDE.md updated). `nest_flutter/web` is gone, with the web-only code
(login cookies, the web start-up config, drift's web worker, the
`canChooseServer` switch). The server's web domain (`nest.g3cko.be`) now
serves a small static site from `nest_server/web/site`: a bilingual page
pointing to the app, `privacy.html` (moved there; the App Store links to
it) and `assets/assets/config.json`, which the app still reads when a user
types the web address instead of the API's (so installed apps keep finding
the server). The image and the release workflow build only the admin
portal. `serverpod start` now launches the app as a macOS app. Hosting
guides, README, `.env.example` and Compose comments updated. No API change.
Smoke-tested the site route locally (page, privacy, config, favicon); 187
app tests pass. CI and the image passed on `ac4dded`, tag `v0.12.1`;
deployed by Claude with Thomas's OK (`NEST_VERSION=0.12.1`, `.env.bak-*`
kept, dump `nest-pre-update-20261031-120142.sql.gz`). Verified over https:
`nest.g3cko.be/` shows the new page, `/privacy.html` 200, `config.json`
gives `https://nest-api.g3cko.be/`, health 0.12.1 / API 10. The log only
showed `notSignedIn` from stream reconnects in the first 30 s after the
restart.

**Colour redesign (2026-10-31, released as 0.12.0):** after a colour audit and
two nature-inspired passes (d53fc7b, 6981286), Thomas and his wife picked
"Navy & ivory" from seven side-by-side options on a Claude design canvas:
ivory background, navy To buy tiles and primary buttons with white text,
sand (meals), misty blue (tasks), lilac (watchlist) and blush (recipes)
tints with dark text, all at 4.5:1 or more (new `onAccent` token). Also from
the audit: unchecked boxes 3:1+, overdue as red-brown text instead of a
badge, store dots in the deep store colour, watchlist avatars 24 px, store
colour names (Blue, Sand, Mist, Lilac, Blush, Linen). CLAUDE.md section 8
updated.
Released as 0.12.0 with Thomas's OK: CI and image passed on `c60fe5e`, tag
`v0.12.0`, deployed by Claude (dump `nest-pre-update-20261031-113401.sql.gz`,
`.env.bak-*` next to `.env`). Verified: health 0.12.0 / API 10, web app 200
and shows the new colours, clean start. The iOS app with the new colours is
only on Thomas's iPhone (installed from Xcode); other phones get it with the
next TestFlight/App Store build.

**Phase 9 — Dashboard + release: in progress (2026-10-30).** The dashboard
is built and tested locally (not released yet). Next in phase 9: real
Google/Apple sign-in and TestFlight / Play internal testing.

**Google and Apple sign-in (2026-10-30, built, not released):** server API
level 9 / app API level 9. `GoogleIdpEndpoint` and `AppleIdpEndpoint` wrap
the auth module's sign-in in `SocialSignIn` (one transaction): a new
identity whose verified email matches an existing account (email sign-in or
another provider) is merged into it; otherwise it is a new account under the
sign-up mode (invite code from Create account, super-admin email, or open
server), takes the provider's name, and joins the invite's household. A
refused sign-in leaves nothing behind. Providers switch on per host
(`GOOGLE_CLIENT_SECRET_JSON`, `APPLE_*` in `.env`); `health.ping` reports
`googleServerClientId` and `appleSignIn`, and the iOS app shows "Continue
with Apple/Google" only then (never on web/Android this round). Delete
account revokes Sign in with Apple at Apple. New direct dependencies, with
Thomas's OK: `google_sign_in` 7.2.0 and `sign_in_with_apple` 8.2.0 (app),
`sign_in_with_apple_server` 1.0.0 (server), all already in the tree via the
auth module. Google "G" logo rasterized from the auth module's
`google.svg`. iOS: `Runner.entitlements` with Sign in with Apple. **Still
needed:** the Google iOS client ID (`googleIosClientId` in
`social_sign_in_repository.dart` + URL scheme in Info.plist), keys in the
Pi's `.env`, a release, and a test on a real device. 336 server and 185 app
tests pass; unsigned release build compiles.

**Released as 0.9.0 (2026-10-31, with Thomas's OK):** Thomas's Google
(iOS client `…7os8jknj…`, web client `…jdqollqd…`) and Apple (Team
`7UG34L5AG4`, Key `798H6D63K5`, Services ID `be.g3cko.nest.signin`) set up;
iOS client ID and URL scheme in the app. Secrets added to the Pi's `.env`
(`GOOGLE_CLIENT_SECRET_JSON`, `APPLE_*`; copied files deleted, backups
`.env.bak-*`). CI passed on `a2b21c5`, tag `v0.9.0`, images published,
`deploy/deploy.sh` (dump `nest-pre-update-20261031-091817.sql.gz`).
**Outage, about 3 minutes:** the server crash-looped because the auth
module requires `redirect_uris` in the Google JSON and a web client without
redirect URIs has none; fixed on the Pi by adding `"redirect_uris":[]` to
the JSON in `.env` and restarting `nest`. Code fix committed afterwards
(not released yet): a missing `redirect_uris` defaults to empty and an
unreadable Google setting is logged and skipped instead of stopping the
server. Verified over https: health 0.9.0 / API 9 with
`googleServerClientId` and `appleSignIn: true`, web app 200. **Not verified
yet:** real Google and Apple sign-ins on a device.

**Released as 0.11.0 (2026-10-31, with Thomas's OK):** at Thomas's request,
new Google and Apple accounts need no invite code (also on an invite-only
server; invite-only now applies to email sign-up only): after signing in
the app asks for a name and to create or join a household; an invite code
typed on Create account joins its household. Linking may take over an
identity whose account is in no household. **Faster image builds:** the
"Server image" workflow builds the web apps once, then each architecture on
a native runner (`ubuntu-24.04-arm` for arm64, no QEMU) with a GitHub
Actions layer cache, and publishes one multi-arch tag at the end (6 min on
the first run with an empty cache, was 11). Release flow now: push and tag
together, so CI and the image build run side by side; deploy only when both
are green. CI and image passed on `a3b85bd`; deployed by Claude (dump
`nest-pre-update-20261031-105016.sql.gz`). Verified: health 0.11.0 / API
10, Google and Apple on, web app 200, clean start.

**Linking Google and Apple (2026-10-31), released as 0.10.0:** Thomas's
Apple sign-in was treated as a new account (Apple's email did not match his
Nest email), so Settings now has "Sign-in methods": while signed in, Link
Apple / Link Google attaches that identity to the account (API level 10,
`googleIdp.link`, `appleIdp.link`, `profile.signInMethods`; an identity of
another account gives `alreadyLinked`). The sign-in hint also tells existing
users to link Apple under Settings. Includes the Google JSON start-up fix.
CI passed on `6371b1f`, tag `v0.10.0`, deployed by Claude with Thomas's OK
(dump `nest-pre-update-20261031-102354.sql.gz`). Verified: health 0.10.0 /
API 10 with Google and Apple on, web app 200, clean start. 342 server and
188 app tests pass. **Not verified yet:** linking on Thomas's iPhone.

**App Store readiness (2026-10-30):** account deletion (server API level 8,
`profile.deleteMe`; Settings, Delete account, hidden on older servers), a new
app icon (two overlapping houses, chosen by Thomas), a bilingual privacy page
(`web/privacy.html`, served at `https://nest.g3cko.be/privacy.html` after the
next deploy; contact email rooyakkers.thomas@gmail.com since 0.8.1) and
`ITSAppUsesNonExemptEncryption = false`. App API level is now 8. An unsigned
release build compiles.

**Released as 0.8.0 (2026-10-30, with Thomas's OK):** CI (format, analyze,
tests) passed on `56f429f`; tag `v0.8.0`; the "Server image" workflow
published `nest-server:0.8.0` and `nest-backup:0.8.0`. Pi: `NEST_VERSION=0.8.0`
in `~/nest/deploy/.env` (backup `.env.bak-*` next to it), `deploy/deploy.sh`
(dump `nest-pre-update-20261030-160132.sql.gz`). Verified over https: health
0.8.0 / API 8, web app 200 (includes the dashboard), `privacy.html` 200, no
errors in the server log. No migration in this release.

**0.8.1 (2026-10-30, deployed by Thomas):** contact email on the privacy
page. CI passed on `6eb0002`, tag `v0.8.1`, images published; Thomas set
`NEST_VERSION=0.8.1` and ran `deploy/deploy.sh` (dump
`nest-pre-update-20261030-173015.sql.gz`). Verified: health 0.8.1 / API 8,
web app 200, no errors in the log; Cloudflare's email obfuscation rewrites
the address on `privacy.html` (decodes in the browser to the right
address). Still with Thomas: signing team in Xcode, the App Store Connect
record, a reviewer demo account, and the upload to TestFlight.

**Phase 8 — Admin + backups: released as 0.7.0 (2026-10-30).** Server
0.7.0 / API level 7 and the restic backup job run on the Pi; the first
backup succeeded. Still to do with Thomas: route `nest-admin.g3cko.be` in the
tunnel behind Cloudflare Access, a second backup target (NFS/OneDrive), and
a restore test.

Phase 7 (Watchlist) is done and released as 0.6.0.

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

## Phases

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
- **Released (2026-10-30, with Thomas's OK):** CI (analyze, format, tests)
  passed on `e79af1e`; tag `v0.6.0`; the "Server image" workflow published
  `ghcr.io/thomasrooyakkers/nest-server:0.6.0` and `:latest` (arm64 +
  amd64). Pi: Thomas set `TMDB_API_KEY` in `~/nest/deploy/.env`;
  `NEST_VERSION=0.6.0` (backup `.env.bak-*` next to it), `deploy/deploy.sh`
  (dump `nest-pre-update-20261030-113025.sql.gz`). Verified over https:
  health 0.6.0 / API 6, migration `20261030101948724` applied (watchlist
  empty), `watchlist.search` answers `notSignedIn` without a login, web app
  200, and the key works from the Pi (a TMDB search for "paddington" in
  Dutch returned 20 results). **Not verified:** a search through Nest
  itself on production (no account used) and real posters in the app.

### UI refresh (2026-10-30)

Thomas asked for a more modern, less "Android" look. The colour palette and
Nunito stay; how they are applied changed, mostly in `nest_shared`:

- **Theme:** iOS page transitions on every platform, no ink ripples (a quiet
  highlight instead), compact centred titles on pushed screens, tighter title
  tracking, lighter body weights, soft filled inputs with the label inside
  (sage fill while focused), filled secondary buttons instead of outlines,
  ink-coloured selected chips, iOS-style switch and segmented control, round
  checkboxes, rounded sheets with a drag handle, rounded dialogs and floating
  snack bars. Spinners and switches use the `.adaptive` variants.
- **Surfaces:** cards and white tiles/chips lose their hairline border and get
  a very soft shadow (`NestShadows`); tinted cards stay flat.
- **Tab bar:** frosted, translucent floating bar with an animated active pill
  and a haptic tick; long Dutch labels shrink instead of being cut off.
- **New shared widget** `NestRoundButton` for header actions (home settings,
  meal plan week arrows and slots). Household switcher is a white pill with
  an icon disc; sign-in has an app mark. Last Material icons replaced by
  Lucide.
- Checked on the iPhone 18 Pro simulator (home, shopping, meals, tasks,
  watchlist, settings, sign in) against the local server; 169 app tests,
  16 shared tests and the admin test pass.
- CLAUDE.md section 8 updated to the new look (Thomas's OK, 2026-10-30):
  soft shadows instead of hairline borders, body 15/650, native-feeling
  controls, frosted tab bar.

### Phase 8 — Admin + backups (2026-10-30)

- **Server:** admin endpoints under `endpoints/admin/` (households, users,
  system health, backups, audit log), each starting with
  `AdminGuard.require` and returning metadata and counts only; every admin
  action writes an `admin_audit_log` row. `backup_run` and `backup_request`
  tables; system health reports version/API level, uptime, database, mail,
  TMDB, free disk space and the backup targets. All admin endpoints are in
  the "normal user gets an error" test.
- **Backup job** (`deploy/backup`, image `nest-backup`): `pg_dump` once,
  stored with restic in every target of `BACKUP_TARGETS` (local folder, NFS
  share via `BACKUP_EXTRA_DIR`, OneDrive or any rclone remote), daily at
  `BACKUP_TIME` and on "Back up now" (picked up within 30 s); one
  `backup_run` row per target with size, snapshot or error; old snapshots
  thinned with `restic forget`. `nest-backup snapshots` and
  `nest-backup restore <target> <snapshot>` for restores.
- **Admin portal** (`nest_admin`, Flutter web, EN/NL): sign-in for the
  super-admin only, side menu (drawer on narrow screens) with Households
  (summary cards for last backup, server and free space; table with
  Suspend/Reactivate), Users (Disable/Enable, not yourself), Backups (runs,
  Back up now, the restore command for the latest good snapshot), System
  health and Audit log. Served on its own domain (`NEST_ADMIN_DOMAIN`).
- **Hosting guide (EN/NL):** new "Admin portal" section; "Backups",
  "Restore" and "Moving to a new machine" rewritten for restic, with the
  backup settings in the `.env` table.
- **Checks:** 8 admin portal widget tests (incl. narrow screen, Dutch,
  1.6× text); fixed two overflows (name + Super-admin badge, and table
  buttons/headers breaking mid-word). In the browser against the local
  server: sign-in as the seeded super-admin, Households, Users and Backups
  show real data. **Not verified:** the backup container itself (needs
  Docker; runs on the Pi), a real restic run to NFS/OneDrive, and a restore.

- **Released (2026-10-30, with Thomas's OK):** CI (format, analyze, tests)
  passed on `37ecbe5`; tag `v0.7.0`; the "Server image" workflow published
  `nest-server:0.7.0` and the new `nest-backup:0.7.0` (both pullable without
  login). Pi `~/nest/deploy/.env` (backup `.env.bak-*` next to it):
  `RESTIC_PASSWORD` generated on the Pi (61 characters, never printed;
  **Thomas: copy it into your password manager**), `BACKUP_TARGETS=local=/backups/restic`,
  `BACKUP_TIME=03:00`, `TZ=Europe/Brussels`,
  `NEST_ADMIN_DOMAIN=nest-admin.g3cko.be`, `NEST_VERSION=0.7.0`; empty
  `rclone` folder created. `deploy/deploy.sh` (pre-update dump in
  `backups/`). Verified: health 0.7.0 / API 7 over https, web app 200,
  migration `20261030120148533` applied, the backup job caught up at once
  (`backup_run` 1: succeeded, local, 148766 bytes, snapshot `5cbe45b0`,
  4 s) and `nest-backup snapshots local` lists it. **Not verified:** the
  portal on production (hostname not routed yet), Back up now on
  production.
- **Restore test (2026-10-30, Thomas's OK):** snapshot `5cbe45b0` restored
  with `nest-backup restore local 5cbe45b0` into a throwaway database
  `nest_restore_test` on the Pi, compared table by table with the live
  database, then dropped. 48 of 51 tables equal; the 3 differences are
  expected (`backup_run` is written after the dump; two Serverpod health
  tables grow every minute). **But production had no accounts or
  household data yet** (only the 127 built-in catalog items), so the test
  proves the mechanism, not real household data or recipe photos.

### Phase 9 — Dashboard (2026-10-30, not released)

- **Home screen is the dashboard** (CLAUDE.md section 7): greeting with
  today's date and the household switcher; **Tonight** (honey) with
  tonight's dinner, servings, prep-ahead note and "Open recipe", or
  "Plan dinner" on an empty day; **tiles** for items to buy on the shown
  list (opens Shopping) and tasks for today (opens Tasks); **Today's
  tasks**: overdue and due today, up to 5, with check-off, due label,
  recurrence and assignee (the Tasks screen's row, now shared as
  `TaskRow`), and "All tasks"; the Recipes card. No watchlist card
  (Thomas, 2026-10-30). Every
  card hides when its feature is off or the server is too old. The server
  card moved off the home screen (Settings and About show it).
- The dashboard keeps the meal plan (this week), recipes, shopping and
  tasks in live sync while it is shown; the feature screens share
  these syncs.
- No server change (API level stays 7).
- **Checks:** 177 app tests pass (new `dashboard_test.dart`: 6 widget
  tests incl. Dutch with 2× text, check-off, Open recipe and that the
  watchlist is not shown; `dashboard_logic_test.dart`: 2). Four existing tests adjusted: tab
  finders that also matched the new tiles, the Recipes card now at the
  bottom, and the meal plan test's load count (this week stays in sync).
  Checked on the web at phone size against the local server with the seed
  data, and in the iOS simulator against production (empty household:
  "Nothing planned", "Nothing to buy", "Nothing due today"). **Not
  verified:** with real data on production, and on a phone.

- **Android APK (2026-11-01).** Toolchain via Homebrew: `openjdk@17`
  (set with `flutter config --jdk-dir`) and `android-commandlinetools`
  (SDK at `/opt/homebrew/share/android-commandlinetools`: platform 36,
  build-tools 36, NDK 28.2, emulator, AVD `nest_pixel` on an android-36
  arm64 image). Fix: the main manifest lacked the INTERNET permission, so a
  release build could not reach any server (debug builds add it themselves).
  `flutter build apk --release` builds `app-release.apk` (72 MB), still signed
  with the debug key. On the emulator it starts on the sign-in screen and
  connects to nest.g3cko.be via "Change server". **Not verified:** signing
  in, and on a real Android phone.
- **Google sign-in on Android (2026-11-01, built, not released).** Release
  builds are signed with an upload key: `nest_flutter/android/upload-keystore.jks`
  and `android/key.properties` (both untracked, see `key.properties.example`;
  without them release builds fall back to the debug key). Upload key SHA-1
  `BF:53:03:CA:31:D4:4A:58:66:0F:D4:B5:BC:8F:AE:DB:73:49:F9:43`. The app now
  offers "Continue with Google" (and "Link Google" in Settings) on Android;
  Apple stays iOS-only (Android would need Apple's web flow). On Android only
  the server's web client ID goes to Google; the app is recognised by package
  `be.g3cko.nest` plus the signing key's SHA-1, so no server change. Checked
  on the emulator: the button appears against nest.g3cko.be. Thomas created
  the Android OAuth client (upload key SHA-1) and backed up the keystore and
  `key.properties` in Bitwarden. **Verified 2026-11-01 on the emulator
  against production:** Thomas signed in with Google and landed in his
  household; Settings shows Google as linked and no Apple row. **Still
  needed:** a second Android OAuth client with Play's app signing key SHA-1
  (Play Console → App integrity) once the app is on Play, and a test on a
  real phone. The emulator AVD was created with `hw.keyboard=no`; set
  `hw.keyboard=yes` in `~/.android/avd/<name>.avd/config.ini` to type with
  the Mac keyboard.

