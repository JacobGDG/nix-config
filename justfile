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

# NIXOS: Build and use new home-manager config
hm-nix:
  home-manager switch --flake .#nixos-laptop

# MACOS: Build and use new home-manager config
hm-mac:
  home-manager switch --flake .#macbook

# rebuild nixos but don't switch to it
os-build:
  sudo nixos-rebuild build --flake .#nixos-laptop --show-trace

# rebuild nixos and use it
os-switch:
  sudo nixos-rebuild switch --flake .#nixos-laptop --show-trace
