{
  lib,
  config,
  ...
}: {
  options.nixpkgs.overlays = lib.mkOption {
    type = lib.types.listOf lib.types.raw;
    default = [];
  };

  config = {
    flake.modules.nixos.core.nixpkgs.overlays = config.nixpkgs.overlays;
  };
}
