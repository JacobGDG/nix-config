#!/usr/bin/env bash
# start-work — start, or pick back up, work on a Jira ticket in its own
# worktree and tmux session.
#
#   1. Pick one of your To Do / Doing tickets, or type a title for work that
#      has no ticket (enter with no match, or alt-enter, uses what you typed).
#   2. Edit the suggested branch name, e.g. JIR-123-fix-the-bug.
#   3. Pick a repo from `bark repos`.
#   4. If the branch already exists, see its state and choose to open it or
#      start a fresh <branch>-N.
#   5. `bark add` creates or opens the worktree and switches tmux to the
#      <repo>/<branch> session.
#
# bark never prompts, so every question lives here. Bound to prefix-b (see
# modules/shell/tmux.nix).
#
# Usage:
#   start-work --open-popup CLIENT   run in a popup on CLIENT
#   start-work [--client CLIENT]     run here; switch CLIENT when done
#   start-work --branch-name KEY TITLE
#                                    print the branch name the picker would
#                                    suggest (KEY may be empty)
#
# The client is passed explicitly for the same reason as in tmux-agents: with
# several terminals attached, tmux can't tell which one a popup belongs to.
set -uo pipefail

MAX_BRANCH_LEN=50
client=""

die() {
  echo "start-work: $*" >&2
  # A popup closes as soon as the script exits; keep the error readable.
  if [[ -n $client ]]; then
    read -rsn1 -p "Press any key to close."
  fi
  exit 1
}

# ── Branch names ─────────────────────────────────────────────────────────────

