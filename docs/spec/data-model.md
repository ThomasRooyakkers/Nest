# Data model (Serverpod .spy.yaml)

Moved out of `CLAUDE.md` on 2026-11-07 (it was section 6 there). Changing
what this file says is changing a decision: ask Thomas first. Deviations
already agreed are in `docs/DEVIATIONS.md`.


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
| tasks | householdId, title, notes, assigneeId, dueAt, recurrence (none/daily/weekly/monthly), doneAt | Completing a recurring task creates the next one |
| watchlist_items | householdId, tmdbId, type (movie/series), title, posterPath, year, rating, status (want/watching/watched), addedBy, householdRating | |
| backup_runs | startedAt, finishedAt, status, sizeBytes, snapshotId, target, error | Written by the backup job |
| backup_requests | requestedBy, requestedAt, pickedUpAt | "Back up now" from the admin portal |
| admin_audit_log | adminId, action, targetType, targetId, details, at | Append-only |

Child tables without `householdId` (recipe_ingredients, recipe_steps) are only reachable through their parent, after the guard has checked the parent's household.
