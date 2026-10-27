BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "admin_audit_log" (
    "id" bigserial PRIMARY KEY,
    "adminId" bigint NOT NULL,
    "action" text NOT NULL,
    "targetType" text NOT NULL,
    "targetId" text,
    "details" text,
    "at" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "admin_audit_log_at_idx" ON "admin_audit_log" USING btree ("at");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "household" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "status" text NOT NULL DEFAULT 'active'::text,
    "enabledFeatures" json NOT NULL,
    "inviteCode" text,
    "inviteExpiresAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "household_invite_code_idx" ON "household" USING btree ("inviteCode");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "membership" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "householdId" bigint NOT NULL,
    "role" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "membership_user_household_idx" ON "membership" USING btree ("userId", "householdId");
CREATE INDEX "membership_household_idx" ON "membership" USING btree ("householdId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "nest_user" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "name" text NOT NULL,
    "locale" text NOT NULL DEFAULT 'en'::text,
    "isSuperAdmin" boolean NOT NULL DEFAULT false,
    "disabledAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "nest_user_auth_user_idx" ON "nest_user" USING btree ("authUserId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "membership"
    ADD CONSTRAINT "membership_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "nest_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "membership"
    ADD CONSTRAINT "membership_fk_1"
    FOREIGN KEY("householdId")
    REFERENCES "household"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "nest_user"
    ADD CONSTRAINT "nest_user_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR nest
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('nest', '20261027204250297', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261027204250297', "timestamp" = now();

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
