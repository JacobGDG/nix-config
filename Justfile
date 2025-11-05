hm:
  ./nix-config hm

os:
  ./nix-config os

update:
  ./nix-config update

full_update:
  ./nix-config full_update

go: update hm

clean:
  ./nix-config clean

pull:
  git pull
