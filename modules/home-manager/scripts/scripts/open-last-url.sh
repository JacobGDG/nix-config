#!/usr/bin/env bash

RED="\033[0;31m"
ENDCOLOR="\033[0m"

last_url=$(tmux capture-pane -p -S -1000 \
    | grep -oE 'https?://[^ ]+' \
    | tail -n1)

if [[ -n "$last_url" ]]; then
    if command -v xdg-open >/dev/null 2>&1; then
        xdg-open "$last_url"
    elif command -v open >/dev/null 2>&1; then
        open "$last_url"
    else
        echo "No suitable opener found (xdg-open or open)."
        exit 1
    fi
else
    echo "No URL found in the last 1000 lines of pane history."
    exit 1
fi
