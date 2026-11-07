# Jira — how Nest work is tracked

Project **Nest** (key `NEST`) on https://ingeniumworks.atlassian.net/browse/NEST
— a company-managed Kanban project. Jira holds the backlog and the work
in flight; `docs/history/STATUS-HISTORY.md` stays the record of what was built and why.

## Where does it belong? Components

Every item gets one or more components. A change that touches several
parts gets all of them.

| Component | Covers |
| --- | --- |
| App – iOS | Family app on iOS (`nest_flutter`) |
| App – Android | Family app on Android (`nest_flutter`) |
| Admin portal | `nest_admin` (ships inside the server image) |
| Server | `nest_server`, `nest_client`, static site, privacy page |
| Deploy & hosting | Pi, Compose, Cloudflare, backups, CI images, hosting guide |

Shared Flutter work that changes both platforms gets **both** App
components. Platform-only work (store listings, signing, an
Android-only bug) gets one.

## What kind of work? Issue types

| Type | Use for |
| --- | --- |
| Epic | A large change or release spanning several items (e.g. "App Store release 1.0", a CLAUDE.md phase) |
| Story | Something a user or super-admin can see or do |
| Bug | Something that is broken |
| Task | Technical work, chores, releases, accounts, decisions |
| Sub-task | Splitting one item further (rarely needed) |

## Who does it? Labels

Every open item carries at least one of these labels:

- `claude` — Claude Code can pick it up and do it in the repo or browser.
- `thomas` — only Thomas can do it: accounts, payments, uploads, a real
  device, Cloudflare/Apple/Google consoles, or a decision.

Both labels mean a joint item (e.g. Claude prepares, Thomas approves or
signs in). Assignee is optional; the label is what counts.

## Releases (Versions)

Releases are simple product versions: `1.0`, `1.1`, `2.0`, … One release
covers everything that ships together (apps, server, admin portal);
server image tags (`vX.Y.Z`) and store build numbers are noted in the
release description or a comment, not as separate Jira versions.

- `1.0` — first release (iOS submitted to Apple, awaiting approval).
- `1.1` — first update after 1.0.
- `2.0` — next major release.

Set **Fix version** when an item is planned for a release. When a
release ships, mark the version released in Jira with its date.

## Workflow

Backlog → Selected for Development → In Progress → Done.

- **Backlog:** captured, not yet planned.
- **Selected for Development:** next up; Claude takes `claude` items from
  here, top first (board order is the priority order).
- **In Progress:** being worked on.
- **Done:** merged/released or completed. Mention the commit, tag or PR
  in a comment.

Waiting on Thomas: keep it In Progress, add the `thomas` label and a
comment saying what is needed (or flag the item).

## Saved filters

- **NEST · Claude queue** — open `claude` items
- **NEST · Thomas** — open `thomas` items
- **NEST · Bugs** — open bugs
- **NEST · Unreleased server work** — server, portal and deploy items with an unreleased fix version
- **NEST · Untriaged** — open items missing a component or a label

## For Claude Code

- Before starting work, look in Jira for an existing item; otherwise
  create one with type, component(s), label and (when known) fix version.
  Write the description in English: what, why, and "Done when".
- Move items through the workflow as you work and comment with the
  commit hash or release when done.
- Never put secrets, passwords or personal data of family members in
  Jira.
- `docs/history/STATUS-HISTORY.md` keeps the detailed history; Jira items link to it
  rather than copying it.
