#!/usr/bin/env bash
# Play a named notification sound, cross-platform, by delegating to whatever
# native player exists (afplay on macOS; pw-play/paplay on Linux). Non-blocking
# and best-effort: an unknown type or a missing player is a silent no-op, so
# callers never break on a machine without audio.
#
# Usage: play-sound [type]
#   type is a .wav basename in this repo's sounds dir (default: attention).
#   Only 'attention' is bundled today; drop more WAVs in sounds/ to add types.
#
# The sounds directory is baked in at build time via the @sounds@ placeholder.
set -uo pipefail

sounds="@sounds@"
type="${1:-attention}"
file="$sounds/$type.wav"

[ -f "$file" ] || exit 1

{
  if command -v afplay >/dev/null 2>&1; then
    afplay "$file"
  elif command -v pw-play >/dev/null 2>&1; then
    pw-play "$file"
  elif command -v paplay >/dev/null 2>&1; then
    paplay "$file"
  fi
} >/dev/null 2>&1 &
