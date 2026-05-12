#!/usr/bin/env bash
# Segment: short session id.
source "${CCSL_ROOT}/lib/config.sh"
ccsl_theme_load "${CCSL_THEME:-$CCSL_CFG_THEME}"

SID=$(ccsl_read_json "session_id")
[ -z "$SID" ] && exit 0

SHORT="${SID:0:8}"
DIM=$(ccsl_color dim)
R=$'\033[0m'

printf '%s%s%s' "$DIM" "$SHORT" "$R"
