hm:
  ./nix-config hm

os:
  ./nix-config os

update: pull
  ./nix-config update

full_update: pull
  ./nix-config full_update

go: update hm

pull:
  git pull
