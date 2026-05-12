#!/usr/bin/env bash
# Segment: current working directory (with ~ replacement + truncate).
source "${CCSL_ROOT}/lib/config.sh"
ccsl_theme_load "${CCSL_THEME:-$CCSL_CFG_THEME}"

CWD=$(ccsl_read_json "workspace.current_dir")
[ -z "$CWD" ] && CWD=$(ccsl_read_json "cwd")
[ -z "$CWD" ] && CWD="$PWD"

DISPLAY="${CWD/#$HOME/~}"
TRUNC="${CCSL_CFG_TRUNCATE_DIR:-40}"
DISPLAY=$(ccsl_truncate "$DISPLAY" "$TRUNC")

C=$(ccsl_color accent_blue)
R=$'\033[0m'
ICON=""
[ "${CCSL_CFG_ICONS:-true}" = "true" ] && ICON="📁 "

printf '%s%s%s%s' "$C" "$ICON" "$DISPLAY" "$R"
