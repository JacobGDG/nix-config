{mylib, ...}: {
  imports = [
    ../common
    ./configuration.nix
    ./hardware-configuration.nix
    ./secrets.nix
    ./services.nix

    ../../modules/nixos/hyprland.nix
    ../../modules/nixos/steam.nix
    ../../modules/nixos/firefox.nix
  ];
}
