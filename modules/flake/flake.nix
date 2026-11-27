{
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.flake-file.flakeModules.tack
    inputs.flake-parts.flakeModules.modules
  ];

  flake-file = {
    inputs = {
      flake-file.url = "github:vic/flake-file";
      flake-parts.url = "github:hercules-ci/flake-parts";
      import-tree.url = "github:denful/import-tree";
      tack.url = "github:manic-systems/tack";
    };

    tack = {
      package = pkgs: inputs.tack.packages.${pkgs.stdenv.hostPlatform.system}.default;
      allFollow = {
        flake-parts = "flake-parts";
        home-manager = "home-manager";
        nixpkgs = "nixpkgs";
        nixpkgs-stable = "nixpkgs";
      };
    };
  };

  perSystem = {pkgs, ...}: {
    packages.write-lock = config.flake-file.apps.write-lock pkgs;
  };
}
