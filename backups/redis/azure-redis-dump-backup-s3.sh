#!/usr/bin/env bash
set -euo pipefail

# ---- Config ----
NAMESPACE="quilr"
POD="my-redis-master-0"
REDIS_AUTH="quilr353"    # Redis password you confirmed
LOCAL_DUMP="/home/quilradmin/redis-backup/dump.rdb"

BUCKET="quilr-aws-azure-migration"
PREFIX="backups/redis"
S3_BASE="s3://${BUCKET}/${PREFIX}"

DATE=$(date +%d%m%Y)
FILE="redis_dump_${DATE}.rdb"

# ---- Trigger dump inside Redis ----
echo "Triggering SAVE inside Redis ..."
kubectl exec -n "$NAMESPACE" "$POD" -- \
  redis-cli -a "$REDIS_AUTH" SAVE

# ---- Copy dump.rdb from container ----
echo "Copying dump.rdb from pod to VM ..."
kubectl cp "${NAMESPACE}/${POD}:/data/dump.rdb" "$LOCAL_DUMP"

# ---- Upload to S3 ----
echo "Uploading dump to S3 ..."
aws s3 cp "$LOCAL_DUMP" "${S3_BASE}/${DATE}/${FILE}" --sse AES256
aws s3 cp "$LOCAL_DUMP" "${S3_BASE}/latest/redis_dump.rdb" --sse AES256

echo "Backup complete:"
echo "  dated : ${S3_BASE}/${DATE}/${FILE}"
echo "  latest: ${S3_BASE}/latest/redis_dump.rdb"
