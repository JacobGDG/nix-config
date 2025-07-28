{pkgs, ...}: {
  home.packages = with pkgs; [
    zsh
    sesh
  ];

  xdg.configFile."sesh/sesh.toml".source = (pkgs.formats.toml {}).generate "sesh.toml" {
    default_session.startup_command = "tmuxifier load-window vimsplit && tmux move-window -t 0 && tmux kill-window -t 1";
    session = [
      {
        name = "Spotify 🎵";
        startup_command = "tmuxifier load-window music && tmux move-window -t 0 && tmux kill-window -t 1";
      }
      {
        name = "NixConfig 🔧";
        path = "~/src/nix-config/";
        startup_command = "tmuxifier load-window vimsplit && tmux move-window -t 0 && tmux kill-window -t 1";
      }
      {
        name = "Tomato 🍅";
        path = "~";
        startup_command = "tomato";
      }
    ];
  };
}
