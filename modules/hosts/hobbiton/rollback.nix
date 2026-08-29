{
  flake.modules.nixos."nixosConfigurations/hobbiton" = {
    boot.initrd.systemd.services.rollback = {
      description = "Rollback BTRFS root subvolume to blank";
      wantedBy = ["initrd.target"];
      after = ["systemd-cryptsetup@crypted.service"];
      before = ["sysroot.mount"];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = ''
        # Mount the raw btrfs filesystem (not any subvolume) so we can manipulate subvolumes directly
        mkdir /btrfs_tmp
        mount /dev/mapper/crypted /btrfs_tmp

        # If a root subvolume exists from a previous boot, stamp it with a timestamp and archive it
        if [[ -e /btrfs_tmp/root ]]; then
            mkdir -p /btrfs_tmp/old_roots
            timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
            mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
        fi

        # Delete any archived roots older than 30 days, including any nested subvolumes inside them
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

        # Create a fresh empty root subvolume for this boot
        btrfs subvolume create /btrfs_tmp/root
        umount /btrfs_tmp
      '';
    };
  };
}
