{
  flake.modules.homeManager."jake@erebor" = {};
  flake.modules.homeManager."han@erebor" = {};
  flake.modules.nixos."nixosConfigurations/erebor" = {
    users.users = {
      jake = {
        initialPassword = "password";
        isNormalUser = true;
        extraGroups = ["wheel" "networkmanager"];
        useDefaultShell = true;
      };
      han = {
        initialPassword = "password";
        isNormalUser = true;
        extraGroups = ["wheel" "networkmanager"];
        useDefaultShell = true;
      };
    };
  };
}
