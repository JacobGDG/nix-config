{
  flake.modules.homeManager."jake@jake-laptop-nixos" = {lib, ...}: {
    home.stateVersion = "24.05";
  };

  flake.modules.nixos."nixosConfigurations/jake-laptop-nixos" = {
    users.users = {
      jake = {
        initialPassword = "correcthorsebatterystaple";
        isNormalUser = true;
        extraGroups = ["wheel" "networkmanager"];
        useDefaultShell = true;
      };
    };
  };
}
