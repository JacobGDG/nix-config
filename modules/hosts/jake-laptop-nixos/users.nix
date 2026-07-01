{
  flake.modules.homeManager."jake@jake-laptop-nixos" = {};

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
