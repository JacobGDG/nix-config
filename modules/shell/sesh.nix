{
  flake.modules.homeManager.sesh = {
    pkgs,
    inputs,
    ...
  }: {
    programs = {
      zoxide = {
        enable = true;
        enableZshIntegration = true;
      };
      fzf.tmux.enableShellIntegration = true;
      sesh = {
        enable = true;
        tmuxKey = "s";
        enableAlias = false;
        settings = {
          default_session.startup_command = " tmuxifier load-window vimsplit && tmux move-window -t 0 && tmux kill-window -t 1";
          blacklist = ["quick-access-kitty"];
          session = [
            {
              name = "NixConfig";
              path = "~/src/nix-config/main/";
              startup_command = " tmuxifier load-window vimsplit && tmux move-window -t 0 && tmux kill-window -t 1";
            }
            {
              name = "Pomodoro";
              path = "~";
              startup_command = "tomato";
            }
          ];
        };
      };
    };
  };
}
