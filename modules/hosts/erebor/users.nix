{
  flake.modules.nixos."nixosConfigurations/erebor" = {
    users.users = {
      jake = {
        initialPassword = "password";
        isNormalUser = true;
        extraGroups = ["wheel" "networkmanager"];
        useDefaultShell = true;
      };
    };
  };
}
