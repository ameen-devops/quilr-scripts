DROP TABLE IF EXISTS "public"."datapipeline";
-- This script only contains the table creation statements and does not fully represent the table in the database. Do not use it as a backup.

-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS datapipeline_id_seq;

-- Table Definition
CREATE TABLE "public"."datapipeline" (
    "id" int8 NOT NULL DEFAULT nextval('datapipeline_id_seq'::regclass),
    "content_id" varchar(255) NOT NULL,
    "ended_at" int8,
    "error" varchar(255),
    "execution_count" int4 NOT NULL,
    "execution_type" varchar(255) NOT NULL,
    "instance_id" varchar(255) NOT NULL,
    "integration_id" varchar(255) NOT NULL,
    "is_trackable" bool NOT NULL,
    "last_ended_at" int8,
    "last_started_at" int8,
    "meta" jsonb,
    "name" varchar(255) NOT NULL,
    "output" jsonb,
    "schedule" varchar(255) NOT NULL,
    "started_at" int8 NOT NULL,
    "status" varchar(255) NOT NULL,
    "subscriber" varchar(255) NOT NULL,
    "tenant" varchar(255) NOT NULL,
    "updated_at" int8 NOT NULL,
    PRIMARY KEY ("id")
);


-- Indices
CREATE UNIQUE INDEX uc_content_data_pipeline_subscriber_tenant ON public.datapipeline USING btree (subscriber, tenant, instance_id, content_id);