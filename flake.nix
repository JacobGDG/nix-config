# DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{
  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  inputs = {
    flake-file.url = "github:vic/flake-file";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    import-tree.url = "github:denful/import-tree";
    mac-app-util = {
      url = "github:hraban/mac-app-util";
      inputs = {
        cl-nix-lite.inputs = {
          nixpkgs.follows = "nixpkgs";
          treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
        };
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
      };
    };
    neovim = {
      url = "git+ssh://git@github.com/JacobGDG/nvim.nix.git?shallow=1";
      inputs = {
        gen-luarc.inputs.git-hooks.inputs.nixpkgs-stable.follows = "nixpkgs";
        nixpkgs.follows = "nixpkgs";
      };
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
  };
}
