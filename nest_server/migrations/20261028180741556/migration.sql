BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "recipe" (
    "id" bigserial PRIMARY KEY,
    "householdId" bigint NOT NULL,
    "title" text NOT NULL,
    "description" text NOT NULL DEFAULT ''::text,
    "photoPath" text,
    "servings" bigint NOT NULL DEFAULT 4,
    "prepMinutes" bigint,
    "cookMinutes" bigint,
    "tags" json NOT NULL,
    "isFavorite" boolean NOT NULL DEFAULT false,
    "createdById" bigint,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "recipe_household_idx" ON "recipe" USING btree ("householdId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "recipe_ingredient" (
    "id" bigserial PRIMARY KEY,
    "recipeId" bigint NOT NULL,
    "position" bigint NOT NULL,
    "quantity" double precision,
    "unit" text NOT NULL DEFAULT ''::text,
    "name" text NOT NULL,
    "note" text NOT NULL DEFAULT ''::text
);

-- Indexes
CREATE INDEX "recipe_ingredient_recipe_idx" ON "recipe_ingredient" USING btree ("recipeId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "recipe_step" (
    "id" bigserial PRIMARY KEY,
    "recipeId" bigint NOT NULL,
    "position" bigint NOT NULL,
    "text" text NOT NULL
);

-- Indexes
CREATE INDEX "recipe_step_recipe_idx" ON "recipe_step" USING btree ("recipeId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "recipe"
    ADD CONSTRAINT "recipe_fk_0"
    FOREIGN KEY("householdId")
    REFERENCES "household"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "recipe"
    ADD CONSTRAINT "recipe_fk_1"
    FOREIGN KEY("createdById")
    REFERENCES "nest_user"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "recipe_ingredient"
    ADD CONSTRAINT "recipe_ingredient_fk_0"
    FOREIGN KEY("recipeId")
    REFERENCES "recipe"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "recipe_step"
    ADD CONSTRAINT "recipe_step_fk_0"
    FOREIGN KEY("recipeId")
    REFERENCES "recipe"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR nest
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('nest', '20261028180741556', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261028180741556', "timestamp" = now();

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
