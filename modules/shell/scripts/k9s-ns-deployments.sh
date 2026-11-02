#!/usr/bin/env bash

function help {
  echo "open a tmux window with k9s pods above deployments for a given namespace"
  echo "  usage: k9s-ns-deployments <namespace>"
}

if [[ $# -ne 1 ]]; then
  help
  exit 1
fi

if ! kubectl get namespace "$1" >/dev/null 2>&1; then
  echo "Namespace $1 does not exist."
  exit 1
fi

K9S_NAMESPACE="$1" tmuxifier load-window k9s-ns-deployments
