{
  nixosHosts.erebor = {
    system = "x86_64-linux";
  };

  flake.modules.nixos."nixosConfigurations/erebor" = {inputs, ...}: {
    imports = with inputs.self.modules.nixos; [
      nvidia
      hyprland
    ];

    networking.hostName = "erebor";

    system = {
      stateVersion = "25.05";
      autoUpgrade.enable = false;
    };
  };

  flake.modules.homeManager.erebor = {inputs, ...}: {
    imports = with inputs.self.modules.homeManager; [hyprland];
  };
}
