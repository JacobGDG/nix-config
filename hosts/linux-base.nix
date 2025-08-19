{
  pkgs,
  mylib,
  ...
}: {
  imports =
    [
      ./base.nix
    ]
    ++ (map mylib.homeManagerModules [
      "genealogy.nix"
      "hyprland" # TODO: move to my-modules
      "libreoffice.nix"
      "spotify-player.nix"
      "thunderbird.nix"
      "wireguard.nix"
      "firefox.nix"
      "udiskie.nix"
    ]);

  systemd.user.startServices = "sd-switch";

  myModules = {
    hyprland.enable = true;
    zen-browser.enable = true;
    mpv.enable = true;
  };

  home = {
    username = "jake";
    homeDirectory = "/home/jake";

    packages = with pkgs; [
      devenv
      blender
      rpi-imager
      kitty
      ruby
      bc # cli calculator
      unzip
    ];
  };
}
