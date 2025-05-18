{
  pkgs,
  mylib,
  inputs,
  ...
}: {
  imports =
    [
      ./base.nix
      inputs.nix-colors.homeManagerModules.default
    ]
    ++ (map mylib.homeManagerModules [
      "genealogy.nix"
      "hyprland"
      "libreoffice.nix"
      "spotify-player.nix"
      "thunderbird.nix"
      "wireguard.nix"
      "firefox.nix"
    ]);

  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;

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
