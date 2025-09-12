DROP TABLE IF EXISTS "public"."classificationrepository";
-- This script only contains the table creation statements and does not fully represent the table in the database. Do not use it as a backup.

-- Table Definition
CREATE TABLE "public"."classificationrepository" (
    "id" varchar NOT NULL,
    "version" varchar,
    "code" varchar,
    "name" varchar,
    "type" varchar,
    "impact" varchar,
    "likelihood" varchar,
    "factor" float8,
    "createdon" timestamp,
    "updatedon" timestamp,
    "range" jsonb,
    "recommendations" jsonb,
    "description" varchar,
    "tags" jsonb,
    "humanfactor" varchar(64),
    "behavior" jsonb,
    "posture" jsonb,
    "examples" jsonb,
    "remediations" jsonb,
    "view" varchar,
    "criticality" varchar,
    "query" varchar,
    "config" jsonb,
    "lambda" varchar,
    "category" varchar,
    "attributes" jsonb,
    "condition" jsonb,
    "disabled" bool,
    "actiontype" varchar,
    "outcomes" jsonb,
    "subscriber" varchar,
    "tenant" varchar,
    "priority" int4
);
