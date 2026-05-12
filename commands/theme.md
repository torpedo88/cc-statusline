---
description: Switch the cc-statusline theme. Usage — /cc-statusline:theme <name>. Available themes — catppuccin, dracula, nord, tokyo-night, gruvbox, minimal.
---

# Switch statusline theme

The user wants to switch the active cc-statusline theme to: **$ARGUMENTS**

## Steps

1. Validate `$ARGUMENTS` is one of: `catppuccin`, `dracula`, `nord`, `tokyo-night`, `gruvbox`, `minimal`. If empty or invalid, list the choices and stop.

2. Read the config file at `~/.config/cc-statusline/config.toml`. If it does not exist, copy it from `${CLAUDE_PLUGIN_ROOT}/config/config.example.toml` first.

3. Update the `theme = "..."` line (under `[general]`) to the new theme. Preserve all other settings exactly. Do not reorder, do not change comments.

4. Confirm with a single sentence stating the new theme, and suggest the user restart Claude Code (the statusline command is invoked per prompt — most terminals will pick up the change on the next prompt without restart).
