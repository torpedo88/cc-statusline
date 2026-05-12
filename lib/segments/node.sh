#!/usr/bin/env bash
# Segment: node version (only shows in node projects).
source "${CCSL_ROOT}/lib/config.sh"
ccsl_theme_load "${CCSL_THEME:-$CCSL_CFG_THEME}"

CWD=$(ccsl_read_json "workspace.current_dir")
[ -z "$CWD" ] && CWD="$PWD"

[ -f "$CWD/package.json" ] || [ -f "$CWD/.nvmrc" ] || exit 0
command -v node >/dev/null 2>&1 || exit 0

VER=$(node --version 2>/dev/null | tr -d 'v')
[ -z "$VER" ] && exit 0

C=$(ccsl_color accent_green)
R=$'\033[0m'
ICON=""
[ "${CCSL_CFG_ICONS:-true}" = "true" ] && ICON=" "

printf '%s%snode %s%s' "$C" "$ICON" "$VER" "$R"
