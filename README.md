# cc-statusline

A modular, themeable statusline for [Claude Code](https://claude.com/claude-code) — written in pure bash, zero runtime dependencies beyond `python3` (already on macOS/Linux).

![CI](https://github.com/torpedo88/cc-statusline/actions/workflows/ci.yml/badge.svg)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Bash](https://img.shields.io/badge/bash-3.2%2B-green.svg)

## Why

Claude Code accepts a custom `statusLine` command that's invoked on every prompt. Most setups inline a long shell snippet in `settings.json` — hard to maintain, no themes, no segment reuse. `cc-statusline` ships:

- **17 ready-made segments** (model, dir, git, cost, diff, duration, context, tokens, profile, caveman, time, battery, node, python, kubectl, aws, session)
- **6 themes** (Catppuccin, Dracula, Nord, Tokyo Night, Gruvbox, Minimal)
- **TOML config** at `~/.config/cc-statusline/config.toml` — pick segments and order, theme, separator, icons on/off
- **Powerline mode** when you have a Nerd Font installed
- **Bash 3.2 compatible** — works on stock macOS, no Homebrew bash needed
- **Fast** — sub-50ms render, segments run in independent subshells so a stuck git command can't block the whole bar

## Install

### Option A — Claude Code plugin (recommended)

```
/plugin marketplace add torpedo88/cc-statusline
/plugin install cc-statusline@cc-statusline
```

Restart Claude Code. The plugin ships a default `statusLine` config that points at the plugin's bundled script via `${CLAUDE_PLUGIN_ROOT}` — no manual `settings.json` edit needed.

The plugin also registers four slash commands:

| Command                              | Purpose                                          |
|--------------------------------------|--------------------------------------------------|
| `/cc-statusline:theme <name>`        | Switch theme (`dracula`, `nord`, …)              |
| `/cc-statusline:segments <list>`     | Set active segments — comma-separated            |
| `/cc-statusline:preview`             | Render against a sample payload                  |
| `/cc-statusline:doctor`              | Diagnose installation                            |

### Option B — standalone install

```bash
curl -fsSL https://raw.githubusercontent.com/torpedo88/cc-statusline/main/install.sh | bash
```

Then add to `~/.claude/settings.json`:

```json
{
  "statusLine": {
    "type": "command",
    "command": "bash $HOME/.cc-statusline/bin/cc-statusline.sh",
    "padding": 0
  }
}
```

Restart Claude Code.

## Customize

Edit `~/.config/cc-statusline/config.toml`:

```toml
[general]
theme = "tokyo-night"
segments = "caveman,profile,model,dir,git,context,cost,diff,duration"
separator = " | "
powerline = "false"
icons = "true"
truncate_dir = "40"
truncate_branch = "20"
hide_zero_cost = "true"
date_format = "%H:%M"
```

Or override per-session with environment variables:

```bash
CCSL_THEME=dracula CCSL_SEGMENTS=model,dir,git bash ~/.cc-statusline/bin/cc-statusline.sh
```

## Segments

| Segment    | Shows                                                |
|------------|------------------------------------------------------|
| `caveman`  | Active caveman-mode badge if `~/.claude/.caveman-active` exists |
| `profile`  | Active Claude profile from `~/.claude/.active-profile` |
| `model`    | Model display name (`Opus 4.7`, `Sonnet 4.6`, ...)   |
| `dir`      | Current working directory (with `~` collapse + truncate) |
| `git`      | Branch, dirty flag, `↑ahead/↓behind` counts          |
| `cost`     | Session cost in USD                                  |
| `diff`     | Lines added / removed in session                     |
| `duration` | Session duration                                     |
| `context`  | Visual bar + percent of model's context window used  |
| `tokens`   | Input/output tokens (humanized `1.2k` / `3.4M`)      |
| `time`     | Local clock (configurable strftime)                  |
| `battery`  | Battery percent + charging icon (macOS/Linux)        |
| `node`     | Node version (only in projects with `package.json` / `.nvmrc`) |
| `python`   | Active `VIRTUAL_ENV` or `CONDA_DEFAULT_ENV`          |
| `kubectl`  | Current `kubectl` context + namespace                |
| `aws`      | `AWS_PROFILE:AWS_REGION`                             |
| `session`  | Short session id                                     |

See [docs/SEGMENTS.md](docs/SEGMENTS.md) for details.

## Themes

| Theme         | Preview |
|---------------|---------|
| catppuccin    | Mocha palette — default |
| dracula       | Classic Dracula |
| nord          | Cool blue-grey |
| tokyo-night   | Dark VS Code Tokyo Night |
| gruvbox       | Warm retro |
| minimal       | 16-color, terminal-default friendly |

See [docs/THEMES.md](docs/THEMES.md) to add your own.

## Diagnose

```bash
~/.cc-statusline/bin/cc-statusline.sh --doctor
~/.cc-statusline/bin/cc-statusline.sh --list
~/.cc-statusline/bin/cc-statusline.sh --version
```

## Test locally

```bash
echo '{"model":{"display_name":"Opus 4.7"},"workspace":{"current_dir":"/tmp"},"cost":{"total_cost_usd":0.5,"total_lines_added":10,"total_lines_removed":2,"total_duration_ms":65000}}' \
  | bash bin/cc-statusline.sh
```

## Contributing

PRs welcome. Add a segment under `lib/segments/<name>.sh`, follow the existing pattern, add a test in `test/`, and open a PR. The CI runs shellcheck + bats on Linux and macOS.

## License

MIT — see [LICENSE](LICENSE).
