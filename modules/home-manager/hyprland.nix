{pkgs, ...}: {
  imports = [
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    anyrun # launcher
    networkmanager
    dunst # notification
  ];

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
        "$mod, F, exec, $browser"
        "$mod, K, exec, $terminal"
        "$mod, SPACE, exec, $launcher"
        ", Print, exec, grimblast copy area"
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
      "waybar"
      "dunst"
    ];
    input = {
      kb_options = "ctrl:nocaps";
      kb_layout = "gb";
    };
    gestures = {
      workspace_swipe = true;
    };
    monitor = [
      "eDP-1, 1920x1080@60, 0x0, 1"
    ];
  };
}
