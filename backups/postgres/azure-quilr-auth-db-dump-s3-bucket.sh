#!/usr/bin/env bash
set -euo pipefail

export PGPASSWORD='QUILRroot3579'

PGHOST="quilr-psqlspotnanapoc-internal.postgres.database.azure.com"
PGUSER="adminuser"
PGDATABASE="quilr_auth"

BUCKET="quilr-aws-azure-migration"
PREFIX="backups/postgres"

DATE=$(date +%d%m%Y)
FILE="quilr_auth_db_dump_${DATE}.sql"
S3_BASE="s3://${BUCKET}/${PREFIX}"

echo "Dumping ${PGDATABASE}@${PGHOST} -> ${FILE}"
pg_dump -v -h "$PGHOST" -U "$PGUSER" -d "$PGDATABASE" > "$FILE"

# Store under the date folder
aws s3 cp "$FILE" "${S3_BASE}/${DATE}/${FILE}" --sse AES256

# Also publish/overwrite a stable alias
aws s3 cp "$FILE" "${S3_BASE}/latest/quilr_auth_db_dump.sql" --sse AES256

echo "Done:"
echo "  dated : ${S3_BASE}/${DATE}/${FILE}"
echo "  latest: ${S3_BASE}/latest/quilr_auth_db_dump.sql"
