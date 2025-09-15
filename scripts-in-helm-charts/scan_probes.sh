#!/usr/bin/env bash
# scan_probes.sh
# Usage: ./scan_probes.sh /path/to/quilr-helm-charts

ROOT="${1:-.}"

printf "%-30s | %-40s | %-12s | %-10s\n" "Service/Chart" "File" "Probe" "Status"
printf -- "-------------------------------------------------------------------------------------------------------------\n"

find "$ROOT" -type d -name "services-scale-down-or-in-progress" -prune -o \
             -type f -name "deployment.yaml" -print | while read -r file; do
  service=$(basename "$(dirname "$(dirname "$file")")")

  for probe in readinessProbe livenessProbe; do
    if grep -Eq "^[[:space:]]*$probe:" "$file"; then
      status="present"
    elif grep -Eq "^[[:space:]]*#.*$probe:" "$file"; then
      status="commented"
    else
      status="not there"
    fi
    printf "%-30s | %-40s | %-12s | %-10s\n" "$service" "$(basename "$file")" "$probe" "$status"
  done
done
