{
  nixosHosts.erebor = {
    system = "x86_64-linux";
  };

  flake.modules.homeManager.erebor = {inputs, ...}: {
    imports = [inputs.self.modules.homeManager.hyprland];
  };

  flake.modules.nixos."nixosConfigurations/erebor" = {inputs, ...}: {
    imports = [
      inputs.self.modules.nixos.nvidia
      inputs.self.modules.nixos.hyprland
    ];

    networking.hostName = "erebor";

    system = {
      stateVersion = "25.05";
      autoUpgrade.enable = false;
    };
  };
}
