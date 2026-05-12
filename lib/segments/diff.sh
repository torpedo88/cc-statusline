#!/usr/bin/env bash
# Segment: lines added/removed in session.
source "${CCSL_ROOT}/lib/config.sh"
ccsl_theme_load "${CCSL_THEME:-$CCSL_CFG_THEME}"

ADDED=$(ccsl_read_json "cost.total_lines_added")
REMOVED=$(ccsl_read_json "cost.total_lines_removed")

ADDED=${ADDED:-0}
REMOVED=${REMOVED:-0}

[ "$ADDED" = "0" ] && [ "$REMOVED" = "0" ] && exit 0

GREEN=$(ccsl_color accent_green)
RED=$(ccsl_color accent_red)
DIM=$(ccsl_color dim)
R=$'\033[0m'

printf '%s+%s%s%s/%s-%s%s' "$GREEN" "$ADDED" "$R" "$DIM" "$RED" "$REMOVED" "$R"
