{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    # https://github.com/magveta/HyprlandGruvbox/tree/main/hypr/waybar
    style = ''
      * {
        border: none;
        border-radius: 6px;
        font-family: JetBrainsMono NF;
        font-size: 12px;
        min-height: 0;
      }

      window#waybar {
        background: rgba(29, 32, 33, 1.0);
        color: #ebdbb2;
      }

      tooltip {
        background: #282828;
        border-radius: 10px;
        border-width: 2px;
        border-style: solid;
        border-color: #1d2021;
      }
      #workspaces button {
        padding: 0 0.6em;
        color: #504945;
        border-radius: 6px;
        margin-right: 2px;
        margin-left: 2px;
        margin-top: 2px;
        margin-bottom: 2px;
      }

      #workspaces button.active {
        color: #ebdbb2;
        background: #4e635b;
      }

      #workspaces button.focused {
        color: #ebdbb2;
        background: #4e635b;
      }

      #workspaces button.urgent {
        color: #1d2021;
        background: #fb4934;
      }

      #workspaces button:hover {
        background: #4e635b;
        color: #ebdbb2;
      }

      #custom-power,
      #date,
      #clock,
      #pulseaudio,
      #workspaces,
      #cpu,
      #memory,
      #network {
        color: #ebdbb2;
        background: #32302f;
      }

      #pulseaudio {
        margin-right: 6px;
        color: #ebdbb2;
      }

      #custom-power {
        color: #fb4934;
        background: #32302f;
      }

      #clock {
        color: #ebdbb2;
        margin-right: 6px;
      }

      #cpu.critical,
      #memory.critical {
          background-color: #ddc7a1;
          border: 2px solid #c7ab7a;
          color: #c14a4a;
      }

      #battery.warning,
      #battery.critical,
      #battery.urgent {
          background-color: #ddc7a1;
          border: 2px solid #c7ab7a;
          color: #c14a4a;
      }
    '';

    settings = [
      {
        height = 30;
        layer = "top";
        position = "top";
        spacing = 10;
        modules-center = ["hyprland/window"];
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
          format = "{capacity}% {icon} ";
          format-alt = "{time} {icon} ";
          format-charging = "{capacity}% 󱐋 ";
          format-icons = ["" "" "" "" ""];
          format-plugged = "{capacity}%  ";
          states = {
            critical = 15;
            warning = 30;
          };
        };
        clock = {
          format-alt = "{:%Y-%m-%d}";
          tooltip-format = "{:%Y-%m-%d | %H:%M}";
        };
        cpu = {
          format = "{usage}%  ";
          tooltip = false;
        };
        memory = {format = "{}%  ";};
        network = {
          interval = 1;
          format-alt = "{ifname}: {ipaddr}/{cidr}";
          format-disconnected = "Disconnected ⚠";
          format-ethernet = "{ifname}: {ipaddr}/{cidr}   up: {bandwidthUpBits} down: {bandwidthDownBits}";
          format-linked = "{ifname} (No IP) ";
          format-wifi = "{essid} ({signalStrength}%)  ";
        };
        pulseaudio = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-icons = {
            car = "";
            default = ["" "" ""];
            handsfree = "";
            headphones = "";
            headset = "";
            phone = "";
            portable = "";
          };
          format-muted = " {format_source}";
          format-source = "{volume}% ";
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
