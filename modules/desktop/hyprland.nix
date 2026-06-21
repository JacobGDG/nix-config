{
  flake.modules.nixos.hyprland = {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    security.pam.services.hyprlock.enable = true;

    programs = {
      hyprlock.enable = true;

      hyprland = {
        enable = true;
        withUWSM = true;
      };
    };
  };

  flake.modules.homeManager.hyprland = {
    config,
    pkgs,
    inputs,
    ...
  }: {
    imports = [inputs.self.modules.homeManager.terminal];

    home.packages = with pkgs; [
      brightnessctl
      libnotify
      networkmanager
      networkmanager_dmenu
      pavucontrol
      pulseaudio
      kdePackages.dolphin
      playerctl
      grim
      slurp
      cliphist
      ungoogled-chromium
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
      configType = "hyprlang";
      systemd = {
        # disable systemd integration as it conflicts with uwsm
        enable = false;
        variables = ["--all"];
      };

      settings = {
        "$app" = "uwsm app --";
        "$mod" = "SUPER";
        "$window-mod" = "$mod CTRL";
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
            "$mod SHIFT, SPACE, exec, quick-access-kitty"
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

            "$mod, G, workspace, 10"

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
          "wl-paste --type text --watch cliphist store"
          "wl-paste --type image --watch cliphist store"
        ];

        monitor = [
          "eDP-1, 1920x1080@60, 0x0, 1"
          "HDMI-A-2, 2560x1440@60, 0x0, 1"
        ];

        general = {
          gaps_out = 3;
          gaps_in = 3;
          "col.inactive_border" = "rgb(${config.colorScheme.palette.base02})";
          "col.active_border" = "rgb(${config.colorScheme.palette.base05})";
        };

        misc = {
          force_default_wallpaper = 0;
        };

        decoration = {
          rounding = 2;
        };

        ecosystem = {
          no_update_news = true;
          no_donation_nag = true;
        };

        gesture = [
          "3, horizontal, workspace"
        ];

        windowrule = [
          "idle_inhibit fullscreen, match:class .*"

          "float on, match:title ^(Volume Control|Friends List|Steam Settings)$"
          "float on, match:title ^(Extension.*Mozilla Firefox)$"

          "float on, match:class ^(org.kde.dolpkgs.mpv-unwrapped.overridephin)$"
          "size 1200 800, match:class ^(org.kde.dolphin)$"
          "center on, match:class ^(org.kde.dolphin)$"
          "workspace special, match:class ^(org.kde.dolphin)$"

          "fullscreen on, match:class ^steam_app\\d+$"

          "workspace 1, match:class ^(kitty)$"

          "float on, match:title ^(QuickAccessKitty)$"
          "size 1200 800, match:title ^(QuickAccessKitty)$"
          "center on, match:title ^(QuickAccessKitty)$"
          "workspace special, match:title ^(QuickAccessKitty)$"

          "workspace 2, match:class ^(firefox)$"

          "workspace 3, match:class ^(chrome-.+__-Default|Spotify|discord)$"
          "workspace 3, match:title ^(Remap)$"

          "workspace 9, match:class ^(steam|org.prismlauncher.PrismLauncher|info.mumble.Mumble)$"
          "workspace 9, match:title ^(Steam)$"

          "workspace 10, match:class ^(steam_app_[0-9]+|dwarfort|Minecraft.*)$"
        ];
      };
    };
  };
}
