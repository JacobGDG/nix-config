{pkgs, ...}: {
  home.packages = [
    (pkgs.writeShellScriptBin "battery-warning-daemon" ''
      #!/bin/bash

      notification_timeout=5000 # in milliseconds
      sleep_when_low=240 # in seconds
      sleep_normal=120 # in seconds
      battery_capacity_file=/sys/class/power_supply/BAT1/capacity
      charging_status_file=/sys/class/power_supply/BAT1/status

      if [ ! -f $battery_capacity_file ]; then
        notify-send -t $notification_timeout "
        Failed to read battery capacity. Cannot warn of low battery.

      Could not read $battery_capacity_file
      "
        exit 1
      fi

      while true; do
        battery=$(cat $battery_capacity_file)
        status=$(cat $charging_status_file)
        if [ "$battery" -le "20" ] && [ "$status" = "Discharging" ]; then
          notify-send -t $notification_timeout -u critical "  Low battery: $battery%"
          sleep $sleep_when_low
        else
          sleep $sleep_normal
        fi
      done
    '')
  ];
}
