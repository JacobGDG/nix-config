#!/usr/bin/env bash
set -euo pipefail

BOOKMARKS_FILE="${HOME}/.mozilla/firefox/default/bookmarks.html"

extract_bookmarks() {
    rg '<a href="([^"]+)"[^>]*add_date="([^"]+)"[^>]*last_modified="([^"]+)"[^>]*>([^<]+)</a>' \
        -or '{"url": "$1", "add_date": "$2", "last_modified": "$3", "title": "$4"}' \
        < "$BOOKMARKS_FILE"
}

format_for_wofi() {
    jq -r -s 'sort_by(.add_date) | reverse | .[] | "\(.title) (\(.url))"'
}

select_bookmark() {
    wofi -p "Bookmarks: " --show dmenu -i
}

open_url() {
    sed -E 's/.*\((.*)\)/\1/' | xargs -- xdg-open
}

main() {
    extract_bookmarks | \
    format_for_wofi | \
    select_bookmark | \
    open_url
}

main
