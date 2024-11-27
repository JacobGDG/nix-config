{inputs, ...}:
{
  alacritty = import ./alacritty.nix { inherit inputs; };
  zsh = import ./zsh.nix;
  git = import ./git.nix;
  tmux = import ./tmux.nix;
}
