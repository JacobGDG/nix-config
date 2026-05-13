write-flake:
  nix run .#write-flake --show-trace

check:
  nix flake check --show-trace

hm-build:
  home-manager build --flake ".#$(whoami)@$(hostname)" --show-trace

os-build:
  sudo nixos-rebuild build --flake .#"$(hostname)" --show-trace

vm-clean host=`hostname`:
  rm -f ./{{host}}.qcow2

vm host=`hostname`: (vm-clean host)
  nix run .#vm-{{host}}

debug:
  cp modules/_debug.nix modules/debug.nix
  git add modules/debug.nix

debug-clean:
  git rm -f modules/debug.nix 2>/dev/null || rm -f modules/debug.nix

test: write-flake hm-build os-build

check-scripts:
  #!/usr/bin/env bash
  set -euo pipefail
  orphans=()
  while IFS= read -r sh; do
    basename=$(basename "$sh")
    if ! grep -q "$basename" modules/packages/default.nix; then
      orphans+=("$sh")
    fi
  done < <(find modules/packages -name "*.sh")
  if ! [ ${#orphans[@]} -eq 0 ]; then
    echo "Orphaned .sh files (not referenced in modules/packages/default.nix):"
    printf '  %s\n' "${orphans[@]}"
    exit 1
  fi

web:
  xdg-open https://github.com/JacobGDG/nix-config/tree/dendritic-rebuild
