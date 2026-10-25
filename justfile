write-flake:
  nix run .#write-flake --show-trace

check:
  nix flake check --show-trace

[linux]
vm-clean host=`hostname`:
  rm -f ./{{host}}.qcow2

[linux]
diff host=`hostname`:
  #!/usr/bin/env bash
  set -euo pipefail
  attr='nixosConfigurations."{{host}}".config.system.build.toplevel.drvPath'
  OLD=$(nix eval --raw "git+file://$PWD?rev=$(git rev-parse HEAD)#$attr")
  NEW=$(nix eval --raw ".#$attr")
  if [ "$OLD" = "$NEW" ]; then
    echo "✓ {{host}}: derivations are identical"
  else
    nix run nixpkgs#nix-diff -- "$OLD" "$NEW"
  fi

[linux]
os-build host=`hostname`:
  sudo nixos-rebuild build --flake .#"{{host}}" --show-trace

[linux]
os host=`hostname`:
  sudo nixos-rebuild switch --flake .#"{{host}}" --show-trace

hm-build user=`whoami` host=`hostname`:
  home-manager build --flake .#"{{user}}@{{host}}" --show-trace

hm user=`whoami` host=`hostname`:
  home-manager switch --flake .#"{{user}}@{{host}}" --show-trace

[linux]
vm host=`hostname`: (vm-clean host)
  nix run .#vm-{{host}}
