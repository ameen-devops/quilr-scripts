DROP TABLE IF EXISTS "snowdata_schema"."alertclassify";
-- This script only contains the table creation statements and does not fully represent the table in the database. Do not use it as a backup.

-- Table Definition
CREATE TABLE "snowdata_schema"."alertclassify" (
    "record_metadata" jsonb NOT NULL,
    "id" text,
    "context_id" text,
    "alertid" text,
    "alerttype" text,
    "alertsubtype" text,
    "severity" text,
    "generationtime" int8,
    "eventtime" int8,
    "entitytype" text,
    "entity" text,
    "tags" jsonb,
    "status" text,
    "isresolved" bool,
    "assignmentstatus" text,
    "sla" text,
    "source" text,
    "level" text,
    "levelname" text,
    "levelcode" text,
    "score" float8,
    "createdby" text,
    "subscriber" text,
    "tenant" text,
    "mode" text,
    "resolutionchannel" text,
    "businessjustification" text,
    "assignedtotype" text,
    "copilotstatus" text,
    "actionstatus" text,
    "actiontaken" text,
    "impactcode" text,
    "likelihoodcode" text
);


