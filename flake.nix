{
  description = "My NixOS and home-manager flake.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/master";

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
    nixpkgs-unstable,
    home-manager,
    plasma-manager,
    alacritty-themes,
    agenix,
    mac-app-util,
    ...
  } @ inputs: let
    mylib = import ./mylib {inherit lib;};

    lib = nixpkgs.lib // home-manager.lib;
    systems = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;

    inherit (self) outputs;
  in {
    inherit lib;
    nixosModules = import ./modules/nixos/default.nix;

    formatter = forAllSystems (pkgs: pkgs.alejandra);

    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      nixos-laptop = lib.nixosSystem {
        specialArgs = {
          hostConfig = {
            username = "jake";
            hostName = "jake-laptop-nixos";
          };
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
          system = "aarch64-darwin";
          overlays = [
            (final: prev: {
              unstable = import nixpkgs-unstable {
                system = prev.system;
              };
            })
          ];
        };
        extraSpecialArgs = {
          mylib = mylib;
          inherit inputs outputs;
        };
        modules = [
          mac-app-util.homeManagerModules.default
          ./hosts/work-mac.nix
        ];
      };
      nixOSLenovo = lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [
            (final: prev: {
              unstable = import nixpkgs-unstable {
                system = prev.system;
              };
            })
          ];
        };
        extraSpecialArgs = {
          mylib = mylib;
          inherit inputs outputs;
        };
        modules = [
          plasma-manager.homeManagerModules.plasma-manager
          ./hosts/jake-laptop-nixos.nix
        ];
      };
    };
  };
}
