{jg, ...}: {
  jg.hyprland.includes = [jg.waybar];

  jg.waybar.homeManager = {
    config,
    pkgs,
    lib,
    ...
  }: let
    p = config.theme.palette;
  in {
    programs.waybar = {
      enable = true;
      systemd.enable = true;

      style = ''
        * {
          border: none;
          border-radius: 0px;
          font-family: "JetBrainsMono Nerd Font";
          font-size: 12px;
          min-height: 0;
        }

        window#waybar {
          background: #${p.base00};
          color: #${p.base05};
        }

        tooltip {
          background: #${p.base00};
          border-radius: 5px;
          border-width: 2px;
          border-style: solid;
          border-color: #${p.base01};
        }
        #workspaces button {
          padding: 0 0.6em;
          color: #${p.base05};
          border-radius: 6px;
          margin-right: 2px;
          margin-left: 2px;
          margin-top: 2px;
          margin-bottom: 2px;
        }

        #workspaces button:hover,
        #workspaces button.active {
          color: #${p.base05};
          background: #${p.base0D};
        }

        #workspaces button.focused {
          color: #${p.base05};
          background: #${p.base01};
        }

        #workspaces button.urgent {
          color: #${p.base00};
          background: #${p.base08};
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
          color: #${p.base05};
          background: #${p.base01};
        }

        #clock {
          margin-right: 6px;
          margin-left: 6px;
        }

        #custom-power {
          color: #${p.base08};
          padding: 0 0.5em;
        }

        #privacy {
          background-color: #${p.base02};
          color: #${p.base08};
          padding: 0 0.2em;
        }

        #custom-wireguard.active,
        #cpu.critical,
        #memory.critical,
        #battery.critical,
        #battery.urgent {
            background-color: #${p.base02};
            border: 2px solid #${p.base08};
            color: #${p.base08};
        }

        #battery.warning {
          border: 2px solid #${p.base09};
          color: #${p.base09};
        }

        #battery.charging.critical,
        #battery.charging.warning {
          border: 2px solid #${p.base0B};
          color: #${p.base0B};
        }
      '';

      settings = [
        {
          height = 30;
          layer = "top";
          position = "top";
          spacing = 10;
          modules-center = [
            "hyprland/workspaces"
          ];
          modules-left = [
            "clock"
            "idle_inhibitor"
            "custom/wireguard"
            "privacy"
          ];
          modules-right = builtins.filter (x: x != null) [
            "pulseaudio"
            "network"
            "cpu"
            "memory"
            "custom/power"
          ];
          privacy = {
          };
          clock = {
            format-alt = " {:%y-%m-%d} ";
            tooltip-format = "{:%y-%m-%d | %h:%m}";
          };
          cpu = {
            format = " {usage}%    ";
            tooltip = false;
          };
          memory = {format = " {}%  ";};
          network = {
            interval = 1;
            tooltip = false;
            format-disabled = "disabled ⚠";
            format-disconnected = "disconnected ⚠";
            format-ethernet = " 󰈁 up: {bandwidthUpBits} down: {bandwidthDownBits}";
            format-linked = " {ifname} (no ip) ";
            format-wifi = " {essid} ({signalstrength}%)  ";
            on-click = "networkmanager_dmenu";
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
              "alsa_output.pci-0000_04_00.6.hifi__speaker__sink" = "󰌢 ";
              "bluez_output.88_c9_e8_24_52_61.1" = "󱡏 ";
            };
            format-source = " ";
            format-source-muted = " ";
            on-click = "pavucontrol";
          };
          "custom/power" = {
            format = "⏻";
            tooltip = false;
            on-click = "wlogout --protocol layer-shell";
          };
          "custom/wireguard" = {
            format = " {icon} ";
            return-type = "json";
            on-click = "wg-wofi";
            format-icons = {
              inactive = "󰦞";
              home = "󰚊";
              public = "";
            };
            exec = "wg-waybar";
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
  };
}
