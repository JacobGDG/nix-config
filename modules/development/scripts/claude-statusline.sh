#!/usr/bin/env bash
set -euo pipefail

# Claude Code pipes session JSON on stdin; whatever we print becomes the
# status line.
input=$(cat)

# Character (not byte) lengths for the block chars; C.UTF-8 is built into
# glibc, so this works without a locale archive.
export LC_ALL=C.UTF-8

# Columns kept clear on the right. Claude Code reserves undocumented space
# around the status line and truncates with "…" if we overrun it; 2 was too
# small, so tune this by eye.
right_margin=5

# Leads the line so tmux-status (modules/shell/scripts/tmux-status.sh) can
# find and drop it when reading the screen. Change both together.
marker='◆'

field() {
  jq -r "$1" <<<"$input"
}

# Coloured bar (10 cells unless a width is given) for a 0-100 percentage,
# followed by the number.
bar() {
  local pct=$1 width=${2:-10} filled colour bar_full bar_empty

  filled=$(((pct * width + 50) / 100)) # round to nearest cell
  ((filled > width)) && filled=$width

  # Pad to n spaces, then swap spaces for block chars (tr is byte-wise, so it
  # can't emit multibyte UTF-8).
  printf -v bar_full '%*s' "$filled" ''
  printf -v bar_empty '%*s' "$((width - filled))" ''

  if ((pct >= 90)); then
    colour=$'\e[31m'
  elif ((pct >= 75)); then
    colour=$'\e[38;5;208m' # orange; basic ANSI only has yellow
  else
    colour=$'\e[32m'
  fi

  printf '%s%s%s\e[0m %s%%' "$colour" "${bar_full// /▓}" "${bar_empty// /░}" "$pct"
}

# Spaces needed between two strings to push the second to the right edge.
# COLUMNS is set by Claude Code (the script's output is captured, so tput
# can't see the terminal); without it we fall back to a single space.
gap() {
  local visible
  visible=$(printf '%s%s' "$1" "$2" | sed 's/\x1b\[[0-9;]*m//g')
  local n=$((${COLUMNS:-0} - right_margin - ${#visible}))
  echo $((n > 1 ? n : 1))
}

# Time from now until an epoch timestamp, as its two largest units: 2d2h,
# 2h13m, 45m. Prints nothing once it has passed.
countdown() {
  local secs=$(($1 - EPOCHSECONDS)) d h m
  ((secs > 0)) || return 0

  d=$((secs / 86400))
  h=$((secs % 86400 / 3600))
  m=$((secs % 3600 / 60))

  if ((d > 0)); then
    printf '%dd%dh' "$d" "$h"
  elif ((h > 0)); then
    printf '%dh%dm' "$h" "$m"
  else
    printf '%dm' "$m"
  fi
}

model() {
  field '.model.display_name'
}

context() {
  # used_percentage is null until the first API response of a session.
  bar "$(field '.context_window.used_percentage // 0 | floor')"
}

# Prints nothing when the limit is absent (API-key auth, or before the first
# response).
rate_limit() {
  local label=$1 window=$2 pct reset
  pct=$(field ".rate_limits.$window.used_percentage // empty | floor")
  [[ -n $pct ]] || return 0
  printf '%s %s' "$label" "$(bar "$pct" 5)"

  reset=$(countdown "$(field ".rate_limits.$window.resets_at // 0")")
  [[ -n $reset ]] && printf ' ↻%s' "$reset"
  return 0
}

left=$(printf '%s %s · %s' "$marker" "$(model)" "$(context)")
right=$(printf '%s  %s' "$(rate_limit 5h five_hour)" "$(rate_limit 7d seven_day)")
right=${right#"  "} # drop the separator when the 5h limit is absent
right=${right%"  "} # ...or the 7d one

if [[ -n $right ]]; then
  printf '%s%*s%s\n' "$left" "$(gap "$left" "$right")" '' "$right"
else
  printf '%s\n' "$left"
fi
