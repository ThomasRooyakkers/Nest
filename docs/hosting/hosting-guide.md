# Hosting a Nest server

*Nederlands: [hosting-guide.nl.md](hosting-guide.nl.md)*

Nest is a private family app. Anyone can run a Nest server for their own
family: the same Nest app (iPhone, Android, web) connects to whichever server
its users choose. One server can hold several households, and each household
only ever sees its own data.

This guide sets up a server from scratch. You need no knowledge of Nest's
code.

## What you need

- A computer that is always on, running Linux (for example a Raspberry Pi 4
  or 5 with a 64-bit OS, a mini PC or a small cloud server). Both arm64 and
  amd64 work. 2 GB of memory and 10 GB of free disk space are plenty.
- [Docker](https://docs.docker.com/engine/install/) with the Compose plugin
  (`docker compose version` should work).
- A domain name with two addresses for your server, for example
  `nest.example.com` (the web app, the address your family types) and
  `nest-api.example.com` (the API).
- A way to reach the server over https from the internet: either a free
  [Cloudflare Tunnel](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/)
  (no open ports at home) or your own https reverse proxy (for example
  Caddy or nginx).
- Optional: a [Resend](https://resend.com) account to email sign-up codes.
  Without one, the codes appear in the server log and you pass them on.
- Optional: a free [TMDB](https://www.themoviedb.org) account for the
  watchlist's film search (see "Film data" below).

## 1. Get the files

Make a folder for Nest and download the Compose file and the example
settings from the [Nest repository](https://github.com/ThomasRooyakkers/Nest):

```bash
mkdir -p ~/nest && cd ~/nest
curl -fsSLO https://raw.githubusercontent.com/ThomasRooyakkers/Nest/main/deploy/docker-compose.yml
curl -fsSL -o .env https://raw.githubusercontent.com/ThomasRooyakkers/Nest/main/deploy/.env.example
```

The server image itself, `ghcr.io/thomasrooyakkers/nest-server`, is
downloaded by Docker when you start (step 4). It runs on arm64 and amd64.

## 2. Fill in `.env`

Open `.env` in an editor. Every setting is explained in the file.

| Setting | What to put |
| --- | --- |
| `NEST_WEB_DOMAIN` | the web app address, e.g. `nest.example.com` |
| `NEST_API_DOMAIN` | the API address, e.g. `nest-api.example.com` |
| `SUPER_ADMIN_EMAIL` | your own email address: that account becomes the server's super-admin |
| `SIGN_UP_MODE` | `invite-only` (recommended: new accounts need a household invite code) or `open` |
| `NEST_IMAGE`, `NEST_VERSION` | the server image and version; keep the values from `.env.example` unless you want a specific version |
| `DATABASE_PASSWORD`, `SERVICE_SECRET`, `EMAIL_SECRET_HASH_PEPPER`, `JWT_HMAC_SHA512_PRIVATE_KEY`, `JWT_REFRESH_TOKEN_HASH_PEPPER` | each a different random value |
| `RESEND_API_KEY`, `MAIL_FROM` | optional, see "Mail" below |
| `TMDB_API_KEY` | optional, see "Film data" below |

Make each secret with:

```bash
openssl rand -base64 48 | tr -d '\n/+='
```

Keep `.env` private and make a copy somewhere safe: without these secrets
existing accounts cannot sign in.

## 3. Make the server reachable

Choose one of the two options.

### Option A: Cloudflare Tunnel

1. Add your domain to Cloudflare (the free plan is enough).
2. In the Cloudflare dashboard, go to Zero Trust > Networks > Tunnels and
   create a tunnel (type "Cloudflared"). Copy its token.
3. Add two public hostnames to the tunnel:
   - `nest.example.com` → service `http://nest:8082`
   - `nest-api.example.com` → service `http://nest:8080`
4. In `.env`, uncomment and fill in:

   ```bash
   COMPOSE_PROFILES=tunnel
   TUNNEL_TOKEN=<the token>
   ```

### Option B: your own https proxy

The server listens on this machine only: the API on port 8080 and the web
app on port 8082 (change them with `NEST_API_PORT` and `NEST_WEB_PORT`).
Let your proxy forward the two domains there, with WebSockets allowed. For
example with [Caddy](https://caddyserver.com), which also gets the https
certificates:

```
nest.example.com {
  reverse_proxy 127.0.0.1:8082
}

nest-api.example.com {
  reverse_proxy 127.0.0.1:8080
}
```

If the proxy runs on another machine, set `NEST_BIND_ADDRESS` to this
machine's address in the local network (and do not expose the ports to the
internet directly).

The web app and the API should be on the same site (two subdomains of one
domain, as above). If they are not, add `SERVERPOD_AUTH_COOKIE_SAME_SITE=none`
to the `nest` service's environment in `docker-compose.yml`, or signing in on
the web will not stick.

## 4. Start

```bash
cd ~/nest
docker compose up -d
docker compose ps
docker compose logs -f nest
```

The first start downloads the images and creates the database; that takes a
minute. Then check:

- `https://nest-api.example.com/` answers (an empty page is fine), and
- `https://nest.example.com/` shows the Nest sign-in screen.

## 5. Create your account

1. Open `https://nest.example.com/` and choose **Create account** with the
   email address of `SUPER_ADMIN_EMAIL`. You need no invite code.
2. Enter the code from the email. Without mail set up, find it in the log:

   ```bash
   docker compose logs nest | grep "Registration code"
   ```

3. Choose a password and a name, and create your household.
4. In **Settings**, create an invite code and give it to your family. On an
   invite-only server they enter it when they create their account and join
   your household straight away.

## 6. Connect the app

- **Web:** your family uses `https://nest.example.com/`; it always talks to
  your server.
- **iPhone and Android:** on the sign-in screen, tap **Change server**, enter
  `nest.example.com` and tap **Connect**. The app checks that it is a Nest
  server of a compatible version and remembers it. Settings and About show
  which server the app uses. Switching to another server signs you out and
  clears the data stored on the device.

## Mail

To email sign-up and password reset codes:

1. Create a [Resend](https://resend.com) account and verify your domain
   (Resend shows the DNS records to add).
2. Create an API key and set in `.env`:

   ```bash
   RESEND_API_KEY=re_...
   MAIL_FROM=Nest <nest@example.com>
   ```

3. Apply it: `docker compose up -d`.

The emails are in English and Dutch.

## Film data

The watchlist finds films and series through [TMDB](https://www.themoviedb.org),
with your own free key. Only the server talks to TMDB; the apps show the
posters from TMDB's image server.

1. Create a TMDB account and request an API key under Settings → API.
2. Set the API key (or the API read access token) in `.env`:

   ```bash
   TMDB_API_KEY=...
   ```

3. Apply it: `docker compose up -d`.

Without a key the watchlist search offers a few sample titles, so the
feature can be tried. Nest shows TMDB's attribution on the watchlist and the
About screen, as TMDB's terms require.

## Updating

```bash
cd ~/nest
docker compose pull
docker compose up -d
```

Database changes are applied automatically when the new version starts.
To stay on a version, set `NEST_VERSION` in `.env` (for example `0.2.0`)
instead of `latest`. Older Nest apps keep working with newer servers; when an
app is too old for the server, it says so.

## Backups

The `backup` service writes a database dump to `~/nest/backups` every night
and keeps the last 14. Copy that folder somewhere else regularly (another
disk or a cloud drive), together with your `.env`. Recipe photos are stored
in the database, so the dump includes them; there is no separate folder to
back up.

Make a dump right now:

```bash
docker compose exec postgres pg_dump -U postgres nest | gzip > backups/nest-manual.sql.gz
```

### Restore

This replaces all data on the server with the dump.

```bash
cd ~/nest
docker compose stop nest
docker compose exec postgres dropdb -U postgres nest
docker compose exec postgres createdb -U postgres nest
gunzip -c backups/nest-YYYYMMDD-HHMMSS.sql.gz | docker compose exec -T postgres psql -U postgres -d nest
docker compose start nest
```

Use the same `.env` secrets as the server that made the dump, or nobody can
sign in.

Try a restore on a spare machine once before you rely on your backups.

## Moving to a new machine

Install Docker on the new machine, copy `docker-compose.yml`, `.env` and the
latest dump, start only the database (`docker compose up -d postgres`),
restore the dump as above and run `docker compose up -d`. Then point the
tunnel or proxy at the new machine.

## Troubleshooting

- **`docker compose up` says a setting is missing:** fill it in in `.env`.
- **The app says "No Nest server answered at this address":** check that
  both addresses open in a browser, and that the tunnel or proxy sends the
  web domain to port 8082 and the API domain to 8080.
- **A new address is "not found" although the tunnel or proxy is set up:**
  a device or router that looked the name up before it existed may remember
  that for up to 30 minutes. Wait, or clear the DNS cache (on a Mac:
  `sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder`; on the
  router, restart its DNS service). `dig +short nest.example.com @1.1.1.1`
  shows whether the name exists on the internet.
- **Signing in on the web does not stick:** see the cookie note under
  option B.
- **"This server only accepts new accounts with an invite code":** the
  server is invite-only; get an invite code from a household on it.
- **Logs:** `docker compose logs --tail 200 nest`.
