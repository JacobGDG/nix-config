{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.11";
  
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
  };
}
