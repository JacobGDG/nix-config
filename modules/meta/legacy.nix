# Legacy configurations — preserved as-is during dendritic migration.
# Hosts/homes will be removed from here as they are migrated to den.hosts/den.homes.
{inputs, ...}: let
  lib = inputs.nixpkgs.lib // inputs.home-manager.lib;
  mylib = import ../../mylib {inherit lib;};

  mkOverlays = system: [
    (final: prev: {
      unstable = import inputs.nixpkgs-unstable {inherit system;};
    })
    inputs.neovim.overlays.default
  ];

  mkPkgs = system:
    import inputs.nixpkgs {
      inherit system;
      overlays = mkOverlays system;
    };

  mkHome = {
    user,
    system,
    modules,
  }:
    lib.homeManagerConfiguration {
      pkgs = mkPkgs system;
      extraSpecialArgs = {inherit inputs mylib;};
      inherit modules;
    };

  mkNixos = {
    hostName,
    username,
    modules,
  }:
    lib.nixosSystem {
      specialArgs = {
        hostConfig = {inherit hostName username;};
        inherit inputs mylib;
      };
      modules = [inputs.ragenix.nixosModules.default] ++ modules;
    };
in {
  flake = {
    inherit lib;

    nixosConfigurations = {
      jake-laptop-nixos = mkNixos {
        hostName = "jake-laptop-nixos";
        username = "jake";
        modules = [../../nixos/jake-laptop-nixos];
      };

      erebor = mkNixos {
        hostName = "erebor";
        username = "jake";
        modules = [../../nixos/erebor];
      };
    };

    homeConfigurations = {
      "jakegreenwood@MacOS" = mkHome {
        user = "jakegreenwood";
        system = "aarch64-darwin";
        modules = [../../hosts/work-mac.nix];
      };

      "jake@jake-laptop-nixos" = mkHome {
        user = "jake";
        system = "x86_64-linux";
        modules = [../../hosts/jake-laptop-nixos.nix];
      };

      "jake@erebor" = mkHome {
        user = "jake";
        system = "x86_64-linux";
        modules = [../../hosts/erebor.nix];
      };
    };
  };

  perSystem = {pkgs, ...}: {
    devShells.default = pkgs.mkShell {
      name = "nixConfig";
      buildInputs = with pkgs; [
        nil
        alejandra
      ];
    };
  };
}
