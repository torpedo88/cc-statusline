#!/usr/bin/env bash
# Segment: battery percent + charging state. macOS + Linux.
source "${CCSL_ROOT}/lib/config.sh"
ccsl_theme_load "${CCSL_THEME:-$CCSL_CFG_THEME}"

PCT=""
STATE=""

if [ "$(uname)" = "Darwin" ]; then
  OUT=$(pmset -g batt 2>/dev/null)
  PCT=$(echo "$OUT" | grep -oE '[0-9]+%' | head -1 | tr -d '%')
  echo "$OUT" | grep -q "AC Power" && STATE="charging"
elif [ -d /sys/class/power_supply/BAT0 ]; then
  PCT=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null)
  ST=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null)
  [ "$ST" = "Charging" ] && STATE="charging"
fi

[ -z "$PCT" ] && exit 0

if [ "$PCT" -lt 20 ]; then
  C=$(ccsl_color accent_red)
elif [ "$PCT" -lt 50 ]; then
  C=$(ccsl_color accent_yellow)
else
  C=$(ccsl_color accent_green)
fi
R=$'\033[0m'

ICON="🔋"
[ "$STATE" = "charging" ] && ICON="🔌"

printf '%s%s %d%%%s' "$C" "$ICON" "$PCT" "$R"
