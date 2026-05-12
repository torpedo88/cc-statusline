#!/usr/bin/env bash
# cc-statusline — modular statusline for Claude Code.
# https://github.com/torpedo88/cc-statusline
#
# Reads Claude Code JSON payload from stdin, renders a configurable status line.

set -u

CCSL_VERSION="0.1.0"
CCSL_ROOT="${CCSL_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
CCSL_CONFIG="${CCSL_CONFIG:-$HOME/.config/cc-statusline/config.toml}"

# shellcheck source=../lib/config.sh
source "$CCSL_ROOT/lib/config.sh"
# shellcheck source=../lib/render.sh
source "$CCSL_ROOT/lib/render.sh"

main() {
  local payload=""
  if [ ! -t 0 ]; then
    payload=$(cat)
  fi

  ccsl_config_load "$CCSL_CONFIG"
  ccsl_theme_load "${CCSL_THEME:-$CCSL_CFG_THEME}"

  local segments_csv="${CCSL_SEGMENTS:-$CCSL_CFG_SEGMENTS}"
  local separator="${CCSL_SEPARATOR:-$CCSL_CFG_SEPARATOR}"
  local powerline="${CCSL_POWERLINE:-$CCSL_CFG_POWERLINE}"

  CCSL_PARTS_BUF=""
  local seg out
  local old_ifs="$IFS"
  IFS=','
  set -- $segments_csv
  IFS="$old_ifs"
  for seg in "$@"; do
    seg=$(echo "$seg" | tr -d ' ')
    [ -z "$seg" ] && continue
    local seg_file="$CCSL_ROOT/lib/segments/${seg}.sh"
    if [ -f "$seg_file" ]; then
      out=$(CCSL_ROOT="$CCSL_ROOT" CCSL_THEME="${CCSL_THEME:-$CCSL_CFG_THEME}" \
            CCSL_CFG_ICONS="$CCSL_CFG_ICONS" CCSL_CFG_TRUNCATE_DIR="$CCSL_CFG_TRUNCATE_DIR" \
            CCSL_CFG_TRUNCATE_BRANCH="$CCSL_CFG_TRUNCATE_BRANCH" \
            CCSL_CFG_HIDE_ZERO_COST="$CCSL_CFG_HIDE_ZERO_COST" \
            CCSL_CFG_DATE_FORMAT="$CCSL_CFG_DATE_FORMAT" \
            CCSL_PAYLOAD="$payload" bash "$seg_file" 2>/dev/null)
      if [ -n "$out" ]; then
        if [ -z "$CCSL_PARTS_BUF" ]; then
          CCSL_PARTS_BUF="$out"
        else
          CCSL_PARTS_BUF="${CCSL_PARTS_BUF}
${out}"
        fi
      fi
    fi
  done

  if [ "$powerline" = "true" ] || [ "$powerline" = "1" ]; then
    ccsl_render_powerline
  else
    ccsl_render_plain "$separator"
  fi
}

case "${1:-}" in
  --version|-v) echo "cc-statusline $CCSL_VERSION"; exit 0 ;;
  --help|-h)
    cat <<EOF
cc-statusline $CCSL_VERSION — modular statusline for Claude Code

Usage:
  cc-statusline               Read JSON from stdin, render statusline
  cc-statusline --version     Show version
  cc-statusline --help        Show this help
  cc-statusline --doctor      Diagnose configuration
  cc-statusline --list        List available segments and themes

Config: ~/.config/cc-statusline/config.toml
Env overrides:
  CCSL_THEME=catppuccin       Override theme
  CCSL_SEGMENTS=model,dir,git Override segments (comma-sep)
  CCSL_POWERLINE=true         Powerline mode
  CCSL_CONFIG=/path/to.toml   Override config path

Docs: https://github.com/torpedo88/cc-statusline
EOF
    exit 0
    ;;
  --doctor)
    echo "cc-statusline doctor"
    echo "  root:   $CCSL_ROOT"
    echo "  config: $CCSL_CONFIG $([ -f "$CCSL_CONFIG" ] && echo '✓' || echo '✗ (using defaults)')"
    echo "  python: $(command -v python3 || echo 'missing')"
    echo "  git:    $(command -v git || echo 'missing')"
    echo "  bash:   $BASH_VERSION"
    exit 0
    ;;
  --list)
    echo "Segments:"
    for f in "$CCSL_ROOT"/lib/segments/*.sh; do
      basename "$f" .sh | sed 's/^/  /'
    done
    echo "Themes:"
    for f in "$CCSL_ROOT"/lib/themes/*.sh; do
      basename "$f" .sh | sed 's/^/  /'
    done
    exit 0
    ;;
esac

main
