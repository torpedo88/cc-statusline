#!/usr/bin/env bash
# Segment: active Claude Code profile (symlink at ~/.claude/.active-profile).
source "${CCSL_ROOT}/lib/config.sh"
ccsl_theme_load "${CCSL_THEME:-$CCSL_CFG_THEME}"

PROFILE=""
PROFILE_FILE="$HOME/.claude/.active-profile"

if [ -L "$PROFILE_FILE" ]; then
  PROFILE=$(basename "$(readlink "$PROFILE_FILE")")
elif [ -f "$PROFILE_FILE" ]; then
  PROFILE=$(head -c 32 "$PROFILE_FILE" 2>/dev/null | tr -cd 'a-zA-Z0-9_-')
fi

[ -z "$PROFILE" ] && exit 0

C=$(ccsl_color accent_green)
R=$'\033[0m'
ICON=""
[ "${CCSL_CFG_ICONS:-true}" = "true" ] && ICON="◆ "

printf '%s%s%s%s' "$C" "$ICON" "$PROFILE" "$R"
