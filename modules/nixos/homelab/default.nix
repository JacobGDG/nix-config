{
  lib,
  mylib,
  config,
  ...
}: let
  cfg = config.myModules.nixOS.homelab;
in {
  options.myModules.nixOS.homelab = {
    enable = lib.mkEnableOption "Homelab";
  };

  imports = mylib.scanPaths ./.;

  config = lib.mkIf cfg.enable {
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
}
