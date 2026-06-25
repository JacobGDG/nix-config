{
  flake.modules.homeManager.git = {
    config,
    pkgs,
    ...
  }: let
    no_commit = pkgs.writeScriptBin "no-commit" ''
      #!/usr/bin/env bash
      #
      # Prevent debug code from being accidentally committed.
      # Add a comment containing !nocommit near debug code to abort the commit.
      #
      FILES=$(git diff --cached --name-only)

      if echo "$FILES" | grep -q 'nocommit'; then
        echo "'nocommit' file found in staged files"
        exit 1
      fi

      for file in $FILES; do
        if grep -q '!nocommit' "$file"; then
          echo -e "'!nocommit' found in $file"
          exit 1
        fi
      done
    '';
    conventional_commit = pkgs.writeScriptBin "conventional-commit" ''
      #!/usr/bin/env bash

      commit_msg=$(cat "$1")
      pattern='^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(\(.+\))?(!)?: .+'

      if ! echo "$commit_msg" | grep -qE "$pattern"; then
        echo "ERROR: commit message does not follow Conventional Commits format."
        echo "Expected: <type>(optional scope): <description>"
        echo "Types: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert"
        echo ""
        echo "Got: $commit_msg"
        exit 1
      fi

    '';
  in {
    home.packages = [no_commit conventional_commit];

    programs.jujutsu = {
      enable = true;
      settings.user = {
        name = "JacobGDG";
        email = "10035081+JacobGDG@users.noreply.github.com";
      };
    };

    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "JacobGDG";
          email = "10035081+JacobGDG@users.noreply.github.com";
        };

        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        pull.rebase = true;
        colour.ui = true;
        help.autocorrect = 30;

        core = {
          editor = "nvim";
          hooksPath = "${config.xdg.configHome}/git/hooks";
        };

        commit = {
          verbose = true;
          template = "${config.xdg.configHome}/git/commit-template";
        };

        alias = {
          co = "checkout";
          cm = "commit";
          rbm = "!git pull origin $(git default-branch) --rebase";
          cm-temp = "commit -m 'temp commit'";
          default-branch = "!git symbolic-ref refs/remotes/origin/HEAD | cut -d'/' -f4";
          url = "config --get remote.origin.url";
          home = "!f(){ git checkout $(git default-branch) $@;}; f";
          amend = "commit --amend -C HEAD";
          p-force = "push --force-with-lease";
          fooked = "!git add . && git amend && git p-force";
          resetorigin = "!git fetch origin && git reset --hard @{u} && git clean -f -d";
          pretty = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
          hide = "update-index --assume-unchanged";
          hidden = "!git ls-files -v | grep '^[a-z]'";
          unhide = "update-index --no-assume-unchanged";
          unhide-all = "update-index --really-refresh";
          pr = "!gh pr view --web";
          alias = "!git config --get-regexp ^alias\\. | sed -e s/^alias\\.// -e s/\\ /\\ =\\ /";
          claude = "!git commit --amend --no-edit --trailer 'Co-authored-by: Claude <noreply@anthropic.com>'";
        };
      };
    };

    xdg.configFile = {
      "git/commit-template" = {
        text = ''

          # Types: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert
          # Scope: optional, e.g. auth, api, ui
          # Breaking change: append ! after type/scope, e.g. feat!: or feat(api)!:
        '';
      };
      "git/hooks/pre-commit" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash
          ${no_commit}/bin/no-commit

          LOCAL_HOOK="$(git rev-parse --git-dir)/hooks/pre-commit"
          if [ -x "$LOCAL_HOOK" ]; then
            exec "$LOCAL_HOOK" "$@"
          fi
        '';
      };
      "git/hooks/commit-msg" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash
          set -eo pipefail
          ${conventional_commit}/bin/conventional-commit "$1"

          LOCAL_HOOK="$(git rev-parse --git-dir)/hooks/commit-msg"
          if [ -x "$LOCAL_HOOK" ]; then
            exec "$LOCAL_HOOK" "$@"
          fi
        '';
      };
    };
  };
}
