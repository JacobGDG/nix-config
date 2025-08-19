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
      grim # screenshot
      slurp # select area for screenshot
      cliphist # clipboard history
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
            "$mod ALT, F, exec, $browser"
            "$mod ALT, K, exec, $terminal"
            "$mod, SPACE, exec, $launcher"
            "$mod, Q, exec, hyprctl-conditional-quit"

            "$mod, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"

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

            "$mod, G, workspace, 10" # game
            "$mod, L, workspace, e+1"
            "$mod, H, workspace, e-1"

            ", Print, exec, grim -g \"$(slurp)\" && notify-send -a 'Grim' 'Screenshot taken'"

            "$mod, TAB, workspace, previous"
          ]
          ++ (
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
          ", F8, exec, media-control play_pause"
          ", F9, exec, media-control next"
          ", F7, exec, media-control prev"
        ];
        exec-once = [
          "$terminal"
          "nm-applet"
          "wl-paste --type text --watch cliphist store # Stores only text data"
          "wl-paste --type image --watch cliphist store # Stores only text data"
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
        windowrulev2 = [
          "idleinhibit fullscreen, class:.*"

          "float,title:^(Volume Control|Friends List|Steam Settings)$"
          "float,class:^(org.kde.dolphin)$"

          "fullscreen,class:^steam_app\d+$"

          "workspace 1, class:^(kitty)$"
          "workspace 2, class:^(zen-beta|firefox)$"
          "workspace 9, class:^(steam)$"
          "workspace 10, class:^(steam_app_[0-9]+|dwarfort)$"
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
