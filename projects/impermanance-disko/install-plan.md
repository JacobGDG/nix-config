# hobbiton Install Plan
## NixOS + disko + LUKS + btrfs

This document is the complete step-by-step guide from blank laptop to booted system.
Work through it top to bottom. Each section notes what machine you are on.

---

## Pre-flight checklist

- [ ] Laptop is plugged into power
- [ ] A blank USB stick (≥ 4 GB) for the NixOS installer
- [ ] A second USB stick (≥ 1 GB) for the config + SSH key
- [ ] The LUKS passphrase chosen and memorised — **you cannot recover the disk without it**
- [ ] Internet access at install time (ethernet preferred; wifi steps included below)

---

## Stage 1 — Prepare install media (current machine)

### 1.1 Download the NixOS minimal ISO

Go to https://nixos.org/download and grab the **Minimal ISO** for x86_64-linux.
Minimal is preferred — no GUI overhead, more RAM available.

Verify the hash:
```bash
sha256sum nixos-minimal-*.iso
# compare against the hash shown on the download page
```

### 1.2 Write the ISO to the installer USB

Find the USB device (do NOT confuse it with your internal disk):
```bash
lsblk
# Identify the USB stick — e.g. /dev/sdb
```

Write it:
```bash
sudo dd if=nixos-minimal-*.iso of=/dev/sdX bs=4M status=progress conv=fsync
# replace /dev/sdX with the actual device — not a partition (sdb, not sdb1)
```

Wait for the prompt to return, then eject.

### 1.3 Prepare the config USB stick

This stick carries the nix-config repo and your SSH private key.

Find the stick's device (do NOT confuse it with your internal disk or the installer USB):
```bash
lsblk
# Identify the config stick — e.g. /dev/sda
```

Wipe any existing signatures (ISO, filesystem, old partition table) then repartition interactively:
```bash
sudo wipefs -a /dev/sda
sudo cfdisk /dev/sda
```

Inside cfdisk:
1. If prompted for a label type, select **gpt**
2. Select the free space and choose **[ New ]**
3. Accept the default size (full disk)
4. Choose **[ Write ]** — type `yes` to confirm
5. Choose **[ Quit ]**

```bash
# Wait for the kernel to see the new partition
sudo partprobe /dev/sda
```

Format — the stick will auto-mount at `/run/media/jake/jakes_stick` once formatted:
```bash
sudo mkfs.ext4 -L jakes_stick /dev/sda1
```

Replug the stick to trigger auto-mount, then fix ownership so your user can write to it:
```bash
sudo chown $USER /run/media/jake/jakes_stick
```

Then copy the repo and SSH key:
```bash
# Copy the repo — use git archive to get a clean tracked-only copy
git -C /home/jake/worktrees/nix-config/main archive HEAD \
  | sudo tar -x -C /run/media/jake/jakes_stick --one-top-level=nix-config

# Copy your SSH private key (needed for private flake inputs: bark, neovim)
cp ~/.ssh/id_ed25519 /run/media/jake/jakes_stick/
cp ~/.ssh/id_ed25519.pub /run/media/jake/jakes_stick/
```

### 1.4 Pre-fetch the system closure (while on fast ethernet)

Build the full hobbiton system closure and export it to the USB stick as a binary cache.
The binary cache format stores NARs as plain compressed files alongside the real nix store,
so the installer can copy directly to the disk store without downloading anything.

```bash
# Build the system closure (this may take a while on first run)
TOPLEVEL=$(nix build \
  /home/jake/worktrees/nix-config/main#nixosConfigurations.hobbiton.config.system.build.toplevel \
  --no-link --print-out-paths 2>/dev/null)

echo "Toplevel: $TOPLEVEL"
# Note this path — you will need it on the installer

# Also cache the disko tool itself
DISKO=$(nix build github:nix-community/disko#disko --no-link --print-out-paths 2>/dev/null)

# Export both closures to the USB as a binary cache
nix copy --to "file:///run/media/jake/jakes_stick/nixcache" $TOPLEVEL $DISKO
```

