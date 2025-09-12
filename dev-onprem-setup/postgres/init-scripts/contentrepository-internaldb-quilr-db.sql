DROP TABLE IF EXISTS "public"."contentrepository";
-- This script only contains the table creation statements and does not fully represent the table in the database. Do not use it as a backup.

-- Table Definition
CREATE TABLE "public"."contentrepository" (
    "id" varchar NOT NULL,
    "type" varchar(255),
    "version" varchar(255),
    "schedule" varchar(255),
    "source" jsonb,
    "destination" jsonb,
    "config" jsonb,
    "lambda" text,
    "createdon" date,
    "updatedon" date,
    "historicalrecordduration" varchar,
    "context" varchar(255) NOT NULL DEFAULT 'user'::character varying,
    "istrackable" bool NOT NULL DEFAULT false,
    "name" varchar(255),
    "subscriber" varchar,
    "tenant" varchar,
    "active" bool,
    "lambda_config" jsonb
);
