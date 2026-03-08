{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myModules.opencode;
in {
  options = {
    myModules.opencode = {
      enable = lib.mkEnableOption "Opencode";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      opencode
    ];
  };
}
