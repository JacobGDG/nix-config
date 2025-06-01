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

[linux]
erebor-hm:
  home-manager switch --flake .#erebor

# rebuild nixos and use it
[linux]
os:
  sudo nixos-rebuild switch --flake .#jake-laptop-nixos --show-trace

[linux]
erebor-os:
  sudo nixos-rebuild switch --flake .#erebor --show-trace

# Build and use new home-manager config
[macos]
hm:
  home-manager switch --flake .#workMac --extra-experimental-features nix-command --extra-experimental-features flakes

# Delete old generations
clean:
  sudo nix-collect-garbage -d

# Clean nix code
format:
  nix fmt
