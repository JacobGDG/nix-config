{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myModules.llm;
in {
  options = {
    myModules.llm = {
      enable = lib.mkOption {
        default = false;
        description = ''
          whether to enable
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      llm
    ];
  };
}
