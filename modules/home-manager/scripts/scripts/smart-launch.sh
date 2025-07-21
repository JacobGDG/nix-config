#!/usr/bin/env bash

app="$1"
shift

if [ -z "$app" ]; then
  echo "Usage: smart-focus.sh <app-name> [command...]"
  exit 1
fi

# Check if the app is running
match=$(hyprctl clients -j | jq -r --arg app "$app" '.[] | select(.class|test($app;"i")) | "\(.address) \(.workspace.id)"' | head -n1)

if [ -n "$match" ]; then
  # If found, focus its workspace
  workspace_id=$(echo "$match" | awk '{print $2}')
  hyprctl dispatch workspace "$workspace_id"
else
  # Find an unused workspace (simple increment until we hit an unused one)
  used=$(hyprctl workspaces -j | jq '.[].id' | sort -n)
  new_ws=1
  while echo "$used" | grep -qx "$new_ws"; do
    new_ws=$((new_ws + 1))
  done

  # Move to the new workspace and launch the app there
  hyprctl dispatch workspace "$new_ws"
  exec "$app" "$@" &
fi
