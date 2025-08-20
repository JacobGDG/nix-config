{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    # https://github.com/magveta/HyprlandGruvbox/tree/main/hypr/waybar
    style = ''
      * {
        border: none;
        border-radius: 5px;
        font-family: JetBrainsMono;
        font-size: 12px;
        min-height: 0;
      }

      window#waybar {
        background: #${config.colorScheme.palette.base00};
        color: #${config.colorScheme.palette.base05};
      }

      tooltip {
        background: #${config.colorScheme.palette.base00};
        border-radius: 10px;
        border-width: 2px;
        border-style: solid;
        border-color: #${config.colorScheme.palette.base01};
      }
      #workspaces button {
        padding: 0 0.6em;
        color: #${config.colorScheme.palette.base05};
        border-radius: 6px;
        margin-right: 2px;
        margin-left: 2px;
        margin-top: 2px;
        margin-bottom: 2px;
      }

      #workspaces button:hover,
      #workspaces button.active {
        color: #${config.colorScheme.palette.base05};
        background: #${config.colorScheme.palette.base0D};
      }

      #workspaces button.focused {
        color: #${config.colorScheme.palette.base05};
        background: #${config.colorScheme.palette.base01};
      }

      #workspaces button.urgent {
        color: #${config.colorScheme.palette.base00};
        background: #${config.colorScheme.palette.base08};
      }

      #battery,
      #cpu,
      #custom-gpu,
      #custom-power,
      #date,
      #memory,
      #network,
      #pulseaudio,
      #workspaces {
        color: #${config.colorScheme.palette.base05};
        background: #${config.colorScheme.palette.base01};
      }

      #pulseaudio {
        margin-right: 6px;
      }

      #clock {
        margin-right: 6px;
      }

      #custom-power {
        color: #${config.colorScheme.palette.base08};
      }

      #cpu.critical,
      #memory.critical,
      #battery.critical,
      #battery.urgent {
          background-color: #${config.colorScheme.palette.base02};
          border: 2px solid #${config.colorScheme.palette.base08};
          color: #${config.colorScheme.palette.base08};
      }

      #battery.warning {
        border: 2px solid #${config.colorScheme.palette.base09};
        color: #${config.colorScheme.palette.base09};
      }

      #battery.charging.critical,
      #battery.charging.warning {
        border: 2px solid #${config.colorScheme.palette.base0B};
        color: #${config.colorScheme.palette.base0B};
      }
    '';

    settings = [
      {
        height = 30;
        layer = "top";
        position = "top";
        spacing = 10;
        modules-center = [
          "clock"
        ];
        modules-left = [
          "hyprland/workspaces"
          "idle_inhibitor"
        ];
        modules-right = builtins.filter (x: x != null) [
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          (
            if config.myModules.common.desktop
            then "custom/gpu"
            else "battery"
          )
          "custom/power"
        ];
        battery = {
          format = " {capacity}% {icon} ";
          format-alt = " {time} {icon} ";
          format-charging = " {capacity}% 󱟠 ";
          format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰂀" "󰂂" "󰁹"];
          format-plugged = " {capacity}%  ";
          states = {
            critical = 10;
            warning = 20;
          };
        };
        clock = {
          format-alt = " {:%Y-%m-%d} ";
          tooltip-format = "{:%Y-%m-%d | %H:%M}";
        };
        cpu = {
          format = " {usage}%    ";
          tooltip = false;
        };
        memory = {format = " {}%  ";};
        network = {
          interval = 1;
          tooltip = false;
          format-alt = " {ifname}: {ipaddr}/{cidr}";
          format-disconnected = "Disconnected ⚠";
          format-ethernet = " 󰈁 up: {bandwidthUpBits} down: {bandwidthDownBits}";
          format-linked = " {ifname} (No IP) ";
          format-wifi = " {essid} ({signalStrength}%)  ";
        };
        pulseaudio = {
          format = " {volume}% {icon} | {format_source}";
          format-bluetooth = "{volume}% {icon} | {format_source}";
          format-bluetooth-muted = " {icon} | {format_source}";
          format-muted = " 󰖁 | {format_source}";
          format-icons = {
            car = " ";
            default = [" " " " " "];
            headphones = " ";
            phone = " ";
            portable = " ";
            "alsa_output.pci-0000_04_00.6.HiFi__Speaker__sink" = "󰌢 ";
            "bluez_output.88_C9_E8_24_52_61.1" = "󱡏 ";
          };
          format-source = " ";
          format-source-muted = " ";
          on-click = "pavucontrol";
        };
        "custom/power" = {
          format = " ⏻ ";
          tooltip = false;
          on-click = "wlogout --protocol layer-shell";
        };
        "custom/gpu" = {
          format = " {}% {icon}";
          exec = "nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits";
          format-icons = "󰢮 ";
          interval = 1;
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = " ";
            deactivated = " ";
          };
        };
        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            "1" = " ";
            "2" = "󰖟 ";
            "3" = "󱃷 ";
            "9" = " ";
            "10" = "󰊴 ";
          };
          on-click = "hyprctl dispatch workspace";
        };
      }
    ];
  };

  systemd.user.services = lib.mkForce {
    waybar = {
      Install = {
        WantedBy = ["graphical-session.target"];
      };

      Unit = {
        Description = "Waybar Service started thru UWSM";
        Documentation = ["man:waybar(1)"];
        After = ["graphical-session.target"];
      };

      Service = {
        Type = "exec";
        ExecStart = "${pkgs.waybar}/bin/waybar";
        ExecCondition = "${pkgs.systemd}/lib/systemd/systemd-xdg-autostart-condition \"Hyprland\" \"\" ";
        Restart = "on-failure";
        Slice = "background-graphical.slice";
      };
    };
  };
}
