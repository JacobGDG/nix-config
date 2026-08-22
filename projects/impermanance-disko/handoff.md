# Handoff: Disko + Impermanence for jake-laptop-nixos

## Focus for next session

Implement the disko disk layout + btrfs impermanence setup directly in the repo at `/home/jake/worktrees/nix-config/main`.

---

## What was discussed

The user wants declarative disk management (disko) for their `jake-laptop-nixos` NixOS host, with the end goal of **impermanence** — the machine wipes `/` on every boot and only keeps what is explicitly declared as persistent.

### Design decisions made

| Decision | Choice | Reason |
|---|---|---|
| Filesystem | btrfs with subvolumes | Subvolume management, CoW, compression |
| Encryption | LUKS (password at boot) | Laptop — physical theft risk |
| Swap | btrfs swapfile in `/.swapvol` | Keeps everything inside the LUKS container |
| Hibernation | Yes | Swapfile must be >= RAM size; requires post-install `resume_offset` step |
| Impermanence mechanism | Archive approach — move old root, create fresh subvolume | No bootstrap state needed; purely declarative; old roots kept 30 days for recovery |
| `/home` persistence | Impermanent — wiped with root, no dedicated subvolume | Avoid drift in home dir; persist only what is explicitly declared |

### Why archive approach over rollback-to-blank-snapshot

The rollback approach requires a `root-blank` snapshot to exist before the first boot. That snapshot must be created between disk formatting and the first nixos-install activation — a gap that doesn't exist cleanly with `disko-install`. Any workaround (manual split steps or activation script) involves an imperative command outside the config.

The archive approach has no bootstrap state. The initrd script on every boot:
1. Moves the old root to `old_roots/<timestamp>`
2. Creates a fresh empty subvolume as the new root

No snapshot, no one-time imperative step, works correctly from the very first boot. Old roots are cleaned up after 30 days automatically by the same script.

### Subvolume layout (final)

```
/root    → /              compress=zstd noatime  (wiped every boot — archived, not deleted; home lives here)
/nix     → /nix           compress=zstd noatime  (persistent, reproducible)
/persist → /persist       compress=zstd noatime  (persistent, declared state)
/swap    → /.swapvol      (swapfile for swap + hibernation)
```

`old_roots/` lives at the top level of the btrfs pool (not declared in disko — created at runtime by the initrd script). It holds timestamped archived root subvolumes and their children.

### LUKS config

- Device mapper name: `crypted`
- `allowDiscards = true` — TRIM passthrough for NVMe performance
- Passphrase only (no keyfile) — interactive prompt at boot
- Disko generates `boot.initrd.luks.devices.crypted` — classic initrd, compatible with `postResumeCommands`

### initrd compatibility note

`boot.initrd.postResumeCommands` requires the **classic** initrd. Do not enable `boot.initrd.systemd.enable = true` on this host — it would break the impermanence script. Disko's LUKS setup (`boot.initrd.luks.devices`) uses classic initrd by default, so there is no conflict.

`postResumeCommands` runs after the hibernation resume check on every boot. On a hibernate resume the kernel jumps directly to the suspended image and `postResumeCommands` never executes — meaning root is preserved across hibernation as expected.

---

## Repo structure (key facts)

- Path: `/home/jake/worktrees/nix-config/main`
- `flake.nix` is **auto-generated** — do not edit directly. Run `nix run .#write-flake` after adding inputs.
- Inputs are declared via `flake-file.inputs.<name>` in any module. See `modules/development/bark.nix` for an example of how to add an input this way.
- `import-tree` auto-imports all `.nix` files under `modules/` — no manual import wiring needed for new files.
- Host files live at `modules/hosts/jake-laptop-nixos/`: `default.nix`, `hardware-configuration.nix`, `users.nix`

---

## Files to create / modify

### Create: `modules/hosts/jake-laptop-nixos/disko.nix`

Declares the `disko` flake input and the full disk layout. Template:

```nix
{
  flake-file.inputs.disko = {
    url = "github:nix-community/disko";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.nixos."nixosConfigurations/jake-laptop-nixos" = {inputs, ...}: {
    imports = [inputs.disko.nixosModules.disko];

    disko.devices.disk.main = {
      device = "/dev/disk/by-id/nvme-SAMSUNG_MZALQ512HALU-000L2_S4UKNF0NB85601";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            priority = 1;
            type = "EF00";
            size = "512M";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = ["umask=0077"];
            };
          };
          luks = {
            size = "100%";
            content = {
              type = "luks";
              name = "crypted";
              settings.allowDiscards = true;
              content = {
                type = "btrfs";
                extraArgs = ["-f"];
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                  "/persist" = {
                    mountpoint = "/persist";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                  "/swap" = {
                    mountpoint = "/.swapvol";
                    swap.swapfile.size = "16G"; # must be >= RAM
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
```