Eject the stick safely via your file manager before unplugging.

The `nixcache/` directory on the stick will contain `.narinfo` and `nar/` files for every
store path in the closure. On a typical NixOS system this is several gigabytes.

---

## Stage 2 — Boot the installer

### 2.1 Boot from the installer USB

Enter the BIOS/UEFI boot menu (usually F2, F12, or Delete at POST).
Select the NixOS installer USB.

You will land at a root shell.

### 2.2 Connect to the internet

**Ethernet** — should work automatically. Test with:
```bash
ping -c 3 1.1.1.1
```

**Wi-Fi** — use `wpa_supplicant` or `nmcli`:
```bash
# List available networks
nmcli device wifi list

# Connect
nmcli device wifi connect "SSID" password "passphrase"
```

### 2.3 (Optional) SSH in from your desk

Working remotely is more comfortable than typing on the installer console.

```bash
# On the installer:
passwd nixos               # set a temporary password
systemctl start sshd
ip a                       # note the IP address
```

Then from your desk:
```bash
ssh nixos@<installer-ip>
```

---

## Stage 3 — Set up the live environment

All following commands run on the **installer**, as root (or with sudo).

### 3.1 Mount the config stick

Mount it once and leave it mounted — it is needed for the nix cache during disko and install,
and again for the LUKS backup at the end.

```bash
mkdir -p /tmp/jakes_stick
mount /dev/sdb1 /tmp/jakes_stick
# Note: mount here, NOT under /mnt — disko will mount btrfs at /mnt and hide anything underneath it
```

Copy the config:
```bash
cp -r /tmp/jakes_stick/nix-config /tmp/nix-config
```

### 3.2 Load the SSH key

Required — disko evaluates the full NixOS config to extract the disk layout, which fetches
the private flake inputs (`neovim`, `bark`) over SSH. Without the key this fails before
any formatting happens.

```bash
mkdir -p ~/.ssh
cp /tmp/jakes_stick/id_ed25519 ~/.ssh/
chmod 600 ~/.ssh/id_ed25519
eval $(ssh-agent -s)
ssh-add ~/.ssh/id_ed25519
```

---

## Stage 4 — Format the disk

**This is destructive. All existing data on the NVMe will be wiped.**

### 4.1 Confirm the target device

```bash
ls /dev/disk/by-id/ | grep SAMSUNG
# Should show: nvme-SAMSUNG_MZALQ512HALU-000L2_S4UKNF0NB85601
```

If the device ID does not match what is in `disko.nix`, stop here and update the config.

### 4.2 Run disko

This partitions the disk, formats, creates LUKS, creates btrfs subvolumes, and mounts everything to `/mnt`.
It does **not** touch `/nix` on the live system.

```bash
sudo -E nix \
  --extra-experimental-features "nix-command flakes" \
  --extra-substituters "file:///tmp/jakes_stick/nixcache" \
  run github:nix-community/disko -- \
  --mode disko \
  --flake /tmp/nix-config#hobbiton
```

**You will be prompted for a LUKS passphrase twice.**
This passphrase encrypts the entire disk. It is stored in the LUKS header on disk only — it is not in the config. If you forget it, the data is unrecoverable. Choose carefully.

### 4.3 Verify mounts

```bash
mount | grep /mnt
```

Expected output (order may vary):
```
/dev/mapper/crypted on /mnt type btrfs (subvol=/root ...)
/dev/mapper/crypted on /mnt/nix type btrfs (subvol=/nix ...)
/dev/mapper/crypted on /mnt/persist type btrfs (subvol=/persist ...)
/dev/mapper/crypted on /mnt/.swapvol type btrfs (subvol=/swap ...)
/dev/disk/by-partlabel/disk-main-ESP on /mnt/boot type vfat ...
```

If any are missing, do not proceed. Check `dmesg` and `lsblk` for errors.

---

## Stage 5 — Install NixOS

### 5.1 Import the pre-fetched closure from the USB stick

This loads all store paths directly from the USB into `/mnt/nix/store`, so nixos-install
has nothing to download.

