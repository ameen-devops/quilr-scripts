DROP TABLE IF EXISTS "public"."fabriccontextstore";
-- This script only contains the table creation statements and does not fully represent the table in the database. Do not use it as a backup.

-- Table Definition
CREATE TABLE "public"."fabriccontextstore" (
    "fabricid" varchar NOT NULL,
    "key" varchar NOT NULL,
    "value" varchar(2000) NOT NULL,
    "subscriber" varchar NOT NULL,
    "tenant" varchar NOT NULL,
    "fabricexecutionid" varchar NOT NULL
);


