{
  jg,
  inputs,
  ...
}: {
  flake-file.inputs.neovim = {
    url = "git+ssh://git@github.com/JacobGDG/nvim.nix.git?shallow=1";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  jg.tui.includes = [jg.neovim];

  jg.neovim.homeManager = {pkgs, ...}: {
    nixpkgs.overlays = [inputs.neovim.overlays.default];

    home = {
      packages = [pkgs.nvim-pkg];
      sessionVariables.EDITOR = "nvim";
    };
  };
}
