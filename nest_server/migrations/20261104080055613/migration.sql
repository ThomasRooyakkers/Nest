BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "security_event" (
    "id" bigserial PRIMARY KEY,
    "type" text NOT NULL,
    "method" text,
    "userId" bigint,
    "emailHint" text,
    "reason" text,
    "at" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "security_event_at_idx" ON "security_event" USING btree ("at");
CREATE INDEX "security_event_user_idx" ON "security_event" USING btree ("userId");


--
-- MIGRATION VERSION FOR nest
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('nest', '20261104080055613', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261104080055613', "timestamp" = now();

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
