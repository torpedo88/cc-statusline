#!/usr/bin/env bash
# Segment: active AWS profile / region.
source "${CCSL_ROOT}/lib/config.sh"
ccsl_theme_load "${CCSL_THEME:-$CCSL_CFG_THEME}"

PROFILE="${AWS_PROFILE:-${AWS_DEFAULT_PROFILE:-}}"
REGION="${AWS_REGION:-${AWS_DEFAULT_REGION:-}}"

[ -z "$PROFILE" ] && [ -z "$REGION" ] && exit 0

C=$(ccsl_color accent_orange)
R=$'\033[0m'
ICON=""
[ "${CCSL_CFG_ICONS:-true}" = "true" ] && ICON=" "

OUT=""
[ -n "$PROFILE" ] && OUT="$PROFILE"
[ -n "$REGION" ] && OUT="${OUT:+$OUT:}$REGION"

printf '%s%s%s%s' "$C" "$ICON" "$OUT" "$R"