### Create: `modules/hosts/jake-laptop-nixos/impermanence.nix`

Declares the impermanence input, the archive initrd script, and persistence declarations.

Key points:
- Device is `/dev/mapper/crypted` (our LUKS name), not the LVM path from the upstream example
- `neededForBoot = true` on `/persist` is required — disko won't set it automatically, and the impermanence bind mounts depend on `/persist` being available early
- `lib` must be in the module args for `lib.mkAfter`
- `fileSystems` declarations from the upstream example are **not** copied — disko owns those

```nix
{lib, ...}: {
  flake-file.inputs.impermanence.url = "github:nix-community/impermanence";

  flake.modules.nixos."nixosConfigurations/jake-laptop-nixos" = {inputs, ...}: {
    imports = [inputs.impermanence.nixosModules.impermanence];

    fileSystems."/persist".neededForBoot = true;

    boot.initrd.postResumeCommands = lib.mkAfter ''
      mkdir /btrfs_tmp
      mount /dev/mapper/crypted /btrfs_tmp
      if [[ -e /btrfs_tmp/root ]]; then
          mkdir -p /btrfs_tmp/old_roots
          timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
          mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
      fi

      delete_subvolume_recursively() {
          IFS=$'\n'
          for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
              delete_subvolume_recursively "/btrfs_tmp/$i"
          done
          btrfs subvolume delete "$1"
      }

      for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
          delete_subvolume_recursively "$i"
      done

      btrfs subvolume create /btrfs_tmp/root
      umount /btrfs_tmp
    '';

    environment.persistence."/persist" = {
      hideMounts = true;
      directories = [
        "/var/log"
        "/var/lib/bluetooth"
        "/var/lib/nixos"
        "/etc/NetworkManager/system-connections"
      ];
      files = [
        "/etc/machine-id"
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_ed25519_key"
      ];
    };
  };
}
```

### Modify: `modules/hosts/jake-laptop-nixos/hardware-configuration.nix`

Remove the three blocks that disko now owns (disko auto-generates `fileSystems` and `swapDevices`):

```diff
-    fileSystems."/" = { ... };
-    fileSystems."/boot" = { ... };
-    swapDevices = [ ... ];
```

Keep everything else: `boot.*`, `networking.useDHCP`, `nixpkgs.hostPlatform`, `hardware.*`.

---

## After creating files

```bash
nix run .#write-flake
```

This regenerates `flake.nix` with the new `disko` and `impermanence` inputs.

---

## Testing disko before install

Before touching any real disk, verify the partition/subvolume layout by building the disko formatting script:

```bash
nix build .#nixosConfigurations.jake-laptop-nixos.config.system.build.diskoScript
cat result
```

This produces a shell script showing exactly what disko will do — partition table, LUKS setup, btrfs subvolumes, mount options. Read it carefully and confirm it matches the expected layout before proceeding to install.

Disko also has a VM test mode that runs the formatting in a throwaway VM:

```bash
nix run 'github:nix-community/disko#disko' -- \
  --mode dryrun \
  --flake .#jake-laptop-nixos
```

---

## Install-time steps (not in the config, done manually)

Use `disko-install` — it combines disk formatting and NixOS installation into one tool. The `--disk` flag maps the disk name from the disko config (`main`) to the actual device at install time.

### Phase 1: disko only (no impermanence yet)

Install without `impermanence.nix` active. Get the machine booting and stable first, then add impermanence once confident. Low risk — fresh install means no accumulated state to lose, and `old_roots/` gives 30-day recovery anyway.

1. Boot NixOS installer
2. Run disko-install:
   ```bash
   sudo nix run 'github:nix-community/disko#disko-install' -- \
     --flake .#jake-laptop-nixos \
     --disk main /dev/disk/by-id/nvme-SAMSUNG_MZALQ512HALU-000L2_S4UKNF0NB85601
   ```
3. **LUKS passphrase**: disko-install will prompt interactively during `cryptsetup luksFormat`. This passphrase is stored in the LUKS header on disk — it is not in the NixOS config. Choose it carefully; there is no recovery if forgotten.
4. After first successful boot, back up the LUKS header:
   ```bash
   cryptsetup luksHeaderBackup /dev/disk/by-partlabel/disk-main-luks \
     --header-backup-file luks-header-backup.img
   ```
   Store this somewhere safe (not on the encrypted disk). Header corruption is rare but unrecoverable without it.

