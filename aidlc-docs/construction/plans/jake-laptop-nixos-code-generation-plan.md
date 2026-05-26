# Code Generation Plan - jake-laptop-nixos Host Import

## Unit Context
- **Unit**: jake-laptop-nixos host import (single unit)
- **Dependencies**: Existing modules (hyprland, firefox, steam, etc.), core infrastructure
- **Workspace Root**: /home/jake/src/nix-config/dendritic-flake-parts

## Generation Steps

### Step 1: Create battery module
- [x] Create `modules/system/battery.nix`
- [x] `flake.modules.nixos.battery`: TLP (performance/powersave governors, charge thresholds 40-80%), thermald, powertop
- [x] `flake.modules.homeManager.battery`: battery-warning-daemon systemd user service (monitors BAT1, notifies at <=20% via libnotify)
- [x] Follow nvidia.nix pattern for module structure

### Step 2: Create shared host packages module
- [x] Create `modules/core/packages.nix`
- [x] Add shared linux host packages to `flake.modules.homeManager.core`: wl-clipboard, sshfs, bc, unzip, ruby, nerd-fonts.jetbrains-mono
- [x] These are host-level utilities shared across all hosts

### Step 3: Create host definition
- [x] Create `modules/hosts/jake-laptop-nixos/default.nix`
- [x] `nixosHosts.jake-laptop-nixos = { system = "x86_64-linux"; }`
- [x] NixOS module imports: hyprland, firefox, steam, battery
- [x] HM module imports: hyprland, waybar, dunst, hypridle, hyprlock, hyprpaper, wlogout, wofi, terminal, firefox, aiAgents, devops, spotifyPlayer, cava, mpv, battery
- [x] Host-specific HM packages: btop
- [x] `networking.hostName = "jake-laptop-nixos"`
- [x] `system.stateVersion = "24.05"`

### Step 4: Create hardware configuration
- [x] Create `modules/hosts/jake-laptop-nixos/hardware-configuration.nix`
- [x] Convert source hardware-configuration.nix to flake-parts pattern (`flake.modules.nixos."nixosConfigurations/jake-laptop-nixos"`)
- [x] AMD laptop: nvme, xhci_pci, usb_storage, sd_mod, sdhci_pci kernel modules
- [x] kvm-amd kernel module, systemd-boot, EXT4 root, VFAT boot, swap
- [x] Bluetooth enabled, AMD microcode updates

### Step 5: Create users configuration
- [x] Create `modules/hosts/jake-laptop-nixos/users.nix`
- [x] `flake.modules.nixos."nixosConfigurations/jake-laptop-nixos"` with jake user
- [x] initialPassword: "correcthorsebatterystaple" (matching source)
- [x] Groups: wheel, networkmanager
- [x] useDefaultShell: true

### Step 6: Update jake.nix
- [x] Add user-specific packages to `flake.modules.homeManager.jake`: blender, prismlauncher, mumble, discord, rpi-imager, spotify
- [x] Add `flake.modules.homeManager."jake@jake-laptop-nixos"` with `home.stateVersion = lib.mkOverride 999 "24.05"` (override core default of 25.05)

### Step 7: Update erebor host
- [x] Remove from `modules/hosts/erebor/default.nix` HM packages: wl-clipboard, sshfs, bc, unzip, ruby, nerd-fonts.jetbrains-mono (now in core/packages.nix)
- [x] Keep erebor-specific: btop-cuda
