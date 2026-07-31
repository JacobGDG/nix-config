{
  nixpkgs.allowedUnfreePackages = ["claude-code"];

  flake.modules.homeManager.aiAgents = {pkgs, config, ...}: let
    # Notify via tmux-notify on the pane Claude is running in. tmux-notify does
    # the cross-session focus check and only alerts when that pane is not being
    # looked at — see modules/shell/scripts.nix.
    notify = ''${pkgs.tmux-notify}/bin/tmux-notify "$TMUX_PANE"'';
  in {
    home.packages = with pkgs; [
      opencode
    ];

    home.file.".cache/ref-repos/.keep".text = "";

    programs.claude-code = {
      enable = true;

      skills = {
        clone-repo = ./skills/clone-repo.md;
      };

      settings = {
        theme = "dark";

        permissions = {
          allow = [
            "Bash(git -C:*)"
            "Bash(mkdir -p ~/.cache/ref-repos:*)"
          ];
          additionalDirectories = ["${config.home.homeDirectory}/.cache/ref-repos"];
        };

        # Claude's own terminal-bell notification is gated on the terminal
        # WINDOW being unfocused (OS level), so it never fires when you're on a
        # different tmux pane in the same, still-focused window. We disable it and
        # drive notifications from lifecycle hooks instead, which fire regardless
        # of focus and hand us the pane id — letting tmux-notify do the
        # pane-level focus check. See modules/shell/scripts.nix for tmux-notify.
        preferredNotifChannel = "notifications_disabled";

        hooks = {
          # Claude finished / is awaiting input.
          Stop = [{hooks = [{type = "command"; command = notify;}];}];
          # Claude is asking permission to run a tool (fires mid-turn, so Stop
          # doesn't cover it). idle_prompt is intentionally excluded: Stop
          # already pinged at turn end.
          Notification = [
            {
              matcher = "permission_prompt";
              hooks = [{type = "command"; command = notify;}];
            }
          ];
        };
      };
    };
  };
}
