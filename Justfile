hm:
  ./nix-config hm

os:
  ./nix-config os

update:
  nix flake update agenix mysecrets wallpapers prompts neovim private-config

full_update:
  nix flake update --show-trace

go: update hm

clean:
  sudo nix-collect-garbage -d

check:
  nix flake check


pull:
  git pull

prep_sudo:
  sudo -v

full_sync: prep_sudo pull update os hm
