{jg, ...}: {
  jg.tui.includes = [jg.git];
  jg.git.homeManager = {
    config,
    pkgs,
    ...
  }: let
    noCommit = pkgs.writeScriptBin "no-commit" ''
      #!/usr/bin/env bash

      # Abort commit if any staged file contains the keyword !nocommit,
      # or if a file named 'nocommit' is staged.

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
    home.packages = [pkgs.pre-commit noCommit];

    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "JacobGDG";
          email = "10035081+JacobGDG@users.noreply.github.com";
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
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        pull.rebase = true;
        colour.ui = true;
        help.autocorrect = 30;
        core = {
          editor = "nvim";
          hooksPath = "${config.xdg.configHome}/git/hooks";
        };
      };
    };

    xdg.configFile."git/hooks/pre-commit" = {
      executable = true;
      # Runs no-commit first (blocks !nocommit markers), then delegates to the
      # pre-commit framework if a config exists in the repo — so pre-commit install
      # is not needed and this hook is never overwritten.
      text = ''
        #!/usr/bin/env bash
        set -e
        ${noCommit}/bin/no-commit
        if [ -f ".pre-commit-config.yaml" ]; then
          pre-commit run --hook-stage pre-commit
        fi
      '';
    };
  };
}
