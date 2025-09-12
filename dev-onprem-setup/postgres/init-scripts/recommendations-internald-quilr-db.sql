DROP TABLE IF EXISTS "public"."recommendations";
-- This script only contains the table creation statements and does not fully represent the table in the database. Do not use it as a backup.

-- Table Definition
CREATE TABLE "public"."recommendations" (
    "id" varchar NOT NULL,
    "name" varchar,
    "recommendation" varchar,
    "behavior" varchar,
    "subscriber" varchar,
    "tenant" varchar,
    "generation_time" timestamp,
    "config" jsonb,
    PRIMARY KEY ("id")
);


