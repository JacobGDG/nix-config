{inputs, ...}: {
  alacritty = import ./alacritty.nix {inherit inputs;};
  btop = import ./btop.nix;
  cava = import ./cava.nix;
  git = import ./git.nix;
  neovim = import ./neovim.nix;
  plasma = import ./plasma.nix;
  ripgrep = import ./ripgrep.nix;
  spotify-player = import ./spotify-player.nix;
  thunderbird = import ./thunderbird.nix;
  tmux = import ./tmux.nix;
  zoxide = import ./zoxide.nix;
  zsh = import ./zsh.nix;
}
