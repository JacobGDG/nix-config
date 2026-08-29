{
  nixpkgs.allowedUnfreePackages = ["claude-code"];

  persist = {
    users = {
      directories = [
        ".claude"
      ];
      files = [
        ".claude.json"
      ];
    };
  };

  flake.modules.homeManager.aiAgents = {
    pkgs,
    config,
    ...
  }: let
    # Notify via tmux-notify on the pane Claude is running in. tmux-notify does
    # the cross-session focus check and only alerts when that pane is not being
    # looked at — see modules/shell/scripts.nix.
    notifyHook = {
      type = "command";
      command = ''${pkgs.tmux-notify}/bin/tmux-notify "$TMUX_PANE"'';
    };
    mattpocock-skills = pkgs.fetchFromGitHub {
      owner = "mattpocock";
      repo = "skills";
      rev = "5b15a47f2d7150f545fbcacbfe381787fc0230dc";
      hash = "sha256-FPAAotNqA5aHrFDlj/XddoLs4TDKi+4J5H/mvevlOlk=";
    };
  in {
    home.packages = with pkgs; [
      opencode
    ];

    home.file."${config.xdg.cacheHome}/ref-repos/.keep".text = "";

    # home.file.*.source accepts store-path strings, which lets us reference
    # files inside fetchFromGitHub outputs without the lib.isPath limitation of
    # programs.claude-code.skills.
    home.file = {
      ".claude/skills/grilling/SKILL.md".source = "${mattpocock-skills}/skills/productivity/grilling/SKILL.md";
      ".claude/skills/handoff/SKILL.md".source = "${mattpocock-skills}/skills/productivity/handoff/SKILL.md";
    };

    programs.claude-code = {
      enable = true;

      skills = {
        clone-repo = ./skills/clone-repo.md;
      };

      settings = {
        theme = "dark";
        sandbox = {
          enabled = true;
          filesystem.allowWrite = ["${config.xdg.cacheHome}/ref-repos"];
          network.allowedDomains = ["github.com" "*.github.com"];
        };

        permissions = {
          allow = [
            "Bash(git* clone:*)"
            "Bash(git* status:*)"
            "Bash(git* log:*)"
            "Bash(git* diff:*)"
            "Bash(git* show:*)"
            "Bash(mkdir -p ${config.xdg.cacheHome}/ref-repos/*)"
            "Bash(mkdir -p ~/.cache/ref-repos/*)"
          ];
          deny = [
            "Bash(git* commit*)"
            "Bash(git* push*)"
            "Bash(git* add*)"
            "Bash(git* merge*)"
            "Bash(git* rebase*)"
            "Bash(git* reset*)"
            "Bash(ssh *)"
            "Bash(sudo *)"
            "Bash(tofu apply *)"
            "Bash(terraform apply *)"
          ];
          additionalDirectories = ["${config.xdg.cacheHome}/ref-repos"];
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
          Stop = [{hooks = [notifyHook];}];
          # Claude is asking permission to run a tool (fires mid-turn, so Stop
          # doesn't cover it). idle_prompt is intentionally excluded: Stop
          # already pinged at turn end.
          Notification = [
            {
              matcher = "permission_prompt";
              hooks = [notifyHook];
            }
          ];
        };
      };
    };
  };
}