### Phase 2: add impermanence

The archive approach requires no additional steps after installation. On first boot the initrd script finds no existing root subvolume (the `if [[ -e /btrfs_tmp/root ]]` guard handles this gracefully) and creates a fresh one.

---

## Testing impermanence after install

Before relying on the machine daily, validate the full impermanence cycle:

1. **Test a clean reboot** — reboot and confirm the system comes up cleanly. Check that persisted state (NetworkManager connections, bluetooth, machine-id) survives.

2. **Test the archive mechanism** — create a file in a non-persisted location (e.g. `/tmp/test` or a file directly in `/`), reboot, confirm it is gone from the live root and present in `/btrfs_tmp/old_roots/<timestamp>/` (mount the raw pool to check: `mount /dev/mapper/crypted /btrfs_tmp`).

3. **Test recovery** — simulate the zen browser scenario: create `~/.zen/` with a dummy file, reboot without adding it to persistence, confirm it is gone, then recover it from `old_roots`:
   ```bash
   mount /dev/mapper/crypted /btrfs_tmp
   ls /btrfs_tmp/old_roots/
   # copy what you need back out
   ```

4. **Test hibernation** — hibernate and resume. Confirm root is NOT wiped on resume (the `postResumeCommands` guard means the wipe only runs on a cold boot, not a hibernate resume).

5. **Validate persistence declarations are complete** — run the machine normally for a day before committing to it. Watch for services that fail on reboot due to missing state in `/persist`. Common gaps: NetworkManager connections, bluetooth pairings, SSH host keys.

**Adding impermanence is a one-way door for accumulated state.** The first boot after activating `impermanence.nix` archives the existing root and starts fresh. Anything not declared in `/persist`, `/home`, or `/nix` will not be in the live root. Recover from `old_roots/` within 30 days if needed.

---

## Hibernation (post-install, first boot)

btrfs swapfiles require a physical offset for the kernel resume param:

```bash
sudo btrfs inspect-internal map-swapfile -r /.swapvol/swapfile
```

Then add to the host config:

```nix
boot.resumeDevice = "/dev/mapper/crypted";
boot.kernelParams = ["resume_offset=<value>"];
```

---

## Co-locating persistence declarations with the module that needs them

The goal is to keep persistence declarations next to the module that requires them (e.g. bark's `worktrees` declared in `bark.nix`), so removing a module removes its persistence config too.

### Pattern: NixOS module named `impermanence` inside a home-manager module file

A file like `bark.nix` can contain both a home-manager module AND a NixOS module that declares the persistence footprint. The NixOS module is named `impermanence` (not `bark`) to reflect what is actually being configured:

```nix
{
  flake.modules.nixos.impermanence = {config, lib, ...}: {
    environment.persistence."/persist" = {
      users = lib.mapAttrs (_: _: {
        directories = ["worktrees"];
      }) (lib.filterAttrs (_: u: u.isNormalUser) config.users.users);
    };
  };

  flake.modules.homeManager.bark = {inputs, ...}: {
    imports = [inputs.bark.homeManagerModules.default];
    programs.bark.enable = true;
  };
}
```

### Why `isNormalUser` rather than targeting specific users

Apply user-level persistence to all normal users via `lib.filterAttrs (_: u: u.isNormalUser) config.users.users`. For a single-user personal machine this is equivalent to targeting jake specifically, without hardcoding the username. Dynamic per-module user attribution is out of scope.

---

## Open questions

- **`/persist` directory pre-population**: Services like NetworkManager and bluetooth need their state directories to exist in `/persist` before first boot. May need `systemd.tmpfiles.rules` entries.
- **Swapfile size**: Confirmed. Machine has ~7GB RAM, 16G swapfile is sufficient for hibernation.

---

## Existing plan file

`/home/jake/.claude/plans/https-github-com-nix-community-disko-glistening-lark.md` — written before the impermanence design was added. The plan in this handoff supersedes it.

## Reference repos

- disko: `~/.cache/ref-repos/nix-community/disko` (already cloned)
- impermanence: not yet cloned — use `/clone-repo https://github.com/nix-community/impermanence` if needed

---

## Suggested skills

- **`/clone-repo https://github.com/nix-community/impermanence`** — if the impermanence module options need reading before writing `impermanence.nix`
- **`/code-review`** — after writing the files, to check correctness before committing
