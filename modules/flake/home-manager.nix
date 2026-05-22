{
  inputs,
  lib,
  config,
  ...
}: {
  options = {
    users = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {};
      });
    };

    homeManagerModuleSets = lib.mkOption {
      type = lib.types.attrsOf (lib.types.listOf lib.types.deferredModule);
      default = {};
    };
  };

  config = {
    homeManagerModuleSets = let
      userAtHostModules = lib.filterAttrs (name: _: builtins.match ".+@.+" name != null) config.flake.modules.homeManager;
    in
      lib.mapAttrs (name: userAtHostModule: let
        parts = builtins.match "(.+)@(.+)" name;
        user = builtins.elemAt parts 0;
        host = builtins.elemAt parts 1;
      in [
        # remember the order here does not matter, it is all about priority
        # https://wiki.nixos.org/wiki/NixOS:Properties
        config.flake.modules.homeManager.core
        (config.flake.modules.homeManager."${user}" or {})
        (config.flake.modules.homeManager."${host}" or {})
        userAtHostModule
      ])
      userAtHostModules;

    flake.homeConfigurations =
      lib.mapAttrs (
        name: modules: let
          parts = builtins.match "(.+)@(.+)" name;
          host = builtins.elemAt parts 1;
        in
          inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = import inputs.nixpkgs {
              system = config.nixosHosts.${host}.system;
              config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) config.nixpkgs.allowedUnfreePackages;
              overlays = config.nixpkgs.overlays;
            };
            extraSpecialArgs.inputs = inputs;
            inherit modules;
          }
      )
      config.homeManagerModuleSets;
  };
}
