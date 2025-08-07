#!/usr/bin/env bash

function help {
  echo "kubernetes helper scropt to fetch all the pods dependant on a given configmap"
  echo "  usage: k-cm-dependants <namespace> <configmap_name>"
}

function check_configmap {
  configmap_exists=$(kubectl get configmap "$configmap_name" --namespace $namespace --ignore-not-found)

  if [[ -z "$configmap_exists" ]]; then
    echo "ConfigMap $configmap_name does not exist."
    exit 1
  fi
}

if [[ $# -eq 0 ]]; then
  help
  exit 1
fi

export namespace="$1"
export configmap_name="$2"

check_configmap

kubectl get pods -n "$namespace" -o json | jq -r '
  .items[] |
  select(
    (.spec.volumes[]?.configMap?.name == "'$configmap_name'") or
    (.spec.containers[].envFrom[]?.configMapRef?.name == "'$configmap_name'") or
    (.spec.containers[].env[]?.valueFrom?.configMapKeyRef?.name == "'$configmap_name'")
  ) |
  .metadata.name'
