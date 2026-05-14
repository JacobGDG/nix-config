{jg, ...}: {
  jg.homelab = {
    includes = [jg.homer jg.traefik];
    nixos = {pkgs, ...}: {
      virtualisation = {
        oci-containers.backend = "podman";
        podman = {
          enable = true;
          autoPrune.enable = true;
          dockerCompat = true;
        };
      };

      systemd.targets."podman-homelab-root" = {
        unitConfig = {
          Description = "Root target for homelab.";
        };
      };
    };
  };
}
