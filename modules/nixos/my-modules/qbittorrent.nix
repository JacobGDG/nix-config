{
  config,
  lib,
  ...
}: let
  cfg = config.myModules.nixOS.qbittorrent;
in {
  options = {
    myModules.nixOS.qbittorrent = {
      enable = lib.mkEnableOption "qbittorrent";
    };
  };

  config = lib.mkIf cfg.enable {
    services.qbittorrent = {
      enable = true;
    };
  };
}
