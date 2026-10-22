{
  flake.modules.nixos."nixosConfigurations/hobbiton" = {pkgs, ...}: let
    # The Synaptics touchpad sometimes isn't ready when i2c_hid_acpi probes it
    # at boot ("Failed to fetch the HID Descriptor"), and nothing retries.
    # Reload the driver until the HID device shows up; systemd handles retries.
    # journalctl -k -b | grep MSFT0004
    fix-touchpad = pkgs.writeShellApplication {
      name = "fix-touchpad";
      runtimeInputs = with pkgs; [
        kmod
      ];
      text = ''
        shopt -s nullglob
        touchpad=/sys/bus/i2c/devices/i2c-MSFT0004:00

        touchpad_present() {
          local hid_devices=("$touchpad"/0018:*)
          (( ''${#hid_devices[@]} > 0 ))
        }

        if touchpad_present; then
          echo "touchpad present"
          exit 0
        fi

        # Fail so systemd restarts us; the next run checks whether this worked
        echo "touchpad missing, reloading i2c_hid_acpi"
        modprobe -r i2c_hid_acpi || true
        modprobe i2c_hid_acpi
        exit 1
      '';
    };
  in {
    systemd.services.fix-touchpad = {
      description = "Reload touchpad driver if it failed to probe";
      wantedBy = ["multi-user.target"];
      # Up to 5 attempts, then give up and leave the unit failed
      startLimitBurst = 5;
      startLimitIntervalSec = 60;
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${fix-touchpad}/bin/fix-touchpad";
        Restart = "on-failure";
        RestartSec = 2;
      };
    };
  };
}
