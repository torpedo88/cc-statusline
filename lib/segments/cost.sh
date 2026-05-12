#!/usr/bin/env bash
# Segment: session cost (USD).
source "${CCSL_ROOT}/lib/config.sh"
ccsl_theme_load "${CCSL_THEME:-$CCSL_CFG_THEME}"

COST=$(ccsl_read_json "cost.total_cost_usd")
[ -z "$COST" ] && exit 0

if [ "${CCSL_CFG_HIDE_ZERO_COST:-true}" = "true" ]; then
  case "$COST" in
    0|0.0|0.00|0.000|0.0000) exit 0 ;;
  esac
fi

COST_FMT=$(printf '%.4f' "$COST" 2>/dev/null || echo "$COST")

C=$(ccsl_color accent_yellow)
R=$'\033[0m'
ICON=""
[ "${CCSL_CFG_ICONS:-true}" = "true" ] && ICON=""

printf '%s%s$%s%s' "$C" "$ICON" "$COST_FMT" "$R"
