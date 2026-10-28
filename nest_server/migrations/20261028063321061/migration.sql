BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "catalog_item" (
    "id" bigserial PRIMARY KEY,
    "householdId" bigint,
    "builtInKey" text,
    "nameEn" text NOT NULL,
    "nameNl" text NOT NULL,
    "iconKey" text NOT NULL,
    "category" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "catalog_item_household_idx" ON "catalog_item" USING btree ("householdId");
CREATE UNIQUE INDEX "catalog_item_built_in_key_idx" ON "catalog_item" USING btree ("builtInKey");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "shopping_item" (
    "id" bigserial PRIMARY KEY,
    "householdId" bigint NOT NULL,
    "listId" bigint NOT NULL,
    "catalogItemId" bigint,
    "name" text NOT NULL,
    "spec" text NOT NULL DEFAULT ''::text,
    "category" text NOT NULL,
    "iconKey" text NOT NULL,
    "storeIds" json NOT NULL,
    "status" text NOT NULL,
    "statusChangedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "addedById" bigint,
    "sourceRecipeId" bigint,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "shopping_item_list_idx" ON "shopping_item" USING btree ("listId");
CREATE UNIQUE INDEX "shopping_item_list_catalog_idx" ON "shopping_item" USING btree ("listId", "catalogItemId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "shopping_list" (
    "id" bigserial PRIMARY KEY,
    "householdId" bigint NOT NULL,
    "name" text NOT NULL,
    "memberIds" json NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "shopping_list_household_idx" ON "shopping_list" USING btree ("householdId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "store" (
    "id" bigserial PRIMARY KEY,
    "householdId" bigint NOT NULL,
    "name" text NOT NULL,
    "color" text NOT NULL DEFAULT 'sage'::text,
    "address" text,
    "categoryOrder" json NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "store_household_idx" ON "store" USING btree ("householdId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "catalog_item"
    ADD CONSTRAINT "catalog_item_fk_0"
    FOREIGN KEY("householdId")
    REFERENCES "household"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "shopping_item"
    ADD CONSTRAINT "shopping_item_fk_0"
    FOREIGN KEY("householdId")
    REFERENCES "household"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "shopping_item"
    ADD CONSTRAINT "shopping_item_fk_1"
    FOREIGN KEY("listId")
    REFERENCES "shopping_list"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "shopping_item"
    ADD CONSTRAINT "shopping_item_fk_2"
    FOREIGN KEY("catalogItemId")
    REFERENCES "catalog_item"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "shopping_item"
    ADD CONSTRAINT "shopping_item_fk_3"
    FOREIGN KEY("addedById")
    REFERENCES "nest_user"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "shopping_list"
    ADD CONSTRAINT "shopping_list_fk_0"
    FOREIGN KEY("householdId")
    REFERENCES "household"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "store"
    ADD CONSTRAINT "store_fk_0"
    FOREIGN KEY("householdId")
    REFERENCES "household"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR nest
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('nest', '20261028063321061', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261028063321061', "timestamp" = now();

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
