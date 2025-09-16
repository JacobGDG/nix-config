#!/usr/bin/env bash

awk '{print $2}' < ~/.mozilla/firefox/default/bookmarks.html  | rg -o 'https?://[^"]+' |  wofi -p "Bookmarks: " --show dmenu -i | xargs -- xdg-open
