{
  flake.modules.homeManager."jake@hobbiton" = {};

  flake.modules.nixos."nixosConfigurations/hobbiton" = {
    inputs,
    config,
    ...
  }: {
    age.secrets.jakePassword.file = "${inputs.secrets}/jake-password.age";

    users = {
      mutableUsers = false;
      users = {
        jake = {
          hashedPasswordFile = config.age.secrets.jakePassword.path;
          isNormalUser = true;
          extraGroups = ["wheel" "networkmanager"];
          useDefaultShell = true;
        };
      };
    };
  };
}
