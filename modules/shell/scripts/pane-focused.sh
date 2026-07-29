#!/usr/bin/env bash
# Exit 0 if the given tmux pane is currently focused — i.e. some attached
# client that has terminal focus is actively viewing it. Exit 1 otherwise.
# This is cross-session: tmux's per-session "current pane" can't answer it,
# so we inspect every client's focus flag against the pane it is viewing.
#
# Usage: pane-focused [pane-id]   (defaults to $TMUX_PANE)
set -uo pipefail

pane="${1:-${TMUX_PANE:-}}"
[ -z "$pane" ] && exit 1

while IFS=' ' read -r flags client_pane; do
  case ",$flags," in
    *,focused,*) [ "$client_pane" = "$pane" ] && exit 0 ;;
  esac
done < <(tmux list-clients -F '#{client_flags} #{pane_id}' 2>/dev/null)

exit 1
