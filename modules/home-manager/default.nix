{ inputs, ... }:
{
  alacritty = import ./alacritty.nix { inherit inputs; };
  btop = import ./btop.nix;
  git = import ./git.nix;
  neovim = import ./neovim.nix;
  plasma = import ./plasma.nix;
  ripgrep = import ./ripgrep.nix;
  spotify-player = import ./spotify-player.nix;
  cava = import ./cava.nix;
  tmux = import ./tmux.nix;
  zoxide = import ./zoxide.nix;
  zsh = import ./zsh.nix;
}
