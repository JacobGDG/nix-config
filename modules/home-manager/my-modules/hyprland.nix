{
  config,
  pkgs,
  lib,
  mylib,
  ...
}: let
  cfg = config.myModules.hyprland;
in {
  options = {
    myModules.hyprland = {
      enable = lib.mkOption {
        default = false;
        description = ''
          Whether to enable the hyprland module and all it's dependancies
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      brightnessctl
      libnotify # notify-send
      networkmanager
      networkmanagerapplet
      pavucontrol
      pulseaudio
      kdePackages.dolphin
      playerctl
    ];

    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 14;
    };

    fonts.fontconfig.enable = true;

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      systemd = {
        # disable the systemd integration, as it conflicts with uwsm.
        enable = false;
        variables = ["--all"];
      };

      settings = {
        "$mod" = "SUPER";
        "$window-mod" = "$mod SHIFT";
        "$terminal" = "kitty";
        "$browser" = "firefox";
        "$launcher" = "wofi --show drun";
        bind =
          [
            "$mod ALT, F, exec, smart-launch $browser"
            "$mod ALT, K, exec, smart-launch $terminal"
            "$mod, SPACE, exec, $launcher"
            "$mod, Q, killactive"

            "$window-mod, H, movewindow, l"
            "$window-mod, L, movewindow, r"
            "$window-mod, K, movewindow, u"
            "$window-mod, J, movewindow, d"

            # Resize window
            "$window-mod, Left, resizeactive, -240 0"
            "$window-mod, Right, resizeactive, 180 0"
            "$window-mod, Up, resizeactive, 0 -240"
            "$window-mod, Down, resizeactive, 0 180"

            "$mod, H, movefocus, l"
            "$mod, L, movefocus, r"
            "$mod, K, movefocus, u"
            "$mod, J, movefocus, d"

            "$mod, F, fullscreen"

            "ALT, X, togglespecialworkspace"
          ]
          ++ (
            # workspaces
            # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
            builtins.concatLists (builtins.genList (
                i: let
                  ws = i + 1;
                in [
                  "$mod, code:1${toString i}, workspace, ${toString ws}"
                  "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
                ]
              )
              9)
          );
        bindm = [
          "$mod, mouse:272, movewindow"
        ];
        # l -> do stuff even when locked
        # e -> repeats when key is held
        bindle = [
          ", XF86AudioRaiseVolume, exec, media-control volume_up"
          ", XF86AudioLowerVolume, exec, media-control volume_down"
          ", XF86MonBrightnessUp, exec, media-control brightness_up"
          ", XF86MonBrightnessDown, exec, media-control brightness_down"
        ];
        bindl = [
          ", XF86AudioMute, exec, media-control volume_mute"
          ", XF86AudioMicMute, exec, media-control mic_mute"
        ];
        exec-once = [
          "$terminal"
          "nm-applet"
        ];
        input = {
          kb_options = "ctrl:nocaps";
          kb_layout = "gb";
          kb_model = "pc104";
          follow_mouse = 2;
          mouse_refocus = false;

          repeat_delay = 200;
          repeat_rate = 40;
        };
        gestures = {
          workspace_swipe = true;
        };
        monitor = [
          "eDP-1, 1920x1080@60, 0x0, 1" # Laptop screen
          "HDMI-A-2, 2560x1440@60, 0x0, 1" # Erebor/Desktop screen
        ];
        general = {
          gaps_out = 5;
          gaps_in = 3;
          "col.inactive_border" = "rgb(${config.colorScheme.palette.base02})";
          "col.active_border" = "rgb(${config.colorScheme.palette.base05})";
        };
        windowrule = [
          "idleinhibit fullscreen, class:.*"
          "float,title:^(Volume Control)$"
        ];
        ecosystem = {
          no_update_news = true;
          no_donation_nag = true;
        };

        decoration = {
          rounding = 5;
        };
      };
    };
  };
}
