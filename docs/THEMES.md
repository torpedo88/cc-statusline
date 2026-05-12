# Themes

Themes live in `lib/themes/<name>.sh` and assign 10 named colors as 256-color ANSI escape sequences.

## Built-in

| Theme        | Inspiration                                          |
|--------------|------------------------------------------------------|
| catppuccin   | [Catppuccin Mocha](https://github.com/catppuccin/catppuccin) |
| dracula      | [Dracula](https://draculatheme.com)                  |
| nord         | [Nord](https://www.nordtheme.com)                    |
| tokyo-night  | [Tokyo Night](https://github.com/enkia/tokyo-night-vscode-theme) |
| gruvbox      | [Gruvbox](https://github.com/morhetz/gruvbox)        |
| minimal      | 16-color, terminal-default friendly                  |

Select via `theme = "..."` in your config or `CCSL_THEME=...` env var.

## Adding a theme

Create `lib/themes/mytheme.sh`:

```bash
# Theme: My theme
# Replace the 256-color codes (\033[38;5;NNNm) with values from your palette.

CCSL_C_accent_red=$'\033[38;5;203m'
CCSL_C_accent_orange=$'\033[38;5;215m'
CCSL_C_accent_yellow=$'\033[38;5;228m'
CCSL_C_accent_green=$'\033[38;5;120m'
CCSL_C_accent_cyan=$'\033[38;5;159m'
CCSL_C_accent_blue=$'\033[38;5;117m'
CCSL_C_accent_purple=$'\033[38;5;141m'
CCSL_C_accent_pink=$'\033[38;5;212m'
CCSL_C_dim=$'\033[38;5;240m'
CCSL_C_fg=$'\033[38;5;255m'

export CCSL_C_accent_red CCSL_C_accent_orange CCSL_C_accent_yellow CCSL_C_accent_green
export CCSL_C_accent_cyan CCSL_C_accent_blue CCSL_C_accent_purple CCSL_C_accent_pink
export CCSL_C_dim CCSL_C_fg
```

Use a 256-color picker like [terminal.sexy](https://terminal.sexy/) or [256colres](https://jonasjacek.github.io/colors/) to find the codes you want.

### Truecolor

256-color renders consistently across terminals. If you need 24-bit truecolor, swap `\033[38;5;N m` for `\033[38;2;R;G;Bm`. Some terminals (Apple Terminal.app) only ship 256-color support.
