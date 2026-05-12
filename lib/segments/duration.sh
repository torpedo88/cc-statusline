#!/usr/bin/env bash
# Segment: session duration.
source "${CCSL_ROOT}/lib/config.sh"
ccsl_theme_load "${CCSL_THEME:-$CCSL_CFG_THEME}"

MS=$(ccsl_read_json "cost.total_duration_ms")
[ -z "$MS" ] || [ "$MS" = "0" ] && exit 0

SECS=$((MS / 1000))
if [ "$SECS" -ge 3600 ]; then
  H=$((SECS / 3600))
  M=$(( (SECS % 3600) / 60 ))
  DUR="${H}h${M}m"
elif [ "$SECS" -ge 60 ]; then
  M=$((SECS / 60))
  S=$((SECS % 60))
  DUR="${M}m${S}s"
else
  DUR="${SECS}s"
fi

DIM=$(ccsl_color dim)
R=$'\033[0m'
ICON=""
[ "${CCSL_CFG_ICONS:-true}" = "true" ] && ICON="⏱ "

printf '%s%s%s%s' "$DIM" "$ICON" "$DUR" "$R"
