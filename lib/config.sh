# cc-statusline config loader. Bash 3.2 compatible.
# Minimal TOML-subset parser (key="value" and [section]) — no deps.

CCSL_CFG_THEME="catppuccin"
CCSL_CFG_SEGMENTS="caveman,profile,model,dir,git,cost,diff,duration"
CCSL_CFG_SEPARATOR=" | "
CCSL_CFG_POWERLINE="false"
CCSL_CFG_ICONS="true"
CCSL_CFG_TRUNCATE_DIR="40"
CCSL_CFG_TRUNCATE_BRANCH="20"
CCSL_CFG_HIDE_ZERO_COST="true"
CCSL_CFG_DATE_FORMAT="%H:%M"

ccsl_config_load() {
  local cfg="$1"
  [ -f "$cfg" ] || return 0
  [ -L "$cfg" ] && return 0

  local section=""
  local line key val
  while IFS= read -r line || [ -n "$line" ]; do
    line="${line%%#*}"
    line="${line#"${line%%[![:space:]]*}"}"
    line="${line%"${line##*[![:space:]]}"}"
    [ -z "$line" ] && continue

    if [[ "$line" =~ ^\[(.+)\]$ ]]; then
      section="${BASH_REMATCH[1]}"
      continue
    fi

    if [[ "$line" =~ ^([a-zA-Z_][a-zA-Z0-9_]*)[[:space:]]*=[[:space:]]*(.+)$ ]]; then
      key="${BASH_REMATCH[1]}"
      val="${BASH_REMATCH[2]}"
      val="${val#\"}"; val="${val%\"}"
      val="${val#\'}"; val="${val%\'}"

      case "$section.$key" in
        ".theme"|"general.theme") CCSL_CFG_THEME="$val" ;;
        ".segments"|"general.segments") CCSL_CFG_SEGMENTS="$val" ;;
        ".separator"|"general.separator") CCSL_CFG_SEPARATOR="$val" ;;
        ".powerline"|"general.powerline") CCSL_CFG_POWERLINE="$val" ;;
        ".icons"|"general.icons") CCSL_CFG_ICONS="$val" ;;
        ".truncate_dir"|"general.truncate_dir") CCSL_CFG_TRUNCATE_DIR="$val" ;;
        ".truncate_branch"|"general.truncate_branch") CCSL_CFG_TRUNCATE_BRANCH="$val" ;;
        ".hide_zero_cost"|"general.hide_zero_cost") CCSL_CFG_HIDE_ZERO_COST="$val" ;;
        ".date_format"|"general.date_format") CCSL_CFG_DATE_FORMAT="$val" ;;
      esac
    fi
  done < "$cfg"
}

# Color storage: plain vars CCSL_C_<key>. Bash 3.2 compatible.
ccsl_theme_load() {
  local theme="$1"
  local theme_file="${CCSL_ROOT}/lib/themes/${theme}.sh"
  if [ ! -f "$theme_file" ]; then
    theme_file="${CCSL_ROOT}/lib/themes/catppuccin.sh"
  fi
  # shellcheck source=themes/catppuccin.sh
  . "$theme_file"
}

ccsl_color() {
  local key="$1"
  local var="CCSL_C_${key}"
  printf '%s' "${!var:-}"
}

ccsl_read_json() {
  local key="$1"
  local payload="${CCSL_PAYLOAD:-}"
  [ -z "$payload" ] && return 0
  printf '%s' "$payload" | /usr/bin/env python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    for k in '$key'.split('.'):
        d = d.get(k) if isinstance(d, dict) else None
        if d is None: break
    print('' if d is None else d)
except Exception:
    print('')
" 2>/dev/null
}

ccsl_truncate() {
  local s="$1"
  local n="$2"
  if [ "${#s}" -gt "$n" ]; then
    printf '%s…' "${s:0:$((n-1))}"
  else
    printf '%s' "$s"
  fi
}

export -f ccsl_color ccsl_read_json ccsl_truncate ccsl_theme_load
