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
- Optioneel: een gratis [TMDB](https://www.themoviedb.org)-account voor het
  zoeken naar films in de kijklijst (zie "Filmgegevens" hieronder).

## 1. Haal de bestanden op

Maak een map voor Nest en download het Compose-bestand en de
voorbeeldinstellingen uit de [Nest-repository](https://github.com/ThomasRooyakkers/Nest):

```bash
mkdir -p ~/nest && cd ~/nest
curl -fsSLO https://raw.githubusercontent.com/ThomasRooyakkers/Nest/main/deploy/docker-compose.yml
curl -fsSL -o .env https://raw.githubusercontent.com/ThomasRooyakkers/Nest/main/deploy/.env.example
```

Het serverimage zelf, `ghcr.io/thomasrooyakkers/nest-server`, downloadt
Docker bij het starten (stap 4). Het draait op arm64 en amd64.

## 2. Vul `.env` in

Open `.env` in een editor. Elke instelling wordt in het bestand uitgelegd.

| Instelling | Wat vul je in |
| --- | --- |
| `NEST_WEB_DOMAIN` | het adres van de web-app, bv. `nest.example.com` |
| `NEST_API_DOMAIN` | het adres van de API, bv. `nest-api.example.com` |
| `SUPER_ADMIN_EMAIL` | je eigen e-mailadres: dat account wordt superbeheerder van de server |
| `SIGN_UP_MODE` | `invite-only` (aanbevolen: nieuwe accounts hebben een uitnodigingscode van een huishouden nodig) of `open` |
| `NEST_IMAGE`, `NEST_BACKUP_IMAGE`, `NEST_VERSION` | het server- en back-upimage en de versie; laat de waarden uit `.env.example` staan, tenzij je een bepaalde versie wilt |
| `DATABASE_PASSWORD`, `SERVICE_SECRET`, `EMAIL_SECRET_HASH_PEPPER`, `JWT_HMAC_SHA512_PRIVATE_KEY`, `JWT_REFRESH_TOKEN_HASH_PEPPER` | elk een andere willekeurige waarde |
| `RESEND_API_KEY`, `MAIL_FROM` | optioneel, zie "Mail" hieronder |
| `TMDB_API_KEY` | optioneel, zie "Filmgegevens" hieronder |
| `RESTIC_PASSWORD` | een willekeurige waarde die de back-ups versleutelt; bewaar er een kopie van, zie "Back-ups" hieronder |
| `BACKUP_TARGETS`, `BACKUP_TIME`, `TZ` | waar en wanneer back-ups gemaakt worden; de standaardwaarden werken, zie "Back-ups" hieronder |
| `NEST_ADMIN_DOMAIN` | optioneel, zie "Beheerportaal" hieronder |

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

## Filmgegevens

De kijklijst zoekt films en series via [TMDB](https://www.themoviedb.org),
met je eigen gratis sleutel. Alleen de server praat met TMDB; de apps tonen
de posters van de beeldserver van TMDB.

1. Maak een TMDB-account en vraag een API-sleutel aan onder Settings → API.
2. Zet de API-sleutel (of het API read access token) in `.env`:

   ```bash
   TMDB_API_KEY=...
   ```

3. Pas het toe: `docker compose up -d`.

Zonder sleutel biedt de zoekfunctie van de kijklijst een paar voorbeeldtitels,
zodat je de functie kunt uitproberen. Nest toont de vermelding van TMDB op de
kijklijst en het scherm Over Nest, zoals de voorwaarden van TMDB vragen.

## Aanmelden met Google en Apple

De gepubliceerde Nest-app voor iOS kan "Doorgaan met Apple" en "Doorgaan met
Google" aanbieden. Daarvoor zijn sleutels nodig die voor die app (bundle-ID
`be.g3cko.nest`) zijn uitgegeven en bij de beheerder van de app horen. Op je
eigen server biedt de app dus alleen aanmelden met e-mail aan, tenzij je een
eigen iOS-app bouwt en publiceert met je eigen Google-client en Apple-sleutel
(zie de instellingen `GOOGLE_*` en `APPLE_*` in `.env.example`).

Als ze aan staan, komt wie met een Google- of Apple-adres aanmeldt dat al bij
een account hoort, in dat account terecht; anderen kunnen Apple of Google
koppelen bij Instellingen, Aanmeldmethoden. Een nieuw Google- of Apple-account
heeft geen uitnodigingscode nodig, ook niet op een server met alleen
uitnodigingen (dat geldt voor registreren met e-mail): de app vraagt een naam
en om een huishouden aan te maken of lid te worden van een huishouden. Een uitnodigingscode
die je bij Account aanmaken invult voor je op de knop tikt, voegt je meteen
aan dat huishouden toe.

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

## Beheerportaal

Het beheerportaal toont de huishoudens, gebruikers, back-ups, systeemstatus
en een auditlog van elke beheeractie. Het toont nooit wat een huishouden in
Nest bewaart (geen lijstitems, recepten of taaknamen).

Zet daarvoor `NEST_ADMIN_DOMAIN` in `.env` (bijvoorbeeld
`nest-admin.example.com`), stuur het door zoals de web-app (poort 8082) en
voer `docker compose up -d` uit. Bescherm het adres met een extra aanmelding
ervoor, bijvoorbeeld Cloudflare Access. Meld aan met het account van
`SUPER_ADMIN_EMAIL`; andere accounts komen er niet in.

## Back-ups

De dienst `backup` maakt elke dag om `BACKUP_TIME` (in tijdzone `TZ`) een
dump van de database en bewaart die met [restic](https://restic.net),
versleuteld met `RESTIC_PASSWORD`. Foto's van recepten staan in de database,
dus de dump bevat ze. Oude back-ups worden uitgedund: de laatste 10, één per
dag gedurende 14 dagen, één per week gedurende 8 weken en één per maand
gedurende een jaar.

Standaard gaan de back-ups naar `~/nest/backups/restic` op dezelfde machine.
Voeg een tweede plek toe in `BACKUP_TARGETS`, zodat een kapotte schijf de
back-ups niet meeneemt:

- **Een map, zoals een NFS-share** die op deze machine gekoppeld is: zet
  `BACKUP_EXTRA_DIR` op die map en voeg `nas=/backups-extra/restic` toe.
- **OneDrive of een andere clouddrive** via [rclone](https://rclone.org):
  voer `rclone config` uit op een willekeurige computer, maak een remote met
  de naam `onedrive`, kopieer het `rclone.conf` dat dat oplevert naar
  `~/nest/rclone/` en voeg `onedrive=rclone:onedrive:nest` toe.

Bijvoorbeeld `BACKUP_TARGETS=local=/backups/restic onedrive=rclone:onedrive:nest`.
Voer daarna `docker compose up -d` uit. Elke back-up komt in elke bestemming
terecht, en elke bestemming krijgt een eigen rij op de pagina Back-ups van
het beheerportaal, met de fout als het misliep.

Bewaar `RESTIC_PASSWORD` en `.env` ook op een andere plek, bijvoorbeeld in
een wachtwoordbeheerder: zonder `RESTIC_PASSWORD` is geen enkele back-up nog
te lezen.

Maak nu meteen een back-up met "Nu back-uppen" in het beheerportaal (hij
start binnen een minuut), of:

```bash
cd ~/nest
docker compose exec backup nest-backup now
```

Toon de back-ups (snapshots) van een bestemming:

```bash
docker compose run --rm backup snapshots local
```

### Terugzetten

Dit vervangt alle gegevens op de server door de back-up. De pagina Back-ups
van het beheerportaal toont deze opdrachten met de bestemming en snapshot
van elke back-up al ingevuld.

```bash
cd ~/nest
docker compose stop nest
docker compose run --rm backup restore local 1a2b3c4d
docker compose start nest
```

Vervang `local` door de bestemming en `1a2b3c4d` door de snapshot. Gebruik
dezelfde geheimen in `.env` als de server die de back-up maakte, anders kan
niemand aanmelden.

Probeer één keer een terugzetting op een reservemachine voor je op je
back-ups vertrouwt.

## Verhuizen naar een nieuwe machine

Installeer Docker op de nieuwe machine en kopieer `docker-compose.yml`,
`.env`, de map `rclone` en, voor de bestemming `local`, de map `backups`.
Start alleen de database (`docker compose up -d postgres`), zet de laatste
back-up terug zoals hierboven (`docker compose run --rm backup restore ...`)
en voer `docker compose up -d` uit. Laat daarna de tunnel of proxy naar de
nieuwe machine wijzen.

## Problemen oplossen

- **`docker compose up` meldt dat een instelling ontbreekt:** vul ze in in
  `.env`.
- **De app meldt "Op dit adres antwoordt geen Nest-server":** controleer dat
  beide adressen in een browser openen, en dat de tunnel of proxy het
  webdomein naar poort 8082 en het API-domein naar 8080 stuurt.
- **Een nieuw adres wordt "niet gevonden" hoewel de tunnel of proxy klaar
  is:** een toestel of router die de naam opzocht voor hij bestond, kan dat
  tot 30 minuten onthouden. Wacht, of wis de DNS-cache (op een Mac:
  `sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder`; op de
  router: herstart de DNS-dienst). `dig +short nest.example.com @1.1.1.1`
  toont of de naam op het internet bestaat.
- **Aanmelden op het web blijft niet bewaard:** zie de opmerking over cookies
  bij mogelijkheid B.
- **"Deze server aanvaardt alleen nieuwe accounts met een
  uitnodigingscode":** de server is `invite-only`; vraag een
  uitnodigingscode aan een huishouden op die server.
- **Logs:** `docker compose logs --tail 200 nest`.
