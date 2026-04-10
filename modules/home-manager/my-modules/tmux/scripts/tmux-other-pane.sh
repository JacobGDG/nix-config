#!/usr/bin/env bash

# Ensure we're inside tmux
if [ -z "$TMUX" ]; then
  echo "Not inside a tmux session"
  exit 1
fi

# Get the current pane ID
current_pane=$(tmux display-message -p "#{pane_index}")

# Get all pane IDs in the current window
all_panes=($(tmux list-panes -F "#{pane_index}"))

# Check pane count
if [ "${#all_panes[@]}" -ne 2 ]; then
  echo "Error: This script only works when there are exactly 2 panes in the window" >&2
  exit 2
fi

# Find the other one
for pane in "${all_panes[@]}"; do
  if [[ "$pane" != "$current_pane" ]]; then
    echo "$pane"
    exit 0
  fi
done

echo "UNKNOWN ERROR"
exit 3
