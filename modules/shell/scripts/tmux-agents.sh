#!/usr/bin/env bash
# tmux-agents — pick a Claude Code pane from any tmux session and jump to it.
#
# Lists every Claude pane, most urgent first, with a live preview of its
# screen. Bound to prefix-a, and its counts shown in the status bar (see
# modules/shell/tmux.nix).
#
# States are decided from the facts tmux-status reports:
#   ⏳ waiting     a permission prompt or question needs an answer
#   ✅ done        finished while you weren't looking (tmux-notify's @attention)
#   ⚙️ working     a turn is running
#   💤 idle        at the prompt, already seen
#   📜 transcript  left in the ctrl+o viewer, where idle and waiting look alike
#   ❓ unknown     nothing matched — Claude's UI has probably changed; the
#                  preview shows the line tmux-status couldn't place
#
# Usage:
#   tmux-agents --open-popup CLIENT   open the picker in a popup on CLIENT
#   tmux-agents [--client CLIENT]     run the picker here; jumps on CLIENT
#   tmux-agents --list                print the picker rows (ctrl-r reload)
#   tmux-agents --preview PANE STATE  print the preview for a row
#   tmux-agents --summary             counts for the status bar, e.g. `⏳1 ✅2 💤3`
#
# The client is passed explicitly because with several terminals attached,
# tmux can't tell which one a popup belongs to. The keybinding gets it from
# run-shell, which expands #{client_name} (display-popup doesn't).
set -uo pipefail

# Shared jq definitions: a tmux-status object -> its state, and a state ->
# [urgency rank, icon]. Lower ranks are more urgent and sort first.
# $claude is a jq variable, not a shell one.
# shellcheck disable=SC2016
JQ_STATE_DEFS='
  def state:
    .data as $claude
    | if $claude.awaiting_choice then "waiting"
      elif $claude.transcript_viewer_open then (if .attention then "done" else "transcript" end)
      elif $claude.turn_running then "working"
      elif $claude.input_box_visible then (if .attention then "done" else "idle" end)
      else "unknown" end;

  def badge:
    {waiting: [0, "⏳"], done: [1, "✅"], working: [2, "⚙️"], idle: [3, "💤"],
     transcript: [4, "📜"], unknown: [5, "❓"]}[.];
'

# ── Listing ──────────────────────────────────────────────────────────────────

# One tmux-status JSON object per pane, across all sessions.
describe_all_panes() {
  tmux list-panes -a -F '#{pane_id}' | while read -r pane; do
    # The pane may close between listing and describing it.
    tmux-status "$pane" 2>/dev/null || true
  done
}

# Claude panes as tab-separated rows:
#   urgency rank, pane id, state, location, directory, session name
claude_rows() {
  jq -r "$JQ_STATE_DEFS"'
    select(.type == "claude")
    | state as $state
    | ($state | badge) as [$rank, $icon]
    | [$rank, .pane, "\($icon) \($state)", .location, (.path | split("/") | last), .data.session_name]
    | @tsv
  '
}

most_urgent_first() {
  sort -s -n -k1,1 | cut -f2-
}

# Pad tab-separated columns to a common width (util-linux column isn't
# available on darwin).
align_columns() {
  awk -F'\t' '
    {
      rows[NR] = $0
      for (i = 1; i <= NF; i++) if (length($i) > width[i]) width[i] = length($i)
    }
    END {
      for (r = 1; r <= NR; r++) {
        n = split(rows[r], cell, "\t")
        line = ""
        for (i = 1; i < n; i++) line = line sprintf("%-" width[i] "s  ", cell[i])
        print line cell[n]
      }
    }
  '
}

list_rows() {
  describe_all_panes | claude_rows | most_urgent_first | align_columns
}

# Counts per state, most urgent first, skipping states with no panes; empty
# when there are no Claude panes.
summary() {
  describe_all_panes | jq -rs "$JQ_STATE_DEFS"'
    [.[] | select(.type == "claude") | state] as $states
    | ["waiting", "done", "working", "idle"]
    | map(. as $state
          | ($states | map(select(. == $state)) | length) as $count
          | select($count > 0)
          | "\($state | badge | .[1])\($count)")
    | join(" ")
  '
}

# ── Picker ───────────────────────────────────────────────────────────────────

# The pane's live screen, headed by the line tmux-status couldn't place when
# the state is unknown.
preview() {
  local pane=$1 state=$2 lines=${FZF_PREVIEW_LINES:-40}
  if [ "$state" = unknown ]; then
    echo "❓ No state rule matched this line:"
    echo "   $(tmux-status "$pane" | jq -r .data.last_line)"
    echo
    lines=$((lines - 3))
  fi
  tmux capture-pane -ep -t "$pane" | tail -n "$lines"
}

# Pick a row from stdin; prints its pane id (the hidden first column). The
# preview gets the pane id and state, the first and third columns.
pick_pane() {
  fzf \
    --no-sort --ansi --prompt '🤖  ' \
    --header '  ^r reload' \
    --with-nth 2.. \
    --bind 'tab:down,btab:up' \
    --bind "ctrl-r:reload($0 --list)" \
    --preview-window 'right:55%' \
    --preview "$0 --preview {1} {3}" |
    awk '{ print $1 }'
}

# Runs tmux with `-c CLIENT` inserted after the subcommand when a client is
# known, so it acts on the terminal the picker was opened from.
tmux_on_client() {
  local subcommand=$1
  shift
  tmux "$subcommand" ${client:+-c "$client"} "$@"
}

jump_to_pane() {
  local pane=$1
  tmux_on_client switch-client -t "$pane"
  tmux select-window -t "$pane" \; select-pane -t "$pane"
}

run_picker() {
  local rows pane
  rows=$(list_rows)
  if [ -z "$rows" ]; then
    tmux_on_client display-message "tmux-agents: no Claude panes"
    return
  fi

  # fzf exits non-zero when dismissed; that's not an error.
  pane=$(pick_pane <<<"$rows") || return 0
  if [ -n "$pane" ]; then
    jump_to_pane "$pane"
  fi
}

open_popup() {
  tmux display-popup -c "$client" -E -w 80% -h 70% -T ' agents ' "$0" --client "$client"
}

# ── Main ─────────────────────────────────────────────────────────────────────

client=""

main() {
  case "${1:-}" in
    --open-popup) client=$2 && open_popup ;;
    --client) client=$2 && run_picker ;;
    --list) list_rows ;;
    --preview) preview "$2" "$3" ;;
    --summary) summary ;;
    "") run_picker ;;
    *)
      echo "usage: tmux-agents [--open-popup CLIENT | --client CLIENT | --list | --preview PANE STATE | --summary]" >&2
      exit 2
      ;;
  esac
}

main "$@"
