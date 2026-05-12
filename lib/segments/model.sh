#!/usr/bin/env bash
# Segment: Claude model display name.
source "${CCSL_ROOT}/lib/config.sh"
ccsl_theme_load "${CCSL_THEME:-$CCSL_CFG_THEME}"

MODEL=$(ccsl_read_json "model.display_name")
[ -z "$MODEL" ] && exit 0

C=$(ccsl_color accent_purple)
R=$'\033[0m'
ICON=""
[ "${CCSL_CFG_ICONS:-true}" = "true" ] && ICON="⚡ "

printf '%s%s%s%s' "$C" "$ICON" "$MODEL" "$R"
