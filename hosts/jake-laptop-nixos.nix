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
      "hyprland"
      "libreoffice.nix"
      "genealogy.nix"
      "thunderbird.nix"
      "spotify-player.nix"
      "wireguard.nix"
    ]);

  home = {
    username = "jake";
    homeDirectory = "/home/jake";

    packages = with pkgs; [
      devenv
      blender
      vlc
      rpi-imager
      unstable.talosctl
      kitty
    ];
  };
}
