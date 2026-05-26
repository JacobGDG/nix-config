#!/usr/bin/env bash
set -euo pipefail

KITTY_TITLE="QuickAccessKitty"
KITTY_CMD="kitty --title $KITTY_TITLE"

# Function to check if kitty instance with the given title is running
is_kitty_running() {
    hyprctl clients | grep -q "title: $KITTY_TITLE"
}

# Function to launch kitty
launch_kitty() {
    export TMUX_SESSION=quick-access-kitty
    $KITTY_CMD &
    disown
}

# Function to close kitty
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
    if ! command -v hyprctl >/dev/null; then
        echo "Error: hyprctl not found. Are you running Hyprland?" >&2
        exit 1
    fi
    if ! command -v kitty >/dev/null; then
        echo "Error: kitty terminal not found." >&2
        exit 1
    fi

    if is_kitty_running; then
        close_kitty || exit 1
    else
        launch_kitty || exit 1
    fi
}

main "$@"
