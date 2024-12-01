{ inputs, ... }:
{
  alacritty = import ./alacritty.nix { inherit inputs; };
  zsh = import ./zsh.nix;
  git = import ./git.nix;
  ripgrep = import ./ripgrep.nix;
  tmux = import ./tmux.nix;
  vim = import ./vim.nix;
}
