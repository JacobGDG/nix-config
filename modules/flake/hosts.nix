{
  inputs,
  lib,
  config,
  ...
}: {
  options = {
    nixosHosts = let
      nixosHostType = lib.types.submodule {
        options = {
          system = lib.mkOption {
            type = lib.types.str;
          };
        };
      };
    in
      lib.mkOption {
        type = lib.types.attrsOf nixosHostType;
      };
  };

  config = {
    flake.nixosConfigurations = let
      mkHost = hostname: options:
        inputs.nixpkgs.lib.nixosSystem {
          system = options.system;
          specialArgs.inputs = inputs;
          specialArgs.homeManagerModuleSets = config.homeManagerModuleSets;

          modules = [
            config.flake.modules.nixos.core
            (config.flake.modules.nixos."nixosConfigurations/${hostname}" or {})
          ];
        };
    in
      lib.mapAttrs mkHost config.nixosHosts;
  };
}
