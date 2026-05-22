{inputs, ...}: {
  flake-file.inputs.neovim = {
    url = "git+ssh://git@github.com/JacobGDG/nvim.nix.git?shallow=1";
    inputs.nixpkgs.follows = "nixpkgs";
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
