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
    neovim.url = "git+ssh://git@github.com/JacobGDG/nvim.nix.git?shallow=1";
    private-config = {
      url = "git+ssh://git@github.com/JacobGDG/private-nix-config.nix.git?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
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
    neovim,
    private-config,
    self,
    ...
  } @ inputs: let
    mylib = import ./mylib {inherit lib;};
    lib = nixpkgs.lib // home-manager.lib;

    mkShellForSystem = system: let
      pkgs = import nixpkgs {inherit system;};
    in
      pkgs.mkShell {
        name = "nixConfig";

        buildInputs = with pkgs; [
          nil
          alejandra
        ];
      };

    # Common overlay set (unstable + neovim)
    mkOverlays = system: [
      (final: prev: {
        unstable = import nixpkgs-unstable {inherit system;};
      })
      neovim.overlays.default
    ];

    mkPkgs = system:
      import nixpkgs {
        inherit system;
        overlays = mkOverlays system;
      };

    # Generic Home Manager builder
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

    # Generic NixOS builder
    mkNixos = {
      hostName,
      username,
      modules,
    }:
      lib.nixosSystem {
        specialArgs = {
          hostConfig = {inherit hostName username;};
          inherit inputs;
        };
        modules = [agenix.nixosModules.default] ++ modules;
      };
  in {
    inherit lib;

    nixosConfigurations = {
      jake-laptop-nixos = mkNixos {
        hostName = "jake-laptop-nixos";
        username = "jake";
        modules = [./nixos/jake-laptop-nixos];
      };

      erebor = mkNixos {
        hostName = "erebor";
        username = "jake";
        modules = [./nixos/erebor];
      };
    };

    homeConfigurations = {
      "jakegreenwood@MacOS" = mkHome {
        user = "jakegreenwood";
        system = "aarch64-darwin";
        modules = [./hosts/work-mac.nix];
      };

      "jake@jake-laptop-nixos" = mkHome {
        user = "jake";
        system = "x86_64-linux";
        modules = [./hosts/jake-laptop-nixos.nix];
      };

      "jake@erebor" = mkHome {
        user = "jake";
        system = "x86_64-linux";
        modules = [./hosts/erebor.nix];
      };
    };

    devShells = {
      x86_64-linux.default = mkShellForSystem "x86_64-linux";
      aarch64-darwin.default = mkShellForSystem "aarch64-darwin";
    };
  };
}
