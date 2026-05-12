#!/usr/bin/env bash
# Segment: git branch + dirty + ahead/behind counts.
source "${CCSL_ROOT}/lib/config.sh"
ccsl_theme_load "${CCSL_THEME:-$CCSL_CFG_THEME}"

command -v git >/dev/null 2>&1 || exit 0

CWD=$(ccsl_read_json "workspace.current_dir")
[ -z "$CWD" ] && CWD="$PWD"

BRANCH=$(git -C "$CWD" rev-parse --abbrev-ref HEAD 2>/dev/null)
[ -z "$BRANCH" ] && exit 0
[ "$BRANCH" = "HEAD" ] && BRANCH=$(git -C "$CWD" rev-parse --short HEAD 2>/dev/null)

TRUNC="${CCSL_CFG_TRUNCATE_BRANCH:-20}"
BRANCH=$(ccsl_truncate "$BRANCH" "$TRUNC")

DIRTY=""
if [ -n "$(git -C "$CWD" status --porcelain 2>/dev/null)" ]; then
  DIRTY="*"
fi

AHEAD_BEHIND=""
COUNTS=$(git -C "$CWD" rev-list --count --left-right '@{u}...HEAD' 2>/dev/null)
if [ -n "$COUNTS" ]; then
  BEHIND=$(echo "$COUNTS" | cut -f1)
  AHEAD=$(echo "$COUNTS" | cut -f2)
  [ "$AHEAD" != "0" ] && AHEAD_BEHIND="${AHEAD_BEHIND}↑${AHEAD}"
  [ "$BEHIND" != "0" ] && AHEAD_BEHIND="${AHEAD_BEHIND}↓${BEHIND}"
fi

C=$(ccsl_color accent_pink)
R=$'\033[0m'
ICON=""
[ "${CCSL_CFG_ICONS:-true}" = "true" ] && ICON=" "

printf '%s%s%s%s' "$C" "$ICON" "$BRANCH" "$DIRTY"
[ -n "$AHEAD_BEHIND" ] && printf ' %s' "$AHEAD_BEHIND"
printf '%s' "$R"
