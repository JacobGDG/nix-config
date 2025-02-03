{
  description = "My NixOS and home-manager flake.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    alacritty-themes = {
      url = "github:alacritty/alacritty-theme/master";
      flake = false;
    };

    agenix = {
      url = "github:JacobGDG/ragenix/687ee92114bce9c4724376cf6b21235abe880bfa";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mysecrets = {
      url = "git+ssh://git@github.com/JacobGDG/nix-secrets.git?shallow=1";
      flake = false;
    };

    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    plasma-manager,
    alacritty-themes,
    agenix,
    mac-app-util,
    ...
  } @ inputs: let
    platformConfig = import ./platforms;

    workMacConfigs = platformConfig.workMac;
    nixOSLenovoConfigs = platformConfig.nixOSLenovo;

    lib = nixpkgs.lib // home-manager.lib;
    systems = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
    forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
    pkgsFor = lib.genAttrs systems (
      system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
    );

    inherit (self) outputs;
  in {
    inherit lib;
    homeManagerModules = import ./modules/home-manager/default.nix {inherit inputs;};
    nixosModules = import ./modules/nixos/default.nix;

    formatter = forEachSystem (pkgs: pkgs.alejandra);

    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      nixos-laptop = lib.nixosSystem {
        specialArgs = {
          platformConfig = nixOSLenovoConfigs;
          inherit inputs outputs;
        };
        modules = [
          agenix.nixosModules.default

          ./nixos/configuration.nix
          ./secrets/nixOSLenovo.nix
        ];
      };
    };

    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      workMac = lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = workMacConfigs.system;
        };
        extraSpecialArgs = {
          platformConfig = workMacConfigs;
          inherit inputs outputs;
        };
        modules = [
          mac-app-util.homeManagerModules.default
          ./home-manager/home.nix
        ];
      };
      nixOSLenovo = lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = nixOSLenovoConfigs.system;
        };
        extraSpecialArgs = {
          platformConfig = nixOSLenovoConfigs;
          inherit inputs outputs;
        };
        modules = [
          plasma-manager.homeManagerModules.plasma-manager

          ./home-manager/home.nix
        ];
      };
    };
  };
}
