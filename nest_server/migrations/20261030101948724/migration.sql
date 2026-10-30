BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "watchlist_item" (
    "id" bigserial PRIMARY KEY,
    "householdId" bigint NOT NULL,
    "tmdbId" bigint NOT NULL,
    "type" text NOT NULL,
    "title" text NOT NULL,
    "posterPath" text,
    "year" bigint,
    "rating" double precision,
    "status" text NOT NULL DEFAULT 'want'::text,
    "addedById" bigint,
    "householdRating" bigint,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "watchlist_item_title_idx" ON "watchlist_item" USING btree ("householdId", "type", "tmdbId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "watchlist_item"
    ADD CONSTRAINT "watchlist_item_fk_0"
    FOREIGN KEY("householdId")
    REFERENCES "household"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "watchlist_item"
    ADD CONSTRAINT "watchlist_item_fk_1"
    FOREIGN KEY("addedById")
    REFERENCES "nest_user"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR nest
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('nest', '20261030101948724', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261030101948724', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260924105404509', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105404509', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260924105232991', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105232991', "timestamp" = now();


COMMIT;
