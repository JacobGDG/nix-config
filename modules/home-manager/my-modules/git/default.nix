{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myModules.git;

  hooksDir = ./hooks;
  hookFiles = builtins.attrNames (builtins.readDir hooksDir);
  mkScript = name: {
    name = builtins.replaceStrings [".sh"] [""] name;
    value = ''
      ${builtins.readFile (hooksDir + "/${name}")}

      # Run local pre-commit hook if exists
      if [ -e ./.git/hooks/${builtins.replaceStrings [".sh"] [""] name} ]; then
        ./.git/hooks/${builtins.replaceStrings [".sh"] [""] name} "$@"
      else
        exit 0
      fi
    '';
  };
  hookSet = builtins.listToAttrs (map mkScript hookFiles);

  # create configFile for each hook
  hookConfigs =
    builtins.mapAttrs (name: value: {
      "git/global-hooks/${name}" = {
        text = value;
        executable = true;
      };
    })
    hookSet;
in {
  options = {
    myModules.git = {
      enable = lib.mkOption {
        default = true;
        description = ''
          whether to enable
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = "JacobGDG";
      userEmail = "10035081+JacobGDG@users.noreply.github.com";

      extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        pull.rebase = true;
        colour.ui = true;
        help.autocorrect = 30;

        core = {
          editor = "nvim";
          hooksPath = "~/.config/git/global-hooks";
        };
      };

      aliases = {
        co = "checkout";
        cm = "commit --verbose";

        rbm = "!git pull origin $(git default-branch) --rebase";
        cm-temp = "commit -m 'temp commit'";

        # default branch
        default-branch = "!git symbolic-ref refs/remotes/origin/HEAD | cut -d'/' -f4";

        url = "config --get remote.origin.url";

        # checkout default branch
        home = "!f(){ git checkout $(git default-branch) $@;}; f";

        # oops
        amend = "commit --amend -C HEAD";
        p-force = "push --force-with-lease";
        fooked = "!git add . && git amend && git p-force";
        resetorigin = "!git fetch origin && git reset --hard @{u} && git clean -f -d";

        pretty = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        # diffnames = "!git diff-tree -r --no-commit-id --name-only $(git log -1 --format="%H") origin/master";

        hide = "update-index --assume-unchanged";
        hidden = "!git ls-files -v | grep '^[a-z]'";
        unhide = "update-index --no-assume-unchanged";
        unhide-all = "update-index --really-refresh";

        pr = "!gh pr view --web";

        # print aliases
        alias = "!git config --get-regexp ^alias\\. | sed -e s/^alias\\.// -e s/\\ /\\ =\\ /";
      };
    };

    xdg.configFile = lib.mkMerge (builtins.attrValues hookConfigs);
  };
}
