---
description: Diagnose cc-statusline installation, config, and dependencies. Useful when the statusline is not showing up or rendering wrong.
---

# Diagnose cc-statusline

Run the doctor script and interpret the output for the user.

## Steps

1. Execute `bash "${CLAUDE_PLUGIN_ROOT}/bin/cc-statusline.sh" --doctor` and capture the output.

2. Read the user's `~/.claude/settings.json` and check whether `statusLine.command` points at the plugin's `bin/cc-statusline.sh` (the path under `${CLAUDE_PLUGIN_ROOT}`). If the field is missing, instruct the user that the plugin install did not wire the statusLine and they should add it manually using the snippet from the README.

3. Read `~/.config/cc-statusline/config.toml` if it exists and confirm the chosen `theme` and `segments` are valid (cross-check against `${CLAUDE_PLUGIN_ROOT}/lib/themes/` and `${CLAUDE_PLUGIN_ROOT}/lib/segments/`).

4. Report findings as a short bulleted list — green check for working, red x with a one-line fix for anything broken.
