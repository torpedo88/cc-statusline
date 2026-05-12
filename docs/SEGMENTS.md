# Segments

Each segment is a self-contained script under `lib/segments/<name>.sh` that reads the Claude Code JSON payload from `$CCSL_PAYLOAD`, emits a colored fragment to stdout, and exits silently (`exit 0` with no output) when there is nothing to show.

## Built-in segments

### caveman
Reads `~/.claude/.caveman-active` and renders `[CAVEMAN]`, `[CAVEMAN:ULTRA]`, etc. Designed for the [caveman](https://github.com/JuliusBrussee/caveman) plugin but harmless when not installed.

### profile
Reads `~/.claude/.active-profile` (file or symlink). Useful when running multiple Claude Code profiles (personal / work).

### model
Reads `model.display_name` from the payload. Renders `⚡ Opus 4.7`.

### dir
Reads `workspace.current_dir`. Collapses `$HOME` to `~`, truncates to `truncate_dir` characters with a trailing `…`.

### git
Branch, dirty marker (`*`), and `↑N` / `↓N` upstream divergence. Skips silently outside a git repo. Caps branch name at `truncate_branch` chars.

### cost
Renders `$0.1234` from `cost.total_cost_usd`. Hidden when zero if `hide_zero_cost = "true"`.

### diff
`+42/-7` from `cost.total_lines_added` / `cost.total_lines_removed`. Hidden when both are zero.

### duration
`12m5s` / `1h2m` from `cost.total_duration_ms`.

### context
Horizontal bar (`██████░░`) + percent of the model's context window used. Window is inferred from `model.id` (1M for `*1m*`, otherwise 200k). Bar color shifts green → yellow → red.

### tokens
`↓85.0k ↑2.5k` from `cost.total_input_tokens` / `cost.total_output_tokens`.

### time
Current local clock — `date_format` is an [strftime](https://man7.org/linux/man-pages/man3/strftime.3.html) format string.

### battery
Battery percent and charging icon. Uses `pmset` on macOS, `/sys/class/power_supply/BAT0` on Linux.

### node
Node version, only shown when `package.json` or `.nvmrc` is present in the cwd.

### python
Active `VIRTUAL_ENV` (preferred) or `CONDA_DEFAULT_ENV`.

### kubectl
`current-context/namespace`. Skipped if `kubectl` is not installed.

### aws
`$AWS_PROFILE:$AWS_REGION` (either may be empty).

### session
First 8 chars of `session_id`.

## Writing a new segment

Create `lib/segments/myseg.sh`:

```bash
#!/usr/bin/env bash
source "${CCSL_ROOT}/lib/config.sh"
ccsl_theme_load "${CCSL_THEME:-$CCSL_CFG_THEME}"

# Read from payload:
VALUE=$(ccsl_read_json "some.key")
[ -z "$VALUE" ] && exit 0

# Pick a theme color:
C=$(ccsl_color accent_blue)
R=$'\033[0m'

# Respect the icons toggle:
ICON=""
[ "${CCSL_CFG_ICONS:-true}" = "true" ] && ICON="★ "

printf '%s%s%s%s' "$C" "$ICON" "$VALUE" "$R"
```

Then add `myseg` to the `segments` list in your config.

### Available theme colors

`accent_red`, `accent_orange`, `accent_yellow`, `accent_green`, `accent_cyan`, `accent_blue`, `accent_purple`, `accent_pink`, `dim`, `fg`.

### Helpers

| Helper              | Description |
|---------------------|-------------|
| `ccsl_read_json k`  | Pull a dotted key from the JSON payload, empty if missing |
| `ccsl_color k`      | Look up a theme color by name |
| `ccsl_truncate s n` | Truncate string `s` to `n` chars with trailing `…` |

### Performance

Segments are invoked per-prompt. Avoid shelling out to slow tools. Cache when you can. The git segment, for example, calls `git` three times — fine on a laptop, but if you have a 100k-file monorepo consider using `--no-optional-locks` or disabling the segment.
