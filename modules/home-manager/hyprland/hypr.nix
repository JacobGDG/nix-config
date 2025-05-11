{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    anyrun # launcher
    hypridle
    dunst # notification
    hyprpaper # wallpaper
    networkmanager
    networkmanagerapplet
    pavucontrol
    pulseaudio
  ];

  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 14;
  };

  fonts.fontconfig.enable = true;

  programs.kitty.enable = true;
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland = {
      enable = true;
    };
  };
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    "$terminal" = "alacritty";
    "$browser" = "firefox";
    "$launcher" = "anyrun";
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
    exec-once = [
      "$terminal"
      "dunst"
      "hyprpaper"
      "hypridle"
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
      "eDP-1, 1920x1080@60, 0x0, 1"
    ];
    general = {
      gaps_out = 10;
    };
  };

  home.file."${config.xdg.configHome}/hypr/hyprpaper.conf" = {
    text = ''
      preload=${../../../wallpapers/haystacks.jpg}
      wallpaper=,${../../../wallpapers/haystacks.jpg}
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
