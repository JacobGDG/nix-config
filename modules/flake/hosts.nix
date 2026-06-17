{
  inputs,
  lib,
  config,
  ...
}: {
  options = {
    hosts = let
      hostType = lib.types.submodule {
        options = {
          system = lib.mkOption {
            type = lib.types.str;
          };
          configurator = lib.mkOption {
            type = lib.types.str;
            default = "noop";
          };
          hasBattery = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };
        };
      };
    in
      lib.mkOption {
        type = lib.types.attrsOf hostType;
      };
  };

  config = {
    flake.nixosConfigurations = let
      mkHost = hostname: options:
        inputs.nixpkgs.lib.nixosSystem {
          system = options.system;
          specialArgs.inputs = inputs;

          modules = [
            config.flake.modules.nixos.core
            (config.flake.modules.nixos."nixosConfigurations/${hostname}" or {})
          ];
        };
    in
      lib.mapAttrs mkHost (lib.filterAttrs (_: attr: attr.configurator == "nixos") config.hosts);
  };
}
