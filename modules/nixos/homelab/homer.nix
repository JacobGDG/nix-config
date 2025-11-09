{
  lib,
  config,
  ...
}: let
  homelabEnabled = config.myModules.nixOS.homelab.enable;
  cfg = config.myModules.nixOS.homelab.homer;
in {
  options.myModules.nixOS.homelab.homer = {
    enable = lib.mkEnableOption "Homer";
  };

  config = lib.mkIf (homelabEnabled && cfg.enable) {
    virtualisation.oci-containers.containers.homer = {
      image = "docker.io/b4bz/homer:v25.10.1";
      log-driver = "journald";
      extraOptions = [
        "--network=insecure"
      ];
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.myapp.rule" = "Host(`homer.local`)";
        "traefik.http.routers.myapp.entrypoints" = "web";
        "traefik.http.services.testapp.loadbalancer.server.port" = "8080";
      };
      podman.user = "homer";
    };

    users.users.homer = {
      isSystemUser = true;
      group = "homer";
      extraGroups = ["podman"];
      home = "/var/lib/podman";
      createHome = true;
    };
    users.groups.homer = {};

    systemd.services."podman-homer" = {
      serviceConfig = {
        Restart = "always";
      };
      after = [
        "podman-network-insecure.service"
      ];
      requires = [
        "podman-network-insecure.service"
      ];
    };

    networking.hosts = {
      "127.0.0.1" = ["homer.local"];
    };
  };
}
