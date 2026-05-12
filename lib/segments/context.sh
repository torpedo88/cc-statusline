#!/usr/bin/env bash
# Segment: context window usage estimate from cost.input_tokens.
# Renders a horizontal bar plus percent of model's context window.
source "${CCSL_ROOT}/lib/config.sh"
ccsl_theme_load "${CCSL_THEME:-$CCSL_CFG_THEME}"

TOKENS=$(ccsl_read_json "cost.total_input_tokens")
[ -z "$TOKENS" ] || [ "$TOKENS" = "0" ] && exit 0

MODEL=$(ccsl_read_json "model.id")
case "$MODEL" in
  *1m*|*200k*) WINDOW=1000000 ;;
  *opus*|*sonnet*|*haiku*) WINDOW=200000 ;;
  *) WINDOW=200000 ;;
esac

PCT=$(( TOKENS * 100 / WINDOW ))
[ "$PCT" -gt 100 ] && PCT=100

if [ "$PCT" -lt 50 ]; then
  C=$(ccsl_color accent_green)
elif [ "$PCT" -lt 80 ]; then
  C=$(ccsl_color accent_yellow)
else
  C=$(ccsl_color accent_red)
fi
DIM=$(ccsl_color dim)
R=$'\033[0m'

BAR_WIDTH=8
FILLED=$(( PCT * BAR_WIDTH / 100 ))
EMPTY=$(( BAR_WIDTH - FILLED ))
BAR=""
[ "$FILLED" -gt 0 ] && BAR=$(printf '█%.0s' $(seq 1 "$FILLED"))
[ "$EMPTY" -gt 0 ] && BAR="${BAR}$(printf '░%.0s' $(seq 1 "$EMPTY"))"

printf '%s%s%s %s%d%%%s' "$C" "$BAR" "$R" "$DIM" "$PCT" "$R"
