{inputs, ...}: {
  imports = [
    inputs.private-config.nixosModules.generic

    ../../modules/nixos/my-modules
  ];
}
