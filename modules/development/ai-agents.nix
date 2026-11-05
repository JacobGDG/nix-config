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
    statusline = pkgs.writeShellApplication {
      name = "claude-statusline";
      runtimeInputs = with pkgs; [jq];
      text = builtins.readFile ./scripts/claude-statusline.sh;
    };
  in {
    home.file."${config.xdg.cacheHome}/ref-repos/.keep".text = "";
    home.file."${config.xdg.cacheHome}/reading-recs/.keep".text = "";

    # home.file.*.source accepts store-path strings, which lets us reference
    # files inside fetchFromGitHub outputs without the lib.isPath limitation of
    # programs.claude-code.skills.
    home.file = {
      ".claude/skills/grilling/SKILL.md".source = "${mattpocock-skills}/skills/productivity/grilling/SKILL.md";
      ".claude/skills/handoff/SKILL.md".source = "${mattpocock-skills}/skills/productivity/handoff/SKILL.md";
    };

    programs.claude-code = {
      enable = true;

      package = pkgs.unstable.claude-code;

      skills = {
        clone-repo = ./skills/clone-repo.md;
        reading-recs = ./skills/reading-recs.md;
      };

      mcpServers = {
        raindrop = {
          type = "http";
          url = "https://api.raindrop.io/rest/v2/ai/mcp";
        };
      };

      context = ''
        # Worktrees

        Repos live in `~/worktrees/<repo>/`, with the git dir at
        `~/worktrees/<repo>/.git` and each branch checked out as a git worktree
        alongside it, e.g. `~/worktrees/<repo>/main` (`master` for older repos)
        or `~/worktrees/<repo>/<feature-branch>`. When I mention another repo,
        look for it there before cloning or searching the web.

        # git and gh

        - Don't prefix commands with `cd <path> &&`; use `git -C <path>` and
          `gh -R <owner>/<repo>` instead. `gh` only runs outside the sandbox
          when it is the first word of the command, so run it on its own
          rather than chained after other commands.

        # Skills

        - `clone-repo` - use this when investigating or reading the source of a
          git repository other than the current working directory, rather than
          fetching files from the web.
      '';

      settings = {
        theme = "dark";
        sandbox = {
          enabled = true;
          filesystem.allowWrite = [
            "${config.xdg.cacheHome}/ref-repos"
            "${config.xdg.cacheHome}/reading-recs"
          ];
          network.allowedDomains = ["github.com" "*.github.com"];
          # gh (like other Go binaries on macOS) verifies TLS through
          # com.apple.trustd.agent, which the sandbox blocks — inside it gh
          # fails with "x509: OSStatus -26276". Run gh unsandboxed rather than
          # opening trustd to every sandboxed command.
          excludedCommands = ["gh *"];
        };

        # https://github.com/NixOS/nixpkgs/issues/579204
        env.CLAUDE_CODE_CERT_STORE = "bundled,system";

        promptSuggestionEnabled = false;

        statusLine = {
          type = "command";
          command = "${statusline}/bin/claude-statusline";
          refreshInterval = 60;
        };

        permissions = {
          allow = [
            "Bash(git clone:*)"
            "Bash(git status:*)"
            "Bash(git log:*)"
            "Bash(git diff:*)"
            "Bash(git show:*)"
            "Bash(git fetch *)"
            "Bash(git-ref-clone:*)"
            "Bash(git-ref-clean:*)"
          ];
          ask = [
            "Bash(rm *)"
            "Bash(rmdir *)"
            "Bash(git* commit*)"
            "Bash(git* add*)"
            "Bash(ssh *)"
          ];
          deny = [
            "Bash(git* push*)"
            "Bash(git* merge)"
            "Bash(git* merge *)"
            "Bash(git* rebase*)"
            "Bash(git* reset*)"
            "Bash(sudo *)"
            "Bash(tofu apply *)"
            "Bash(terraform apply *)"
          ];
          additionalDirectories = [
            "${config.xdg.cacheHome}/ref-repos"
            "${config.xdg.cacheHome}/reading-recs"
          ];
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
