{ pkgs, ... }:
{
  programs.nixvim.plugins.treesitter = {
    enable = true;

    settings = {
      indent = {
        enable = true;
      };
      highlight = {
        enable = true;
      };
    };

    folding = true;
    grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars;
  };
}
