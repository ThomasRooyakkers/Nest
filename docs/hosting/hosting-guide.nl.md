# Een Nest-server hosten

*English: [hosting-guide.md](hosting-guide.md)*

Nest is een privé-gezinsapp. Iedereen kan een Nest-server draaien voor het
eigen gezin: dezelfde Nest-app (iPhone, Android, web) verbindt met de server
die de gebruikers kiezen. Eén server kan meerdere huishoudens bevatten, en
elk huishouden ziet alleen zijn eigen gegevens.

Deze handleiding zet een server op vanaf nul. Je hoeft de code van Nest niet
te kennen.

## Wat je nodig hebt

- Een computer die altijd aan staat en Linux draait (bijvoorbeeld een
  Raspberry Pi 4 of 5 met een 64-bit besturingssysteem, een mini-pc of een
  kleine cloudserver). Zowel arm64 als amd64 werken. 2 GB geheugen en 10 GB
  vrije schijfruimte zijn ruim voldoende.
- [Docker](https://docs.docker.com/engine/install/) met de Compose-plugin
  (`docker compose version` moet werken).
- Een domeinnaam met twee adressen voor je server, bijvoorbeeld
  `nest.example.com` (de web-app, het adres dat je gezin intypt) en
  `nest-api.example.com` (de API).
- Een manier om de server via https vanaf het internet te bereiken: een
  gratis [Cloudflare Tunnel](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/)
  (geen open poorten thuis) of je eigen https-reverse-proxy (bijvoorbeeld
  Caddy of nginx).
- Optioneel: een [Resend](https://resend.com)-account om aanmeldcodes te
  mailen. Zonder account verschijnen de codes in het serverlog en geef je ze
  zelf door.

## 1. Haal de bestanden op

Maak een map voor Nest en zet er twee bestanden uit de map `deploy` van de
Nest-repository in: `docker-compose.yml` en `.env.example`.

```bash
mkdir -p ~/nest && cd ~/nest
# kopieer docker-compose.yml en .env.example hierheen
cp .env.example .env
```

## 2. Vul `.env` in

Open `.env` in een editor. Elke instelling wordt in het bestand uitgelegd.

| Instelling | Wat vul je in |
| --- | --- |
| `NEST_WEB_DOMAIN` | het adres van de web-app, bv. `nest.example.com` |
| `NEST_API_DOMAIN` | het adres van de API, bv. `nest-api.example.com` |
| `SUPER_ADMIN_EMAIL` | je eigen e-mailadres: dat account wordt superbeheerder van de server |
| `SIGN_UP_MODE` | `invite-only` (aanbevolen: nieuwe accounts hebben een uitnodigingscode van een huishouden nodig) of `open` |
| `NEST_IMAGE`, `NEST_VERSION` | het serverimage en de versie; laat de waarden uit `.env.example` staan, tenzij je een bepaalde versie wilt |
| `DATABASE_PASSWORD`, `SERVICE_SECRET`, `EMAIL_SECRET_HASH_PEPPER`, `JWT_HMAC_SHA512_PRIVATE_KEY`, `JWT_REFRESH_TOKEN_HASH_PEPPER` | elk een andere willekeurige waarde |
| `RESEND_API_KEY`, `MAIL_FROM` | optioneel, zie "Mail" hieronder |

Maak elk geheim met:

```bash
openssl rand -base64 48 | tr -d '\n/+='
```

Houd `.env` privé en bewaar een kopie op een veilige plek: zonder deze
geheimen kan niemand met een bestaand account nog aanmelden.

## 3. Maak de server bereikbaar

Kies een van de twee mogelijkheden.

### Mogelijkheid A: Cloudflare Tunnel

1. Voeg je domein toe aan Cloudflare (het gratis abonnement volstaat).
2. Ga in het Cloudflare-dashboard naar Zero Trust > Networks > Tunnels en
   maak een tunnel (type "Cloudflared"). Kopieer het token.
3. Voeg twee publieke hostnamen toe aan de tunnel:
   - `nest.example.com` → service `http://nest:8082`
   - `nest-api.example.com` → service `http://nest:8080`
4. Haal in `.env` het commentaarteken weg bij deze regels en vul ze in:

   ```bash
   COMPOSE_PROFILES=tunnel
   TUNNEL_TOKEN=<het token>
   ```

### Mogelijkheid B: je eigen https-proxy

De server luistert alleen op deze machine: de API op poort 8080 en de web-app
op poort 8082 (aan te passen met `NEST_API_PORT` en `NEST_WEB_PORT`). Laat je
proxy de twee domeinen daarheen doorsturen, met WebSockets toegestaan.
Bijvoorbeeld met [Caddy](https://caddyserver.com), dat ook de
https-certificaten regelt:

```
nest.example.com {
  reverse_proxy 127.0.0.1:8082
}

nest-api.example.com {
  reverse_proxy 127.0.0.1:8080
}
```

Draait de proxy op een andere machine, zet dan `NEST_BIND_ADDRESS` op het
adres van deze machine in het lokale netwerk (en stel de poorten niet
rechtstreeks open naar het internet).

De web-app en de API horen op dezelfde site te staan (twee subdomeinen van
één domein, zoals hierboven). Is dat niet zo, voeg dan
`SERVERPOD_AUTH_COOKIE_SAME_SITE=none` toe aan de omgeving van de dienst
`nest` in `docker-compose.yml`, anders blijf je op het web niet aangemeld.

## 4. Starten

```bash
cd ~/nest
docker compose up -d
docker compose ps
docker compose logs -f nest
```

De eerste start downloadt de images en maakt de database aan; dat duurt een
minuut. Controleer daarna:

- `https://nest-api.example.com/` antwoordt (een lege pagina is goed), en
- `https://nest.example.com/` toont het aanmeldscherm van Nest.

## 5. Maak je account

1. Open `https://nest.example.com/` en kies **Account aanmaken** met het
   e-mailadres van `SUPER_ADMIN_EMAIL`. Je hebt geen uitnodigingscode nodig.
2. Vul de code uit de e-mail in. Zonder mail vind je hem in het log:

   ```bash
   docker compose logs nest | grep "Registration code"
   ```

3. Kies een wachtwoord en een naam, en maak je huishouden aan.
4. Maak in **Instellingen** een uitnodigingscode en geef die aan je gezin. Op
   een server met `invite-only` vullen ze die in bij het aanmaken van hun
   account en worden ze meteen lid van je huishouden.

## 6. Verbind de app

- **Web:** je gezin gebruikt `https://nest.example.com/`; die praat altijd
  met jouw server.
- **iPhone en Android:** tik op het aanmeldscherm op **Server wijzigen**, vul
  `nest.example.com` in en tik op **Verbinden**. De app controleert dat het
  een Nest-server met een geschikte versie is en onthoudt hem. Instellingen
  en Over Nest tonen welke server de app gebruikt. Overschakelen naar een
  andere server meldt je af en wist de gegevens op het toestel.

## Mail

Om aanmeld- en wachtwoordcodes te mailen:

1. Maak een [Resend](https://resend.com)-account en verifieer je domein
   (Resend toont de DNS-records die je moet toevoegen).
2. Maak een API-sleutel en zet in `.env`:

   ```bash
   RESEND_API_KEY=re_...
   MAIL_FROM=Nest <nest@example.com>
   ```

3. Pas het toe: `docker compose up -d`.

De mails zijn in het Engels en het Nederlands.

## Bijwerken

```bash
cd ~/nest
docker compose pull
docker compose up -d
```

Wijzigingen aan de database worden automatisch toegepast wanneer de nieuwe
versie start. Wil je op een versie blijven, zet dan `NEST_VERSION` in `.env`
(bijvoorbeeld `0.2.0`) in plaats van `latest`. Oudere Nest-apps blijven
werken met nieuwere servers; is een app te oud voor de server, dan meldt hij
dat.

## Back-ups

De dienst `backup` schrijft elke nacht een databasedump naar
`~/nest/backups` en bewaart de laatste 14. Kopieer die map regelmatig naar
een andere plek (een andere schijf of een clouddrive), samen met je `.env`.

Nu meteen een dump maken:

```bash
docker compose exec postgres pg_dump -U postgres nest | gzip > backups/nest-handmatig.sql.gz
```

### Terugzetten

Dit vervangt alle gegevens op de server door de dump.

```bash
cd ~/nest
docker compose stop nest
docker compose exec postgres dropdb -U postgres nest
docker compose exec postgres createdb -U postgres nest
gunzip -c backups/nest-JJJJMMDD-UUMMSS.sql.gz | docker compose exec -T postgres psql -U postgres -d nest
docker compose start nest
```

Gebruik dezelfde geheimen in `.env` als de server die de dump maakte, anders
kan niemand aanmelden.

Probeer één keer een terugzetting op een reservemachine voor je op je
back-ups vertrouwt.

## Verhuizen naar een nieuwe machine

Installeer Docker op de nieuwe machine, kopieer `docker-compose.yml`, `.env`
en de laatste dump, start alleen de database (`docker compose up -d
postgres`), zet de dump terug zoals hierboven en voer `docker compose up -d`
uit. Laat daarna de tunnel of proxy naar de nieuwe machine wijzen.

## Problemen oplossen

- **`docker compose up` meldt dat een instelling ontbreekt:** vul ze in in
  `.env`.
- **De app meldt "Op dit adres antwoordt geen Nest-server":** controleer dat
  beide adressen in een browser openen, en dat de tunnel of proxy het
  webdomein naar poort 8082 en het API-domein naar 8080 stuurt.
- **Aanmelden op het web blijft niet bewaard:** zie de opmerking over cookies
  bij mogelijkheid B.
- **"Deze server aanvaardt alleen nieuwe accounts met een
  uitnodigingscode":** de server is `invite-only`; vraag een
  uitnodigingscode aan een huishouden op die server.
- **Logs:** `docker compose logs --tail 200 nest`.
