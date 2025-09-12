-- Create the database and schema
CREATE DATABASE development;
-- Connect to db for further operations
\connect development;

CREATE TABLE IF NOT EXISTS SCHEMAMODIFICATIONHISTORY (
    id SERIAL PRIMARY KEY,  -- Automatically incrementing primary key
    query VARCHAR(1000) NOT NULL,
    registryid BIGINT NOT NULL,
    response TEXT NOT NULL  -- Use TEXT for large strings
);

CREATE TABLE IF NOT EXISTS SCHEMAREGISTRY (
    id SERIAL PRIMARY KEY,
    subscriber VARCHAR(36) NOT NULL,
    updatedby VARCHAR(100) NOT NULL,
    updatedat BIGINT NOT NULL,
    tablename VARCHAR(100) NOT NULL,
    modeljson JSONB NOT NULL,
    source VARCHAR(100) NOT NULL,
    type VARCHAR(100) NOT NULL,
    UNIQUE (subscriber, tablename, type, source) -- UNIQUE CONSTRAINT
);

CREATE TABLE IF NOT EXISTS SCHEMAREGISTRYHISTORY (
    id SERIAL PRIMARY KEY,
    subscriber VARCHAR(36) NOT NULL,
    createdby VARCHAR(100) NOT NULL,
    createdat BIGINT NOT NULL,
    tablename VARCHAR(100) NOT NULL,
    modeljson JSONB NOT NULL,
    source VARCHAR(100) NOT NULL,
    type VARCHAR(100) NOT NULL,
    registryid BIGINT NOT NULL 
);

CREATE TABLE IF NOT EXISTS SUBSCRIBERCONNECTIONCONFIG (
    id SERIAL PRIMARY KEY,
    subscriber VARCHAR(36) NOT NULL,
    source VARCHAR(100) NOT NULL,
    config JSONB NOT NULL,
    status VARCHAR(100) NOT NULL DEFAULT 'ACTIVE',
    UNIQUE (subscriber, source)  -- Unique constraint
);

 -- Create the database and schema
CREATE DATABASE kafka_connect;
-- Connect to db for further operations
\connect kafka_connect;

CREATE SCHEMA IF NOT EXISTS snowdata_schema;

CREATE TABLE IF NOT EXISTS snowdata_schema.BEHAVIOURPROFILEAGGREGATED (
    year INTEGER,
    monthofyear INTEGER,
    dayofmonth INTEGER,
    subscriber VARCHAR(36),
    tenant VARCHAR(36),
    agg_type_name TEXT,
    agg_subtype_name TEXT,
    agg_subtype TEXT,
    average_count DOUBLE PRECISION,
    alert_percentile DOUBLE PRECISION,
    agg_type TEXT,
    timestamp BIGINT
);

CREATE TABLE IF NOT EXISTS snowdata_schema.DAILY_ORG_ANALYTICS (
    total_apps BIGINT,
    total_users BIGINT,
    total_accounts BIGINT,
    critical_apps BIGINT,
    subscriber VARCHAR(36) NOT NULL,
    tenant VARCHAR(36) NOT NULL,
    dayofmonth INTEGER NOT NULL,
    year INTEGER NOT NULL,
    monthofyear INTEGER NOT NULL,
    timestamp BIGINT NOT NULL,
    total_apps_change BIGINT,
    total_users_change BIGINT,
    total_accounts_change BIGINT,
    critical_apps_change BIGINT,
    total_ai_apps BIGINT,
    total_ai_apps_change BIGINT,
    total_ai_apps_account BIGINT,
    total_ai_apps_account_change BIGINT,
    new_ai_apps_change BIGINT,
    new_ai_apps BIGINT,
    most_used_ai_apps BIGINT,
    most_used_ai_apps_change BIGINT,
    new_account_count BIGINT,
    total_ununsed_account_count BIGINT,
    total_unused_account_count_change BIGINT,
    PRIMARY KEY (subscriber, tenant, dayofmonth, year, monthofyear)
);

CREATE TABLE IF NOT EXISTS snowdata_schema.POSTUREPROFILEAGGREGATED (
    year INTEGER,
    monthofyear INTEGER,
 dayofmonth INTEGER,
 subscriber VARCHAR(36),
 tenant VARCHAR(36),
 AGG_TYPE_NAME TEXT,
 AGG_SUBTYPE_NAME TEXT,
 AGG_SUBTYPE TEXT,
 AVERAGE_COUNT DOUBLE PRECISION,
 ALERT_PERCENTILE DOUBLE PRECISION,
 AGG_TYPE TEXT,
 TIMESTAMP BIGINT
);

CREATE TABLE IF NOT EXISTS snowdata_schema.USERSCORESNAPSHOTAGGREGATED (
    YEAR INTEGER,
 MONTHOFYEAR INTEGER,
 DAYOFMONTH INTEGER,
 SUBSCRIBER VARCHAR(36),
 TENANT VARCHAR(36),
 AGG_TYPE TEXT,
 AGG_TYPE_NAME TEXT,
 AGG_SUBTYPE TEXT,
 AGG_SUBTYPE_NAME TEXT,
 RISK_SCORE DOUBLE PRECISION,
    ALERT_PERCENTILE DOUBLE PRECISION,
 TIMESTAMP BIGINT
);
