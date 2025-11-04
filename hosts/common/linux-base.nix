{
  pkgs,
  mylib,
  config,
  ...
}: {
  imports =
    [
      ./base.nix
    ]
    ++ (map mylib.homeManagerModules [
      "genealogy.nix"
      "libreoffice.nix"
      "spotify-player.nix"
      "thunderbird.nix"
      "wireguard.nix"
      "udiskie.nix"
      "dconf.nix"
      "cava.nix"
    ]);

  systemd.user.startServices = "sd-switch";

  myModules = {
    hyprland = {
      enable = true;
      hyprpaper.wallpaper_path = config.myModules.common.wallpaper;
      hyprlock.wallpaper_path = config.myModules.common.wallpaper;
    };
    firefox.enable = true;
    mpv.enable = true;
    zsh.extraAliases = {
      pbcopy = "wl-copy";
    };
    tmux = {
      sesh = {
        sessions = [
          {
            name = "Spotify 🎵";
            startup_command = "tmuxifier load-window music && tmux move-window -t 0 && tmux kill-window -t 1";
          }
        ];
      };
    };
  };

  home = {
    username = "jake";
    homeDirectory = "/home/jake";

    packages = with pkgs; [
      devenv
      blender
      kitty
      ruby
      bc # cli calculator
      unzip
      wl-clipboard
      sshfs
    ];
  };
}
