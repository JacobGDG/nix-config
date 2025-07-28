{
  description = "My NixOS and home-manager flake.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors.url = "github:misterio77/nix-colors";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:JacobGDG/ragenix/687ee92114bce9c4724376cf6b21235abe880bfa";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mysecrets = {
      url = "git+ssh://git@github.com/JacobGDG/nix-secrets.git?shallow=1";
      flake = false;
    };
    wallpapers = {
      url = "git+ssh://git@github.com/JacobGDG/wallpapers.git?shallow=1";
      flake = false;
    };
    prompts = {
      url = "git+ssh://git@github.com/JacobGDG/prompts.git?shallow=1";
      flake = false;
    };

    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs = {
    agenix,
    home-manager,
    mysecrets,
    wallpapers,
    prompts,
    nix-colors,
    mac-app-util,
    nixpkgs,
    nixpkgs-unstable,
    self,
    ...
  } @ inputs: let
    mylib = import ./mylib {inherit lib;};

    lib = nixpkgs.lib // home-manager.lib;

    inherit (self) outputs;
  in {
    inherit lib;
    nixosConfigurations = {
      jake-laptop-nixos = lib.nixosSystem {
        specialArgs = {
          hostConfig = {
            username = "jake";
            hostName = "jake-laptop-nixos";
          };
          inherit inputs outputs;
        };
        modules = [
          agenix.nixosModules.default

          ./nixos/jake-laptop-nixos
        ];
      };
      erebor = lib.nixosSystem {
        specialArgs = {
          hostConfig = {
            username = "jake";
            hostName = "erebor";
          };
          inherit inputs outputs;
        };
        modules = [
          agenix.nixosModules.default

          ./nixos/erebor
          # ./secrets/erebor
        ];
      };
    };

    homeConfigurations = {
      "jakegreenwood@MacOS" = lib.homeManagerConfiguration {
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
          ./hosts/work-mac.nix
        ];
      };
      "jake@jake-laptop-nixos" = lib.homeManagerConfiguration {
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
          ./hosts/jake-laptop-nixos.nix
        ];
      };
      "jake@erebor" = lib.homeManagerConfiguration {
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
          ./hosts/erebor.nix
        ];
      };
    };
  };
}
