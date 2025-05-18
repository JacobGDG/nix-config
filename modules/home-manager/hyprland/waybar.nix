{config, ...}: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    # https://github.com/magveta/HyprlandGruvbox/tree/main/hypr/waybar
    style = ''
      * {
        border: none;
        border-radius: 5px;
        font-family: JetBrainsMono NF;
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

      #date,
      #clock,
      #pulseaudio,
      #workspaces,
      #cpu,
      #memory,
      #custom-power,
      #network {
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
      #battery.warning,
      #battery.critical,
      #battery.urgent {
          background-color: #${config.colorScheme.palette.base02};
          border: 2px solid #${config.colorScheme.palette.base08};
          color: #${config.colorScheme.palette.base08};
      }

      #battery.critical {
      }
    '';

    settings = [
      {
        height = 30;
        layer = "top";
        position = "top";
        spacing = 10;
        modules-center = [];
        modules-left = ["hyprland/workspaces"];
        modules-right = [
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "battery"
          "clock"
          "custom/power"
        ];
        battery = {
          format = "{capacity}% {icon}";
          format-alt = "{time} {icon}";
          format-charging = "{capacity}% 󱐋 ";
          format-icons = [" " " " " " " " " "];
          format-plugged = "{capacity}%  ";
          states = {
            critical = 15;
            warning = 30;
          };
        };
        clock = {
          format-alt = " {:%Y-%m-%d} ";
          tooltip-format = "{:%Y-%m-%d | %H:%M}";
        };
        cpu = {
          format = " {usage}%   ";
          tooltip = false;
        };
        memory = {format = " {}%  ";};
        network = {
          interval = 1;
          format-alt = " {ifname}: {ipaddr}/{cidr}";
          format-disconnected = "Disconnected ⚠";
          format-ethernet = " {ifname}: {ipaddr}/{cidr}   up: {bandwidthUpBits} down: {bandwidthDownBits}";
          format-linked = " {ifname} (No IP) ";
          format-wifi = " {essid} ({signalStrength}%)  ";
        };
        pulseaudio = {
          format = " {volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-icons = {
            car = " ";
            default = [" " " " " "];
            handsfree = "";
            headphones = " ";
            headset = " ";
            phone = " ";
            portable = " ";
          };
          format-muted = " {format_source}";
          format-source = "{volume}%  ";
          format-source-muted = "";
          on-click = "pavucontrol";
        };
        "custom/power" = {
          format = " ⏻ ";
          tooltip = false;
          on-click = "wlogout --protocol layer-shell";
        };
      }
    ];
  };
}
