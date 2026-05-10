{inputs, ...}: let
  version = "25.11";
in {
  imports = [
    inputs.den.flakeModules.dendritic
    inputs.flake-file.flakeModules.dendritic
  ];
  flake-file = {
    inputs = {
      den.url = "github:vic/den";
      flake-file.url = "github:vic/flake-file";
      nixpkgs.url = "github:nixos/nixpkgs/nixos-${version}";
      home-manager = {
        url = "github:nix-community/home-manager/release-${version}";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };
    outputs = "inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules)";
  };
}
