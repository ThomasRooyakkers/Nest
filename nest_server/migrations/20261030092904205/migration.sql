BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "household" ADD COLUMN "mealSlots" json;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "meal_plan_entry" (
    "id" bigserial PRIMARY KEY,
    "householdId" bigint NOT NULL,
    "date" timestamp without time zone NOT NULL,
    "slot" text NOT NULL DEFAULT 'dinner'::text,
    "recipeId" bigint,
    "freeText" text NOT NULL DEFAULT ''::text,
    "servings" bigint,
    "prepAheadNote" text NOT NULL DEFAULT ''::text,
    "createdById" bigint,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "meal_plan_entry_day_idx" ON "meal_plan_entry" USING btree ("householdId", "date", "slot");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "meal_plan_entry"
    ADD CONSTRAINT "meal_plan_entry_fk_0"
    FOREIGN KEY("householdId")
    REFERENCES "household"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "meal_plan_entry"
    ADD CONSTRAINT "meal_plan_entry_fk_1"
    FOREIGN KEY("recipeId")
    REFERENCES "recipe"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "meal_plan_entry"
    ADD CONSTRAINT "meal_plan_entry_fk_2"
    FOREIGN KEY("createdById")
    REFERENCES "nest_user"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR nest
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('nest', '20261030092904205', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261030092904205', "timestamp" = now();

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
