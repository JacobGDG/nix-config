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

# rebuild nixos but don't switch to it
build:
  sudo nixos-rebuild build --flake .#nixos-laptop --show-trace

# rebuild nixos and use it
switch:
  sudo nixos-rebuild switch --flake .#nixos-laptop --show-trace
