write-flake:
  nix run .#write-flake --show-trace

check:
  nix flake check --show-trace

hm-build:
  home-manager build --flake .#"$(whoami)"@"$(hostname)" --show-trace

os-build:
  sudo nixos-rebuild build --flake .#"$(hostname)" --show-trace

test: write-flake hm-build os-build
