DROP TABLE IF EXISTS "public"."fabricpersistentstate";
-- This script only contains the table creation statements and does not fully represent the table in the database. Do not use it as a backup.

-- Table Definition
CREATE TABLE "public"."fabricpersistentstate" (
    "state" varchar,
    "fabricid" varchar,
    "fabricexecutionid" varchar,
    "context" jsonb,
    "anyerror" bool,
    "subscriber" varchar,
    "tenant" varchar,
    "startedtime" int4,
    "endtime" int4,
    "blockcontext" jsonb
);


