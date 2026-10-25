{inputs, ...}: {
  flake-file.inputs.neovim = {
    url = "github:JacobGDG/nvim.nix";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.gen-luarc.inputs.git-hooks.inputs.nixpkgs-stable.follows = "nixpkgs";
  };

  persist = {
    users = {
      directories = [
        ".local/state/nvim"
      ];
    };
  };

  nixpkgs.overlays = [inputs.neovim.overlays.default];

  flake.modules.homeManager.neovim = {pkgs, ...}: {
    home = {
      packages = with pkgs; [
        nvim-pkg
      ];
      sessionVariables.EDITOR = "nvim";
    };
  };
}
