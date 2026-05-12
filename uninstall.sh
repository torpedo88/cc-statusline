#!/usr/bin/env bash
# cc-statusline uninstaller.

set -euo pipefail

INSTALL_DIR="${CCSL_INSTALL_DIR:-$HOME/.cc-statusline}"
CONFIG_DIR="$HOME/.config/cc-statusline"

read -r -p "Remove $INSTALL_DIR? [y/N] " ans
if [ "$ans" = "y" ] || [ "$ans" = "Y" ]; then
  rm -rf "$INSTALL_DIR"
  echo "removed $INSTALL_DIR"
fi

read -r -p "Remove config $CONFIG_DIR? [y/N] " ans2
if [ "$ans2" = "y" ] || [ "$ans2" = "Y" ]; then
  rm -rf "$CONFIG_DIR"
  echo "removed $CONFIG_DIR"
fi

echo "Done. Remove the statusLine block from ~/.claude/settings.json manually."
