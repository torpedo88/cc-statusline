#!/usr/bin/env bash
# Segment: total token usage (input + output, formatted as k/M).
source "${CCSL_ROOT}/lib/config.sh"
ccsl_theme_load "${CCSL_THEME:-$CCSL_CFG_THEME}"

IN=$(ccsl_read_json "cost.total_input_tokens")
OUT=$(ccsl_read_json "cost.total_output_tokens")
IN=${IN:-0}
OUT=${OUT:-0}

[ "$IN" = "0" ] && [ "$OUT" = "0" ] && exit 0

fmt() {
  local n="$1"
  if [ "$n" -ge 1000000 ]; then
    printf '%.1fM' "$(echo "$n/1000000" | bc -l 2>/dev/null || echo 0)"
  elif [ "$n" -ge 1000 ]; then
    printf '%.1fk' "$(echo "$n/1000" | bc -l 2>/dev/null || echo 0)"
  else
    printf '%d' "$n"
  fi
}

DIM=$(ccsl_color dim)
C=$(ccsl_color accent_cyan)
R=$'\033[0m'

printf '%s↓%s%s %s↑%s%s' "$C" "$(fmt "$IN")" "$R" "$C" "$(fmt "$OUT")" "$R"
