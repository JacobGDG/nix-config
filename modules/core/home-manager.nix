{config, ...}: {
  flake-file.inputs.home-manager = {
    url = "github:nix-community/home-manager/release-${config.nixpkgsStableVersion}";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules = {
    nixos.core = {
      pkgs,
      config,
      inputs,
      lib,
      homeManagerModuleSets,
      ...
    }: let
      hostname = config.networking.hostName;
      usersForHost =
        lib.filterAttrs (
          name: _:
            builtins.match ".+@${hostname}" name != null
        )
        homeManagerModuleSets;
    in {
      imports = [inputs.home-manager.nixosModules.home-manager];
      home-manager = {
        backupFileExtension = "bak";

        useGlobalPkgs = true;
        useUserPackages = true;

        users = lib.mapAttrs' (name: modules: let
          user = builtins.head (builtins.match "(.+)@.+" name);
        in
          lib.nameValuePair user {imports = modules;})
        usersForHost;

        extraSpecialArgs.inputs = inputs;
      };
    };

    homeManager.core = {lib, ...}: {
      home.stateVersion = lib.mkDefault "25.05";
      programs.home-manager.enable = true;
      programs.zsh.enable = true;
    };
  };
}
