{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myModules.git;

  hooksDir = ./hooks;

  # [ "file-1.sh ]
  hookFiles = builtins.attrNames (builtins.readDir hooksDir);

  # {"file-1" = "<contents>"}
  mkScript = name: {
    name = builtins.replaceStrings [".sh"] [""] name;
    value = builtins.readFile (hooksDir + "/${name}");
  };

  # { "file-1" = "<contents>", ... }
  hookSet = builtins.listToAttrs (map mkScript hookFiles);

  # { "file-1" = { "git/hooks/file-1" = { text = "<contents>", executable = true } }, ... }
  hookConfigs =
    builtins.mapAttrs (name: value: {
      "git/hooks/${name}" = {
        text = value;
        executable = true;
      };
    })
    hookSet;

  noCommit = pkgs.writeScriptBin "no-commit" (builtins.readFile ./no-commit.sh);
in {
  config = lib.mkIf cfg.global-pre-commit.enable {
    home.packages = [
      noCommit
    ];
    programs.git.extraConfig.core.hooksPath = "~/.config/git/hooks";
    xdg.configFile = lib.mkMerge (builtins.attrValues hookConfigs);
    home.file.".config/pre-commit/pre-commit-config.yaml" = {
      text = ''
        repos:
        - repo: local
          hooks:
            - id: no-commit
              name: no-commit
              entry: ${noCommit}/bin/no-commit
              language: script
              pass_filenames: false
      '';
    };
  };
}
