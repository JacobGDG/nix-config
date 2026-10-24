#!/usr/bin/env bash
set -euo pipefail

CANDIDATES=()
[[ -n "${FIREFOX_BOOKMARKS_PATH:-}" ]] && CANDIDATES+=("$FIREFOX_BOOKMARKS_PATH")
[[ -n "${XDG_CONFIG_HOME:-}" ]] && CANDIDATES+=("${XDG_CONFIG_HOME}/mozilla/firefox/default/bookmarks.html")
CANDIDATES+=(
  "${HOME}/.mozilla/firefox/default/bookmarks.html"
  "${HOME}/Downloads/bookmarks.html"
)

BOOKMARKS_FILE=""
for candidate in "${CANDIDATES[@]}"; do
  if [[ -f "$candidate" ]]; then
    BOOKMARKS_FILE="$candidate"
    break
  fi
done

if [[ -z "$BOOKMARKS_FILE" ]]; then
  notify-send -t 5000 -u critical "wofi-bookmarks" "Bookmarks file not found in: ${CANDIDATES[*]}, download it from firefox."
  exit 1
fi

extract_bookmarks() {
  rg '<A HREF="([^"]+)"[^>]*ADD_DATE="([^"]+)"[^>]*LAST_MODIFIED="([^"]+)"[^>]*>([^<]+)</A>' \
    -or '{"url": "$1", "add_date": "$2", "last_modified": "$3", "title": "$4"}' \
    <"$BOOKMARKS_FILE"
}

format_for_wofi() {
  jq -r -s 'sort_by(.add_date) | reverse | .[] | "\(.title) (\(.url))"'
}

select_bookmark() {
  wofi -p "Bookmarks: " --show dmenu -i --cache-file "${XDG_CACHE_HOME:-$HOME/.cache}/wofi/bookmarks"
}

open_url() {
  sed -E 's/.*\((.*)\)/\1/' | xargs -- xdg-open
}

main() {
  extract_bookmarks |
    format_for_wofi |
    select_bookmark |
    open_url
}

main
