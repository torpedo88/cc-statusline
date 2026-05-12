#!/usr/bin/env bats
# Basic render tests for cc-statusline.

setup() {
  ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
  BIN="$ROOT/bin/cc-statusline.sh"
}

strip_ansi() {
  /usr/bin/env python3 -c "import sys,re; print(re.sub(r'\x1b\[[0-9;]*m','', sys.stdin.read()))"
}

@test "binary is executable" {
  [ -x "$BIN" ]
}

@test "--version prints version" {
  run bash "$BIN" --version
  [ "$status" -eq 0 ]
  [[ "$output" == cc-statusline* ]]
}

@test "--help prints usage" {
  run bash "$BIN" --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage:"* ]]
}

@test "--list shows segments" {
  run bash "$BIN" --list
  [ "$status" -eq 0 ]
  [[ "$output" == *"model"* ]]
  [[ "$output" == *"git"* ]]
  [[ "$output" == *"dir"* ]]
}

@test "--doctor runs" {
  run bash "$BIN" --doctor
  [ "$status" -eq 0 ]
  [[ "$output" == *"cc-statusline doctor"* ]]
}

@test "renders model segment" {
  out=$(echo '{"model":{"display_name":"Opus 4.7","id":"claude-opus-4-7"},"workspace":{"current_dir":"/tmp"}}' \
        | CCSL_SEGMENTS=model bash "$BIN" | strip_ansi)
  [[ "$out" == *"Opus 4.7"* ]]
}

@test "renders dir segment" {
  out=$(echo '{"workspace":{"current_dir":"/tmp/foo"}}' \
        | CCSL_SEGMENTS=dir bash "$BIN" | strip_ansi)
  [[ "$out" == *"/tmp/foo"* ]]
}

@test "renders cost segment when non-zero" {
  out=$(echo '{"cost":{"total_cost_usd":0.5}}' \
        | CCSL_SEGMENTS=cost bash "$BIN" | strip_ansi)
  [[ "$out" == *"\$0.5"* ]]
}

@test "hides cost when zero" {
  out=$(echo '{"cost":{"total_cost_usd":0}}' \
        | CCSL_SEGMENTS=cost bash "$BIN" | strip_ansi)
  [ -z "$out" ]
}

@test "renders diff when non-zero" {
  out=$(echo '{"cost":{"total_lines_added":10,"total_lines_removed":3}}' \
        | CCSL_SEGMENTS=diff bash "$BIN" | strip_ansi)
  [[ "$out" == *"+10"* ]]
  [[ "$out" == *"-3"* ]]
}

@test "renders duration" {
  out=$(echo '{"cost":{"total_duration_ms":65000}}' \
        | CCSL_SEGMENTS=duration bash "$BIN" | strip_ansi)
  [[ "$out" == *"1m5s"* ]]
}

@test "handles empty payload gracefully" {
  run bash "$BIN" <<< ""
  [ "$status" -eq 0 ]
}

@test "respects CCSL_THEME env override" {
  out=$(echo '{"model":{"display_name":"X"}}' \
        | CCSL_THEME=minimal CCSL_SEGMENTS=model bash "$BIN")
  [[ "$out" == *"X"* ]]
}

@test "unknown theme falls back to catppuccin" {
  out=$(echo '{"model":{"display_name":"X"}}' \
        | CCSL_THEME=nonexistent CCSL_SEGMENTS=model bash "$BIN" | strip_ansi)
  [[ "$out" == *"X"* ]]
}

@test "truncates long dir" {
  out=$(echo '{"workspace":{"current_dir":"/this/is/a/very/long/path/that/exceeds/forty/chars/easily"}}' \
        | CCSL_SEGMENTS=dir bash "$BIN" | strip_ansi)
  [[ "$out" == *"…"* ]]
}
