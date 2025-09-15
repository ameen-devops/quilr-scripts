#!/usr/bin/env bash
# scan_probes_grid.sh — Service | Probe | Status | initDelay | periodSeconds | timeoutSeconds | failureThreshold
#./scan_probes_with_values.sh | grep -Ei 'commented|not there'


set -euo pipefail
ROOT="${1:-.}"

# ---------- helpers ----------
extract_block() {
  # $1=file  $2=probeName
  awk -v p="$2" '
    BEGIN{ inProbe=0; baseIndent=0 }
    /^[[:space:]]*#/ { if(inProbe){ print; next } else { next } }
    $0 ~ "^[[:space:]]*" p "[[:space:]]*:[[:space:]]*$" { inProbe=1; baseIndent=match($0,/[^ ]/); next }
    inProbe {
      curIndent=match($0,/[^ ]/)
      if(curIndent<=baseIndent && $0 !~ /^[[:space:]]*$/){ exit 0 }
      print
      next
    }
  ' "$1"
}

service_from_path() {
  awk -v p="$1" '
    BEGIN{
      gsub(/\\/, "/", p); n=split(p,a,"/");
      for(i=1;i<=n;i++) if(a[i]=="templates"){ if(i>1){ print a[i-1]; exit } }
      if(n>=2) print a[n-1]; else print a[n]
    }'
}

# ---------- gather rows (TSV) ----------
rows=()
rows+=($'Service/Chart\tProbe\tStatus\tinitDelay\tperiodSeconds\ttimeoutSeconds\tfailureThreshold')

while IFS= read -r -d '' f; do
  service="$(service_from_path "$f")"
  for probe in readinessProbe livenessProbe; do
    status="not there"; init=""; period=""; timeout=""; failure=""

    grep -Eq "^[[:space:]]*#\s*$probe\s*:" "$f" && status="commented"
    if grep -Eq "^[[:space:]]*$probe\s*:" "$f"; then
      status="present"
      block="$(extract_block "$f" "$probe" || true)"
      init=$(   printf "%s\n" "$block" | sed -nE 's/^[[:space:]]*initialDelaySeconds:[[:space:]]*(.*)$/\1/p' | head -1)
      period=$( printf "%s\n" "$block" | sed -nE 's/^[[:space:]]*periodSeconds:[[:space:]]*(.*)$/\1/p'       | head -1)
      timeout=$(printf "%s\n" "$block" | sed -nE 's/^[[:space:]]*timeoutSeconds:[[:space:]]*(.*)$/\1/p'      | head -1)
      failure=$(printf "%s\n" "$block" | sed -nE 's/^[[:space:]]*failureThreshold:[[:space:]]*(.*)$/\1/p'    | head -1)
    fi

    rows+=("$service"$'\t'"$probe"$'\t'"$status"$'\t'"$init"$'\t'"$period"$'\t'"$timeout"$'\t'"$failure")
  done
done < <(find "$ROOT" -type d -name "services-scale-down-or-in-progress" -prune -o \
               -type f \( -name "deployment.yaml" -o -name "deployment.yml" \) -print0)

# ---------- pretty print as a boxed table with auto widths ----------
printf "%s\n" "${rows[@]}" | awk -F'\t' '
function border(   i,j) {
  printf("+");
  for (i=1;i<=nf;i++) {
    for (j=0;j<w[i]+2;j++) printf("-");
    printf("+");
  }
  printf("\n");
}
function printrow(arr,   i,val) {
  printf("|");
  for (i=1;i<=nf;i++) {
    val = (i in arr ? arr[i] : "");
    printf(" %-" w[i] "s |", val);
  }
  printf("\n");
}
{
  for (i=1;i<=NF;i++) if (length($i)>w[i]) w[i]=length($i);
  r[NR]=$0; nf=NF;
}
END{
  if (NR==0) exit 0;
  border();
  split(r[1],h,FS); printrow(h); border();
  for (row=2; row<=NR; row++) { split(r[row],a,FS); printrow(a); border(); }
}'
