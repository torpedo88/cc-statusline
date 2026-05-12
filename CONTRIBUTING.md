# Contributing

Thanks for considering a contribution.

## Quickstart

```bash
git clone https://github.com/torpedo88/cc-statusline.git
cd cc-statusline
chmod +x bin/cc-statusline.sh lib/segments/*.sh
echo '{"model":{"display_name":"Opus 4.7"},"workspace":{"current_dir":"/tmp"}}' | bash bin/cc-statusline.sh
```

## Running tests

Requires [bats-core](https://github.com/bats-core/bats-core).

```bash
brew install bats-core   # macOS
sudo apt-get install bats # Debian/Ubuntu

bats test/
```

## Style

- Pure bash 3.2 compatible — no `declare -A`, no `nameref` (`local -n`), no `&>`.
- Segments must `exit 0` silently when they have nothing to show (do not render a placeholder).
- Use `ccsl_color`, `ccsl_read_json`, `ccsl_truncate` helpers — do not invent new ones unless reusable.
- shellcheck-clean (run `shellcheck bin/cc-statusline.sh lib/**/*.sh` before opening a PR).

## Adding a segment

See [docs/SEGMENTS.md](docs/SEGMENTS.md#writing-a-new-segment).

1. Add `lib/segments/<name>.sh`.
2. Add a test under `test/`.
3. Mention the segment in `README.md` and `docs/SEGMENTS.md`.

## Adding a theme

See [docs/THEMES.md](docs/THEMES.md#adding-a-theme).

1. Add `lib/themes/<name>.sh` with all 10 color variables.
2. Mention it in `README.md` and `docs/THEMES.md`.

## Reporting bugs

Open an issue with the output of `cc-statusline --doctor` and a sample payload that reproduces the problem.
