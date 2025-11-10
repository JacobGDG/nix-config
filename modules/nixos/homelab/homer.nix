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
      networks = [
        "insecure"
      ];
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.myapp.rule" = "Host(`homer.local`)";
        "traefik.http.routers.myapp.entrypoints" = "web";
        "traefik.http.services.testapp.loadbalancer.server.port" = "8080";
      };
    };

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
      serviceConfig = {
        ## Security Tuning
        ProtectHome = "yes";
        ProtectClock = "yes";
        ProtectKernelLogs = "yes";
        ProtectKernelModules = "yes";
        ProtectSystem = "full";
        RestrictSUIDSGID = "yes";
        UMask = 0077;
        SystemCallArchitectures = "native";
        SystemCallFilter = "@system-service @mount @privileged";
        RestrictRealtime = "yes";
        RestrictIPC = "yes";
        LockPersonality = "yes";
        RestrictAddressFamilies = "AF_INET AF_INET6 AF_UNIX AF_NETLINK";
        MemoryDenyWriteExecute = "yes";
      };
    };

    networking.hosts = {
      "127.0.0.1" = ["homer.local"];
    };
  };
}
