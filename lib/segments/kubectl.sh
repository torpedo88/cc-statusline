#!/usr/bin/env bash
# Segment: current kubectl context + namespace.
source "${CCSL_ROOT}/lib/config.sh"
ccsl_theme_load "${CCSL_THEME:-$CCSL_CFG_THEME}"

command -v kubectl >/dev/null 2>&1 || exit 0

CTX=$(kubectl config current-context 2>/dev/null)
[ -z "$CTX" ] && exit 0

NS=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)
[ -z "$NS" ] && NS="default"

C=$(ccsl_color accent_blue)
R=$'\033[0m'
ICON=""
[ "${CCSL_CFG_ICONS:-true}" = "true" ] && ICON="⎈ "

printf '%s%s%s/%s%s' "$C" "$ICON" "$CTX" "$NS" "$R"
