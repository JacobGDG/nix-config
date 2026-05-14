#!/usr/bin/env bash
set -euo pipefail

KITTY_TITLE="QuickAccessKitty"
KITTY_CMD="kitty --title $KITTY_TITLE"

is_kitty_running() {
  hyprctl clients | grep -q "title: $KITTY_TITLE"
}

launch_kitty() {
  export TMUX_SESSION=quick-access-kitty
  $KITTY_CMD &
  disown
}

close_kitty() {
  local kitty_pid
  kitty_pid=$(hyprctl -j clients | jq -r '.[] | select(.initialTitle == "QuickAccessKitty") | .pid')
  if [[ -n "$kitty_pid" ]]; then
    kill "$kitty_pid"
  else
    echo "Error: Could not find kitty process to kill." >&2
    return 1
  fi
}

main() {
  if is_kitty_running; then
    close_kitty || exit 1
  else
    launch_kitty || exit 1
  fi
}

main "$@"
