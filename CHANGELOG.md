# Changelog

All notable changes to this project will be documented in this file. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and this project adheres to [Semantic Versioning](https://semver.org/).

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
