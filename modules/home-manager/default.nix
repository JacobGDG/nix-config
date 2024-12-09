{ inputs, ... }:
{
  alacritty = import ./alacritty.nix { inherit inputs; };
  btop = import ./btop.nix;
  git = import ./git.nix;
  neovim = import ./neovim.nix;
  ripgrep = import ./ripgrep.nix;
  tmux = import ./tmux.nix;
  zoxide = import ./zoxide.nix;
  zsh = import ./zsh.nix;
}
