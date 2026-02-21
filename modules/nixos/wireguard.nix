{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.myModules.nixOS.wireguard;
in {
  options.myModules.nixOS.wireguard = {
    enable = lib.mkEnableOption "Wireguard";
    home.enable = lib.mkEnableOption "Home server";
    public.enable = lib.mkEnableOption "Public server";
  };

  config = lib.mkIf cfg.enable {
    networking.wg-quick.interfaces = {
      home = lib.mkIf cfg.home.enable {
        autostart = false;
        configFile = config.age.secrets."home.conf".path;
      };
      public = lib.mkIf cfg.public.enable {
        autostart = false;
        configFile = config.age.secrets."public.conf".path;
      };
    };

    age.secrets = {
      "home.conf" = lib.mkIf cfg.home.enable {
        file = "${inputs.mysecrets}/home_wg_config.conf.age";
        mode = "0500";
        owner = "root";
      };
      "public.conf" = lib.mkIf cfg.public.enable {
        file = "${inputs.mysecrets}/public_wg_config.conf.age";
        mode = "0500";
        owner = "root";
      };
    };
  };
}
