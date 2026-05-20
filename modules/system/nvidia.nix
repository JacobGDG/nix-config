{
  nixpkgs.allowedUnfreePackages = [
    "nvidia-x11"
    "nvidia-settings"
    "nvidia-persistenced"
  ];

  flake.modules.nixos.nvidia = {config, ...}: {
    services.xserver.videoDrivers = ["nvidia"];

    hardware = {
      graphics.enable = true;

      nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        modesetting.enable = true;
        powerManagement.enable = false;
        powerManagement.finegrained = false;
        open = true;
        nvidiaSettings = true;
      };
    };
  };
}
