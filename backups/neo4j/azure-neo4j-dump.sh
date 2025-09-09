#!/usr/bin/env bash
set -euo pipefail

# === Config ===
DB="neo4j"
BASE="/home/quilradmin/neo4j-backups"                         # local base folder
S3_BASE="s3://quilr-aws-azure-migration/backups/neo4j"       # S3 base prefix
TZ_REGION="Asia/Kolkata"                                      # timestamps in IST
LOG_DIR="$BASE/.logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/dump_$(date +'%Y-%m').log"

# Ensure Neo4j comes back up on any error
cleanup() {
  # If neo4j isn't running, try to start it
  if ! systemctl is-active --quiet neo4j; then
    echo "[${STAMP:-no-ts}] Bringing Neo4j back up..." | tee -a "$LOG_FILE"
    sudo systemctl start neo4j || true
  fi
}
trap cleanup EXIT

# === Timestamped paths (IST) ===
# Folder like 21-Aug-2025/1200
TS_FOLDER=$(TZ=$TZ_REGION date +'%d-%b-%Y/%H00')
# e.g., 21-Aug-2025_1233_IST
STAMP=$(TZ=$TZ_REGION date +'%d-%b-%Y_%H%M_%Z')
OUTDIR="${BASE}/${TS_FOLDER}"
mkdir -p "$OUTDIR"

echo "[${STAMP}] Starting Neo4j dump to: $OUTDIR" | tee -a "$LOG_FILE"

# --- Preflight checks ---
command -v aws >/dev/null 2>&1 || { echo "[${STAMP}] ERROR: aws CLI not found" | tee -a "$LOG_FILE"; exit 1; }
command -v neo4j-admin >/dev/null 2>&1 || { echo "[${STAMP}] ERROR: neo4j-admin not found" | tee -a "$LOG_FILE"; exit 1; }

# --- Stop Neo4j (offline dump is safest) ---
echo "[${STAMP}] Stopping Neo4j..." | tee -a "$LOG_FILE"
sudo systemctl stop neo4j
while systemctl is-active --quiet neo4j; do sleep 1; done
echo "[${STAMP}] Neo4j stopped." | tee -a "$LOG_FILE"

# --- Dump (Neo4j 5+) ---
echo "[${STAMP}] Running neo4j-admin dump..." | tee -a "$LOG_FILE"
sudo neo4j-admin database dump "$DB" --to-path="$OUTDIR" --overwrite-destination

# --- Rename dump to include IST stamp ---
if [ -f "$OUTDIR/$DB.dump" ]; then
  mv "$OUTDIR/$DB.dump" "$OUTDIR/${DB}-${STAMP}.dump"
fi

DUMP_FILE="$OUTDIR/${DB}-${STAMP}.dump"
if [ ! -f "$DUMP_FILE" ]; then
  echo "[${STAMP}] ERROR: dump file not found: $DUMP_FILE" | tee -a "$LOG_FILE"
  exit 1
fi

# --- Start Neo4j back ---
echo "[${STAMP}] Starting Neo4j..." | tee -a "$LOG_FILE"
sudo systemctl start neo4j
echo "[${STAMP}] Neo4j start triggered." | tee -a "$LOG_FILE"

# --- Upload to S3 preserving VM structure ---
# We only sync the current run's subfolder to the matching S3 path:
#   local:  /home/.../21-Aug-2025/1200/
#   remote: s3://.../neo4j/21-Aug-2025/1200/
S3_DEST="${S3_BASE}/${TS_FOLDER}"

echo "[${STAMP}] Uploading to S3: $S3_DEST" | tee -a "$LOG_FILE"
# Trailing slashes ensure we copy *contents* of OUTDIR into the same subpath on S3
aws s3 sync "${OUTDIR}/" "${S3_DEST}/" --only-show-errors | tee -a "$LOG_FILE"

# Optional: lightweight verification by size
LOCAL_SIZE=$(stat -c%s "$DUMP_FILE")
S3_LIST=$(aws s3 ls "${S3_DEST}/" | awk '{print $3" "$4}')
S3_SIZE=$(echo "$S3_LIST" | awk -v name="$(basename "$DUMP_FILE")" '$2==name{print $1}')
if [ "${S3_SIZE:-0}" != "$LOCAL_SIZE" ]; then
  echo "[${STAMP}] WARNING: size mismatch (local $LOCAL_SIZE vs s3 ${S3_SIZE:-0}). Please re-check." | tee -a "$LOG_FILE"
else
  echo "[${STAMP}] Upload verified by size." | tee -a "$LOG_FILE"
fi

echo "[${STAMP}] Done. File: $DUMP_FILE" | tee -a "$LOG_FILE"
