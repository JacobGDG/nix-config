{
  flake.modules.homeManager.waybar = {
    config,
    pkgs,
    lib,
    ...
  }: {
    programs.waybar = {
      enable = true;

      style = ''
        * {
          border: none;
          border-radius: 0px;
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
          border-radius: 5px;
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
        #custom-power,
        #date,
        #memory,
        #network,
        #pulseaudio,
        #workspaces {
          color: #${config.colorScheme.palette.base05};
          background: #${config.colorScheme.palette.base01};
        }

        #clock {
          margin-right: 6px;
          margin-left: 6px;
        }

        #custom-power {
          color: #${config.colorScheme.palette.base08};
          padding: 0 0.5em;
        }

        #privacy {
          background-color: #${config.colorScheme.palette.base02};
          color: #${config.colorScheme.palette.base08};
          padding: 0 0.2em;
        }

        #cpu.critical,
        #memory.critical {
          background-color: #${config.colorScheme.palette.base02};
          border: 2px solid #${config.colorScheme.palette.base08};
          color: #${config.colorScheme.palette.base08};
        }
      '';

      settings = [
        {
          height = 30;
          layer = "top";
          position = "top";
          spacing = 10;
          modules-center = ["hyprland/workspaces"];
          modules-left = [
            "clock"
            "idle_inhibitor"
            "privacy"
          ];
          modules-right = [
            "pulseaudio"
            "network"
            "cpu"
            "memory"
            "custom/power"
          ];

          privacy = {};

          clock = {
            format-alt = " {:%Y-%m-%d} ";
            tooltip-format = "{:%Y-%m-%d | %H:%M}";
          };

          cpu = {
            format = " {usage}%    ";
            tooltip = false;
          };

          memory = {format = " {}%  ";};

          network = {
            interval = 1;
            tooltip = false;
            format-disabled = "Disabled";
            format-disconnected = "Disconnected";
            format-ethernet = " 󰈁 up: {bandwidthUpBits} down: {bandwidthDownBits}";
            format-linked = " {ifname} (No IP) ";
            format-wifi = " {essid} ({signalStrength}%)  ";
            on-click = "networkmanager_dmenu";
          };

          pulseaudio = {
            format = " {volume}% {icon} | {format_source}";
            format-bluetooth = "{volume}% {icon} | {format_source}";
            format-bluetooth-muted = " {icon} | {format_source}";
            format-muted = " 󰖁 | {format_source}";
            format-icons = {
              car = " ";
              default = [" " " " " "];
              headphones = " ";
              phone = " ";
              portable = " ";
            };
            format-source = " ";
            format-source-muted = " ";
            on-click = "pavucontrol";
          };

          "custom/power" = {
            format = "⏻";
            tooltip = false;
            on-click = "wlogout --protocol layer-shell";
          };

          idle_inhibitor = {
            format = "{icon}";
            format-icons = {
              activated = " ";
              deactivated = " ";
            };
          };

          "hyprland/workspaces" = {
            format = "{icon}";
            format-icons = {
              "1" = " ";
              "2" = "󰖟 ";
              "3" = "󱃷 ";
              "9" = " ";
              "10" = "󰊴 ";
            };
            on-click = "hyprctl dispatch workspace";
          };
        }
      ];
    };

    systemd.user.services = lib.mkForce {
      waybar = {
        Install.WantedBy = ["graphical-session.target"];
        Unit = {
          Description = "Waybar Service started through UWSM";
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
  };
}
