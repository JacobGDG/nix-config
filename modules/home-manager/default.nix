{ inputs, ... }:
{
  alacritty = import ./alacritty.nix { inherit inputs; };
  zsh = import ./zsh.nix;
  git = import ./git.nix;
  nixvim = import ./nixvim.nix;
  ripgrep = import ./ripgrep.nix;
  tmux = import ./tmux.nix;
}
