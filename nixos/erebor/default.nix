{mylib, ...}: {
  imports =
    [
      ../common

      ../../modules/nixos/nvidia.nix
      ../../modules/nixos/hyprland.nix
      ../../modules/nixos/steam.nix
      ../../modules/nixos/firefox.nix
      ../../modules/nixos/bluetooth.nix
    ]
    ++ mylib.scanPaths ./.;
}
