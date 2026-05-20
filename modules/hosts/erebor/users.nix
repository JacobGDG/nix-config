{
  flake.modules.nixos."nixosConfigurations/erebor" = {
    users.users = {
      jake = {
        initialPassword = "password";
        isNormalUser = true;
        extraGroups = ["wheel"];
        useDefaultShell = true;
      };
    };
  };
}
