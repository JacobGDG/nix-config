#!/usr/bin/env bash
# Focus-aware attention notification for tmux, invoked by Claude lifecycle
# hooks with the pane Claude is running in. We decide here whether to alert:
# stay silent when a focused client is already viewing that pane (the
# cross-session focus check lives in `pane-focused`). Otherwise flash a visual
# bell on every focused client (`notify-focused`) and play a sound
# (`play-sound`).
#
# The helper commands are baked in by store path via the @...@ placeholders.
#
# Usage: tmux-notify <pane-id> [label]
set -uo pipefail

belling="${1:-}"

# No pane id (e.g. Claude running outside tmux) — nothing to notify about.
[ -n "$belling" ] || exit 0

# You're looking right at it — no need for any alert.
@pane_focused@ "$belling" && exit 0

# Persistent marker: set the @attention window option so the status bar shows a
#  on the belling window until it's focused (cleared by the pane-focus-in hook
# in modules/shell/tmux.nix). Outlives the transient flash below.
tmux set-option -w -t "$belling" @attention 1 2>/dev/null

# Only now, on the path that actually alerts, resolve the pane's location for
# the label (default to the belling pane's session:window).
label="${2:-$(tmux display-message -p -t "$belling" "#{session_name}:#{window_index}" 2>/dev/null || echo "a background window")}"

# Visual bell: flash on every focused client, wherever they are.
@notify_focused@ "🔔 bell in $label"

# Audible bell.
@play_sound@ attention
