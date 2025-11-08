{
  config,
  lib,
  ...
}: let
  cfg = config.myModules.nixOS.steam;
in {
  options.myModules.nixOS.steam.enable = lib.mkEnableOption "Steam";

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
    };

    programs.gamescope = {
      enable = true;
    };
  };
}
