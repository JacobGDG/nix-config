{
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
      };
    };

    aliases = {
      # https://github.com/JacobGDG/dotfiles/blob/master/dot_config/git/config.tmpl
      co = "checkout";
      cm = "commit --verbose";

      rbm = "pull origin main --rebase";
      cm-temp = "commit -m 'temp commit'";

      # default branch
      default-branch = "!git symbolic-ref refs/remotes/origin/HEAD | cut -d'/' -f4";

      url = "config --get remote.origin.url";

      # checkout deafult branch
      home = "!f(){ git checkout $(git default-branch) $@;}; f";

      # oops
      amend = "commit --amend -C HEAD";
      p-force = "push --force-with-lease";
      fooked = "!git add . && git amend && git p-force";
      resetorigin = "!git fetch origin && git reset --hard @{u} && git clean -f -d";

      ls = "!bash -c 'gitcheckout'";
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
}
