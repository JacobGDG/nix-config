#!/usr/bin/env bash
set -euo pipefail

# Remove git-ref-clone clones (~/.cache/ref-repos/<org>/<repo>/<ref>) cloned
# more than max_age_days ago. Only directories carrying git-ref-clone's
# refclone.cloned marker are ever removed; anything else is skipped.

root="${XDG_CACHE_HOME:-$HOME/.cache}/ref-repos"
max_age_days=30

usage() {
  echo "Usage: git-ref-clean [--dry-run]" >&2
  echo "  Removes clones under $root older than $max_age_days days" >&2
  exit 1
}

# Sets: dry_run
parse_args() {
  dry_run=false
  local arg
  for arg in "$@"; do
    case "$arg" in
    -n | --dry-run) dry_run=true ;;
    -h | --help) usage ;;
    *)
      echo "Error: unknown argument '$arg'" >&2
      usage
      ;;
    esac
  done
}

candidates() {
  find "$root" -mindepth 3 -maxdepth 3 -type d -print0
}

# Read the marker straight from the clone's config file, so git never walks up
# into some enclosing repository.
cloned_at() {
  git config --file "$1/.git/config" --get refclone.cloned 2>/dev/null
}

is_safe_path() {
  local path="$1"
  [[ $path == "$root"/*/*/* && $path != *..* && ! -L $path ]]
}

# Sets: removed, kept, skipped
process() {
  local clone="$1" cloned now
  now=$(date +%s)

  if ! is_safe_path "$clone"; then
    echo "Skipping unexpected path: $clone" >&2
    skipped=$((skipped + 1))
    return
  fi

  cloned=$(cloned_at "$clone") || cloned=""
  if [[ ! $cloned =~ ^[0-9]+$ ]]; then
    echo "Skipping unmarked: $clone" >&2
    skipped=$((skipped + 1))
    return
  fi

  if ((now - cloned <= max_age_days * 86400)); then
    kept=$((kept + 1))
    return
  fi

  if $dry_run; then
    echo "Would remove: $clone" >&2
  else
    rm -rf --one-file-system -- "$clone"
    echo "Removed: $clone" >&2
  fi
  removed=$((removed + 1))
}

# Drop <org>/<repo> directories left empty by removed clones.
remove_empty_parents() {
  find "$root" -mindepth 1 -maxdepth 2 -type d -empty -delete
}

main() {
  parse_args "$@"
  [[ -d $root ]] || exit 0

  removed=0 kept=0 skipped=0
  local clone
  while IFS= read -r -d '' clone; do
    process "$clone"
  done < <(candidates)

  local verb=Removed
  if $dry_run; then verb="Would remove"; else remove_empty_parents; fi
  echo "$verb $removed, kept $kept, skipped $skipped (older than $max_age_days days are removed)" >&2
}

main "$@"
