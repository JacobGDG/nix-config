{
  persist = {
    directories = [
      "/etc/NetworkManager/system-connections"
      "/var/lib/NetworkManager"
    ];
  };
  flake.modules.nixos.core = {
    networking.networkmanager.enable = true;
  };
}
