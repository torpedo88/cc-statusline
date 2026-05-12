#!/usr/bin/env bash
# Segment: current local time.
source "${CCSL_ROOT}/lib/config.sh"
ccsl_theme_load "${CCSL_THEME:-$CCSL_CFG_THEME}"

FMT="${CCSL_CFG_DATE_FORMAT:-%H:%M}"
TIME=$(date +"$FMT")

DIM=$(ccsl_color dim)
R=$'\033[0m'
ICON=""
[ "${CCSL_CFG_ICONS:-true}" = "true" ] && ICON="🕐 "

printf '%s%s%s%s' "$DIM" "$ICON" "$TIME" "$R"
