#!/usr/bin/env bash
# Segment: caveman mode badge.
source "${CCSL_ROOT}/lib/config.sh"
ccsl_theme_load "${CCSL_THEME:-$CCSL_CFG_THEME}"

FLAG="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/.caveman-active"
[ -L "$FLAG" ] && exit 0
[ ! -f "$FLAG" ] && exit 0

MODE=$(head -c 64 "$FLAG" 2>/dev/null | tr -d '\n\r' | tr '[:upper:]' '[:lower:]' | tr -cd 'a-z0-9-')
case "$MODE" in
  off|lite|full|ultra|wenyan-lite|wenyan|wenyan-full|wenyan-ultra|commit|review|compress) ;;
  *) exit 0 ;;
esac

C=$(ccsl_color accent_orange)
R=$'\033[0m'

if [ -z "$MODE" ] || [ "$MODE" = "full" ]; then
  printf '%s[CAVEMAN]%s' "$C" "$R"
else
  SUFFIX=$(printf '%s' "$MODE" | tr '[:lower:]' '[:upper:]')
  printf '%s[CAVEMAN:%s]%s' "$C" "$SUFFIX" "$R"
fi
