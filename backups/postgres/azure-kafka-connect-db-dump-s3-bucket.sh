#!/usr/bin/env bash
set -euo pipefail

# ---- DB auth (Azure) ----
export PGPASSWORD='QUILRroot3579'
PGHOST="quilr-psqlspotnanapoc-customer.postgres.database.azure.com"
PGUSER="adminuser"
PGDATABASE="kafka_connect"
SCHEMA="snowdata_schema"

# ---- S3 target ----
BUCKET="quilr-aws-azure-migration"
PREFIX="backups/postgres/kafka_connect"
S3_BASE="s3://${BUCKET}/${PREFIX}"

# ---- Date & pacing ----
DATE="$(date +%d%m%Y)"         # e.g. 21082025
SLEEP_SECS="${SLEEP_SECS:-10}"  # override by env if you want (e.g., SLEEP_SECS=1)

# ---- Tables to dump ----
TABLES=(
  alertclassify
  alertmeta
  behaviourprofile
  behaviourprofileaggregated
  daily_org_analytics
  filedata
  postureprofileaggregated
  transformeddata
  userscoresnapshot
  userscoresnapshotaggregated
)

echo "Starting dumps from ${PGDATABASE}@${PGHOST} (schema: ${SCHEMA}) on ${DATE}"

for tbl in "${TABLES[@]}"; do
  FILE="${tbl}_dump_${DATE}.sql"
  FQTN="${SCHEMA}.${tbl}"

  echo "Dumping table ${FQTN} -> ${FILE}"
  pg_dump -v -h "$PGHOST" -U "$PGUSER" -d "$PGDATABASE" \
    -t "${FQTN}" \
    -f "${FILE}"

  echo "Uploading to ${S3_BASE}/${DATE}/${FILE}"
  aws s3 cp "${FILE}" "${S3_BASE}/${DATE}/${FILE}" --sse AES256

  echo "Publishing latest: ${S3_BASE}/latest/${tbl}_dump.sql"
  aws s3 cp "${FILE}" "${S3_BASE}/latest/${tbl}_dump.sql" --sse AES256

  echo "Done: ${tbl}. Sleeping ${SLEEP_SECS}s..."
  sleep "${SLEEP_SECS}"
done

echo "All table dumps completed."
