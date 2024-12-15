set shell := ["zsh", "-c"]

# List all the just commands
default:
    @just --list

# update the flake
update:
  nix flake update

# check the flake without building
check:
  nix flake check

# Build and use new home-manager config
[linux]
hm:
  home-manager switch --flake .#nixOSLenovo

# rebuild nixos and use it
[linux]
os:
  sudo nixos-rebuild switch --flake .#nixos-laptop --show-trace

# Build and use new home-manager config
[macos]
hm:
  home-manager switch --flake .#workMac

format:
  nix fmt
