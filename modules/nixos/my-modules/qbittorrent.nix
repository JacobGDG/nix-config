{
  config,
  lib,
  ...
}: let
  cfg = config.myModules.nixOS.qbittorrent;
in {
  options.myModules.nixOS.qbittorrent = {
    enable = lib.mkEnableOption "qbittorrent";
    domain = lib.mkOption {
      description = "Domain on which to host qbittorrent webUI, a hosts value will be added pointing to local loopback";
      default = "torrent.local";
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    services.qbittorrent = {
      enable = true;
      serverConfig = {
        # LegalNotice.Accepted = true;
        Preferences = {
          WebUI = {
            Username = "user";
            Password = "password";
          };
          General.Locale = "en_GB.UTF-8";
        };
      };
    };

    networking.hosts = {
      "127.0.0.1" = [cfg.domain];
    };

    services.nginx = {
      enable = true;
      virtualHosts."${cfg.domain}".locations."/" = {
        proxyPass = "http://127.0.0.1:8080/";
      };
    };
  };
}
