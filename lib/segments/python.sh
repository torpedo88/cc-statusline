#!/usr/bin/env bash
# Segment: active python virtualenv.
source "${CCSL_ROOT}/lib/config.sh"
ccsl_theme_load "${CCSL_THEME:-$CCSL_CFG_THEME}"

VENV=""
[ -n "${VIRTUAL_ENV:-}" ] && VENV=$(basename "$VIRTUAL_ENV")
[ -z "$VENV" ] && [ -n "${CONDA_DEFAULT_ENV:-}" ] && VENV="$CONDA_DEFAULT_ENV"
[ -z "$VENV" ] && exit 0

C=$(ccsl_color accent_yellow)
R=$'\033[0m'
ICON=""
[ "${CCSL_CFG_ICONS:-true}" = "true" ] && ICON=" "

printf '%s%s%s%s' "$C" "$ICON" "$VENV" "$R"
