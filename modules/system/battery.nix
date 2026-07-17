{
  flake.modules.nixos.battery = {
    powerManagement.powertop.enable = true;
    services.thermald.enable = true;
    services.tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 20;

        START_CHARGE_THRESH_BAT1 = 40;
        STOP_CHARGE_THRESH_BAT1 = 80;
      };
    };
  };

  flake.modules.homeManager.battery = {pkgs, ...}: let
    battery-warning-daemon = pkgs.writeShellApplication {
      name = "battery-warning-daemon";
      runtimeInputs = with pkgs; [
        libnotify
      ];
      text = ''
        app_name="battery-warning-daemon"
        notification_timeout=5000
        sleep_when_low=240
        sleep_normal=120
        battery_capacity_file=/sys/class/power_supply/BAT1/capacity
        charging_status_file=/sys/class/power_supply/BAT1/status

        if [ ! -f $battery_capacity_file ]; then
          notify-send -a $app_name -t $notification_timeout "
          Failed to read battery capacity. Cannot warn of low battery.

        Could not read $battery_capacity_file
          "
          exit 1
        fi

        while true; do
          read -r battery < "$battery_capacity_file"
          read -r status < "$charging_status_file"

          echo "status: $status, $battery%"

          if (( battery <= 20 )) && [ "$status" = "Discharging" ]; then
            notify-send -a $app_name -t $notification_timeout -u critical "  Low battery: $battery%"
            sleep $sleep_when_low
          else
            sleep $sleep_normal
          fi
        done
      '';
    };
  in {
    home.packages = [battery-warning-daemon];

    systemd.user.services.battery-warning-daemon = {
      Install.WantedBy = ["default.target"];

      Unit = {
        Description = "Daemon warning about low battery";
        After = ["default.target"];
      };

      Service = {
        Type = "exec";
        ExecStart = "${battery-warning-daemon}/bin/battery-warning-daemon";
        Restart = "on-failure";
      };
    };
  };
}
