#!/usr/bin/env bash
set -euo pipefail

# Clone a repo at a ref into ~/.cache/ref-repos/<org>/<repo>/<ref> for use as
# read-only reference. Messages go to stderr; the path is the only stdout.
# Clones are marked with refclone.cloned in their git config so git-ref-clean
# only ever removes what this script created.

root="${XDG_CACHE_HOME:-$HOME/.cache}/ref-repos"

usage() {
  echo "Usage: git-ref-clone [--deep] <url> [ref]" >&2
  echo "  url  https://<host>/<org>/<repo>[.git] or git@<host>:<org>/<repo>[.git]" >&2
  echo "  ref  branch or tag (default: the remote's default branch)" >&2
  exit 1
}

die() {
  echo "Error: $*" >&2
  exit 1
}

# Sets: deep, url, ref
parse_args() {
  deep=false
  local args=() arg
  for arg in "$@"; do
    case "$arg" in
    --deep) deep=true ;;
    -h | --help) usage ;;
    -*)
      echo "Error: unknown option '$arg'" >&2
      usage
      ;;
    *) args+=("$arg") ;;
    esac
  done
  [[ ${#args[@]} -ge 1 && ${#args[@]} -le 2 ]] || usage

  url="${args[0]}"
  ref="${args[1]:-}"
}

# Sets: org, repo
parse_url() {
  local url="$1"
  if [[ $url =~ ^https://[^/]+/([^/]+)/([^/]+)/?$ || $url =~ ^git@[^:/]+:([^/]+)/([^/]+)$ ]]; then
    org="${BASH_REMATCH[1]}"
    repo="${BASH_REMATCH[2]%.git}"
  else
    echo "Error: unsupported URL '$url'" >&2
    usage
  fi
  [[ $org != . && $org != .. && $repo != . && $repo != .. ]] || die "unsupported URL '$url'"
}

default_branch() {
  local url="$1" branch
  branch=$(git ls-remote --symref "$url" HEAD | awk '/^ref:/ { sub("refs/heads/", "", $2); print $2 }')
  [[ -n $branch ]] || die "could not determine default branch of '$url'"
  echo "$branch"
}

last_commit() {
  git -C "$1" log -1 --format='%h %cr (%ci)'
}

unshallow() {
  local target="$1"
  if [[ $(git -C "$target" rev-parse --is-shallow-repository) == true ]]; then
    echo "Unshallowing existing clone..." >&2
    git -C "$target" fetch --unshallow >&2
  fi
}

# Clone beside the target and move into place, so an interrupted clone never
# looks like a present one. tmp is global so the EXIT trap can still see it.
clone() {
  local url="$1" ref="$2" target="$3" deep="$4"
  local repo_dir depth=()
  repo_dir=$(dirname "$target")

  mkdir -p "$repo_dir"
  tmp=$(mktemp -d "$repo_dir/.clone.XXXXXX")
  trap 'rm -rf "$tmp"' EXIT

  $deep || depth=(--depth 1)
  git -c advice.detachedHead=false clone "${depth[@]}" --branch "$ref" "$url" "$tmp/repo" >&2
  git -C "$tmp/repo" config refclone.cloned "$(date +%s)"
  mv "$tmp/repo" "$target"
}

main() {
  parse_args "$@"
  git-ref-clean || echo "Warning: git-ref-clean failed" >&2
  parse_url "$url"
  [[ -n $ref ]] || ref=$(default_branch "$url")
  git check-ref-format --allow-onelevel "$ref" || die "invalid ref '$ref'"

  local target="$root/$org/$repo/${ref//\//-}"

  if [[ -d $target ]]; then
    ! $deep || unshallow "$target"
    echo "Already present: $target" >&2
  else
    clone "$url" "$ref" "$target" "$deep"
    echo "Cloned: $target" >&2
  fi

  echo "Last commit: $(last_commit "$target")" >&2
  echo "$target"
}

main "$@"
