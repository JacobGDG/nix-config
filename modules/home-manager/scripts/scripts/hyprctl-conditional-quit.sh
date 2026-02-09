#!/usr/bin/env bash

help() {
  echo "Hyprland script to quite the active window if it isn't specific applications."
}

notify_canceled_exit() {
  notify-send -a "Safe Exit" "Canceled exit call, us app UI."
}

if [[ $1 == "help" ]]; then
  help
  exit 1
fi

active_window=$(hyprctl activewindow -j | jq -r '.class')

echo $active_window

if [[ $active_window =~ ^(steam_app_[0-9]+|dwarfort|Minecraft.+)$ ]]; then
  notify_canceled_exit
  exit 1
fi

hyprctl dispatch killactive
