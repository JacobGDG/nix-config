{
  pkgs,
  mylib,
  ...
}: {
  imports =
    [
      ./base.nix
    ] ++ (map mylib.homeManagerModules [
      "genealogy.nix"
      "hyprland"
      "libreoffice.nix"
      "spotify-player.nix"
      "thunderbird.nix"
      "wireguard.nix"
      "firefox.nix"
      "udiskie.nix"
    ]);

  systemd.user.startServices = "sd-switch";

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
