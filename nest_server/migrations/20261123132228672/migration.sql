BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "notification_preference" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "taskAssigned" boolean NOT NULL DEFAULT true,
    "shoppingAdded" boolean NOT NULL DEFAULT true
);

-- Indexes
CREATE UNIQUE INDEX "notification_preference_user_idx" ON "notification_preference" USING btree ("userId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "push_device" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "token" text NOT NULL,
    "platform" text NOT NULL,
    "lastSeenAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "push_device_token_idx" ON "push_device" USING btree ("token");
CREATE INDEX "push_device_user_idx" ON "push_device" USING btree ("userId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "notification_preference"
    ADD CONSTRAINT "notification_preference_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "nest_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "push_device"
    ADD CONSTRAINT "push_device_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "nest_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR nest
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('nest', '20261123132228672', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261123132228672', "timestamp" = now();

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
    VALUES ('serverpod_auth_idp', '20261015164015382', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261015164015382', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260924105232991', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105232991', "timestamp" = now();


COMMIT;
