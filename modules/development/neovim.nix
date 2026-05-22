{
  flake.modules.homeManager.neovim = {pkgs, ...}: {
    home = {
      packages = [pkgs.neovim];
      sessionVariables.EDITOR = "nvim";
    };
  };
}
