#!/usr/bin/env bash

status=$(wg-manager status)

# Parse the status output
home=$(echo "$status" | grep 'WG-home:' | awk '{print $2}')
public=$(echo "$status" | grep 'WG-public:' | awk '{print $2}')

if [ "$home" = "ON" ]; then
    alt="home"
    class="active"
    tooltip="Home VPN Connected"
elif [ "$public" = "ON" ]; then
    alt="public"
    class="active"
    tooltip="Public VPN Connected"
else
    alt="inactive"
    class="inactive"
    tooltip="No VPN Connected"
fi

echo "{\"alt\": \"$alt\", \"class\": \"$class\", \"tooltip\": \"$tooltip\"}"
