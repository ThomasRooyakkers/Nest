BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "backup_request" (
    "id" bigserial PRIMARY KEY,
    "requestedBy" bigint NOT NULL,
    "requestedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "pickedUpAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "backup_run" (
    "id" bigserial PRIMARY KEY,
    "startedAt" timestamp without time zone NOT NULL,
    "finishedAt" timestamp without time zone,
    "status" text NOT NULL,
    "sizeBytes" bigint,
    "snapshotId" text,
    "target" text NOT NULL,
    "error" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "backup_run_started_at_idx" ON "backup_run" USING btree ("startedAt");


--
-- MIGRATION VERSION FOR nest
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('nest', '20261030120148533', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261030120148533', "timestamp" = now();

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
