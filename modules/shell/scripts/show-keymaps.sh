#!/usr/bin/env bash

config_file=~/.config/hypr/config.lua
keybinds=$(grep '^hl.bind(' $config_file |
  sed -E \
    -e 's/^hl\.bind\(//' \
    -e 's/^window_mod \.\. "/"SUPER + CTRL/' \
    -e 's/^mod \.\. "/"SUPER/' \
    -e 's/, \{[^}]*\}\)$/)/' \
    -e 's/\)$//' \
    -e 's/hl\.dsp\.//g' \
    -e 's/^"([^"]*)", /\1 = /')
walker --dmenu --placeholder keymaps <<< "$keybinds"
