{
  flake.modules.nixos."nixosConfigurations/bree" = {inputs, ...}: {
    imports = [inputs.disko.nixosModules.disko];

    disko.devices.disk.main = {
      device = "/dev/disk/by-id/nvme-WD_BLACK_SN750_SE_NVMe_1TB_2123GG447114";
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
          root = {
            size = "100%";
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
                  swap.swapfile.size = "8G";
                };
              };
            };
          };
        };
      };
    };

    # Media HDD (WDC WD102KRYZ, ext4 on the whole disk) carried over from the Proxmox VM.
    # Deliberately kept out of disko so an install can never format it.
    fileSystems."/mnt/bigboy" = {
      device = "/dev/disk/by-uuid/0212f77c-4e07-4d9f-ab62-f72bb8f3e91b";
      fsType = "ext4";
      options = ["nofail" "noatime"];
    };
  };
}
