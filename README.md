# nix-config

My NixOS and home-manager configuration.

It follows the [dendritic pattern](https://github.com/mightyiam/dendritic):
every file under `modules/` is a [flake-parts](https://flake.parts) module,
loaded automatically by [import-tree](https://github.com/denful/import-tree).
Each one is a feature, not a host, and contributes to
`flake.modules.<class>.<name>`. Hosts are just lists of the features they
import.

## Hosts

| Host       | Platform        | What it is                                |
| ---------- | --------------- | ----------------------------------------- |
| `erebor`   | NixOS           | Desktop: Hyprland, NVIDIA, sddm           |
| `hobbiton` | NixOS           | Laptop: Hyprland, impermanence, greetd    |
| `work-mac` | macOS (aarch64) | MacBook, home-manager only                |

## Secrets

Secrets are encrypted with [ragenix](https://github.com/yaxitech/ragenix)
and live in the private `nix-secrets` repo, which is pulled in as the `secrets`
flake input. Modules reference them as `${inputs.secrets}/<name>.age`. Each
host decrypts them at activation using its SSH host key.

`ci/stub-secrets` has placeholder files with the same names, so the flake can
be checked without access to the private repo:

```sh
nix flake check --override-input secrets path:./ci/stub-secrets
```

## Usage

```sh
just os        # nixos-rebuild switch for this host
just hm        # home-manager switch for this user@host
just check     # nix flake check
```

`flake.nix` is generated; edit inputs in modules and run `just write-flake`.

## Principles

* *Sticky config*: a feature and everything it needs live in one file. Delete
  `walker.nix` and the launcher, its config and its persisted state go with it.
* *[Erase your darlings](https://grahamc.com/blog/erase-your-darlings/)*: any
  machine can be rebuilt from this repo at short notice, with nothing precious
  left behind.
* *Absolute navigation*: anything should be reachable from anywhere, without
  thinking "_how_". What matters is where something lives, not where it is
  relative to me.
* *Keep it simple, unless it's fun*: don't rebuild what already exists. Unless
  rebuilding it sounds fun, in which case, carry on.

_(these are ideals, not promises)_
