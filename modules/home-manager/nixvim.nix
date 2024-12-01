{ pkgs, ... }:
{
  imports = [
    ./nixvim/settings.nix
    ./nixvim/autocmds.nix
    ./nixvim/keymaps.nix

    ./nixvim/plugins/coding/treesitter.nix

    ./nixvim/plugins/ui/indent-blankline.nix
    ./nixvim/plugins/ui/lualine.nix
    ./nixvim/plugins/ui/smart-splits.nix
    ./nixvim/plugins/ui/web-devicons.nix

    ./nixvim/plugins/utils/comment.nix
    ./nixvim/plugins/utils/committia.nix
    ./nixvim/plugins/utils/gitsigns.nix
    ./nixvim/plugins/utils/oil.nix
    ./nixvim/plugins/utils/telescope.nix
  ];

  programs.nixvim = {
    enable = true;
    vimAlias = true;

    colorschemes.gruvbox.enable = true;
  };
}
