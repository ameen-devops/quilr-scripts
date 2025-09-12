CREATE DATABASE quilr_auth;
CREATE DATABASE data_simulator;

-- Create the database
CREATE DATABASE quilr;

-- Connect to the quilr database before proceeding
\connect quilr;

-- Create tables with IF NOT EXISTS

CREATE TABLE IF NOT EXISTS contentrelease (
    published BOOLEAN,
    releasedate TIMESTAMP WITHOUT TIME ZONE,
    releaseversion CHARACTER VARYING
);

CREATE TABLE IF NOT EXISTS contentrepository (
    id CHARACTER VARYING NOT NULL,
    type CHARACTER VARYING(255),
    version CHARACTER VARYING(255),
    schedule CHARACTER VARYING(255),
    source JSONB,
    destination JSONB,
    config JSONB,
    lambda TEXT,
    createdon DATE,
    updatedon DATE,
    historicalrecordduration CHARACTER VARYING,
    context CHARACTER VARYING(255) NOT NULL DEFAULT 'user'::CHARACTER VARYING,
    istrackable BOOLEAN NOT NULL DEFAULT FALSE,
    name CHARACTER VARYING(255),
    subscriber CHARACTER VARYING,
    tenant CHARACTER VARYING,
    active BOOLEAN
);

CREATE TABLE IF NOT EXISTS classificationrelease (
    published BOOLEAN,
    releasedate TIMESTAMP WITHOUT TIME ZONE,
    releaseversion CHARACTER VARYING
);

CREATE TABLE IF NOT EXISTS browser_extension (
    id CHARACTER VARYING(255) NOT NULL,
    email CHARACTER VARYING NOT NULL,
    createdon TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    updatedon TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    deletedat TIMESTAMP WITHOUT TIME ZONE,
    linkclicked BOOLEAN NOT NULL DEFAULT FALSE,
    iscookieset BOOLEAN NOT NULL DEFAULT FALSE,
    iscookieerror BOOLEAN NOT NULL DEFAULT FALSE,
    cookieerror CHARACTER VARYING,
    emailsent BOOLEAN NOT NULL DEFAULT FALSE,
    emailsenttimestamp TIMESTAMP WITHOUT TIME ZONE,
    linkclickedtimestamp TIMESTAMP WITHOUT TIME ZONE,
    cookietimestamp TIMESTAMP WITHOUT TIME ZONE,
    extensioninstalled BOOLEAN NOT NULL DEFAULT FALSE,
    extensioninstalledtimestamp TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS recommendations (
    id CHARACTER VARYING PRIMARY KEY,
    name CHARACTER VARYING,
    recommendation CHARACTER VARYING,
    behavior CHARACTER VARYING,
    subscriber CHARACTER VARYING,
    tenant CHARACTER VARYING,
    generation_time TIMESTAMP WITHOUT TIME ZONE,
    config JSONB
);

CREATE TABLE IF NOT EXISTS rule_configurations (
    id BIGSERIAL,
    content_id CHARACTER VARYING(255),
    copilot_status CHARACTER VARYING(255),
    created_at BIGINT,
    rule_id CHARACTER VARYING(255),
    rule_name CHARACTER VARYING(255),
    subscriber CHARACTER VARYING(255),
    tenant CHARACTER VARYING(255),
    version CHARACTER VARYING(255),
    auto_remediation_status CHARACTER VARYING(255),
    type CHARACTER VARYING(255),
    updated_at BIGINT
);
