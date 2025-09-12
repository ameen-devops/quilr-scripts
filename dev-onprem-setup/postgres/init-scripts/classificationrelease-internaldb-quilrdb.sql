DROP TABLE IF EXISTS "public"."classificationrelease";
-- This script only contains the table creation statements and does not fully represent the table in the database. Do not use it as a backup.

-- Table Definition
CREATE TABLE "public"."classificationrelease" (
    "published" bool,
    "releasedate" timestamp,
    "releaseversion" varchar
);

INSERT INTO "public"."classificationrelease" ("published", "releasedate", "releaseversion") VALUES
('t', '2025-12-31 03:22:51', '1.0');