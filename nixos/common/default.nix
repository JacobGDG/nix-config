{inputs, ...}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.private-config.nixosModules.generic
    ../../modules/nixos/my-modules

    ../../modules/nixos/hyprland.nix
    ../../modules/nixos/steam.nix
    ../../modules/nixos/firefox.nix
  ];
}
