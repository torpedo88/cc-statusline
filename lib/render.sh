# cc-statusline render functions. Bash 3.2 compatible.
# Inputs passed via global $CCSL_PARTS_BUF (newline-separated parts).

ccsl_render_plain() {
  local sep="$1"
  local dim reset out
  dim=$(ccsl_color dim)
  reset=$'\033[0m'
  local visible_sep="${dim}${sep}${reset}"
  out=""
  local first=1
  local part
  while IFS= read -r part; do
    [ -z "$part" ] && continue
    if [ "$first" -eq 1 ]; then
      out="$part"
      first=0
    else
      out="${out}${visible_sep}${part}"
    fi
  done <<< "$CCSL_PARTS_BUF"
  printf '%s' "$out"
}

ccsl_render_powerline() {
  local sep_left=$''
  local reset=$'\033[0m'
  local out=""
  local first=1
  local part
  while IFS= read -r part; do
    [ -z "$part" ] && continue
    if [ "$first" -eq 1 ]; then
      out="$part"
      first=0
    else
      out="${out} ${sep_left}${reset} ${part}"
    fi
  done <<< "$CCSL_PARTS_BUF"
  printf '%s' "$out"
}
