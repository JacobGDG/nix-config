{
  lib,
  config,
  pkgs,
  ...
}: let
  homelabEnabled = config.myModules.nixOS.homelab.enable;
  cfg = config.myModules.nixOS.homelab.traefik;
in {
  options.myModules.nixOS.homelab.traefik = {
    enable = lib.mkEnableOption "traefik";
  };

  config = lib.mkIf homelabEnabled {
    virtualisation.oci-containers.containers.traefik = {
      image = "docker.io/library/traefik:v3.6.0";
      ports = [
        "80:80/tcp"
        "8080:8080/tcp"
      ];
      cmd = ["--providers.docker=true" "--entrypoints.web.address=:80"];
      log-driver = "journald";
      volumes = [
        "/var/run/podman/podman.sock:/var/run/docker.sock:ro"
      ];
      extraOptions = [
        "--network-alias=traefik"
        "--network=insecure"
      ];
    };

    systemd.services."podman-traefik" = {
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

    systemd.services."podman-network-insecure" = {
      path = [pkgs.podman];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStop = "podman network rm -f insecure";
      };
      script = ''
        podman network inspect insecure || podman network create insecure
      '';
      partOf = ["podman-homelab-root.target"];
      wantedBy = ["podman-homelab-root.target"];
    };
  };
}
