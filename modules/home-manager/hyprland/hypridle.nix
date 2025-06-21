{
  pkgs,
  config,
  inputs,
  lib,
  ...
}: {
  home = {
    packages = with pkgs; [
      hypridle
    ];

    file."${config.xdg.configHome}/hypr/hypridle.conf" = {
      text = ''
        general {
            lock_cmd = pidof hyprlock || hyprlock
            before_sleep_cmd = pidof hyprlock || hyprlock
            after_sleep_cmd = hyprctl dispatch dpms on
        }

        # Lock the screen
        listener {
            timeout = 300
            on-timeout = pidof hyprlock || hyprlock
        }

        # Turn off screen
        listener {
            timeout = 420
            on-timeout = hyprctl dispatch dpms off
            on-resume = hyprctl dispatch dpms on
        }

        # Suspend the system
        listener {
            timeout = 600
            on-timeout = systemctl suspend
        }
      '';
    };
  };

  systemd.user.services = lib.mkForce {
    hypridle = {
      Install = {
        WantedBy = ["graphical-session.target"];
      };

      Unit = {
        Description = "Auto screen lock and power down for Hyprland";
        Documentation = ["https://github.com/hyprwm/hypridle"];
        After = ["graphical-session.target"];
      };

      Service = {
        Type = "exec";
        ExecStart = "${pkgs.hypridle}/bin/hypridle";
        ExecCondition = "${pkgs.systemd}/lib/systemd/systemd-xdg-autostart-condition \"Hyprland\" \"\" ";
        Restart = "on-failure";
        Slice = "background-graphical.slice";
      };
    };
  };
}
