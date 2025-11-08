{
  inputs,
  mylib,
  ...
}: {
  imports =
    [
      inputs.home-manager.nixosModules.home-manager
      inputs.private-config.nixosModules.generic
      ../../modules/nixos
    ]
    ++ mylib.scanPaths ./.;

  myModules.nixOS = {
    firefox.enable = true;
    hyprland.enable = true;
    steam.enable = true;
  };
}
