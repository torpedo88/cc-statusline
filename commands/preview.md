---
description: Preview how cc-statusline renders with a sample payload. Useful for testing theme/segment changes without restarting Claude Code.
---

# Preview the statusline

Render the cc-statusline against a sample Claude Code payload so the user can see the result of their current theme + segment configuration.

## Steps

1. Build a sample JSON payload representing a realistic mid-session state:

```json
{
  "model": {"display_name": "Opus 4.7", "id": "claude-opus-4-7"},
  "workspace": {"current_dir": "/Users/example/projects/my-app"},
  "session_id": "preview-session-001",
  "cost": {
    "total_cost_usd": 0.1234,
    "total_lines_added": 42,
    "total_lines_removed": 7,
    "total_duration_ms": 125000,
    "total_input_tokens": 85000,
    "total_output_tokens": 2500
  }
}
```

2. Pipe it into `bash "${CLAUDE_PLUGIN_ROOT}/bin/cc-statusline.sh"` and show the raw output to the user.

3. If the user passed any args in `$ARGUMENTS` interpret them as env overrides (e.g. `CCSL_THEME=dracula`) and apply them inline to the command — do not modify the config file. The preview is non-destructive.
