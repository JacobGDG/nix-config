{ pkgs, ... }:
{
  home.packages = with pkgs; [
    zsh
    sesh 
  ];

  xdg.configFile."sesh/sesh.toml".source = (pkgs.formats.toml { }).generate "sesh.toml" {
    session = [
      {
        name = "NixConfig 🔧";
        path = "~/src/nix-config/";
        startup_command = "tmuxifier load-window vimsplit & tmux kill-window -t 1";
      }
    ];
  };
}
