{
  description = "My NixOS and home-manager flake.";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    alacritty-themes = {
      url = "github:alacritty/alacritty-theme/master";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    alacritty-themes,
    nixvim,
    ...
  } @ inputs: let
    platformConfig = import ./platforms;

    workMacConfigs = platformConfig.workMac;
    nixOSLenovoConfigs = platformConfig.nixOSLenovo;
    
    inherit (self) outputs;
  in {
    homeManagerModules = import ./modules/home-manager/default.nix { inherit inputs; };

    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      nixos-laptop = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./nixos/configuration.nix];
      };
    };

    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      workMac = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = workMacConfigs.system;
        };
        extraSpecialArgs = {
          platformConfig = workMacConfigs;
          inherit inputs outputs;
        };
        modules = [
          ./home-manager/home.nix
        ];
      };
      nixOSLenovo = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = nixOSLenovoConfigs.system;
        };
        extraSpecialArgs = {
          platformConfig = nixOSLenovoConfigs;
          inherit inputs outputs;
        };
        modules = [
          ./home-manager/home.nix
        ];
      };
    };
  };
}
