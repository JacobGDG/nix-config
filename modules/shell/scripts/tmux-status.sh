#!/usr/bin/env bash
# tmux-status — describe a tmux pane as one line of JSON.
#
# Reports facts, not verdicts: generic pane facts at the top level, plus facts
# from a program-specific reader under `data` when the pane runs a program we
# know how to read. Callers (e.g. tmux-agents) decide what the facts mean.
#
#   pane, location, command, path, title
#   attention   @attention pane option: set by tmux-notify when it alerts about
#               a pane you weren't looking at, cleared on focus (tmux.nix)
#   type        "claude", or null for programs we don't read
#   data        that reader's facts, {} when type is null
#
# To read another program, write a read_<type>_facts function that prints a
# JSON object, and map the program's command to <type> in program_type.
#
# Usage: tmux-status [pane-id] [screen-file]
#   pane-id      defaults to $TMUX_PANE
#   screen-file  read the screen from a saved capture instead of the pane,
#                for testing readers against fixtures
set -uo pipefail
export LC_ALL=C.UTF-8

screen_file=""

# ── Helpers ──────────────────────────────────────────────────────────────────

die() {
  echo "tmux-status: $*" >&2
  exit 2
}

# Print true/false for whether the given command succeeds.
json_bool() { if "$@"; then echo true; else echo false; fi; }

# Case-insensitive extended-regex match of text against pattern.
matches() { grep -qiE "$2" <<<"$1"; }

last_line_of() { tail -n 1 <<<"$1"; }

# ── Pane ─────────────────────────────────────────────────────────────────────

# Sets pane_id, pane_location, pane_command, pane_path, pane_attention and
# pane_title for the target pane.
load_pane() {
  local target=$1 info format
  # Joined with the unit separator rather than tab: tab is IFS whitespace, so
  # `read` would collapse empty fields and shift the rest.
  local sep=$'\x1f'
  local fields=(
    '#{pane_id}'
    '#{session_name}:#{window_index}.#{pane_index}'
    '#{pane_current_command}'
    '#{pane_current_path}'
    '#{@attention}'
    '#{pane_title}'
  )
  format=$(IFS=$sep && echo "${fields[*]}")

  info=$(tmux display-message -p -t "$target" "$format" 2>&1) || die "$info"
  IFS=$sep read -r pane_id pane_location pane_command pane_path pane_attention pane_title <<<"$info"
  # tmux exits 0 with empty fields for a pane that doesn't exist.
  [ -n "$pane_id" ] || die "no such pane: $target"
}

capture_screen() {
  if [ -n "$screen_file" ]; then
    cat "$screen_file"
  else
    tmux capture-pane -p -t "$pane_id"
  fi
}

# The last N non-empty lines of the screen, bottom line last.
bottom_lines() {
  capture_screen | { grep -v '^[[:space:]]*$' || true; } | tail -n "$1"
}

# Nix wrappers (makeWrapper) exec the real binary as `.<name>-wrapped`, so tmux
# reports `.claude-wrapped` rather than `claude`. Turn that back into the name.
unwrapped_name() {
  local name=$1
  name=${name#.}        # remove the leading dot
  name=${name%-wrapped} # remove the trailing "-wrapped"
  echo "$name"
}

# Which reader understands this program, if any.
program_type() {
  case "$(unwrapped_name "$1")" in
    claude) echo claude ;;
  esac
}

# ── Claude Code ──────────────────────────────────────────────────────────────
#
# Read from the screen rather than lifecycle hooks, which go stale on
# interrupts and cancelled permission prompts. Only the bottom lines are read:
# while idle they're always rule, `❯ <input>`, rule, footer — so text typed
# into the input box (or a suggested prompt) is never the line matched.
#
# Patterns mirror herdr's src/detect/manifests/claude.toml — check there first
# when a Claude update breaks one. Verified against Claude Code 2.1.300.

