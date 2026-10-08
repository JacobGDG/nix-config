{
  inputs,
  lib,
  config,
  ...
}: {
  options.nixpkgs.overlays = lib.mkOption {
    type = lib.types.listOf lib.types.raw;
    default = [];
  };

  config = {
    flake-file.inputs = {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-${config.nixpkgsStableVersion}";
      nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    };

    flake.modules.nixos.core.nixpkgs.overlays = config.nixpkgs.overlays;

    nixpkgs.overlays = [
      (final: prev: {
        unstable = import inputs.nixpkgs-unstable {
          inherit (final) system;
          config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) config.nixpkgs.allowedUnfreePackages;
        };
      })
    ];
  };
}
