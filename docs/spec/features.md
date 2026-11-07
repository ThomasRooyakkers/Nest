# Feature specifications

Moved out of `CLAUDE.md` on 2026-11-07 (it was section 7 there). Changing
what this file says is changing a decision: ask Thomas first. Deviations
already agreed are in `docs/DEVIATIONS.md`.


**Dashboard.** Greeting with today's date and a household switcher in the header. Tonight's dinner from the meal plan with "Open recipe". Two tiles: items to buy (opens Shopping) and tasks due today (opens Tasks). Today's tasks with check-off, due time and assignee avatar. Next item on the watchlist. Cards hide when a feature is disabled for the household.

**Shopping List (Bring!-style, own design and icons).** List switcher in the header with member avatars. Search field "What do you need?" that adds from the catalog or creates an own item. Store chips (All stores + each store + "Add store"): picking a store shows only items for that store or "any store", ordered by that store's category order, with a hint how many items are hidden. Items added while a store is picked go to that store; one store can be the household's default store (switch in the store editor, star on its chip), which new items without stores get while "All stores" is shown (decided 2026-11-07). "To buy" grid of tiles (3 columns, icon, name, spec) in the accent colour; tapping a tile moves it to "Recently used". "Recently used" grid of light tiles; tapping adds it back. Live sync for everyone on the list, works offline. Later: photo per item.

**Recipes.** Create/edit with title, photo, servings, prep and cook time, tags, structured ingredients and numbered steps. Servings stepper that rescales amounts. Favourite toggle. Search and filter by tag and favourites. Cooking mode (large text, screen stays awake). "Add to list" adds the recipe's ingredients to the shopping list, skipping items already on it.

**Meal Planning.** Week strip of seven days with previous/next week buttons, one card per day showing dinner, "+ Plan dinner" on empty days. A day is filled from the recipe library or free text. Servings and a "prep ahead" note per meal. Breakfast and lunch slots can be switched on per household (off by default). There is deliberately no "add the week's ingredients to the list" feature.

**Tasks.** Filter chips: Mine, Everyone, Overdue, Done. Each task: check-off, title, due label (overdue highlighted), recurrence indicator, assignee avatar. Floating "+" button for a new task. Recurring tasks create their next occurrence on completion.

**Watchlist.** Search films and series via the server (TMDB). Status tabs: Want to watch, Watching, Watched. "Pick something for tonight" chooses a random title. Three-column poster grid (2:3 posters) with title, type, year, rating and who added it. Show the TMDB attribution line on the watchlist and the About screen: "This product uses the TMDB API but is not endorsed or certified by TMDB." IMDb is not used (no public API, scraping not allowed).

**Choosing a server.** The sign-in screen shows the server in use (default `nest.g3cko.be`) with "Change server". The user enters an address; the app checks that it is a reachable Nest server with a compatible version before switching, and remembers the choice. Signing out keeps the server; switching server signs out and clears the local cache. Settings and the About screen show the server and its version. The address may be the server's API or its web address: the web address serves `assets/assets/config.json` with the API address, which the app reads.

**Self-hosting kit.** A published multi-arch server image (admin portal and static site included), the Compose file (Postgres, server, backup; Cloudflare Tunnel optional) and a hosting guide in English and Dutch: requirements, `.env` settings (domain, secrets, mail, super-admin email, TMDB key, sign-up mode), first start, updating, backups and restore. Sign-up mode per server: invite-only (default: an account can only be created with a valid household invite code, except the configured super-admin) or open.

**Admin portal** (`nest_admin`, Flutter web). Side menu: Households, Users, Backups, System health, Audit log; stacks on narrow screens. Households page: summary cards (last backup, server health, SSD free space), table with name, owner, members, enabled features, last activity, status, and a Suspend/Reactivate action. Backups: recent runs, "Back up now". Restores stay a documented command-line task; the portal only shows the command and the snapshot to use.
