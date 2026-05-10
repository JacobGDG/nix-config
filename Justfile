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

test: write-flake hm-build os-build
