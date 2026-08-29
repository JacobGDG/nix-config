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
  git stash
  OLD=$(nix eval --raw .#nixosConfigurations."{{host}}".config.system.build.toplevel.drvPath)
  git stash pop
  NEW=$(nix eval --raw .#nixosConfigurations."{{host}}".config.system.build.toplevel.drvPath)
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