```bash
# Import the closure into the disk store
# Replace the path below with the toplevel noted in stage 1.4
sudo nix \
  --extra-experimental-features "nix-command" \
  copy \
  --no-check-sigs \
  --from "file:///tmp/jakes_stick/nixcache" \
  --to "local:///mnt" \
  /nix/store/<hash>-nixos-system-hobbiton-*
```

### 5.2 Run nixos-install with disk-backed store

The `--store /mnt` flag directs nix to build into `/mnt/nix/store` (on disk) rather than `/nix/store` (RAM). This is what prevents RAM exhaustion on a low-memory machine.
Because the closure is already in `/mnt/nix/store` from the previous step, this should complete almost instantly with no downloads.

**Do NOT mount anything over `/nix` — that breaks all live system tools.**

```bash
sudo -E nixos-install \
  --root /mnt \
  --flake /tmp/nix-config#hobbiton
```

Watch for errors. If it fails partway through, it is safe to re-run.

### 5.2 Set the root password (if not using `--no-root-passwd`)

If you omitted `--no-root-passwd`, nixos-install will prompt for a root password.
Set something temporary — you can change it after first boot.

---

## Stage 6 — Backup the LUKS header

**Do this before rebooting.** Header corruption is rare but completely unrecoverable without a backup.

```bash
sudo cryptsetup luksHeaderBackup /dev/disk/by-partlabel/disk-main-luks \
  --header-backup-file /tmp/jakes_stick/luks-hobbiton-header.img

umount /tmp/jakes_stick
```

Take the config stick off-site or store it separately from the laptop.

---

## Stage 7 — First boot

```bash
sudo reboot
```

Remove the installer USB when prompted (or immediately — the bootloader will be on the NVMe now).

**Expected boot sequence:**
1. GRUB / systemd-boot menu appears
2. You are prompted for the LUKS passphrase
3. System boots to login prompt

If the machine hangs or drops to an initrd shell, the most common causes are:
- Wrong LUKS device path — check `ls /dev/disk/by-partlabel/`
- Missing `boot.initrd.availableKernelModules` for the NVMe controller

---

## Stage 8 — Post-install: configure hibernation

btrfs swapfiles require a physical offset for the kernel to find the resume location.
Run this **after the first successful boot**, on the installed system:

```bash
sudo btrfs inspect-internal map-swapfile -r /.swapvol/swapfile
# outputs a number, e.g. 533760
```

Add to `modules/hosts/hobbiton/hardware-configuration.nix`:
```nix
boot.resumeDevice = "/dev/mapper/crypted";
boot.kernelParams = ["resume_offset=<value>"];
```

Rebuild and switch:
```bash
sudo nixos-rebuild switch --flake .#hobbiton
```

Test hibernation:
```bash
systemctl hibernate
# resume and confirm root is NOT wiped (impermanence not active yet)
```

---

## Stage 9 — Add impermanence (separate session)

Once the machine is stable and you have used it for at least a day:

1. Create `modules/hosts/hobbiton/impermanence.nix` (template in `handoff.md`)
2. Review the `environment.persistence."/persist"` declarations — add anything you have discovered is missing
3. `git add` the file, run `nix run .#write-flake`, rebuild
4. Reboot — the initrd script will archive the existing root and create a fresh one
5. Follow the impermanence validation checklist in `handoff.md`

**Adding impermanence is a one-way door for accumulated state.**
The first boot after enabling it archives the existing root. Recover from `old_roots/` within 30 days if needed.

---

## Quick reference: recovery

### Unlock and mount from live USB to recover files
```bash
cryptsetup open /dev/disk/by-partlabel/disk-main-luks crypted
mount /dev/mapper/crypted /mnt -o subvol=/root
# or any other subvol: /nix, /persist, /old_roots/<timestamp>
```

### Restore LUKS header from backup
```bash
sudo cryptsetup luksHeaderRestore /dev/disk/by-partlabel/disk-main-luks \
  --header-backup-file luks-hobbiton-header.img
```
