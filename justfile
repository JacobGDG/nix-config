write-flake:
  nix run .#write-flake --show-trace

check:
  nix flake check --show-trace

[linux]
vm-clean host=`hostname`:
  rm -f ./{{host}}.qcow2

[linux]
os-build host=`hostname`:
  sudo nixos-rebuild build --flake .#"{{host}}" --show-trace

hm-build user=`whoami` host=`hostname`:
  home-manager build --flake .#"{{user}}@{{host}}" --show-trace

[linux]
vm host=`hostname`: (vm-clean host)
  nix run .#vm-{{host}}
