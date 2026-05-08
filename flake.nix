# DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{
  outputs = inputs: inputs.flake-parts.lib.mkFlake {inherit inputs;} (inputs.import-tree ./modules/meta);

  inputs = {
    den.url = "github:vic/den";
    flake-file.url = "github:vic/flake-file";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    import-tree.url = "github:vic/import-tree";
    mac-app-util = {
      url = "github:hraban/mac-app-util";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mysecrets = {
      url = "git+ssh://git@github.com/JacobGDG/nix-secrets.git?shallow=1";
      flake = false;
    };
    neovim = {
      url = "git+ssh://git@github.com/JacobGDG/nvim.nix.git?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors.url = "github:misterio77/nix-colors";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/master";
    private-config = {
      url = "git+ssh://git@github.com/JacobGDG/private-nix-config.nix.git?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    prompts = {
      url = "git+ssh://git@github.com/JacobGDG/prompts.git?shallow=1";
      flake = false;
    };
    ragenix = {
      url = "github:JacobGDG/ragenix/687ee92114bce9c4724376cf6b21235abe880bfa";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wallpapers = {
      url = "git+ssh://git@github.com/JacobGDG/wallpapers.git?shallow=1";
      flake = false;
    };
  };
}
