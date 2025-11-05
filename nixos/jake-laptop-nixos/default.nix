{mylib, ...}: {
  imports =
    [
      ../common
      ../../modules/nixos/hyprland.nix
      ../../modules/nixos/steam.nix
      ../../modules/nixos/firefox.nix
    ]
    ++ mylib.scanPaths ./.;
}
