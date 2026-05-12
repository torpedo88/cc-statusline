---
description: Configure which cc-statusline segments are shown. Usage — /cc-statusline:segments <comma-separated list>. Run with no args to list available segments.
---

# Configure statusline segments

The user wants to set the active segments to: **$ARGUMENTS**

## Steps

1. If `$ARGUMENTS` is empty, run `bash "${CLAUDE_PLUGIN_ROOT}/bin/cc-statusline.sh" --list` and show the available segments plus the current `segments = "..."` value from `~/.config/cc-statusline/config.toml`. Stop.

2. Otherwise, validate each comma-separated segment exists as `${CLAUDE_PLUGIN_ROOT}/lib/segments/<name>.sh`. Reject the change if any segment is unknown — list the bad name(s) and the valid options, then stop.

3. Update the `segments = "..."` line under `[general]` in `~/.config/cc-statusline/config.toml`. Preserve all other settings exactly. Do not reorder.

4. Confirm with one sentence stating the new segment list. The change takes effect on the next prompt.