# Footer while a turn runs: `⏵⏵ auto mode on · esc to interrupt · ← for agents`
CLAUDE_TURN_FOOTER='esc to interrupt'
# Key hints closing a permission prompt, question form or menu, anchored to
# their shape so a sentence merely containing "esc to cancel" doesn't count:
#   `Esc to cancel · Tab to amend`
#   `Enter to select · ↑/↓ to navigate · Esc to cancel`
CLAUDE_CHOICE_KEY_HINTS='^[[:space:]]*(enter to [^·]+·[[:space:]]*)*(↑/?↓[^·]*·[[:space:]]*)*esc to cancel([[:space:]]*·.*)?$'
# The input line, also used by question forms to mark the selected option.
CLAUDE_INPUT_LINE='^[[:space:]]*❯'
CLAUDE_RULE='^[[:space:]]*─{3,}'
# Transcript viewer (ctrl+o) footer:
#   `Showing detailed transcript · ctrl+o to toggle · ctrl+e to show all`
CLAUDE_TRANSCRIPT_BANNER='showing detailed transcript'
CLAUDE_TRANSCRIPT_KEY_HINTS='ctrl\+o.*to toggle|ctrl\+e.*(show all|collapse)|↑↓ scroll|\? for shortcuts'

# The model is generating or a tool is running.
claude_turn_running() {
  matches "$(last_line_of "$1")" "$CLAUDE_TURN_FOOTER"
}

# A permission prompt, question form or menu is waiting for a choice.
claude_awaiting_choice() {
  local last_line
  last_line=$(last_line_of "$1")
  ! matches "$last_line" "$CLAUDE_INPUT_LINE" && matches "$last_line" "$CLAUDE_CHOICE_KEY_HINTS"
}

# The input box is showing: an input line, then a rule that only the footer
# follows. Question forms also have a `❯` line and a rule, but more options
# follow their rule.
claude_input_box_visible() {
  awk -v input="$CLAUDE_INPUT_LINE" -v rule="$CLAUDE_RULE" '
    $0 ~ input { after_input = 1; next }
    after_input && $0 ~ rule { closing_rule = NR }
    END { exit !(closing_rule && NR - closing_rule <= 1) }
  ' <<<"$1"
}

claude_transcript_viewer_open() {
  local footer
  footer=$(tail -n 3 <<<"$1")
  matches "$footer" "$CLAUDE_TRANSCRIPT_BANNER" && matches "$footer" "$CLAUDE_TRANSCRIPT_KEY_HINTS"
}

# Claude titles the pane `<glyph> <session name>`. herdr treats a spinner glyph
# as working, but 2.1.300 shows ✳ throughout, so it's reported, not relied on.
read_claude_facts() {
  local bottom
  bottom=$(bottom_lines 6)

  jq -nc \
    --arg title "$pane_title" \
    --arg last_line "$(last_line_of "$bottom")" \
    --argjson turn_running "$(json_bool claude_turn_running "$bottom")" \
    --argjson awaiting_choice "$(json_bool claude_awaiting_choice "$bottom")" \
    --argjson input_box_visible "$(json_bool claude_input_box_visible "$bottom")" \
    --argjson transcript_viewer_open "$(json_bool claude_transcript_viewer_open "$bottom")" \
    '{
      session_name: ($title | .[1:] | ltrimstr(" ")),
      title_glyph: ($title | .[0:1]),
      $turn_running, $awaiting_choice, $input_box_visible, $transcript_viewer_open,
      $last_line
    }'
}

# ── Main ─────────────────────────────────────────────────────────────────────

main() {
  local target=${1:-${TMUX_PANE:-}} type data='{}'
  screen_file=${2:-}
  [ -n "$target" ] || die "usage: tmux-status <pane-id> [screen-file]"

  load_pane "$target"
  type=$(program_type "$pane_command")
  if [ -n "$type" ]; then
    data=$("read_${type}_facts")
  fi

  jq -nc \
    --arg pane "$pane_id" \
    --arg location "$pane_location" \
    --arg command "$pane_command" \
    --arg path "$pane_path" \
    --arg title "$pane_title" \
    --argjson attention "$(json_bool [ -n "$pane_attention" ])" \
    --arg type "$type" \
    --argjson data "$data" \
    '{
      $pane, $location, $command, $path, $title, $attention,
      type: (if $type == "" then null else $type end),
      $data
    }'
}

main "$@"
