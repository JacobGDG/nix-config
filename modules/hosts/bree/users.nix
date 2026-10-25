{
  flake.modules.nixos."nixosConfigurations/bree" = {
    inputs,
    config,
    ...
  }: {
    age.secrets.rootPassword.file = "${inputs.secrets}/bree-root-password.age";

    users = {
      mutableUsers = false;

      # Service account owning media and app state; ids match the old VM so restored files keep their owner
      groups.media.gid = 1000;
      users = {
        media = {
          isSystemUser = true;
          uid = 1000;
          group = "media";
        };

        root.hashedPasswordFile = config.age.secrets.rootPassword.path; # Break-glass
        root.openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO86dD5ffbHnQcdPkZPY0Su9a1VCF3avpaG/cbgMfKwE jake@erebor"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEzvtUjsOg2mFdsMibWXoeoDv3c286lEo7L6Fb6rwiEO jake@hobbiton"
        ];
      };
    };
  };
}
