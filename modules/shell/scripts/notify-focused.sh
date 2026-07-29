#!/usr/bin/env bash
# Flash a message on every attached tmux client that currently has terminal
# focus, wherever they are — a cross-session visual bell. No-op when no client
# is focused (e.g. you've alt-tabbed away from the terminal entirely).
#
# Usage: notify-focused <message>
set -uo pipefail

msg="${1:-}"
[ -z "$msg" ] && exit 0

while IFS=' ' read -r flags client; do
  case ",$flags," in
    *,focused,*) tmux display-message -c "$client" "$msg" 2>/dev/null ;;
  esac
done < <(tmux list-clients -F '#{client_flags} #{client_name}' 2>/dev/null)