# The ticket key keeps its case; the title is lowercased and every run of
# characters other than [a-z0-9] becomes a single "-". Names longer than
# MAX_BRANCH_LEN are cut at the last whole word that fits.
#   branch_name JIR-123 "Fix the Bug: (urgent)"  ->  JIR-123-fix-the-bug-urgent
#   branch_name "" "Tidy up CI"                  ->  tidy-up-ci
branch_name() {
  local key=$1 title=$2 slug name cut
  slug=$(printf '%s' "$title" | LC_ALL=C tr '[:upper:]' '[:lower:]' | LC_ALL=C tr -cs 'a-z0-9' '-')
  slug=${slug#-}
  slug=${slug%-}
  name=$key${key:+${slug:+-}}$slug

  if ((${#name} > MAX_BRANCH_LEN)); then
    # One extra character shows whether the cut falls on a word boundary.
    cut=${name:0:MAX_BRANCH_LEN+1}
    cut=${cut%-*}
    # No boundary to cut at without eating into the key: cut mid-word.
    if ((${#cut} <= ${#key})) || ((${#cut} > MAX_BRANCH_LEN)); then
      cut=${name:0:MAX_BRANCH_LEN}
    fi
    name=${cut%-}
  fi
  printf '%s\n' "$name"
}

# ── Steps ────────────────────────────────────────────────────────────────────

# Your open tickets as tab-separated rows: key, status, summary. Fails if
# Jira can't be reached, e.g. offline or not logged in.
list_tickets() {
  local me
  me=$(jira me 2>/dev/null) || return 1
  jira issue list -a"$me" -s"To Do" -s"Doing" -t~Epic --raw 2>/dev/null |
    jq -r '.[] | [.key, .fields.status.name, .fields.summary] | @tsv'
}

# Sets ticket_key and title. ticket_key is empty for free-text work.
pick_ticket() {
  local tickets header out rc query pressed selection
  header='enter: pick ticket · alt-enter: use typed text as a title with no ticket'
  echo "Fetching tickets..."
  if ! tickets=$(list_tickets); then
    tickets=""
    header="Couldn't reach Jira (try \`jira me\`); type a title for the branch."
  fi

  out=$(printf '%s' "$tickets" | fzf \
    --print-query --expect=alt-enter \
    --delimiter='\t' --tabstop=4 \
    --prompt='ticket> ' \
    --header="$header")
  rc=$?
  # 1 means nothing matched; fzf still prints the query.
  ((rc <= 1)) || return 1

  {
    IFS= read -r query
    IFS= read -r pressed
    IFS= read -r selection
  } <<<"$out"

  if [[ $pressed == alt-enter || -z $selection ]]; then
    ticket_key=""
    title=$query
  else
    IFS=$'\t' read -r ticket_key _ title <<<"$selection"
  fi
  [[ -n $ticket_key || -n $title ]]
}

# Lets you edit the suggested branch name and prints the result. fzf with no
# items serves as the line editor: nixpkgs' non-interactive bash has no
# readline, so `read -e -i` can't pre-fill.
edit_branch() {
  local branch rc
  branch=$(fzf --print-query --query="$1" --prompt='branch> ' \
    --header='Edit the branch name; enter to accept' </dev/null)
  rc=$?
  # 1 means nothing matched, which is always the case with no items.
  ((rc <= 1)) || return 1
  branch=$(head -n1 <<<"$branch")
  [[ -n $branch ]] && printf '%s\n' "$branch"
}

# One line per fact about an existing branch, from `bark status --json`.
describe_status() {
  jq -r '
    "\(.branch) already exists in \(.repo):",
    "  on:          \([if .local then "local" else empty end,
                       if .remote then "origin" else empty end] | join(", "))",
    if .worktree then "  worktree:    \(.worktree) (\(.changed_files) uncommitted)" else empty end,
    if .ahead != null then "  vs origin:   \(.ahead) ahead, \(.behind) behind" else empty end,
    if .last_commit then "  last commit: \(.last_commit)" else empty end,
    "  merged:      \(if .merged then "yes" else "no" end)"
  '
}

# Prints the --on-exists policy to use: open, or increment for a fresh branch.
choose_policy() {
  local status=$1 choice
  if ! jq -e '.exists or .worktree != null' <<<"$status" >/dev/null; then
    echo error
    return
  fi

  choice=$(printf '%s\t%s\n' \
    open "use the existing branch" \
    increment "start a fresh branch: $branch-N" \
    cancel "cancel" |
    fzf --delimiter='\t' --with-nth=2 --no-sort --prompt='branch> ' \
      --header="$(describe_status <<<"$status")") || return 1
  choice=${choice%%$'\t'*}
  [[ $choice != cancel ]] && echo "$choice"
}

# ── Main ─────────────────────────────────────────────────────────────────────

run() {
  local ticket_key title branch repo status policy path repo_path session

  pick_ticket || exit 0
  branch=$(edit_branch "$(branch_name "$ticket_key" "$title")") || exit 0

  repo=$(bark repos | fzf --prompt='repo> ' --header="Branch: $branch") || exit 0

  echo "Checking $repo/$branch..."
  status=$(bark status "$repo" "$branch" --fetch --json) || die "bark status failed"
  policy=$(choose_policy "$status") || exit 0

  # bark switches tmux to the new session itself (it's run inside our
  # session), which is right with one terminal attached.
  path=$(bark add "$repo" "$branch" --on-exists="$policy" --print-path) ||
    die "bark add failed"

  # With several terminals attached, make sure the one that asked is the one
  # that moves. --on-exists=increment may have changed the branch, so take it
  # from the path; bark replaces "." and ":" in session names.
  if [[ -n $client ]]; then
    repo_path=$(bark repos --json | jq -r --arg repo "$repo" '.[] | select(.name == $repo) | .path')
    session="$repo/${path#"$repo_path"/}"
    session=${session//[.:]/_}
    tmux switch-client -c "$client" -t "=$session" 2>/dev/null || true
  fi
}

open_popup() {
  tmux display-popup -c "$client" -E -w 80% -h 70% -T ' start work ' "$0" --client "$client"
}

main() {
  case "${1:-}" in
    --open-popup) client=$2 && open_popup ;;
    --client) client=$2 && run ;;
    --branch-name) branch_name "$2" "$3" ;;
    "") run ;;
    *)
      echo "usage: start-work [--open-popup CLIENT | --client CLIENT | --branch-name KEY TITLE]" >&2
      exit 2
      ;;
  esac
}

main "$@"
