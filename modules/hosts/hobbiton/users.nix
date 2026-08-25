{
  flake.modules.homeManager."jake@hobbiton" = {};

  flake.modules.nixos."nixosConfigurations/hobbiton" = {
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
