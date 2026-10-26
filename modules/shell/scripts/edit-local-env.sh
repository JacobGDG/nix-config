#!/usr/bin/env bash
set -euo pipefail

local_env="${ZDOTDIR:-${XDG_CONFIG_HOME:-$HOME/.config}/zsh}/.zshrc.local"

if [[ ! -f "$local_env" ]]; then
  mkdir -p "$(dirname "$local_env")"
  touch "$local_env"
fi

"${EDITOR:-nvim}" "$local_env"

echo "Run: source \"$local_env\"" >&2
