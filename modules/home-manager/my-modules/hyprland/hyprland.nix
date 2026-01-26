{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.myModules.hyprland;
in {
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      brightnessctl
      libnotify # notify-send
      networkmanager
      networkmanager_dmenu
      pavucontrol
      pulseaudio
      kdePackages.dolphin
      playerctl
      grim # screenshot
      slurp # select area for screenshot
      cliphist # clipboard history
      ungoogled-chromium # for webapps
      xev # help with keycodes
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
        "$app" = "uwsm app --";
        "$mod" = "SUPER";
        "$window-mod" = "$mod SHIFT";
        "$terminal" = "$app kitty";
        "$browser" = "$app firefox";
        "$webapp" = "$app chromium --new-window --ozone-platform=wayland --app";
        "$launcher" = "$app wofi --show drun";
        bind =
          [
            "$mod, SPACE, exec, $launcher"
            "$mod, B, exec, $browser"
            "$mod SHIFT, B, exec, wofi-bookmarks"
            "$mod, T, exec, $terminal"
            "$mod SHIFT, T, exec, kitten quick-access-terminal"
            "$mod, S, exec, $app steam"
            "$mod, A, exec, $webapp=https://chatgpt.com"
            "$mod, W, exec, $webapp=https://web.whatsapp.com/"
            "$mod, K, exec, $webapp=https://remap-keys.app/configure"

            "$mod, Q, exec, hyprctl-conditional-quit"

            "$mod, V, exec, cliphist list | $app wofi --dmenu | cliphist decode | wl-copy"

            "$window-mod, H, movewindow, l"
            "$window-mod, L, movewindow, r"
            "$window-mod, K, movewindow, u"
            "$window-mod, J, movewindow, d"

            "$window-mod, Left, resizeactive, -240 0"
            "$window-mod, Right, resizeactive, 180 0"
            "$window-mod, Up, resizeactive, 0 -240"
            "$window-mod, Down, resizeactive, 0 180"

            "$mod, H, movefocus, l"
            "$mod, L, movefocus, r"
            "$mod, K, movefocus, u"
            "$mod, J, movefocus, d"

            "$mod, F, fullscreen"

            "$mod, G, workspace, 10" # game

            ", Print, exec, grim -g \"$(slurp)\" && notify-send -a 'Grim' 'Screenshot taken'"

            "$mod, TAB, workspace, previous"

            "$mod, X, togglespecialworkspace"
            "$window-mod, X, movetoworkspace, special"
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
          ", XF86AudioPlay, exec, media-control play_pause"
          ", F9, exec, media-control next"
          ", XF86AudioNext, exec, media-control next"
          ", F7, exec, media-control prev"
          ", XF86AudioPrev, exec, media-control prev"
        ];
        exec-once = [
          "$terminal"
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
        gesture = [
          "3, horizontal, workspace"
        ];
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
        misc = {
          force_default_wallpaper = 1;
        };
        windowrulev2 = [
          "idleinhibit fullscreen, class:.*"

          "float,title:^(Volume Control|Friends List|Steam Settings)$"
          "float,title:^(Extension.*Mozilla Firefox)$"
          "float,class:^(org.kde.dolphin)$"

          "fullscreen,class:^steam_app\d+$"

          # Coding
          "workspace 1, class:^(kitty)$"

          # Browsing
          "workspace 2, class:^(firefox)$"

          # Tools
          "workspace 3, class:^(chrome-.+__-Default|Spotify)$"
          "workspace 3, title:^(Remap)$"

          # Game Launcher
          "workspace 9, class:^(steam|org.prismlauncher.PrismLauncher|info.mumble.Mumble)$"
          "workspace 9, title:^(Steam)$"

          # Game (in theory)
          "workspace 10, class:^(steam_app_[0-9]+|dwarfort|Minecraft.*)$"
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
