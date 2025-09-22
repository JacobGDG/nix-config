{
  config,
  lib,
  ...
}: let
  cfg = config.myModules.nixOS.vpn;
in {
  options = {
    myModules.nixOS.vpn = {
      enable = lib.mkEnableOption "VPN service";
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services."systemd-networkd".environment.SYSTEMD_LOG_LEVEL = "debug";
    networking.useNetworkd = true;
    systemd.network = {
      enable = true;
      networks."vpnns" = {
        matchConfig.Name = "dummy0";
      };

      # Attach a dummy device inside that namespace (so it shows up)
      netdevs."60-dummy0" = {
        netdevConfig = {
          Kind = "dummy";
          Name = "dummy0";
        };
      };
    };
  };
}
