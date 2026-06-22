{
  flake.modules.homeManager.git = {
    config,
    pkgs,
    ...
  }: let
    no-commit = pkgs.writeScriptBin "no-commit" ''
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
  in {
    home.packages = [no-commit];

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

        alias = {
          co = "checkout";
          cm = "commit --verbose";
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

    xdg.configFile."git/hooks/pre-commit" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash
        ${no-commit}/bin/no-commit

        LOCAL_HOOK="$(git rev-parse --git-dir)/hooks/pre-commit"
        if [ -x "$LOCAL_HOOK" ]; then
          exec "$LOCAL_HOOK" "$@"
        fi
      '';
    };

    home.file.".config/pre-commit/pre-commit-config.yaml".text = ''
      repos:
      - repo: local
        hooks:
          - id: no-commit
            name: no-commit
            entry: ${no-commit}/bin/no-commit
            language: script
            pass_filenames: false
    '';
  };
}
