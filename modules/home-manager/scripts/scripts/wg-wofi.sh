#!/usr/bin/env bash
set -euo pipefail

# Get list of interfaces
interfaces=()
while read -r iface; do
    [ -n "$iface" ] && interfaces+=("$iface")
done < <(wg-manager services)

# Build menu with status
menu_items="Disconnect All"
for iface in "${interfaces[@]}"; do
    status="$(wg-manager status "$iface" | grep -o 'ON\|OFF')"
    menu_items="$menu_items"$'\n'"$iface [$status]"
done

# Show menu and get selection
selection="$(echo "$menu_items" | wofi --show dmenu --prompt "WireGuard")"

if [[ "$selection" == "Disconnect All" ]]; then
    wg-manager down
elif [[ "$selection" =~ ^([a-zA-Z0-9_-]+)\ \[.*\]$ ]]; then
    iface="${BASH_REMATCH[1]}"
    wg-manager up "$iface"
else
    echo "No valid selection."
    exit 1
fi
