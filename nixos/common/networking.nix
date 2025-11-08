{hostConfig, ...}: {
  networking = {
    hostName = hostConfig.hostName;

    networkmanager.enable = true; # Enable networking
  };
}
