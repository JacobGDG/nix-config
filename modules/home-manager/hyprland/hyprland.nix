{
  pkgs,
  config,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    brightnessctl
    hypridle
    hyprpaper # wallpaper
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
      "$terminal" = "kitty";
      "$browser" = "firefox";
      "$launcher" = "wofi --show drun";
      bind =
        [
          "$mod ALT, F, exec, $browser"
          "$mod ALT, K, exec, $terminal"
          "$mod, SPACE, exec, $launcher"
          ", Print, exec, grimblast copy area"

          "$mod SHIFT, H, movewindow, l"
          "$mod SHIFT, L, movewindow, r"
          "$mod SHIFT, K, movewindow, u"
          "$mod SHIFT, J, movewindow, d"
          "$mod, Q, killactive"

          "$mod, H, movefocus, l"
          "$mod, L, movefocus, r"
          "$mod, K, movefocus, u"
          "$mod, J, movefocus, d"

          "$mod, F, fullscreen"
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
        "dunst"
        "hyprpaper"
        "hypridle"
        "nm-applet"
        # "pidof -x battery-warning-daemon || battery-warning-daemon" # ./battery-warning.nix
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
      ];

      decoration = {
        rounding = 5;
      };
    };
  };

  home.file."${config.xdg.configHome}/hypr/hyprpaper.conf" = {
    text = ''
      preload=${inputs.wallpapers}/nature/haystacks.jpg
      wallpaper=,${inputs.wallpapers}/nature/haystacks.jpg
    '';
  };

  home.file."${config.xdg.configHome}/hypr/hypridle.conf" = {
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
}
