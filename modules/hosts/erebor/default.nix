{config, ...}: {
  nixosHosts.erebor = {
    system = "x86_64-linux";
  };

  flake.modules.nixos."nixosConfigurations/erebor" = {
    imports = [config.flake.modules.nixos.nvidia];

    networking.hostName = "erebor";

    system = {
      stateVersion = "25.05";
      autoUpgrade.enable = false;
    };
  };
}
