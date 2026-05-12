#!/usr/bin/env bash
# cc-statusline installer.
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/torpedo88/cc-statusline/main/install.sh | bash
#   ./install.sh

set -euo pipefail

REPO_URL="${CCSL_REPO_URL:-https://github.com/torpedo88/cc-statusline.git}"
INSTALL_DIR="${CCSL_INSTALL_DIR:-$HOME/.cc-statusline}"
CONFIG_DIR="$HOME/.config/cc-statusline"
CC_SETTINGS="$HOME/.claude/settings.json"

bold() { printf '\033[1m%s\033[0m\n' "$*"; }
info() { printf '\033[36m→\033[0m %s\n' "$*"; }
warn() { printf '\033[33m!\033[0m %s\n' "$*"; }
ok()   { printf '\033[32m✓\033[0m %s\n' "$*"; }
err()  { printf '\033[31m✗\033[0m %s\n' "$*" >&2; }

bold "cc-statusline installer"

command -v git >/dev/null 2>&1 || { err "git required"; exit 1; }
command -v python3 >/dev/null 2>&1 || { err "python3 required"; exit 1; }

if [ -d "$INSTALL_DIR/.git" ]; then
  info "updating existing install at $INSTALL_DIR"
  git -C "$INSTALL_DIR" pull --ff-only
else
  info "cloning to $INSTALL_DIR"
  git clone --depth 1 "$REPO_URL" "$INSTALL_DIR"
fi

chmod +x "$INSTALL_DIR/bin/cc-statusline.sh"
chmod +x "$INSTALL_DIR/lib/segments/"*.sh

mkdir -p "$CONFIG_DIR"
if [ ! -f "$CONFIG_DIR/config.toml" ]; then
  cp "$INSTALL_DIR/config/config.example.toml" "$CONFIG_DIR/config.toml"
  ok "config written: $CONFIG_DIR/config.toml"
else
  info "config exists: $CONFIG_DIR/config.toml (kept)"
fi

ok "installed at $INSTALL_DIR"
echo
bold "Next steps"
echo
echo "Add this to $CC_SETTINGS:"
echo
cat <<EOF
  "statusLine": {
    "type": "command",
    "command": "bash $INSTALL_DIR/bin/cc-statusline.sh",
    "padding": 0
  }
EOF
echo
echo "Then restart Claude Code. Edit $CONFIG_DIR/config.toml to customize."
echo
echo "Run '$INSTALL_DIR/bin/cc-statusline.sh --doctor' to diagnose."
