{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.myModules.nixOS.homer;
in {
  options = {
    myModules.nixOS.homer = {
      enable = lib.mkEnableOption "homer";
      domain = lib.mkOption {
        description = "Domain on which to host Homer, a hosts value will be added pointing to local loopback";
        default = "homer.local";
        type = lib.types.str;
      };
      port = lib.mkOption {
        description = "port on which to host Homer";
        default = 80;
        type = lib.types.int;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.homer = {
      enable = true;
      virtualHost = {
        nginx.enable = true;
        domain = cfg.domain;
      };

      settings = {
        title = lib.mkDefault "SET IN NIXCONFIG";
        footer = "";
        links = lib.mkAfter [
          {
            name = "NixConfig";
            icon = "fab fa-github";
            url = "https://github.com/JacobGDG/nix-config";
          }
        ];
        services = [
          {
            name = "Application";
            icon = "fas fa-code-branch";
            items = [
              {
                name = "Awesome app";
                logo = "assets/tools/sample.png";
                subtitle = "Bookmark example";
                tag = "app";
                keywords = "self hosted reddit";
                url = "https://www.reddit.com/r/selfhosted/";
                target = "_blank";
              }
              {
                name = "Another one";
                logo = "assets/tools/sample2.png";
                subtitle = "Another application";
                tag = "app";
                tagstyle = "is-success";
                url = "#";
              }
            ];
          }
          {
            name = "Other group";
            icon = "fas fa-heartbeat";
            items = [
              {
                name = "Pi-hole";
                logo = "assets/tools/sample.png";
                tag = "other";
                url = "http://192.168.0.151/admin";
                type = "PiHole";
                target = "_blank";
              }
            ];
          }
        ];
      };
    };

    services.nginx.virtualHosts."${cfg.domain}".listen = [
      {
        addr = cfg.domain;
        port = cfg.port;
      }
    ];

    networking.hosts = {
      "127.0.0.1" = [cfg.domain];
    };
  };
}
