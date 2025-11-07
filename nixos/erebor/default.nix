{mylib, ...}: {
  imports =
    [
      ../common

      ../../modules/nixos/nvidia.nix
      ../../modules/nixos/bluetooth.nix
    ]
    ++ mylib.scanPaths ./.;
}
