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
      enable = lib.mkEnableOption "llm";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      llm
    ];
  };
}
