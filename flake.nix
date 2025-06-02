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

    agenix = {
      url = "github:JacobGDG/ragenix/687ee92114bce9c4724376cf6b21235abe880bfa";
      inputs.nixpkgs.follows = "nixpkgs";
    };
   # mysecrets = {
   #   url = "git+ssh://git@github.com/JacobGDG/nix-secrets.git?shallow=1";
   #   flake = false;
   # };

    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs = {
    agenix,
    home-manager,
    nix-colors,
    mac-app-util,
    nixpkgs,
    nixpkgs-unstable,
    self,
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
    formatter = forAllSystems (pkgs: pkgs.alejandra);

    # Available through 'nixos-rebuild --flake .#your-hostname'
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
          ./hosts/work-mac.nix
        ];
      };
      jake-laptop-nixos--jake = lib.homeManagerConfiguration {
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
      erebor--jake = lib.homeManagerConfiguration {
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
