# Changelog

All notable changes to this project will be documented in this file. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- Claude Code plugin packaging: `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`, root `settings.json` shipping default statusLine config using `${CLAUDE_PLUGIN_ROOT}`.
- Slash commands: `/cc-statusline:theme`, `/cc-statusline:segments`, `/cc-statusline:preview`, `/cc-statusline:doctor`.
- Install via `/plugin marketplace add torpedo88/cc-statusline` then `/plugin install cc-statusline@cc-statusline`.

## [0.1.0] — 2026-05-12

### Added
- Initial release.
- 17 segments: `caveman`, `profile`, `model`, `dir`, `git`, `cost`, `diff`, `duration`, `context`, `tokens`, `time`, `battery`, `node`, `python`, `kubectl`, `aws`, `session`.
- 6 themes: `catppuccin`, `dracula`, `nord`, `tokyo-night`, `gruvbox`, `minimal`.
- TOML config at `~/.config/cc-statusline/config.toml`.
- Environment overrides (`CCSL_THEME`, `CCSL_SEGMENTS`, `CCSL_POWERLINE`, `CCSL_CONFIG`).
- `--version`, `--help`, `--doctor`, `--list` flags.
- One-line `install.sh` / `uninstall.sh`.
- CI: shellcheck + bats on Linux and macOS.
