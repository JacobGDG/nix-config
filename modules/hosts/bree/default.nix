{
  hosts.bree = {
    system = "x86_64-linux";
    configurator = "nixos";
  };

  flake.modules.nixos."nixosConfigurations/bree" = {
    inputs,
    lib,
    ...
  }: {
    imports = with inputs.self.modules.nixos; [
      impermanance
      secrets
    ];

    networking.hostName = "bree";

    services.openssh = {
      enable = true;
      settings.PermitRootLogin = lib.mkForce "prohibit-password";
    };

    system = {
      stateVersion = "26.05";
      autoUpgrade.enable = false;
    };
  };
}
