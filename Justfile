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
